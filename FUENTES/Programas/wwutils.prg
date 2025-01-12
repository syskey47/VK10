************************************************************************
* FUNCTION Utils
******************
***    Author: Rick Strahl
***            (c) West Wind Technologies, 1995-98
***   Contact: (541) 386-2087  / rstrahl@west-wind.com
***  Modified: 12/22/97
***  Function: A set of utility classes and functions used by 
***            the various classes and processing code.
*************************************************************************
#INCLUDE FOXPRO.H
#INCLUDE WCONNECT.H

SET PROCEDURE TO wwUtils ADDITIVE


*************************************************************
DEFINE CLASS wwEnv AS Custom
*************************************************************
***  Function: Saves environment settings.
*************************************************************

*** Custom Properties
PROTECTED cSetting,vOldValue


************************************************************************
* wwEnv :: Init
*********************************
***  Function: Saves and restores environment settings
***    Assume: Limited to simple ON/OFF settings
***            Very limited!!! Test carefully.
***      Pass: tcSetting  -   SET value to set
***            tvNewValue -   Value to set to
***    Return:
************************************************************************
FUNCTION Init
LPARAMETERS tcSetting,tvNewValue
THIS.Set(tcSetting, tvNewValue)
ENDFUNC
* Init

************************************************************************
* wwEnv :: Set
*********************************
FUNCTION Set
LPARAMETERS tcSetting,tvNewValue
THIS.cSetting=tcSetting

THIS.vOldValue=SET( tcSetting )

IF TYPE("tvNewValue")="C" AND ;
   INLIST(UPPER(tvNewValue),"ON","OFF") 
   SET &tcSetting &tvNewValue
ELSE
   SET &tcSetting TO (tvNewValue)   
ENDIF

ENDFUNC
* Set
************************************************************************
* wwEnv :: Destroy
*********************************
FUNCTION Destroy
LOCAL lcSetting,lvValue

lcSetting=THIS.cSetting
lvValue=THIS.vOldValue

IF TYPE("lvValue")="C" AND ;
   INLIST(UPPER(lvValue),"ON","OFF") 
   SET &lcSetting &lvValue
ELSE
   SET &lcSetting TO (lvValue)   
ENDIF

ENDFUNC
* Destroy

ENDDEFINE
*EOC wwEnv


#IF .F.
*DEFINE CLASS wwUtils as Custom
#ENDIF


*************************************************************************
****
**** STANDALONE FUNCTIONS
****
*************************************************************************

************************************************************************
FUNCTION OpenExclusive
**********************
***  Modified: 01/27/96
***  Function: Tries to open a table exclusively
***    Assume: Table name can't contain a file name.
***            Returns .F. for other reasons like file !found etc.
***            USES wwEVAL object to test for success
***            Parameters MUST NOT BE LPARAMETERS!!!
***      Pass: lcTable   -  Name of table to open exclusively
***    Return: .T. or .F.
************************************************************************
PARAMETERS lcTable, lcAlias
LOCAL lcOldError, llRetVal, loEval

lcTable=IIF(EMPTY(lcTable),"",lcTable)
lcAlias=IIF(EMPTY(lcAlias),JustStem(lcTable),lcAlias)

IF EMPTY(lcTable)
   RETURN .F.
ENDIF

loEval=CREATE([WWC_wwEval])

*** Use Exclusively to reindex and pack
IF !USED(lcAlias)
   loEval.ExecuteCommand("USE (lcTable) EXCLUSIVE IN 0 ALIAS (lcAlias)")
ELSE
   SELE (lcAlias)
   loEval.ExecuteCommand("USE (lcTable) EXCLUSIVE  ALIAS (lcAlias)")
ENDIF

llRetVal=!loEval.lError

*** Now try to re-open table as shared
IF !llRetVal
   USE (lcTable) IN 0 ALIAS(lcAlias)
ELSE
   SELE (lcAlias)   
ENDIF   

RETURN llRetVal
*EOP OpenExclusive


************************************************************************
FUNCTION File2Var
******************
***  Function: Takes a file and returns the contents as a string or
***            Takes a string and stores it in a file if a second
***            string parameter is specified.
***      Pass: tcFilename  -  Name of the file
***            tcString    -  If specified the string is stored
***                           in the file specified in tcFileName
***    Return: file contents as a string
************************************************************************
LPARAMETERS tcFileName, tcString
LOCAL lcRetVal, lnHandle, lnSize

tcFileName=IIF(EMPTY(tcFileName),"",tcFileName)

IF VARTYPE(tcString) # "C"
   *** File to Text
   lcRetVal=""
   
   *** Make sure file exists and can be opened for READ operation
   lnHandle=FOPEN(tcFileName,0)
   IF lnHandle#-1
     lnSize = FSEEK(lnHandle,0,2)
     FSEEK(lnHandle,0,0)
     lcRetVal=FREAD(lnHandle,lnSize)
     =FCLOSE(lnHandle)
   ENDIF
ELSE
   tcString=IIF(EMPTY(tcString),"",tcString)
   
   *** Text to File
   lnHandle=FCREATE(tcFileName)
   IF lnHandle=-1
      RETURN .F.
   ENDIF
   =FWRITE(lnHandle,tcString)
   =FCLOSE(lnHandle)
   RETURN .T.
ENDIF

RETURN lcRetVal
*EOP File2Var

***********************************************************
FUNCTION CopyObject
*******************
***    Author: Rick Strahl, West Wind Technologies
***            http://www.west-wind.com/
***  Function: Function that copies an object and all of 
***            it child object into a totally new object 
***            reference that is not based on a previous 
***            reference
***    Assume: Support for 1 dimensional arrays only
***      Pass: loObject - Existing object reference to copy
***    Return: New Object reference
***********************************************************
LPARAMETER loInput
LOCAL loObject, laFields[1], x, lcField, lcType, llClass, ;
      lnCount, z, lnLength

#DEFINE COPYOBJECT_PROPERTYEXCLUSIONLIST ;
 ",classlibrary,baseclass,comment,controls,objects,"+;
 "class,name,helpcontextid,whatsthishelpid," +;
 "tag,picture,onetomany,childalias,childorder,"+;
 "parent,parentclass,relationalexpr,controlcount,"

*** Check if we can instantiate input object class
IF TYPE("loInput.Class") = "C"
   *** If we have a class create it
   loObject = CREATEOBJECT(loInput.CLASS)
ELSE
   *** SCATTER NAME Objects don't have a class
   loObject = CREATE("Relation")
ENDIF

*** Grab member properties and loop through 'em
lnCount = AMEMBERS(laFields, loInput)
FOR x=1 TO lnCount
   lcField = LOWER(laFields[x])
   
   *** Ignore stock properties
   IF AT("," + lcField + ",","'" + ;
         COPYOBJECT_PROPERTYEXCLUSIONLIST) > 0
      LOOP
   ENDIF
   
   *** Grab the type
   lcType = TYPE("loInput."+lcField)

   DO CASE
      *** Must check for array properties first
      CASE TYPE([ALEN(loInput.] + lcField + [)]) = "N"
         *** Add property if it doesn't exist
         IF TYPE("loObject." + lcField) = "U"
            loObject.ADDPROPERTY(lcField + "[1]")
         ENDIF

         *** Create the array then run through
         *** NOTE: only 1d supported
         lnLength = ALEN(loInput.&lcField)
         DIMENSION loObject.&lcField[lnLength]
         FOR z=1 TO lnLength
            IF TYPE("loInput." +lcField + "[z]")="O"
               loObject.&lcField[z] = ;
                  CopyObject(EVAL( "loInput." + ;
                                   lcField + "[z]"))
            ELSE
               loObject.&lcField[z] = EVAL("loInput." + ;
                                           lcField)
            ENDIF
         ENDFOR
         
      *** Recursive calls for objects
      CASE lcType = "O"
         IF TYPE("loObject." + lcField) = "U"
            loObject.ADDPROPERTY(lcField)
         ENDIF

         loObject.&lcField = ;
                  CopyObject(EVAL("loInput."+lcField))
      OTHERWISE
         *** Check if property exists
         IF TYPE("loObject." + lcField) = "U"
            loObject.ADDPROPERTY(lcField)
         ENDIF

         *** Straight Assignment
         loObject.&lcField = EVAL("loInput." + lcField)
   ENDCASE
ENDFOR

RETURN loObject
* EOF CopyObject

************************************************************************
FUNCTION CursorToObjectArray
****************************
***  Function: Creates an array of objects of the currently open
***            cursor. The result is an object that has two properties
***            the count and the array of objects that contain the
***            records. The object has properties for each field
***            value (except general fields)
*** Parameter: lcClass  -  Optional class that has aRows and nCount 
***                        members         
***    Return: Object or .NULL. if no records in cursor
************************************************************************
LPARAMETER lcObjName
LOCAL x, laLItems[1]

*** Create object and set count and array properties
IF !EMPTY(lcObjName)
   loResult = CREATE("lcObjName")
ELSE   
	loResult = CREATE("RELATION")
	loResult.ADDPROPERTY("nCount")
	loResult.AddProperty("aRows(1)",1)
ENDIF

x = 0
SCAN
   x=x+1
   DIMENSION loResult.aRows[x]
   SCATTER NAME loResult.aRows[x] MEMO
ENDSCAN

loResult.nCount = x

RETURN loResult
*EOP CursorToObjectArray

************************************************************************
FUNCTION CacheFile
******************
***  Function: Caches read from disk in a cursor. Use like File2Var.
***    Assume: Using llCheckDate can worsen performance considerably
***      Pass: lcFileName       -   Name of the file to read/cache
***            lnRefreshSeconds -   If the file cached is older than
***                                 the number of seconds specified
***                                 here it's reloaded. Use 0 to 
***                                 never reload.
***    Return: String of the file or "" 
************************************************************************
LPARAMETERS lcFileName, lnRefreshSeconds
LOCAL lcOutput, lnHandle 

lcAlias = ALIAS()

IF USED("wwFileCache")
   SELECT wwFileCache
ELSE 
   CREATE CURSOR wwFileCache ;
	  (FileName C(120),;
	   TimeRead T,;
	   Content M)
*	INDEX ON PADR(LOWER(FileName),120) Tag FileName
ENDIF   

LOCATE FOR FileName = PADR(LOWER(lcFileName),120)
IF FOUND()
    *** Reread the file if timed out
	IF lnRefreshSeconds > 0 AND;
	   wwFileCache.TimeRead < DATETIME() - lnRefreshSeconds

      REPLACE Content with FILE2VAR(lcFileName),;
	              TimeRead with DATETIME()
	ENDIF

    lcOutput = Content
ELSE
     lcOutput = File2Var(lcFileName)
     INSERT INTO wwFileCache (FileName, TimeRead, Content) ;
	          VALUES (LOWER(lcFileName),DATETIME(),lcOutput)

ENDIF          

IF !EMPTY(lcAlias)
  SELEC (lcAlias)
ENDIF

RETURN lcOutput
ENDFUNC


************************************************************************
FUNCTION WrCursor
******************
***  Function: Creates a Writable cursor from a SELECTed cursor.
***            The original cursor is closed after completion.
***
***    Assume: No checks for valid cursor are performed! Make sure
***            you have a cursor and not a buffered table image!
***            CURSOR MUST BE CURRENTLY SELECTED!
***
***      Pass: pcNewName  -  New Alias name for the cursor
***
***    Return: nothing
************************************************************************
PARAMETER pcNewName
PRIVATE lcOldAlias

*** work with the current Cursor
lcOldAlias=ALIAS()

*** Select the cursor and get file name
SELE (lcOldAlias)
lcDBF=DBF(lcOldAlias)

*** Make sure things are closed in the new alias
IF USED(pcNewName)
   USE IN (pcNewName)
ENDIF

USE (lcDBF) AGAIN ALIAS (pcNewName) IN 0

USE IN (lcOldAlias)

SELE (pcNewName)

RETURN 

************************************************************************
FUNCTION Extract
******************
***  Function: Extracts a text value between two delimiters
***    Assume: Delimiters case insensitive
***            The first instance only is retrieved. Idea is
***            to translate the delims as you go...
***      Pass: lcString   -  Entire string
***			   lcDelim1   -  The starting delimiter
***            lcDelim2	  -  Ending delimiter
***            lcDelim3	  -  Alternate ending delimiter
***            llEndOk	  -  End of line is OK
***    Return: Text between delimiters or ""
*************************************************************************
PARAMETERS lcString,lcDelim1,lcDelim2,lcDelim3, llEndOk
PRIVATE x,lnLocation,lcRetVal,lcChar,lnNewString,lnEnd

#IF wwVFPVersion > 6
   IF EMPTY(lcDelim3) 
      RETURN STREXTRACT(lcString,lcDelim1,lcDelim2,1,1 + IIF(llendOk,2,0) )
   ENDIF
#ENDIF

lcDelim1=IIF(LEN(lcDelim1)=0,",",lcDelim1)
lcDelim2=IIF(LEN(lcDelim2)=0,"z!x",lcDelim2)
lcDelim3=IIF(EMPTY(lcDelim3),"z!x",lcDelim3)

lnLocation=ATC(lcDelim1,lcString)
IF lnLocation=0
   RETURN ""
ENDIF

lnLocation=lnlocation+len(lcDelim1)

*** Crate a new string of remaining text
lcNewString=SUBSTR(lcString,lnLocation)

lnEnd=ATC(lcDelim2,lcNewString)
IF lnEnd>0
   RETURN SUBSTR(lcNewString,1,lnEnd-1)
ENDIF   
*!*	IF lnEnd = 0
*!*	   *** Empty Delimited string
*!*	   RETURN ""
*!*	ENDIF
   
lnEnd=ATC(lcDelim3,lcNewString)
IF lnEnd>0
   RETURN SUBSTR(lcNewString,1,lnEnd-1)
ENDIF   

IF llEndOk
  *** Return to the end of the line
  RETURN SUBSTR(lcNewString,1)
ENDIF

RETURN ""
*EOP RetValue


************************************************************************
FUNCTION wwPath
******************
***  Function: Adds or deletes items from the path string
***      Pass: pcPathName   -   Filename
***            pcMethod     -   *"ADD","DELETE"
***    Return: New Path or ""
************************************************************************
PARAMETERS pcPath,pcMethod
LOCAL lcOldPath

IF VARTYPE(pcMethod) # "C"
   pcMethod = "ADD"
ENDIF

IF EMPTY(pcPath)
   RETURN
ENDIF
   
pcPath=ADDBS(LOWER(TRIM(pcPath)))
lcOldPath=LOWER(SET("PATH"))

IF pcMethod="ADD"
    IF EMPTY(pcPath) .OR. ;
       !Directory(pcPath)
       RETURN ""
   ENDIF
   IF AT(";" + pcPath + ";" ,";" + lcOldPath + ";")>0
      RETURN ""
   ENDIF
   lcOldPath=lcOldPath+";"+pcPath
ELSE
   IF AT(";" + pcPath + ";" ,";" + lcOldPath + ";") < 1
      RETURN ""
   ENDIF
   lcOldPath=STRTRAN(lcOldPath + ";" ,";" +pcPath+";",";")
   lcOldPath = SUBSTR(lcOldPath,1,LEN(lcOldPath)-1)
ENDIF   

SET PATH TO &lcOldPath

RETURN lcOldPath
*EOP PATH


************************************************************************
FUNCTION DomainName
*******************
***  Modified: 04/13/96
***  Function: Retrieves a Domain name from an URL
***    Assume: URL starts with http:// - // required!
***      Pass: lcUrl         -  URL to retrieve name from
***            llNoStripWWW  -  Don't strip www.
***    Return: Domain Name or ""
*************************************************************************
LPARAMETER lcUrl, llNoStripWWW
lcText=STRTRAN(EXTRACT(lower(lcUrl),"//","/"," "),"/","")
IF !llNoStripWWW
  lcText=STRTRAN(lcText,"www.","")
ENDIF
RETURN PADR(lcText,50)


************************************************************************
FUNCTION PropertyDump
**********************
***  Function: Dumps all of an objects properties to a string separated
***            by Carriage Returns. Note Long strings will be truncated
***            at 80 characters
***      Pass: loObject  -  Object to work with
***    Return: string of key value pairs
*************************************************************************
LPARAMETER loObject
LOCAL x, lnCount, lcOutput

lnCount = AMEMBERS(laFields, loObject)
lcOutput = ""
FOR x=1 to lnCount
   lcType = TYPE("loObject."+laFields[x])
   IF ATC(lcType,"UO") = 0
      lvValue = EVAL("loObject."+laFields[x])
      IF lcType="C" AND LEN(lvValue) > 80
         lvValue = LEFT(lvValue,80)
      ENDIF
      lcOutput = lcOutput  + CHR(13) +  CHR(10) + lower(laFields[x]) + " = " + ALLTRIM(TRANSFORM(lvValue,""))
   ELSE
      lcOutput = lcOutput + CHR(13) + CHR(10) +Lower(laFields[x]) + " = " + IIF(TYPE("loObject."+laFields[x])="O","Object","NULL")
   ENDIF
ENDFOR

RETURN lcOutput
* EOF PropertyDump


************************************************************************
FUNCTION FixPreTags
********************
***  Function: Fixes <PRE> tags in HTML pages so that they
***            display properly and can be cut and pasted
***            as code. Replaces <p> and <br> tags with
***            real carriage returns.
***      Pass: lcHTML  -   HTML to fix
***    Return: Fixed HTML
*************************************************************************
LPARAMETER lcHTML, lnColWidth
LOCAL lcPre, lcFixed, lcPrecount, lnAt1, lnAt2

*** Fix up <Pre> formatted text. Use plain Returns
*** so the code can be pasted properly
lnPrecount = 1
DO WHILE .T.
   lnAt1 = ATC("<pre",lcHTML,lnPreCount)
   lnAt2 = ATC("/pre>",lcHTML,lnPreCount)
   IF lnAt1 = 0 or lnAt2 = 0
      EXIT
   ENDIF
   lcPre = substr(lcHTML,lnAt1,lnAt2 - lnAt1)
   
   lcFixed = STRTRAN(lcPre,"<p>",CHR(13)+CHR(10)+CHR(13)+CHR(10))
   lcFixed = STRTRAN(lcFixed,"<br>",CHR(13)+CHR(10))

   lcHTML = STRTRAN(lcHTML,lcPre,lcFixed)
   lnPreCount = lnPreCount + 1
ENDDO

RETURN lcHTML


************************************************************************
Function FixHTMLForDisplay
************************************************************************
#IF .F.
*:Help Documentation
*:Topic:
wwUtils::FixHTMLForDisplay

*:Description:
This method fixes up HTML for display. Takes HTML and XML tags and converts
them to HTML displayable characters (&lt; for < for example).

*:Parameters:
<<b>>lcHTML<</b>>
HTML to fix up.

*:Returns:
Fixed up HTML
*:ENDHELP
#ENDIF
************************************************************************
LPARAMETER lcHTML

lcHTML = STRTRAN(lcHTML,"<","&lt;")
lcHTML = STRTRAN(lcHTML,">","&gt;")
lcHTML = STRTRAN(lcHTML,["],"&quot;")

RETURN lcHTML

************************************************************************
FUNCTION DisplayMemo
**************************
***  Function: Fixes linebreaks into HTML breaks <br> and <p>
***      Pass: lcHTML  -   HTML to fix
***    Return: Fixed HTML
*************************************************************************
LPARAMETER lcHTML

lcHTML = STRTRAN(lcHTML,CHR(13)+CHR(10),CHR(13))
lcHTML = STRTRAN(lcHTML,CHR(10),CHR(13))
lcHTML = STRTRAN(lcHTML,CHR(13)+CHR(13),"<p>")

RETURN STRTRAN(lcHTML,CHR(13),"<br>")
* FixHTMLLineBreaks



*!*	************************************************************************
*!*	FUNCTION ErrorDisplay
*!*	**********************
*!*	***  Function:
*!*	***    Assume:
*!*	***      Pass:
*!*	***    Return:
*!*	*************************************************************************
*!*	LPARAMETER  lnError, lcMethod, lnLine, lcClass
*!*	LOCAL lcText, lcTitle

*!*	lnError=IIF(EMPTY(lnError),0,lnError)
*!*	lcMethod=IIF(EMPTY(lcMethod),"Unknown",lcMethod)
*!*	lcClass=IIF(EMPTY(lcClass),"Unknown",lcClass)
*!*	lnLine=IIF(EMPTY(lnLine),0,lnLine)

*!*	lcTitle = lcClass + "::" + lcMethod
*!*	lcText = "An error occurred in a class method:" +CHR(13)+CHR(13)+;
*!*	         "Error No:		" + LTRIM(STR(lnError)) + CHR(13) + ;
*!*	         "Error Msg:	"+Message()+CHR(13) + ;
*!*	         "Code:		" + Message(1) + CHR(13) + ;
*!*	         "Line: 		" + LTRIM(STR(lnLine)) + CHR(13)+CHR(13)+;
*!*	         "Do you want to step into the Error Code?"

*!*	lnResult = MessageBox(lcText, 48+4,lcTitle)         
*!*	IF lnResult = 6
*!*	   RETURN .T.
*!*	ENDIF
*!*	   
*!*	RETURN .F. 
*!*	* EOF ErrorDisplay


****************************************************
FUNCTION GoUrl
******************
***    Author: Rick Strahl
***            (c) West Wind Technologies, 1996
***   Contact: rstrahl@west-wind.com
***  Modified: 03/14/96
***  Function: Starts associated Web Browser
***            and goes to the specified URL.
***            If Browser is already open it
***            reloads the page.
***    Assume: Works only on Win95 and NT 4.0
***      Pass: tcUrl  - The URL of the site or
***                     HTML page to bring up
***                     in the Browser
***    Return: 2  - Bad Association (invalid URL)
***            31 - No application association
***            29 - Failure to load application
***            30 - Application is busy 
***
***            Values over 32 indicate success
***            and return an instance handle for
***            the application started (the browser) 
****************************************************
LPARAMETERS tcUrl, tcAction, tcDirectory

tcUrl=IIF(type("tcUrl")="C",tcUrl,;
          "http://www.west-wind.com/")
          
tcAction=IIF(type("tcAction")="C",tcAction,"OPEN")

tcDirectory=IIF(EMPTY(tcDirectory),SYS(2023),tcDirectory)

DECLARE INTEGER ShellExecute ;
    IN SHELL32.dll ;
    INTEGER nWinHandle,;
    STRING cOperation,;
    STRING cFileName,;
    STRING cParameters,;
    STRING cDirectory,;
    INTEGER nShowWindow

DECLARE INTEGER FindWindow ;
   IN WIN32API ;
   STRING cNull,STRING cWinName

RETURN ShellExecute(FindWindow(0,_SCREEN.caption),;
                    tcAction,tcUrl,;
                    "",tcDirectory,1)


************************************************************************
FUNCTION ShowHTML
*****************
***  Function: Takes an HTML string and displays it in the default
***            browser. 
***    Assume: Uses a file to store HTML temporarily.
***            For this reason there may be concurrency issues
***            unless you change the file for each use
***      Pass: lcHTML       -   HTML to display
***            lcFile       -   Temporary File to use (Optional)
***            loWebBrowser -   Web Browser control ref (Optional)
************************************************************************
LPARAMETERS lcHTML, lcFile, loWebBrowser

lcHTML=IIF(EMPTY(lcHTML),"",lcHTML)
lcFile=IIF(EMPTY(lcFile),SYS(2023)+"\ww_HTMLView.htm",lcFile)

File2Var(lcFile,lcHTML)

IF TYPE("loWebBrowser") = "O"
   loWebBrowser.Navigate(lcFile)
ELSE
   IF TYPE("_oscreenx") = "O"
      _oscreenx.Navigate(lcFile)
   ENDIF
*!*	   IF lower(JUSTEXT(lcFile)) = "txt"
*!*	      MODI COMM (lcFile) IN MACDESKTOP
*!*	   ELSE
      =GoUrl(lcFile)
*!*	   ENDIF
ENDIF   

RETURN
*EOP ShowHTML

************************************************************************
FUNCTION ShowXML
*****************
***  Function: Takes an XML string and displays it in the default
***            browser. 
***    Assume: Uses a file to store HTML temporarily.
***            For this reason there may be concurrency issues
***            unless you change the file for each use
***      Pass: lcHTML       -   HTML to display
***            lcFile       -   Temporary File to use (Optional)
***            loWebBrowser -   Web Browser control ref (Optional)
************************************************************************
LPARAMETERS lcHTML, lcFile, loWebBrowser
IF EMPTY(lcFile)
  lcFile=IIF(EMPTY(lcFile),SYS(2023)+"\ww_HTMLView.xml",lcFile)
ENDIF
ERASE (lcFile) 
RETURN ShowHTML(lcHTML,lcFile,loWebBrowser)

************************************************************************
FUNCTION ShowText
*****************
***  Function: Takes an XML string and displays it in the default
***            browser. 
***    Assume: Uses a file to store HTML temporarily.
***            For this reason there may be concurrency issues
***            unless you change the file for each use
***      Pass: lcHTML       -   HTML to display
***            lcFile       -   Temporary File to use (Optional)
***            loWebBrowser -   Web Browser control ref (Optional)
************************************************************************
LPARAMETERS lcHTML, lcFile, loWebBrowser
IF EMPTY(lcFile)
  lcFile=IIF(EMPTY(lcFile),SYS(2023)+"\ww_HTMLView.txt",lcFile)
ENDIF

IF VARTYPE(loWebBrowser) = "C" and loWebBrowser = "MODI"
   FILE2VAR(lcFile,lcHTML)
   MODIFY COMMAND (lcFile)
   RETURN
ENDIF   

RETURN ShowHTML(lcHTML,lcFile,loWebBrowser)


************************************************************************
FUNCTION IsWinnt
*****************
***      Pass: llReturnVersionNumber
***    Return: .t. or .f.   or Version Number or -1 if not NT
*************************************************************************
LPARAMETER llReturnVersionNumber

loAPI=CREATE("wwAPI")
lcVersion = loAPI.ReadRegistryString(HKEY_LOCAL_MACHINE,;
           "SOFTWARE\Microsoft\Windows NT\CurrentVersion",;
           "CurrentVersion")
                          
IF !llReturnVersionNumber
  IF ISNULL(lcVersion)
     RETURN .F.
  ELSE
     RETURN .T.
  ENDIF
ENDIF

IF ISNULL(lcVersion)
   RETURN -1
ENDIF

RETURN VAL(lcVersion)   
* IsWinNt



************************************************************************
FUNCTION StripHTML
*******************
***  Function: Removes HTML tags from the passed text and converts
***            it to plain text. Note formatting is totally removed!
***    Assume: only <br> and <p> are translated
***            any < or > in the HTML besides tags will break this
***            function.
***      Pass: lcText  -   HTML Text to strip
***            lcLTag  -   Left Tag value ("<")
***            lcRTag  -   Right Tag Value (">")
***    Return: Stripped HTML text
*************************************************************************
LPARAMETER lcHTMLText, lcLTag, lcRTag

lcLTag=IIF(EMPTY(lcLTag),"<",lcLTag)
lcRTag=IIF(EMPTY(lcRTag),">",lcRTag)

IF ATC(lcLTag,lcHTMLText) = 0
   RETURN lcHTMLText
ENDIF

*** Start by breaking line breaks
lcHTMLText = STRTRAN(lcHTMLText,lcLTag + "BR" + lcRTag,CRLF)
lcHTMLText = STRTRAN(lcHTMLText,lcLTag + "P" + lcRTag,CRLF+CRLF)
lcHTMLText = STRTRAN(lcHTMLText,lcLTag + "br" + lcRTag,CRLF)
lcHTMLText = STRTRAN(lcHTMLText,lcLTag + "p" + lcRTag,CRLF+CRLF)
lcHTMLText = STRTRAN(lcHTMLText,"&nbsp;"," ")

lcExtract = "x"   
DO WHILE !EMPTY(lcExtract)
   lcExtract = Extract(lcHTMLText,lcLTag,lcRTag)

   IF EMPTY(lcExtract)
      EXIT
   ENDIF
   lcHTMLText = STRTRAN(lcHTMLText,lcLTag+lcExtract+lcRTag,"")
ENDDO

lcHTMLText = STRTRAN(lcHTMLText,"&lt;","<")
lcHTMLText = STRTRAN(lcHTMLText,"&gt;",">")

RETURN lcHTMLText

************************************************************************
FUNCTION HTMLColor
*********************************
***  Function: Converts a FoxPro Color to an HTML Hex color value
***      Pass: lnRGBColor   -  FoxPro RGB color number - RGB(255,255,255)
***            llNoOutput
***    Return: Hex HTML Color String "#FFFFFF"
************************************************************************
LPARAMETER lnRGBColor

lcColor=RIGHT(TRANSFORM(lnRGBColor,"@0"),6)

*** Fox color is BBGGRR, HTML is RRGGBB

RETURN "#" + SUBSTR(lcColor,5,2) + SUBSTR(lcColor,3,2) + LEFT(lcColor,2)
* HTMLColor


************************************************************************
FUNCTION CharToBin
******************
***  Function: Converts a DWORD value in binary string form back into
***            a numeric value
***      Pass: tcWord  -    Binary string value (from a structure?)
***    Return: numeric value of binary string
*************************************************************************
LPARAMETER tcWord

  LOCAL i, lnWord

  lnWord = 0
  FOR i = 1 TO LEN(tcWord)
    lnWord = lnWord + (ASC(SUBSTR(tcWord, i, 1)) * (2 ^ (8 * (i - 1))))
  ENDFOR

RETURN lnWord

************************************************************************
PROCEDURE StrTranC
******************
***  Function: Like Strtran but case insensitive
***      Pass: lcString   -  Entire string
***			   lcDelim1   -  String to replace
***            lcDelim2	  -  String to replace with
***    Return: translated string
*************************************************************************
LPARAMETER lcString, lcSource, lcReplace

#IF wwVFPVersion > 6
  RETURN STRTRAN(lcString,lcSource,lcReplace,1,-1,1)
#ELSE
LOCAL lnAt

lnAt = 1
lnReplaceSize = LEN(lcSource)
DO while .T.
   lnAt = ATC(lcSource,lcString)
   IF lnAT = 0
      RETURN lcString
   ENDIF
   
   lcString = STUFF(lcString,lnAt,lnReplaceSize,lcReplace)
ENDDO

RETURN lcString
#ENDIF


FUNCTION TimeToCStrict
LPARAMETER ltTime, llSQL

lcCentury = SET("CENTURY")
lcDateMode = SET("DATE")
SET CENTURY ON
SET DATE TO YMD

IF llSQL
  lcDate = "'" + TTOC(ltTime) + "'"
ELSE
  lcDate = "{^" + TTOC(ltTime) + "}"
ENDIF

SET DATE TO &lcDateMode
SET CENTURY &lcCentury
RETURN lcDate

************************************************************************
FUNCTION DateToC
******************
***  Function: Converts a date to string displaying empty dates as blanks
***            rather than displaying the empty date format
***      Pass: ldDate  - Date to display
***    Return: Date String or "" if invalid date
*************************************************************************
LPARAMETER ldDate

IF EMPTY(ldDate)
   RETURN ""
ENDIF

RETURN  DTOC(ldDate)
* DateTOC



************************************************************************
FUNCTION TimeToC
******************
***  Function: Converts a time to string displaying empty  as blanks
***            and formatting the time string properly
***      Pass: ltTime  - Date to display (Pass Time, Date or Char)
***    Return: Time String or "" if invalid date (Year is not returned)
*************************************************************************
LPARAMETER ltTime

IF EMPTY(ltTime)
   RETURN ""
ENDIF

IF VARTYPE(ltTime) $ "DT"
  lcTimestamp = TTOC(ltTime)
ELSE
  lcTimeStamp = ltTime  
ENDIF  

RETURN  Substr(lcTimeStamp,1,5)+"/" + Substr(lcTimeStamp,9,8)+lower(Substr(lcTimeStamp,21,2))
* DateTOC

************************************************************************
FUNCTION GetAppStartPath
*********************************
***  Function: Returns the FoxPro start path
***            of the *APPLICATION*
***            under all startmodes supported by VFP.
***            Returns the path of the starting EXE, 
***            DLL, APP, PRG/FXP
***    Return: Path as a string with trailing "\"
************************************************************************

DO CASE 
   *** VFP 6 provides ServerName property for COM servers EXE/DLL/MTDLL
   CASE INLIST(Application.StartMode,2,3,5) 
         lcPath = JustPath(Application.ServerName)

   *** Active Document
   CASE ATC(".APP",SYS(16,0)) > 0
       lcPath = JustPath(SYS(16,0))

  *** Standalone EXE or VFP Development
  OTHERWISE
       lcPath = JustPath(SYS(16,0))
       IF ATC("PROCEDURE",lcPath) > 0
         lcPath = SUBSTR(lcPath,RAT(":",lcPath)-1)
       ENDIF
ENDCASE

RETURN AddBs(lcPath)
* EOF GetAppStartPath      


************************************************************************
FUNCTION ShortPath
******************
***  Function: Converts a Long Windows filename into a short
***            8.3 compliant path/filename
***      Pass: lcPath   -  Path to check
***    Return: lcShortFileName
*************************************************************************
LPARAMETER lcPath

DECLARE INTEGER GetShortPathName IN Win32API;
  STRING @lpszLongPath,	STRING @lpszShortPath,;
  INTEGER cchBuffer

lcPath = lcPath
lcshortname = SPACE(260)
lnlength = LEN(lcshortname)
lnresult = GetShortPathName(@lcPath, @lcshortname, lnlength)
IF lnResult = 0
   RETURN ""
ENDIF
RETURN LEFT(lcShortName,lnResult)


************************************************************************
FUNCTION DeleteFiles
********************
***  Function: Returns the size of a file
***      Pass: lcFileName   - Wildcard File Spec  (d:\temp\*.pdf)
***            lnTimeout    - Timeout in seconds 
***    Return: the size of the file or -1 on error
************************************************************************
PARAMETERS lcFileSpec, lnTimeout
PRIVATE x,lnFiles, loAPI

lnTimeout=IIF(EMPTY(lnTimeout),300,lnTimeout)

lnFiles = aDir(laFiles,lcFileSpec)
*loEval = CREATE([WWC_wwEval])
FOR x=1 to lnFiles
   ldtime = CTOT( DTOC(laFiles[x,3]) + " " + laFiles[x,4] )
   IF  ldTime + lnTimeout < DateTime()
 *     loEval.ExecuteCommand( " ERASE (ADDBS(justpath(lcFileSpec)) + laFiles[x,1]) " )
     ERASE (ADDBS(justpath(lcFileSpec)) + laFiles[x,1]) 
   ENDIF
ENDFOR

RETURN .T.
ENDFUNC


************************************************************************
FUNCTION IsDir
******************
***  Modified: 10/09/97
***  Function: Checks to see whether a directory exists
***      Pass: lcPath   -  Path to check
***    Return: .T. or .F.
*************************************************************************
LPARAMETER lcPath
DIMENSION laTemp[1]
IF ADIR(laTemp,lcPath,"DH") < 1
   RETURN .F.
ENDIF
RETURN .T.

************************************************************************
FUNCTION FileSize
******************
***  Function: Returns the size of a file
***      Pass: lcFileName
***    Return: the size of the file or -1 on error
************************************************************************
LPARAMETERS lcFileName
LOCAL lh, lnSize

lh = FOPEN(lcFileName)
IF lh = -1
   RETURN -1
ENDIF

lnSize = FSEEK(lh, 0, 2)   

FCLOSE(lh)

RETURN lnSize
*EOP FileSize


************************************************************************
FUNCTION Slash
******************
***  Function: Converts slashes from DOS -> Web and vice versa
***      Pass: lcPath   -  Path to convert
***            lcStyle  -  "WEB" or "DOS"
***    Return: update path
************************************************************************
LPARAMETER lcPath, lcStyle
lcStyle=IIF(type("lcStyle")="C",UPPER(lcStyle),"")
IF lcStyle="WEB"
   lcPath=CHRTRAN(lcPath,"\","/")
ELSE
   lcPath=CHRTRAN(lcPath,"/","\")
ENDIF
RETURN lcPath
*EOP LPARAMETER

************************************************************************
FUNCTION ProgLevel
******************
***  Function: Returns the current Calling Stack level. Used to check
***            recursive Error calls in Error methods.
*************************************************************************

FOR x=1 to 128
   IF EMPTY(SYS(16,x))
      exit
   ENDIF
ENDFOR && x=1 to 128

*** -1 for x count - -1 for ProgLevel Call
RETURN x - 2


************************************************************************
FUNCTION AParseString
**********************
***  Modified: 07/03/97
***  Function: Parses a delimited string into an array
***      Pass: laResult    -   Array containing the result strings (@)
***            lcString    -   The full string
***            lcDelimiter -   The delimiter string
***    Return: Count of strings or 0 if null string is passed
*************************************************************************
LPARAMETER laResult, lcString, lcDelimiter
LOCAL lnLastPos, lnItemCount, i

lnItemCount = OCCURS(lcDelimiter,lcString) + 1
DIMENSION laResult[lnItemCount]

lnLastPos=1

FOR i=1 to lnItemCount
   IF i < lnItemCount
     laResult[i] = SUBSTR(lcString,lnLastPos, ;
                          ATC(lcDelimiter,lcString,i) - lnLastPos )
   ELSE
     laResult[i] = SUBSTR(lcString,lnLastPos)
   ENDIF
   lnLastPos = ATC(lcDelimiter,lcString,i) + LEN(lcDelimiter)
ENDFOR

RETURN lnItemCount

************************************************************************
FUNCTION URLDecode
******************
***  Function: URLDecodes a text string to normal text.
***    Assume: Uses wwIPStuff.dll
***      Pass: lcText    -   Text string to decode
***    Return: Decoded string or ""
************************************************************************
LPARAMETERS lcText
LOCAL lnSize, lnLoc, lcHex, lcRetval

*** Use wwIPStuff for large buffers
IF LEN(lcText) > 255
   DECLARE INTEGER URLDecode ;
      IN WWIPSTUFF AS API_URLDecode ;
      STRING @cText

   lnSize=API_URLDecode(@lcText)

   IF lnSize > 0
      lcText = SUBSTR(lcText,1,lnSize)
   ELSE
      lcText = ""
   ENDIF

   RETURN lcText
ENDIF

*** First convert + to spaces
lcText=STRTRAN(lcText,"+"," ")

*** Handle Hex Encoded Control chars

lcRetval = ""
DO WHILE .T.
   *** Format: %0A  ( CHR(10) )
   lnLoc = AT('%',lcText)

   *** No Hex chars
   IF lnLoc > LEN(lcText) - 2 OR lnLoc < 1
      lcRetval = lcRetval + lcText
      EXIT
   ENDIF

   *** Now read the next 2 characters
   *** Check for digits - at this point we must have hex pair!
   lcHex=SUBSTR(lcText,lnLoc+1,2)

   *** Now concat the string plus the evaled hex code
   lcRetval = lcRetval + LEFT(lcText,lnLoc-1) + ;
      CHR( EVAL("0x"+lcHex) )

   *** Trim out the input string
   IF LEN(lcText) > lnLoc + 2
      lcText = SUBSTR(lcText,lnLoc+3)
   ELSE
      EXIT
   ENDIF
ENDDO

RETURN lcRetval
ENDFUNC
* EOF URLDecode

************************************************************************
FUNCTION GetURLEncodedKey
*********************************
***  Function: Retrieves a 'parameter' from the query string that
***            is encoded with standard CGI/ISAPI URL encoding.
***            Typical URL encoding looks like this:
***
***    "User=Rick+Strahl&ID=0011&Address=400+Morton%0A%0DHood+River"
***
***      Pass: lcVal   -   Form Variable to retrieve
***    Return: Value or ""
************************************************************************
LPARAMETERS tcURLString, lcKey
LOCAL lnLoc,c2, cStr, lcURLString, lcRetval

lcURLString=IIF(EMPTY(tcURLString),"","&"+tcURLString)
lcKey=IIF(EMPTY(lcKey),"  ",lcKey)
lcKey=STRTRAN(lcKey," ","+")

#IF wwVFPVersion > 6
	lcRetval = STREXTRACT(lcUrlString,"&"+lcKey+"=","&",1,3)
#ELSE
    lcRetval=Extract(@lcUrlString,"&"+lcKey+"=","&",,.T.)
#ENDIF

RETURN URLDecode(lcRetval)
ENDFUNC


********************************************************
FUNCTION URLEncode
*******************
***  Function: Encodes a string in URL encoded format
***            for use on URL strings or when passing a
***            POST buffer to wwIPStuff::HTTPGetEx
***      Pass: tcValue  -   String to encode
***    Return: URLEncoded string or ""
********************************************************
LPARAMETER tcValue
LOCAL lcResult, lcChar, lnSize, x

*** Large Buffers use the wwIPStuff function 
*** for quicker response
if LEN(tcValue) > 255
   lnSize=LEN(tcValue)
   tcValue=PADR(tcValue,lnSize * 3)

   DECLARE INTEGER VFPURLEncode ;
      IN WWIPSTUFF ;
      STRING @cText,;
      INTEGER cInputTextSize
   
   lnSize=VFPUrlEncode(@tcValue,lnSize)
   
   IF lnSize > 0
      RETURN SUBSTR(TRIM(tcValue),1,lnSize)
   ENDIF
   RETURN ""
ENDIF   
   
*** Do it in VFP Code
lcResult=""

FOR x=1 to len(tcValue)
   lcChar = SUBSTR(tcValue,x,1)
   IF ATC(lcChar,"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") > 0
      lcResult=lcResult + lcChar
      LOOP
   ENDIF
   IF lcChar=" "
      lcResult = lcResult + "+"
      LOOP
   ENDIF
   *** Convert others to Hex equivalents
   lcResult = lcResult + "%" + RIGHT(transform(ASC(lcChar),"@0"),2)
ENDFOR && x=1 to len(tcValue)

RETURN lcResult
* EOF URLEncode


************************************************************************
FUNCTION WCSCompile
*******************
***  Modified: 12/31/97
***  Function: Compiles WCS script files
***    Assume: Requires Runtime version
***            Called by wwMaint using VisualFoxpro.Application
***            Automation object if Runtime is installed.
***      Pass: lcFileSpec    -   Filespec of files to compile
***            llSilent      -   No error display
***    Return: "" on success or Error String
*************************************************************************
LPARAMETER lcFileSpec, llSilent
lcFileSpec=IIF(type("lcFileSpec")="C",lcFileSpec,CURDIR() + "*.wcs")

lcPath = justpath(lcFileSpec)
lcFile = justfname(lcFileSpec)

IF EMPTY(lcPath)
  lcPath = CURDIR()
ENDIF
IF EMPTY(lcFile)
  lcFile = "*.WCS"
ENDIF
lcPath = ADDBS(lcPath)

lcFileSpec = lcPath + lcFile


DIMENSION laFiles[1]
lnFiles = ADIR(laFiles,lcFileSpec)
IF lnFiles < 1
   RETURN "No files to compile..."
ENDIF
oScript = CREATE("wwVFPScript",laFiles[1])
IF TYPE("oScript") <> "O"
  Return "Error: Couldn't create wwVFPScriptObject"
ENDIF
oScript.lDeleteGeneratedCode = .F.   && Erase WCT files

FOR x = 1 to lnFiles
         lcFileName = lcPath+laFiles[x,1]
         wait window nowait "Compiling "+lcFileName
         
         *** WCS - Script Text   WCX - Compiled   WCT - Intermediate
         oScript.cFileName = lcFileName
         oScript.ConvertPage()
         oScript.CompilePage() 
ENDFOR

wait window nowait LTRIM(STR(lnFiles))+ " Web Connection Script file(s) compiled."

lcErrors = ""
IF !EMPTY(oScript.cCompileErrors)
   File2Var(lcPath + "WCS_Script.err",oScript.cCompileErrors)
   IF !llSilent
      MODI COMM (lcPath + "WCS_Script.err")
   ENDIF
   lcErrors = File2Var(lcPath + "WCS_Script.err")
ENDIF

RETURN lcErrors
* EOF WCSCompile


************************************************************************
FUNCTION MergeText
******************
***  Function: This function provides an evaluation engine for FoxPro
***            expressions and Codeblocks that is tuned for Active
***            Server syntax. It works with any delimiters however. This
***            parsing engine is faster than TEXTMERGE and provides
***            extensive error checking and the ability to run
***            dynamically in the VFP runtime (ie uncompiled). Embed any
***            valid FoxPro expressions using
***            
***               <%= Expression%>
***            
***            and any FoxPro code with
***            
***               <% CodeBlock %>
***            
***            Expressions ideally should be character for optimal
***            speed, but other values are converted to string
***            automatically. Although optimized for the delimiters
***            above you may specify your own. Make sure to set the
***            llNoAspSyntax parameter to .t. to disallow the = check
***            for expressions vs code. If you use your own parameters
***            you can only evaluate expressions OR you must use ASP
***            syntax and follow your deleimiters with an = for
***            expressions.
***   Assume:  Delimiter is not used in regular text of the text.
***     Uses:  wwEval class (wwEval.prg)
***            Codeblock Class (wwEval.prg)         
***     Pass:  tcString    -    String to Merge
***            tcDelimeter -    Delimiter used to embed expressions
***                             Default is "<%"
***            tcDelimeter2-    Delimiter used to embed expressions
***                             Default is "%>"
***            llNoAspSytnax    Don't interpret = following first
***                             parm as expression. Everything is 
***                             evaluated as expressions.
***
***  Example:  loHTML.MergeText(HTMLDocs.MemField,"##","##",.T.)
*************************************************************************
LPARAMETER tcString,tcDelimiter, tcDelimiter2, llNoASPSyntax
LOCAL __loEval
__loEval = CREATE([WWC_wwEval])
RETURN __loEval.MergeText(@tcString,tcDelimiter, tcDelimiter2, llNoASPSyntax)
*EOF MergeText



**************************************************
FUNCTION IsCOMObject
*********************
*** Function: Checks to see if a COM object 
***           or ActiveX control exists
***   Assume: Uses wwAPI
***     Pass: lcProgId   - Prog Id of the Class
***           lcClassId  - (Optional) If passed in 
***                        by reference gets ClassId
***           lcClassDescript - (Optional) by ref
***   Return: .T. or .F.
*****************************************************
LPARAMETER lcProgId,lcClassId, lcClassDescript

IF EMPTY(lcProgId)
   RETURN .F.
ENDIF

loAPI = CREATE("wwAPI")

*** Retrieve ClassId and Server Name
lcClassId =  ;
   loAPI.ReadRegistryString(HKEY_CLASSES_ROOT,;
                            lcProgId + "\CLSID",;
                            "")
IF ISNULL(lcClassId)
   lcClassId = ""
   lcClassDescription = ""
   RETURN .F.
ENDIF                                       
                            
lcClassDescript = ;
   loAPI.ReadRegistryString(HKEY_CLASSES_ROOT,;
                            lcProgId,"")

IF ISNULL(lcClassDescript)
   lcClassDescript = ""
ENDIF
                                    
RETURN .T.

************************************************************************
FUNCTION RegisterOleServer
**************************
***    Author: Rick Strahl, West Wind Technologies
***            http://www.west-wind.com/
***  Function: Registers an OLE server or OCX control
***      Pass: lcServerPath  -  Full path and filename of OCX/OLE Server
***            llUnregister  -  .T. to unregister
***            llSilent      -  .T. or .F.
***    Return: .T. or .F.
*************************************************************************
LPARAMETER lcServerPath, llUnRegister, llSilent
LOCAL llRetVal, lcPath, lcOldPath

IF !FILE(lcServerPath)
    RETURN .f.
ENDIF

llRetVal=.F.
IF !llUnregister
   lcOldPath = SYS(5) + curdir()
   lcPath = JUSTPATH(lcServerPath)
   CD (lcPath)
   
   DECLARE INTEGER DllRegisterServer ;
      IN (lcServerPath)

   IF DllRegisterServer() = 0
      If !llSilent
         wait window nowait lcServerPath + " has been registered..."
      endif
      llRetVal=.T.
   ELSE
*!*         DECLARE INTEGER GETLASTERROR IN WIN32API
*!*         lnError = GetLastError()
*!*         wait window STR(lnError)
      wait window lcserverPath +  " could not be registered..." TIMEOUT 5
   ENDIF
   
   cd (lcOldPath)   
ELSE
   DECLARE INTEGER DllUnregisterServer ;
      IN (lcServerPath)

   IF DllUnregisterServer() = 0
      if !llSilent
        wait window nowait lcServerPath + " has been unregistered..."
      ENDIF
      llRetVal=.T.
   ENDIF
ENDIF      

RETURN llRetVal

************************************************************************
FUNCTION DCOMCnfgServer
***********************
***  Function: Sets the security attributes of an Automation server
***            to Interactive User or a specific user account
***    Assume: If a password is passed DCOMPermissions.exe must be
***            available in the Foxpro path
***      Pass: lcProgId  -  Program ID for the server (wcdemo.wcdemoserver)
***            lcRunAs   -  User Account (Default: Interactive User)
***    Return: nothing
*************************************************************************
LPARAMETER lcProgId, lcRunAs, lcPassword
LOCAL lcProgId, loAPI, lcClassId, lcServerName

lcRunAs=IIF(type("lcRunAs")="C",lcRunAs,"Interactive User")
lcProgId=IIF(type("lcProgId")="C",lcProgId,"")
lcPassword=IIF(EMPTY(lcPassword),"",lcPassword)


loAPI = CREATE("wwAPI")

*** Retrieve ClassId and Server Name
lcClassId = loAPI.ReadRegistryString(HKEY_CLASSES_ROOT,;
                                     lcProgId + "\CLSID",;
                                     "")
lcServerName = loAPI.ReadRegistryString(HKEY_CLASSES_ROOT,;
                                        lcProgId + "","")

IF ISNULL(lcClassId) or ISNULL(lcServerName)
  wait window nowait "Invalid Class Id..."
  RETURN
ENDIF
  
wait window "Configuring server security for "+CR+;
             lcProgId + CR + lcServerName  nowait


IF !EMPTY(lcPassword)
   IF !FILE("dcompermissions.exe")
      WAIT WINDOW "Couldn't find dcompermissions.exe..." TIMEOUT 5
      RETURN
   ENDIF
   lcPath = FULLPATH("dcompermissions.exe")
   lcPath = SHORTPATH(lcPath)

   lcCmd = ;
      "RUN " +lcPath +" -runas " + lcClassId + " " + lcRunas + " " + lcPassword +" > dcom.txt"
       
   &lcCMD

   lcResult = FILETOSTR("DCOM.TXT")
   ERASE DCOM.TXT

   IF !EMPTY(lcResult) AND ATC("ERROR:",lcResult) >0
      MESSAGEBOX(lcProgId + CHR(13) + "Account: " + lcUserName + CHR(13)+ CHR(13) +lcResult ,48,"DCOM Permissions")
      RETURN .F.
   ENDIF
ELSE


   *** Now add AppId key to the ClsID entry
   if !loAPI.WriteRegistryString(HKEY_LOCAL_MACHINE,;
           "SOFTWARE\Classes\CLSID\"+lcClassId,"AppId",lcClassID,.t.)
      wait window "Unable to write AppID value..."  nowait
      RETURN
   ENDIF                                     


   *** Create a AppID Entry if it doesn't exist
   if !loAPI.WriteRegistryString(HKEY_CLASSES_ROOT,;
           "AppID\"+lcClassId,CHR(0),CHR(0),.t.)
      wait window "Unable to write AppID key..."  nowait
      RETURN
   ENDIF                                     

   *** Write the Server Name into the Default key
   loAPI.WriteRegistryString(HKEY_CLASSES_ROOT,;
                             "AppID\"+lcClassId,"",;
                             lcServerName,;
                             .t.)


   *** Write Interactive User (or user Accounts)                          
   loAPI.WriteRegistryString(HKEY_CLASSES_ROOT,;
                             "AppID\"+lcClassId,"RunAs",;
                             lcRunAS,;
                             .t.)
ENDIF

wait window "DCOM security context set to: " + lcRunAs nowait                          
RETURN 





************************************************************************
* wwUtils :: DCOMLaunchPermissions
****************************************
***  Function: Sets DCOM Launch and Access Permissions for a specific
***            server. If no ProgId is passed in Default permissions are 
***            set.
***    Assume: DCOMPermissions.exe is in Fox path
***      Pass: lcProgId   -  Progid of COM object
***            lcUserName -  Username to add to Access/Launch permissions
***            @lcErrorMsg - Pass by reference to get error message back
***    Return: .T.  or .F.     (UI shows error messages)
************************************************************************
FUNCTION DCOMLaunchPermissions
LPARAMETERS lcProgid,lcusername, lcErrorMsg

IF !EMPTY(lcProgid)
   lcClassID=""
   llResult = IsComObject(lcProgId,@lcClassID)

   IF EMPTY(lcClassID)
      WAIT WINDOW "Invalid Prog ID"
      RETURN .F.
   ENDIF
ELSE
   lcClassId = ""
ENDIF

lcPath = FULLPATH("dcompermissions.exe")
lcPath = SHORTPATH(lcPath)

IF EMPTY(lcClassID)
   lcCmd = ;
   "RUN " +lcPath +" -da " + lcClassId + " set " + lcUserName + " permit > dcom.txt"
   _cliptext = lcCMD
ELSE
   lcCmd = ;
   "RUN " +lcPath +" -aa " + lcClassId + " set " + lcUserName + " permit > dcom.txt"
   _cliptext = lcCMD
ENDIF
&lcCMD

lcResult = FILETOSTR("DCOM.TXT")
ERASE DCOM.TXT

IF !EMPTY(lcResult) AND ATC("ERROR:",lcResult) > 0
   MESSAGEBOX(lcProgId + CHR(13) + "Account: " + lcUserName + CHR(13)+ CHR(13) +lcResult ,48,"DCOM Permissions")
   RETURN .F.
ENDIF

IF EMPTY(lcClassID)
   lcCmd = ;
   "RUN " +lcPath +" -dl " + lcClassId + " set " + lcUserName + " permit > dcom.txt"
   _cliptext = lcCMD
ELSE
   lcCmd = ;
   "RUN " +lcPath +" -al " + lcClassId + " set " + lcUserName + " permit > dcom.txt"
   _cliptext = lcCMD   
ENDIF

&lcCMD

lcResult = FILETOSTR("DCOM.TXT")
ERASE DCOM.TXT

IF !EMPTY(lcResult) AND ATC("ERROR:",lcResult) >0
   MESSAGEBOX(lcProgId + CHR(13) + "Account: " + lcUserName + CHR(13)+ CHR(13) +lcResult ,48,"DCOM Permissions")
   RETURN .F.
ENDIF

RETURN

#IF .F.
*ENDDEFINE
#ENDIF


* Pass X/YFactor by reference
FUNCTION TwipsFactor(lnXFactor, lnYFactor)
LOCAL ln_x_pixels, ln_y_pixels, ln_twips, ln_partial_x, ln_partial_y, ;
     ln_hwnd, ln_hdc

*** Calculate the factor to be used in the HitTest method...
ln_x_pixels = 88
ln_y_pixels = 90
ln_twips    = 1440

DECLARE INTEGER GetActiveWindow IN win32api
DECLARE INTEGER GetActiveWindow IN win32api
DECLARE INTEGER GetDC           IN win32api INTEGER iHDC
DECLARE INTEGER GetDeviceCaps   IN win32api INTEGER iHDC, INTEGER iIndex

ln_hwnd = GetActiveWindow()
ln_hdc  = GetDC(ln_hwnd)

ln_partial_x = GetDeviceCaps(ln_hdc, ln_x_pixels)
ln_partial_y = GetDeviceCaps(ln_hdc, ln_x_pixels)

lnXFactor = ln_twips/ln_partial_x
lnYFactor = ln_twips/ln_partial_y
RETURN


************************************************************************
* wwUtils :: GetSystemPassword
****************************************
***  Function: Retrieves the AutoLogon Password
***    Assume: Used for demos so I don't have to type my pass
***      Pass: optional llUsername - returns username
***    Return: string
************************************************************************
FUNCTION GetSystemPassword
LPARAMETERS llUserName

loAPI = CREATEOBJECT("wwAPI")
IF !llUserName
   lcPass=loAPI.ReadRegistryString("HKLM","SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","DefaultPassword")
ELSE
   lcPass=loAPI.ReadRegistryString("HKLM","SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","DefaultUserName")
ENDIF

IF ISNULL(lcPass)
   RETURN ""
ENDIF

RETURN lcPass
ENDFUNC
*  wwUtils :: GetSystemPassword

************************************************************************
* wwUtils :: PasswordForm
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION GetPassword(lcMessage)
RETURN InputForm(SPACE(20),"Please enter your password","Password Entry",,,"PASSWORD")
ENDFUNC
*  wwUtils :: PasswordForm

************************************************************************
FUNCTION InputForm
******************
***  Function: Creates a simple Input form that returns a value
***    Assume: Consists of this function and Form Class
***      Pass: lcValue   -   Initial value to retrieve
***            lcMessage -   The request message
***            lcCaption -   Form Caption (_Screen.Caption)
***            lnFormWidth   Width of the form
***            lnFieldWidth  Widht of the input field
***            lcFormat		  Format string for the input field
***            lcCancelValue Value returned on a Cancel operation 
***    Return: Value or ("" or -1)
************************************************************************
LPARAMETER lcValue, lcMessage, lcCaption, lnFormWidth, lnFieldWidth, lcFormat,lcCancelValue
PRIVATE pcResult
LOCAL o

IF PCOUNT() > 6
  pcCancelValue = lcCancelValue
ELSE
  pcCancelValue = NULL
ENDIF

lcValue=IIF(EMPTY(lcValue),"",lcValue)
lcMessage=IIF(EMPTY(lcMessage),"Please enter",lcMessage)
lcCaption=IIF(EMPTY(lcCaption),_SCREEN.Caption,lcCaption)
lnFormWidth=IIF(EMPTY(lnFormWidth),300,lnFormWidth)
lnFieldWidth=IIF(EMPTY(lnFieldWidth),lnFormWidth - 20,lnFieldWidth)
lcFormat=IIF(EMPTY(lcFormat),"@K",lcFormat)


lcType = VARTYPE(lcCancelValue)
pcResult = lcValue

o=CREATE("frmInput")
o.Width = lnFormWidth
o.nFieldWidth = lnFieldWidth
o.Caption = lcCaption
o.cMessage = lcMessage
o.cFormat = lcFormat

IF lcFormat = "PASSWORD"
   o.cFormat = "@K"
   o.txtInput.PasswordChar = "*"
ENDIF


o.Show()

IF TYPE("pcResult")="C"
   lcValue = TRIM(pcResult)
ELSE
   lcValue = pcResult
ENDIF   
RETURN lcValue


**************************************************
*-- Form:         frminput 
*-- ParentClass:  form
*-- BaseClass:    form
DEFINE CLASS frminput AS form
    nFieldWidth = 250
    cMessage = "Please enter:"
    cFormat = ""

	Top = 0
	Left = 0
	Height = 90
	Width = 300
	ControlBox = .F.
	Name = "frmInput"
	WindowType = 1
	AutoCenter = .t.
	Showwindow = 1
	BorderStyle = 2
	MinButton = .f.
	ShowWindow = 1
	MaxButton = .f.

	ADD OBJECT lblMessage AS label WITH ;
		AutoSize = .T., ;
		Caption = "Message Text:", ;
		Height = 17, ;
		Left = 7, ;
		Top = 11, ;
		Width = 81, ;
		Name = "lblMessage",;
		Font = "Tahoma" ,;
		FontSize = 8
		
	ADD OBJECT txtinput AS textbox WITH ;
		ControlSource = "pcResult", ;
		Height = 22, ;
		Left = 5, ;
		Top = 28, ;
		Width = 373, ;
		Name = "txtInput",;
		Font = "Tahoma" ,;
        Default = .T.,;
		FontSize = 8
	ADD OBJECT cmdOk AS commandbutton WITH ;
		Top = 55, ;
		Left = THISFORM.width - 150, ;
		Height = 25, ;
		Width = 70, ;
		Caption = "OK", ;
		Default = .T., ;
		Fontname="Tahoma",;
		Fontsize = 8,;
        Cancel = .F.,;
		Name = "cmdOK"

	ADD OBJECT cmdCancel AS commandbutton WITH ;
		Top = 55, ;
		Left = THISFORM.Width - 75, ;
		Height = 25, ;
		Width = 70, ;
		Caption = "\<Cancel", ;
		Fontname="Tahoma",;
		Fontsize = 8,;
		Cancel = .T.,;
		Name = "cmdCancel" 

    PROCEDURE Show
        THIS.Icon = _Screen.icon
        THIS.txtInput.Width = THIS.nFieldWidth
        THIS.lblMessage.Caption = THIS.cMessage
		THIS.cmdCancel.Left = THISFORM.Width - 85
		THIS.cmdOk.Left = THISFORM.Width - 157
        IF !EMPTY(THIS.cFormat)
           IF ATC("@",THIS.cFormat) > 0
             THIS.txtInput.Format = THIS.cFormat
           ELSE
             THIS.txtInput.InputMask = THIS.cFormat
           ENDIF
        ENDIF
    ENDPROC
	PROCEDURE cmdOk.Click
		RELEASE THISFORM
	ENDPROC
	PROCEDURE cmdCancel.Click
	    LOCAL lcType
       
       IF ISNULL(pcCancelValue)
   	    lcType = TYPE("pcResult")
          DO CASE
               CASE lcType $ "CM"
       	 	    pcResult = ""
        	    CASE lcType $ "NIBY"
            	    pcResult = -99999999
            	CASE lcType $ "DT"
            	    pcResult = {}
            	CASE lcType = "L"
            	    pcResult = .f.
           ENDCASE
      ELSE
         pcResult = pcCancelValue
      ENDIF
	   RELEASE THISFORM
	ENDPROC
ENDDEFINE
*
*-- EndDefine: frminput
**************************************************
