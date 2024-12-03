SET DEFAULT TO D:\Vk8\OWCCharting
SET PROCEDURE TO wwWebGraphs ADDITIVE
*** These are required for IsComObject/DeleteFiles
SET PROCEDURE TO wwUtils ADDITIVE
SET PROCEDURE TO wwAPI ADDITIVE

*** Sample Code
#IF .T.

	loGraph = CREATEOBJECT("wwWebGraphs")

	IF VARTYPE( loGraph ) <> "O"
		MESSAGEBOX( "Objeto No Creado" )
		RETURN
	ENDIF

	loGraph.cPhysicalPath = SYS(2023) + "\"

	IF .T.
	
loGraph.nGraphType = "PIE"
*** Cursor
		CREATE CURSOR TEMP (LABEL C(20), Year_1998 I, Year_1999 I, Year_2000 I)
		INSERT INTO TEMP (LABEL, Year_1998, Year_1999, Year_2000) VALUES ("Income",90000,105000,118300 )
		INSERT INTO TEMP (LABEL, Year_1998, Year_1999, Year_2000) VALUES ("Expenses",32200,55000,65800 )
		INSERT INTO TEMP (LABEL, Year_1998, Year_1999, Year_2000) VALUES ("Taxes",20400,31500,29900 )
		INSERT INTO TEMP (LABEL, Year_1998, Year_1999, Year_2000) VALUES ("Travel",10000,10800,22200 )
		INSERT INTO TEMP (LABEL, Year_1998, Year_1999, Year_2000) VALUES ("Business",40100,49100,53200 )

		loGraph.ShowGraphFromCursor()

	ENDIF

	IF .F.
*** Arrays
		DIMENSION laLabels[3]
		DIMENSION laData[3]
		DIMENSION laData2[3]
		DIMENSION laData3[3]
		DIMENSION laData4[3]

		laLabels[1] = "Data Item 1"
		laLabels[2] = "Data Item 2"
		laLabels[3] = "Data Item 3"

		laData[1] = 10
		laData[2] = 20
		laData[3] = 15

		laData2[1] = 20
		laData2[2] = 25
		laData2[3] = 19

		laData3[1] = 24
		laData3[2] = 28
		laData3[3] = 29

		laData4[1] = 20
		laData4[2] = 25
		laData4[3] = 19

		loGraph.ShowGraphFromArray(@laLabels,@laData,"My Series 1",@laData2,"MY Series 2",@laData3,"My Series 3",@laData4,"Test Series 4")

	ENDIF


	IF .F.

*** Multi-dimensional Array
		DIMENSION laLegend[3]
		laLegend[1] = "Census"
		laLegend[2] = "County"
		laLegend[3] = "Federal"

		DIMENSION laGraphs[3,4]
		laGraphs[1,1] = "Year 1998"
		laGraphs[1,2] = 1000
		laGraphs[1,3] = 1100
		laGraphs[1,4] = 900

		laGraphs[2,1] = "Year 1999"
		laGraphs[2,2] = 3000
		laGraphs[2,3] = 3100
		laGraphs[2,4] = 2900

		laGraphs[3,1] = "Year 2000"
		laGraphs[3,2] = 2000
		laGraphs[3,3] = 2100
		laGraphs[3,4] = 1900

		loGraph.ShowGraphFromMultiDimensionalArray(@laGraphs,@laLegend)
	ENDIF

*** Generate the graph
	loGraph.GetOutput()

	PUBLIC loForm
	loForm =   loGraph.ShowGraphInForm()

*!* GoUrl( loGraph.cPhysicalPath + loGraph.cImageName)

	RETURN
#ENDIF


*************************************************************
DEFINE CLASS wwWebGraphs AS RELATION
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2001
*:Contact: http://www.west-wind.com
*:Created: 09/20/2001
*************************************************************
	#IF .F.
*:Help Documentation
*:Topic:
		CLASS wwWebGraphs

*:Description:

*:Example:

*:Remarks:

*:SeeAlso:


*:ENDHELP
	#ENDIF

*** Graph type:  0 -  Bar
***              3 -  Block (horizontal bar)
***              6 -  Line
***              7 -  Line Dots
***              18 - Pie
***              19 - Exploded Pie

	nGraphType = 0
	cCaption  = ""

*** Office Web Components Chart object
	oOWC = .NULL.

*cOWCProgId = "OWC10.ChartSpace"  && Latest version
	cOWCProgId = "OWC.Chart"    && Office 2000/Office XP installs

*** Physical disk Path  the image is written to
	cPhysicalPath = ""

*** Web Path that is mapped to the physical path
*** used to create an <img> tag for the graph
	cLogicalPath = ""

*** Timeout for graphs before they are deleted
*** Images are checked for timeouts and deleted
*** whenever a new image is created
	nImageTimeout = 30  && 5 minutes - 300 seconds

*** Resulting filename of the image - filename only
	cImageName = ""

	nImageWidth = 750
	nImageHeight = 480

*** Default Colors used
	cBackcolor = "lightyellow"
	cSeries1Color = "red"
	cSeries2Color = "blue"
	cSeries3Color = "green"
	cSeries4Color = "orange"
	cSeries5Color = "purple"
	cSeries6Color = "pink"

	nShowLegend = 1   && Show with column name 2 - ???


	FUNCTION INIT
	LPARAMETERS llNoExistCheck

	IF !llNoExistCheck AND !ISCOMOBJECT(THIS.cOWCProgId)
		RETURN .F.
	ENDIF

	THIS.oOWC = CREATEOBJECT(THIS.cOWCProgId)
	IF VARTYPE(THIS.oOWC) # "O"
		RETURN .F.
	ENDIF

	RETURN

************************************************************************
* wwWebGraphs :: GraphSetup
****************************************
***  Function: Configures the basic Graph Layout
***    Assume: Basic layout used for all graph renderers
************************************************************************
	FUNCTION GraphSetup()
	LOCAL loGraph

	loGraph = THIS.oOWC.Charts.ADD()
	loGraph.TYPE = THIS.nGraphType

	IF THIS.nShowLegend > 0
		loGraph.HasLegend = .T.
	ENDIF

	loGraph.PlotArea.Interior.COLOR = THIS.cBackcolor

	IF !EMPTY(THIS.cCaption)
		THIS.oOWC.HasChartSpaceTitle = .T.
		THIS.oOWC.ChartSpaceTitle.CAPTION = THIS.cCaption
		THIS.oOWC.ChartSpaceTitle.FONT.Bold = .T.
	ENDIF

	RETURN loGraph
ENDFUNC
*  wwWebGraphs :: GraphSetup

************************************************************************
* wwWebGraphics :: ShowGraphFromCursor
****************************************
***  Function: Graphs a chart from a cursor.
***    Assume: Col 1   - Label column
***            Col 2-n - Data columns
***    Return: nothing
************************************************************************
	FUNCTION ShowGraphFromCursor()
	LOCAL x, Y, loGraph, lnFields, lnRows, lnSeries, lcElement, lcArray, oConst

	lnFields = AFIELDS(laFields,ALIAS())
	lnRows = RECCOUNT()
	lnSeries = lnFields - 1

*** Create labal array from the first column of the table
	DIMENSION laLabels[lnRows]

*** Create the value arrays and presize them each
	FOR x = 1 TO lnSeries
		lcArray = "DIMENSION laValues" + TRANSFORM(x) + "[" + TRANSFORM(lnRows) + "]"
		&lcArray
	ENDFOR

	x = 0
	SCAN
		x = x + 1
		laLabels[x] = TRIM(EVALUATE(FIELD(1)))  && First field value

		FOR Y = 1 TO lnSeries
			lcElement = "laValues" + TRANSFORM(Y)+ "[" + TRANSFORM(x) + "]"
			&lcElement = EVALUATE(FIELD(Y+1))
		ENDFOR
	ENDSCAN

	oConst = THIS.oOWC.Constants
	loGraph = THIS.GraphSetup()

	FOR x = 1 TO lnSeries
		loGraph.SeriesCollection.ADD()
		loSeries = loGraph.SeriesCollection(x-1)

		IF !INLIST(THIS.nGraphType,18,19,58,59)
*** Pies can't use interior colors well
			loSeries.Interior.COLOR = EVALUATE("THIS.cSeries" + TRANSFORM(x) +"Color" )
		ELSE
			IF x > 1
				EXIT   && PIes can't render more than a single series
			ENDIF
		ENDIF

		lcArray = "@laValues" + TRANSFORM(x)
		loSeries.CAPTION = PROPER(STRTRAN(TRIM(laFields[x+1,1]),"_"," "))
		loSeries.SETDATA(oConst.chDimCategories, oConst.chDataLiteral, @laLabels)
		loSeries.SETDATA(oConst.chDimValues, oConst.chDataLiteral, &lcArray)
	ENDFOR

ENDFUNC
*  wwWebGraphics :: ShowGraphFromCursor

************************************************************************
* wwWebGraphics :: ShowGraphFromArray
****************************************
***  Function: Graphs a chart from a cursor.
***    Assume: Col 1    - Label array
***            Col 2    - Data array
***            lcSeries - Legend Text for Series
***            to n columns
***    Return: nothing
************************************************************************
	FUNCTION ShowGraphFromArray(laLabels,laSeries1,lcSeries1,laSeries2,lcSeries2,laSeries3,lcSeries3,;
		laSeries4,lcSeries4,laSeries5,lcSeries5,laSeries6,lcSeries6)
	LOCAL x, loGraph, lnSeries, lcArray, lcLabel

	lnSeries = (PCOUNT() - 1) / 2

	loGraph = THIS.GraphSetup()

	oConst = THIS.oOWC.Constants

	FOR x = 1 TO lnSeries
		loGraph.SeriesCollection.ADD()

		IF !INLIST(THIS.nGraphType,18,19)  && Pies can't use interior colors well
			loGraph.SeriesCollection(x-1).Interior.COLOR = EVALUATE("THIS.cSeries" + TRANSFORM(x) +"Color" )
		ENDIF

		lcArray = "@laSeries" + TRANSFORM(x)
		lcLabel = EVALUATE("lcSeries" + TRANSFORM(x))
		loGraph.SeriesCollection(x-1).CAPTION = lcLabel
		loGraph.SeriesCollection(x-1).SETDATA(oConst.chDimCategories, oConst.chDataLiteral, @laLabels)
		loGraph.SeriesCollection(x-1).SETDATA(oConst.chDimValues, oConst.chDataLiteral, &lcArray)
	ENDFOR

ENDFUNC
*  wwWebGraphics :: ShowGraphFromArray


************************************************************************
* wwWebGraphics :: ShowGraphFromMultiDimensionalArray
*****************************************************
***  Function: Graphs a chart from a cursor.
***    Assume: Col 1   - Label col
***            Col 2-n - Data cols
***    Return: nothing
************************************************************************
	FUNCTION ShowGraphFromMultiDimensionalArray(laGraphs,laLegend)
	LOCAL loGraph, lnSeries, lnRows, llLegend, x, Y

	lnSeries = ALEN(laGraphs,2) - 1
	lnRows = ALEN(laGraphs,1)

	loGraph = THIS.GraphSetup()

*** Check if a legend array was passed
	IF TYPE([ALEN(laLegend)]) = "N"
		llLegend = .T.
	ELSE
		llLegend = .F.
		loGraph.HasLegend = .F.
	ENDIF

	oConst = THIS.oOWC.Constants

	DIMENSION laLabels[lnRows]
	FOR Y = 1 TO lnRows
		laLabels[y] = laGraphs[y,1]
	ENDFOR

	FOR x = 2 TO lnSeries + 1
		loGraph.SeriesCollection.ADD()

		IF !INLIST(THIS.nGraphType,18,19)  && Pies can't use interior colors well
			loGraph.SeriesCollection(x-2).Interior.COLOR = EVALUATE("THIS.cSeries" + TRANSFORM(x) +"Color" )
		ENDIF

*** Copy the array column into a 1D Array
		DIMENSION laArray[lnRows]
		FOR Y = 1 TO lnRows
			laArray[y] = laGraphs[y,x]
		ENDFOR

		IF llLegend
			loGraph.SeriesCollection(x-2).CAPTION = laLegend[x-1]
		ENDIF
		loGraph.SeriesCollection(x-2).SETDATA(oConst.chDimCategories, oConst.chDataLiteral, @laLabels)
		loGraph.SeriesCollection(x-2).SETDATA(oConst.chDimValues, oConst.chDataLiteral, @laArray)
	ENDFOR

ENDFUNC
*  wwWebGraphics :: ShowGraphFromArray


************************************************************************
* wwWebGraphics :: GetOutput
****************************************
***  Function: This method actually creates the graph on disk
***            and
***    Assume:
***      Pass:
***    Return:
************************************************************************
	FUNCTION GetOutput()

*** Post Config Event for Graphic Layout
	THIS.SetGraphicsOptions(THIS.oOWC.Charts(0))

*** Delete graph files that have timed out
	DeleteFiles(THIS.cPhysicalPath + "IMG*.gif",THIS.nImageTimeout)

	THIS.cImageName = "IMG" + SYS(2015) + ;
		TRANSFORM(APPLICATION.PROCESSID) + ".gif"

*** Now actually create the image on disk
	THIS.oOWC.ExportPicture(THIS.cPhysicalPath + THIS.cImageName, "gif",;
		THIS.nImageWidth, THIS.nImageHeight)

	RETURN [<img src="] + THIS.cLogicalPath + THIS.cImageName + [">]
ENDFUNC
*  wwWebGraphics :: GetOutput

************************************************************************
* wwWebGraphics :: Clear
****************************************
***  Function: Clears the graphics area
***    Assume:
***      Pass:
***    Return:
************************************************************************
	FUNCTION CLEAR()

	THIS.oOWC.CLEAR()

ENDFUNC
*  wwWebGraphics :: Clear

************************************************************************
* wwWebGraphs :: ShowGraphInForm
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
	FUNCTION ShowGraphInForm(lcFormCaption)
	LOCAL loForm AS FORM
	loForm = CREATEOBJECT("GraphForm")

	loForm.ADDOBJECT("oPicture","image")
	loForm.HEIGHT = THIS.nImageHeight
	loForm.WIDTH = THIS.nImageWidth
	loForm.AUTOCENTER = .T.

	IF !EMPTY(lcFormCaption)
		loForm.CAPTION = lcFormCaption
	ENDIF

	loForm.oPicture.LEFT = 0
	loForm.oPicture.TOP = 0
	loForm.oPicture.HEIGHT = THIS.nImageHeight
	loForm.oPicture.WIDTH = THIS.nImageWidth

	loForm.oPicture.PICTURE = THIS.cPhysicalPath + THIS.cImageName
	loForm.oPicture.VISIBLE = .T.

	loForm.SHOW()

	RETURN loForm

ENDFUNC
*  wwWebGraphs :: ShowGraphInForm

************************************************************************
* wwWebGraphs :: GetGraphTypes
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
	FUNCTION GetGraphTypes(lcCursorName)

	IF EMPTY(lcCursorName)
		lcCursorName = "wwWebGraphTypes"
	ENDIF

	CREATE CURSOR  (lcCursorName) (NAME C(80),ID I)

*** Using this format since this comes from a GetConstants
*** export to header file which can be updated as needed
*** by re-running the constant export
TEXT TO lcVar NOSHOW
#define chChartTypeColumnClustered                        0
#define chChartTypeColumnStacked                          1
#define chChartTypeColumnStacked100                       2
#define chChartTypeBarClustered                           3
#define chChartTypeBarStacked                             4
#define chChartTypeBarStacked100                          5
#define chChartTypeLine                                   6
#define chChartTypeLineStacked                            8
#define chChartTypeLineStacked100                         10
#define chChartTypeLineMarkers                            7
#define chChartTypeLineStackedMarkers                     9
#define chChartTypeLineStacked100Markers                  11
#define chChartTypeSmoothLine                             12
#define chChartTypeSmoothLineStacked                      14
#define chChartTypeSmoothLineStacked100                   16
#define chChartTypeSmoothLineMarkers                      13
#define chChartTypeSmoothLineStackedMarkers               15
#define chChartTypeSmoothLineStacked100Markers            17
#define chChartTypePie                                    18
#define chChartTypePieExploded                            19
#define chChartTypePieStacked                             20
#define chChartTypeScatterMarkers                         21
#define chChartTypeScatterLine                            25
#define chChartTypeScatterLineMarkers                     24
#define chChartTypeScatterLineFilled                      26
#define chChartTypeScatterSmoothLine                      23
#define chChartTypeScatterSmoothLineMarkers               22
#define chChartTypeBubble                                 27
#define chChartTypeBubbleLine                             28
#define chChartTypeArea                                   29
#define chChartTypeAreaStacked                            30
#define chChartTypeAreaStacked100                         31
#define chChartTypeDoughnut                               32
#define chChartTypeDoughnutExploded                       33
#define chChartTypeRadarLine                              34
#define chChartTypeRadarLineMarkers                       35
#define chChartTypeRadarLineFilled                        36
#define chChartTypeRadarSmoothLine                        37
#define chChartTypeRadarSmoothLineMarkers                 38
#define chChartTypeStockHLC                               39
#define chChartTypeStockOHLC                              40
#define chChartTypePolarMarkers                           41
#define chChartTypePolarLine                              42
#define chChartTypePolarLineMarkers                       43
#define chChartTypePolarSmoothLine                        44
#define chChartTypePolarSmoothLineMarkers                 45
#define chChartTypeColumn3D                               46
#define chChartTypeColumnClustered3D                      47
#define chChartTypeColumnStacked3D                        48
#define chChartTypeColumnStacked1003D                     49
#define chChartTypeBar3D                                  50
#define chChartTypeBarClustered3D                         51
#define chChartTypeBarStacked3D                           52
#define chChartTypeBarStacked1003D                        53
#define chChartTypeLine3D                                 54
#define chChartTypeLineOverlapped3D                       55
#define chChartTypeLineStacked3D                          56
#define chChartTypeLineStacked1003D                       57
#define chChartTypePie3D                                  58
#define chChartTypePieExploded3D                          59
#define chChartTypeArea3D                                 60
#define chChartTypeAreaOverlapped3D                       61
#define chChartTypeAreaStacked3D                          62
#define chChartTypeAreaStacked1003D                       63
ENDTEXT

	lnLines = ALINES(laLines,lcVar)

	FOR x = 1 TO lnLines
		lcValue = Extract(laLines[x],"   ",CHR(13),,.T. )
		INSERT INTO (lcCursorName) (NAME,ID) VALUES ;
			( Extract(laLines[x],"#define "," "), VAL(lcValue))
	ENDFOR

	REPLACE ALL NAME WITH STRTRAN(NAME,"chChartType","")

ENDFUNC
*  wwWebGraphs :: GetGraphTypes



************************************************************************
* wwWebGraphs :: SetGraphicsOptions
****************************************
***  Function: Override hook method that allows updating the look
***            of the graph.
***    Assume: virtual
***      Pass:
***    Return:
************************************************************************
	FUNCTION SetGraphicsOptions(loChart)
	RETURN
ENDFUNC
*  wwWebGraphs :: SetGraphicsOptions

	FUNCTION nGraphType_Assign(lvGraphType)

	IF VARTYPE(lvGraphType) = "N"
		THIS.nGraphType = lvGraphType
		RETURN
	ENDIF

	IF VARTYPE(lvGraphType) = "C"
		lvGraphType = UPPER(lvGraphType)
		DO CASE
			CASE lvGraphType = "BAR3D"
				THIS.nGraphType = 50
			CASE lvGraphType = "BAR"
				THIS.nGraphType = 0
			CASE lvGraphType = "PIE3D"
				THIS.nGraphType = 58
			CASE lvGraphType = "PIE"
				THIS.nGraphType = 18
			CASE lvGraphType = "PIEEXPLODED3D"
				THIS.nGraphType = 59
			CASE lvGraphType = "PIEEXPLODED"
				THIS.nGraphType = 19
			CASE lvGraphType = "COLUMN3D"
				THIS.nGraphType = 51
			CASE lvGraphType = "COLUMN"
				THIS.nGraphType = 3
			CASE lvGraphType = "LINE3D"
				THIS.nGraphType = 54
			CASE lvGraphType = "LINEPOINTS"
				THIS.nGraphType = 7
			CASE lvGraphType = "LINE"
				THIS.nGraphType = 6

		ENDCASE
	ENDIF

ENDDEFINE
*EOC wwWebGraphs


*** Form class used to optionally display the graph
DEFINE CLASS GraphForm AS FORM
	SHOWWINDOW = 2 && Top Level Form
	CAPTION = "Graph Results"
	MAXBUTTON = .F.
	BORDERSTYLE = 2
ENDDEFINE

