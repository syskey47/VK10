
DO wwWebGraphs  && Load Libs

RETURN
#IF .F.
oHist = CREATEOBJECT("StockHistory")
? oHist.GetMonthlyHistory("msft,intc,yum",{01/01/01},DATE())

SELECT TStockData

oGraph = CREATEOBJECT("wwWebGraphs")
oGraph.nGraphType = "BAR"

REPLACE ALL date WITH STRTRAN(TRIM(DATE)," ","_")
oGraph.ShowGraphFromCursor()
oGraph.GetOutput()

PUBLIC loForm
loForm = oGraph.ShowGraphInForm()

*lcHTML = oHTTP.HTTPGet("http://chart.yahoo.com/table.csv?s=msft&a=4&b=30&c=2001&d=11&e=11&f=2001&g=m&q=q&y=0&z=msft&x=.csv")
**ShowHTML(lcHTML)

RETURN
#ENDIF

*************************************************************
DEFINE CLASS StockHistory AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2001
*:Contact: http://www.west-wind.com
*:Created: 11/11/2001
*************************************************************
#IF .F.
*:Help Documentation
*:Topic:
Class StockHistory

*:Description:

*:Example:

*:Remarks:

*:SeeAlso:


*:ENDHELP
#ENDIF

*** Custom Properties

*** Stock Properties
lGraphPortfolioTotal = .F.

************************************************************************
* StockHistory :: GetMonthlyHistoryMulti
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION GetMonthlyHistoryMulti(lcSymbols,ldFromDate,ldToDate)

lnSymbols = ALINES(laSymbols,lcSymbols,",")

FOR x = 1 TO lnSymbols
   THIS.GetMonthlyHistory(laSymbols[x],ldFromDate,ldToDate)
ENDFOR

THIS.MergeCursors(lcSymbols)

ENDFUNC
*  StockHistory :: GetMonthlyHistoryMulti


************************************************************************
* StockHIstory :: GetMonthlyHistory
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION GetMonthlyHistory(lcSymbol, ldFromDate, ldToDate)

IF "," $ lcSymbol
   THIS.GetMonthlyHistoryMulti(lcSymbol,ldFromDate,ldToDate)
   RETURN
ENDIF   
   
lcSymbol = ALLTRIM(lcSymbol)   

lcUrl = "http://chart.yahoo.com/table.csv?" + ;
        "s=" + lcSymbol +;
        "&a=" + TRANSFORM(MONTH(ldFromDate)) + ;
        "&b=" + TRANSFORM(Day(ldFromDate)) + ;
        "&c=" + TRANSFORM(Year(ldFromDate)) + ;
        "&d=" + TRANSFORM(MONTH(ldToDate)) + ;
        "&e=" + TRANSFORM(Day(ldToDate)) + ;
        "&f=" + TRANSFORM(Year(ldToDate)) +;
        "&z=" + lcSymbol +;
        "&g=m&q=q&x=.csv"  

oHTTP = CREATEOBJECT("Microsoft.XMLHTTP")
oHTTP.Open("GET",lcUrl,.F.)
oHTTP.Send()
lcHTML = oHTTP.responseText

IF lcHTML # "Date,"
   RETURN .F.
ENDIF

lcFile = SYS(2015) + ".csv"
STRTOFILE(lcHTML,lcFile)

CREATE CURSOR ("Stock_" + lcSymbol ) ;
   (Date C(10), Open N(12,4), High N(12,4), ;
    Low N(12,4), Close N(12,4), Volume I) 

APPEND FROM (lcFile) TYPE CSV

*** Fix up date so that OWC can display it right
REPLACE ALL Date WITH STRTRAN(TRIM(DATE)," "," '")

ERASE (lcFile)

RETURN .T.


************************************************************************
* StockHIstory :: MergeCursors
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION MergeCursors(lcSymbols)

lnSymbols = ALINES(laSymbols,TRIM(lcSymbols),",")

lcCommand = ""

FOR x = 1 TO lnSymbols
   IF !USED("Stock_" + laSymbols[x])
      LOOP
   ENDIF
   
   lcCommand = lcCommand + laSymbols[x] + " I,"
ENDFOR

IF EMPTY(lcCommand)
   RETURN .F.
ENDIF

lcCommand  = "CREATE CURSOR TStockData (Date C(10)," + ;
             SUBSTR(lcCommand,1,LEN(lcCommand)-1) + ")"
&lccommand             

lnFields = AFIELDS(laFields,ALIAS())

*** Grab the date field

FOR x=1 TO lnFields
   IF x=1 
      *** Create the records and enter the labels
      SELECT ("Stock_" + laFields[2,1])
      SCAN
          lcDate = Date
          INSERT INTO TStockData(Date) VALUES (lcDate)
      ENDSCAN
   ELSE
      SELECT ("Stock_" + laFields[x,1])
      SCAN
         lnClose = Close
         lcDate = Date
         lcField = laFields[x,1]
         UPDATE TStockData SET &lcfield = lnClose WHERE Date = lcDate
      ENDSCAN                  
   ENDIF   
ENDFOR

SELECT TStockData
INDEX ON RECNO() DESCENDING TAG SortOrder

ENDFUNC
*  StockHIstory :: MergeCursors


ENDDEFINE
*EOC StockHistory 


FUNCTION laGraphs
FUNCTION laLegend
