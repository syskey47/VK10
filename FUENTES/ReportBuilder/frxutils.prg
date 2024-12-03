* Contains:
*
*	FormatExpressionParser
*	frxDeLoader
*	ErrorHandler
*	frxMetaData

#include frxBuilder.h

*=================================================
* Class: FormatExpressionParser
*=================================================
define class FormatExpressionParser as Custom

	TemplateString   = ""
	FormatCodes      = ""
	Value            = ""

	procedure Value_Access
		if not empty( THIS.FormatCodes )
			return "@" + alltrim(THIS.FormatCodes) + " " + alltrim(THIS.TemplateString)
		else
			return alltrim(THIS.TemplateString)
		endif
	endproc
	
	procedure Value_Assign
		lparameter lcFormatExpr

		THIS.Value = m.lcFormatExpr

		if left(m.lcFormatExpr, 1) == "@"
			if " " $ m.lcFormatExpr
				THIS.FormatCodes    = left(   m.lcFormatExpr, at(" ", m.lcFormatExpr)-1 )				
				THIS.TemplateString = substr( m.lcFormatExpr, at(" ", m.lcFormatExpr)+1 )
			else
				THIS.FormatCodes    = substr(m.lcFormatExpr,2)
				THIS.TemplateString = ""
			endif
		else
			THIS.FormatCodes    = ""				
			THIS.TemplateString = m.lcFormatExpr
		endif
	endproc

enddefine

*===========================================
* Class frxDeLoader
*
* Utility methods for loading a data environment
* into an FRX file.
*
*===========================================

define class frxDeLoader as custom

name       = "frxDeLoader"
deClass    = ""
deClassLib = ""

*-------------------------------------------------------
* LoadFromReport( REPORTFILE )
*
* Replaces the current FRX cursor's DE records with ones 
* copied from another FRX file.
*
* Assumes: frx is currently selected
*
* Returns:
*	0 = Success
*   1 = error loading report
*-------------------------------------------------------
procedure LoadFromReport
lparameters cFrxFile

private iRetval, frxAlias
iRetVal = 0
frxAlias   = alias()

try 
	use (m.cFrxFile) again in 0 shared noupdate alias srcFrx
catch to oError
	iRetVal = 1
	* Maybe change this later:
	local cErrorMsg
	cErrorMsg = oError.message + c_CR + ;
	            "Line " + transform(oError.lineNo) + " in " + oError.procedure + "()"
	if not empty( oError.lineContents )
		cErrorMsg = m.cErrorMsg + ":" + c_CR + oError.lineContents
	endif
	if not empty( oError.userValue )
		cErrorMsg = m.cErrorMsg + c_CR + "Additional info: " + oError.userValue
	endif
	=messagebox( LOAD_DE_ERROR_LOC+c_CR+m.cErrorMsg, 0+48, DEFAULT_MBOX_TITLE_LOC )
endtry
if m.iRetVal = 0
	select (m.frxAlias)
	*--------------------------------------------
	* delete the current DE records in the FRX:
	*--------------------------------------------
	delete for inlist( OBJTYPE, FRX_OBJTYP_DATAENV, FRX_OBJTYP_DATAOBJ )

	select srcFrx
	scan for inlist( OBJTYPE, FRX_OBJTYP_DATAENV, FRX_OBJTYP_DATAOBJ )
		scatter memo to tmpRecord
		scatter memo name oTempRec
		insert into (frxAlias) from name oTempRec
	endscan			
	
endif
if used( "srcFrx" )
	use in srcFrx 
endif
select (m.frxAlias)
return m.iRetVal

endproc

*-------------------------------------------------------
* LoadFromClass( CLASS, CLASSLIB )
*
* Replaces the current FRX cursor's DE records with ones generated 
* from a DataEnvironment class. Records are linked to the DE class 
* through method code.
*
* Assumes: frx is currently selected
*
* Returns:
*	0 = Success
*   1 = error instantiating class
*   2 = invalid base class type
*-------------------------------------------------------
procedure LoadFromClass
lparameters cDEClass, cDeClasslib

local curSel
curSel = select()

* Used by GetMethodCode():
THIS.DEclass    = cDeClass
THIS.DEclasslib = cDeClasslib

*------------------------------------
* Helper class:
*------------------------------------
local ox
ox = newobject("frxClassUtil","frxBuilder.vcx")

*------------------------------------
* instantiate the DE class, with error trapping for any 
* possible silly init code:
*------------------------------------
local oDe, oDeObj
oDe = ox.getInstanceOf( THIS.DEClass, THIS.DEClasslib )
if isnull( m.oDE )
	*------------------------------------
	* Error instantiating class:
	*------------------------------------
	return 1
endif

*------------------------------------
* Check the base class type:
*------------------------------------
if oDe.Baseclass <> "Dataenvironment"
	*------------------------------------
	* Error: invalid base class:
	*------------------------------------
	release oDe
	clear class (THIS.DEClass)
	return 2
endif

*--------------------------------------------
* delete the current DE records in the FRX:
*--------------------------------------------
delete for inlist( OBJTYPE, FRX_OBJTYP_DATAENV, FRX_OBJTYP_DATAOBJ )
go bottom

*------------------------------------
* Load up the report:
*------------------------------------

local iCursorCount, iAdapterCount, iRelationCount
store 0 to iCursorCount, iAdapterCount, iRelationCount

local cExpr, cName, cMethods
store "" to cExpr, cName, cMethods

* delete the current DE records in the FRX:
* insert new ones based on the DE object:

*------------------------------------
* Save the current textmerge delimiters
* and set to default:
*------------------------------------
local lcTextMergeDelims
lcTextMergeDelims = set("TEXTMERGE",1)
set textmerge delimiters

*-----------------------------------------------
* Insert the data environment record:
* We're using some default values here, should be ok
*-----------------------------------------------
cName = "dataenvironment"


Top = 178
Left = -104
Width = 522
Height = 327
InitialSelectedAlias = "Territories"
DataSource = .NULL.
Name = "Dataenvironment"


text to m.cExpr textmerge noshow pretext 7
	Top = 100
	Left = 117
	Width = 522
	Height = 327
	InitialSelectedAlias = "<< oDE.InitialSelectedAlias >>"
	DataSource = .NULL.
	Name = "Dataenvironment"
endtext

cMethods = THIS.GetMethodCode("dataenvironment")

THIS.insertDERecord( FRX_OBJTYP_DATAENV, m.cName, m.cExpr, m.cMethods )

*-----------------------------------------------
* insert each object record:
*-----------------------------------------------
for each oDeObj in oDE.Objects 

	do case
		
	case oDeObj.Class == "Cursor"
		*-----------------------------------------------
		* Insert the cursor object record:
		*-----------------------------------------------
		iCursorCount = iCursorCount + 1

		cName = "cursor"
		
		if not empty( oDeObj.Database )
			text to m.cExpr textmerge noshow pretext 7
				Top = 20
				Left = << 10 + 140*(m.iCursorCount-1) >>
				Height = 90
				Width = 91
				Alias = "<< oDeObj.Alias >>"
				Database = << oDeObj.Database >>
				CursorSource = "<< oDeObj.Cursorsource >>"
				Name = "<< oDeObj.Name >>"
			endtext
		else
			text to m.cExpr textmerge noshow pretext 7
				Top = 20
				Left = << 10 + 140*(m.iCursorCount-1) >>
				Height = 90
				Width = 91
				Alias = "<< oDeObj.Alias >>"
				CursorSource = << oDeObj.Cursorsource >>
				Name = "<< oDeObj.Name >>"
			endtext
		endif		

		cMethods = THIS.GetMethodCode("cursor")
		
		THIS.insertDERecord( FRX_OBJTYP_DATAOBJ, m.cName, m.cExpr, m.cMethods )

	case oDeObj.Class == "Cursoradapter"
		*-----------------------------------------------
		* Insert the adapter object record:
		*-----------------------------------------------
		iAdapterCount = iAdapterCount + 1

		cName = "cursoradapter"

		text to m.cExpr textmerge noshow pretext 7
			Top = 140
			Left = << 10 + 140*(m.iAdapterCount-1) >>
			Height = 90
			Width = 91
			CursorSchema = << oDeObj.Cursorschema >>
			Alias = "<< oDeObj.Alias >>"
			Name = "<< oDeObj.Name >>"
		endtext

		cMethods = THIS.GetMethodCode("cursoradapter")

		THIS.insertDERecord( FRX_OBJTYP_DATAOBJ, m.cName, m.cExpr, m.cMethods )

	case oDeObj.Class == "Relation"
		*-----------------------------------------------
		* Insert the relation object record:
		*-----------------------------------------------
		iRelationCount = iRelationCount + 1

		cName = "relation"

		text to m.cExpr textmerge noshow pretext 7
			ParentAlias = "<< oDeObj.ParentAlias >>"
			RelationalExpr = "<< oDeObj.RelationalExpr >>"
			ChildAlias = "<< oDeObj.ChildAlias >>"
			ChildOrder = "<< oDeObj.ChildOrder >>"
			OneToMany = << oDeObj.OneToMany >>
			Name = "<< oDeObj.Name >>"
		endtext

		cMethods = THIS.GetMethodCode("relation")

		THIS.insertDERecord( FRX_OBJTYP_DATAOBJ, m.cName, alltrim(m.cExpr), m.cMethods )
	
	endcase
endfor
release oDe
clear class (THIS.DEClass)

*------------------------------------
* Restore the original textmerge delimiters
* if necessary:
*------------------------------------
if m.lcTextMergeDelims <> set("TEXTMERGE",1)
	*-----------------------------------
	* They're using custom delimiters: 
	* Restore them
	*-----------------------------------
	local delimSize, leftDelim, rightDelim
	&& it's either 1 or 2:
	delimSize = int(len(m.lcTextMergeDelims)/2)
	leftDelim  = left(  m.lcTextMergeDelims, m.delimSize )
	rightDelim = right( m.lcTextMergeDelims, m.delimSize )
	set textmerge delimiters to m.leftDelim, m.rightDelim
endif

*------------------------------------
* Compile the TAG fields and place in TAG2:
*------------------------------------
local cSrcFile, cCmpCode
cSrcFile = addbs(sys(2023))+sys(3)

select (m.curSel)
locate for OBJTYPE = FRX_OBJTYP_DATAENV
scan rest

	=strtofile( TAG, m.cSrcFile+".PRG", 0 ) 
	compile (m.cSrcFile+".PRG")
	cCmpCode = filetostr( m.cSrcFile+".FXP" )
	replace tag2 with m.cCmpCode

	erase (m.cSrcFile+".PRG")
	erase (m.cSrcFile+".FXP")

endscan

return 0

endproc


*-------------------------------------------------------
* GetMethodCode( DATA_ENV_OBJECT_TYPE )
*
* Returns a string containing DE methods code
*-------------------------------------------------------
procedure GetMethodCode
lparameter lcObjectType

local cCode

do case
case upper(m.lcObjectType) == "DATAENVIRONMENT"

	*=====================	    
	text to m.cCode textmerge noshow pretext 6
	
	PROCEDURE AfterCloseTables
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    IF THIS.BoundDE.AutoCloseTables
	        THIS.BoundDE.CloseTables()
	    ENDIF
	ENDPROC	
	PROCEDURE BeforeOpenTables
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LOCAL loMember, laDEEvents[1], liMember, liMembers, loBoundMember
	    THIS.AddProperty( "BoundDE", NEWOBJECT( "<< THIS.DEClass >>", "<<THIS.DEClasslib >>" ))
	    IF VARTYPE( THIS.BoundDE ) = "O" AND UPPER( THIS.BoundDE.BaseClass ) = "DATAENVIRONMENT"
	        * Bind events here, skipping the Init and Destroy.
	        * The FRX DE and its members can only have base events,
	        * so not that much PEMSTATUS checking is necessary:
	        liMembers = AMEMBERS( laDEEvents, THIS, 1 )	    
	        FOR liMember = 1 TO liMembers
	            IF INLIST( UPPER( laDEEvents[ liMember, 1] ), "INIT", "DESTROY" )
	                LOOP
	            ENDIF
	            IF INLIST( UPPER( laDEEvents[ liMember, 2] ), "EVENT", "METHOD" )
	                BINDEVENT( THIS, ;
	                           laDEEvents[ liMember, 1], ;
	                           THIS.BoundDE, ;
	                           laDEEvents[ liMember, 1] )
	            ENDIF
	        ENDFOR
	        * Now do the members with appropriate checking,
	        * again skipping the Init and Destroy:
	        FOR EACH loMember IN THIS.Objects FOXOBJECT
	            IF PEMSTATUS( THIS.BoundDE, loMember.Name, 5 ) AND ;
	                UPPER( PEMSTATUS( THIS.BoundDE, loMember.Name, 3 )) = "OBJECT"
	                loBoundMember = EVAL( "THIS.BoundDE." + loMember.Name )
	                IF ( loBoundMember.BaseClass == loMember.BaseClass )
	                    liMembers = AMEMBERS( laDEEvents, loMember, 1 )
	                    FOR liMember = 1 to liMembers
	                        IF INLIST( UPPER( laDEEvents[ liMember, 1] ), "INIT", "DESTROY" )
	                            LOOP
	                        ENDIF
	                        IF INLIST( UPPER( laDEEvents[ liMember, 2] ), "EVENT", "METHOD" )
	                            BINDEVENT( THIS, ;
	                                       laDEEvents[ liMember, 1], ;
	                                       loBoundMember, ;
	                                       laDEEvents[ liMember, 1] )
	                        ENDIF
	                    ENDFOR
	                ENDIF
	            ENDIF            
	        ENDFOR
	        THIS.BoundDE.BeforeOpenTables()
	    ENDIF
	    IF THIS.BoundDE.AutoOpenTables
	        THIS.BoundDE.OpenTables()
	    ENDIF
	ENDPROC
	PROCEDURE Destroy
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LOCAL loMember
	    UNBIND( THIS )
	    FOR EACH loMember in THIS.Objects 
	        UNBIND( loMember )
	    ENDFOR
	    IF PEMSTATUS( THIS, "BoundDE", 5 ) AND UPPER( PEMSTATUS( THIS, "BoundDE", 3 )) = "PROPERTY"
	        THIS.BoundDE = NULL
	    ENDIF
	ENDPROC
	PROCEDURE Error
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LPARAMETERS nError, cMethod, nLine
	    DODEFAULT( nError, cMethod, nLine )
	ENDPROC	

	endtext
	*=====================	    

case upper(m.lcObjectType) == "CURSOR"
	* Basically, the only events are:
	*  Destroy, Error, Init

	*=====================	    
	text to m.cCode textmerge noshow pretext 6

	PROCEDURE Error
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LPARAMETERS nError, cMethod, nLine
	    DODEFAULT( nError, cMethod, nLine )
	ENDPROC	

	endtext
	*=====================	    
	

case upper(m.lcObjectType) == "CURSORADAPTER"

	*=====================	    
	text to m.cCode textmerge noshow pretext 6

	PROCEDURE AfterCursorAttach
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias, lResult
		DODEFAULT( cAlias, lResult )
	ENDPROC
	PROCEDURE AfterCursorClose
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias, lResult
		DODEFAULT( cAlias, lResult )
	ENDPROC
	PROCEDURE AfterCursorDetach
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias, lResult
		DODEFAULT( cAlias, lResult )
	ENDPROC
	PROCEDURE AfterCursorFill
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS luseCursorSchema, lNoDataOnLoad, cSelectCmd, lResult
		DODEFAULT( luseCursorSchema, lNoDataOnLoad, cSelectCmd, lResult )
	ENDPROC
	PROCEDURE AfterCursorRefresh
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cSelectCmd, lResult
		DODEFAULT( cSelectCmd, lResult )
	ENDPROC
	PROCEDURE AfterCursorUpdate
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS nRows, lTableUpdateResult, cErrorArray
		DODEFAULT( nRows, lTableUpdateResult, cErrorArray )
	ENDPROC
	PROCEDURE AfterDelete
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, cDeleteCmd, lResult
		DODEFAULT( cFldState, lForce, cDeleteCmd, lResult )
	ENDPROC
	PROCEDURE AfterInsert
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, cInsertCmd, lResult
		DODEFAULT( cFldState, lForce, cInsertCmd, lResult )
	ENDPROC
	PROCEDURE AfterRecordRefresh
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
		DODEFAULT()
	ENDPROC
	PROCEDURE AfterUpdate
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, nUpdateType, cUpdateInsertCmd, cDeleteCmd, lResult
		DODEFAULT( cFldState, lForce, nUpdateType, cUpdateInsertCmd, cDeleteCmd, lResult )
	ENDPROC
	PROCEDURE BeforeCursorAttach
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias
		DODEFAULT( cAlias )
	ENDPROC
	PROCEDURE BeforeCursorClose
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias
		DODEFAULT( cAlias )
	ENDPROC
	PROCEDURE BeforeCursorDetach
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cAlias
		DODEFAULT( cAlias )
	ENDPROC
	PROCEDURE BeforeCursorFill
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS luseCursorSchema, lNoDataOnLoad, cSelectCmd
		DODEFAULT( luseCursorSchema, lNoDataOnLoad, cSelectCmd )
	ENDPROC
	PROCEDURE BeforeCursorRefresh
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cSelectCmd
		DODEFAULT( cSelectCmd )
	ENDPROC
	PROCEDURE BeforeCursorUpdate
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS nRows, lForce
		DODEFAULT( nRows, lForce )
	ENDPROC
	PROCEDURE BeforeDelete
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, cDeleteCmd
		DODEFAULT( cFldState, lForce, cDeleteCmd )
	ENDPROC
	PROCEDURE BeforeInsert
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, cInsertCmd
		DODEFAULT( cFldState, lForce, cInsertCmd )
	ENDPROC
	PROCEDURE BeforeRecordRefresh
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
		DODEFAULT()
	ENDPROC
	PROCEDURE BeforeUpdate
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	LPARAMETERS cFldState, lForce, nUpdateType, cUpdateInsertCmd, cDeleteCmd
		DODEFAULT( cFldState, lForce, nUpdateType, cUpdateInsertCmd, cDeleteCmd )
	ENDPROC
	PROCEDURE Error
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LPARAMETERS nError, cMethod, nLine
	    DODEFAULT( nError, cMethod, nLine )
	ENDPROC	

	endtext
	*=====================	    

case upper(m.lcObjectType) == "RELATION"

	*=====================	    
	text to m.cCode textmerge noshow pretext 6

	PROCEDURE Error
	*-----------------------------------------------------*
	<< DE_METHOD_HEADER_COMMENT_LOC >>
	*-----------------------------------------------------*
	    LPARAMETERS nError, cMethod, nLine
	    DODEFAULT( nError, cMethod, nLine )
	ENDPROC	

	endtext
	*=====================	    
	
otherwise
	cCode = ""
	
endcase
return m.cCode

endproc

*-------------------------------------------------------
* InsertDERecord( ID, NAME, EXPR, CODE )
*
* Inserts a data-environment object record into an FRX. 
* Assumes that the record pointer is located appropriately.
*-------------------------------------------------------
procedure InsertDERecord
lparameters liObjType, lcName, lcExpr, lcMethods

insert blank
replace ;
	PLATFORM 	with FRX_PLATFORM_WINDOWS, ;
	OBJTYPE  	with m.liObjType, ;
	NAME		with m.lcName, ;
	EXPR		with m.lcExpr, ;
	TAG         with m.lcMethods, ;
	ENVIRON		with .F., ;
	CURPOS		with .F.

return

endproc

enddefine

*===========================================
* Class ErrorHandler
*
* A basic error handler.
*
* Useage:
* x = newobject("ErrorHandler","frxUtils.prg")
* x.Handle( iError, cMethod, iLine, THIS ) 
* if x.cancelled
*  :
* if x.suspened
*  :
*
*===========================================
define Class ErrorHandler as Custom

suspended = .F.
cancelled = .F.
errorText = ""

*------------------------------------------
procedure Handle
*------------------------------------------
lparameters iError, cMethod, iLine, oRef

store .F. to this.cancelled, this.suspended

local cErrorMsg, iRetval
cErrorMsg = message() 

cErrorMsg = m.cErrorMsg + c_CR + ;
			"Line " + transform(m.iLine) + " in " + m.cMethod + "()"

if not empty( message(1) )
	cErrorMsg = m.cErrorMsg + ":" + c_CR + message(1) 
endif
*if not empty( sys(2018) )
*	cErrorMsg = m.cErrorMsg + c_CR + sys(2018) 
*endif
if parameters() > 3
	cErrorMsg = m.cErrorMsg + c_CR2 + oRef.Name + ".Error()"
endif	

*------------------------------------------------------
* Save the error message so that it can be retrieved
*------------------------------------------------------
THIS.errorText = m.cErrorMsg

if DEBUG_SUSPEND_ON_ERROR
	cErrorMsg = m.cErrorMsg + c_CR2 + "Do you want to suspend execution?"

	iRetval = messagebox( cErrorMsg, 3+16+512, DEFAULT_MBOX_TITLE_LOC + " Error" )
	do case
	case m.iRetVal = 6 && yes
		this.suspended = .T.
		
	case m.iRetVal = 2 && cancel
		this.cancelled = .T.

	endcase
else
	=messagebox( cErrorMsg, 0+16, DEFAULT_MBOX_TITLE_LOC + " Error" )
	this.cancelled = .T.
endif

return .F.
endproc

enddefine

*===========================================
* Class frxMetaData
*
* Reading and writing metadata from the 
* STYLE field of the frx
*
*===========================================
define class frxMetaData as custom

	errorMsg   = ""
	declass    = ""
	declasslib = ""
	execute    = ""
	execwhen   = ""
	tag        = "frx"
	xpath      = XPATH_REPORTDATA_DEFAULT
	
*-------------------------------------------------
* Reads the XML metadata from the STYLE column of the 
* alias specified by the TAG property, and populates the 
* .DeClass, .DeClassLib, .Execute, and .ExecWhen properties.
*
* Assumes: we are located on the right record.
*-------------------------------------------------
procedure LoadFromFrx
*-------------------------------------------------
lparameter lcFrxAlias

THIS.errorMsg = ""

if empty(m.lcFrxAlias)
	lcFrxAlias = THIS.Tag
endif	

local cursel, cXml, oDom, oNode
cursel = select()
select (m.lcFrxAlias)

*------------------------------------------------------
* Initialise to default:
*------------------------------------------------------
THIS.declass 	= ""
THIS.declasslib	= ""
THIS.execute    = ""
THIS.execwhen	= ""

*------------------------------------------------------
* If the STYLE field is empty, we don't need to 
* try reading it with the DOM. We'll use the default
* values.
*------------------------------------------------------
if empty( STYLE )
	return 
endif

*------------------------------------------------------
* Create a DomDocument:
*------------------------------------------------------
oDom = null
try 
	try 
		oDom = createobject("MSXml.DomDocument")
	catch 
		*-------------------------------------------
		*  "Unable to create MSXml.DomDocument instance. 
		*   Metadata XML may not be available."
		*-------------------------------------------
		error METADATA_DOM_CREATE_FAILED_LOC
	endtry

	*------------------------------------------------------
	* We have a valid DOM. 
	*------------------------------------------------------
	
	*------------------------------------------------------
	* Read the XML metadata out of the STYLE tag:
	*------------------------------------------------------
	cXml = alltrim(STYLE)

	if oDom.loadXML( m.cXml )
		
		*------------------------------------
		* Check for valid root node/schema:
		*------------------------------------
		
		if oDom.firstChild.nodeName = "VFPData"
	
			*------------------------------------
			* look for our element:
			*------------------------------------		
			oNode = oDom.selectSingleNode( THIS.xpath )
			
			if isnull ( m.oNode )
				*---------------------------------------------
				* Looks like our node isn't in the structure.
				* We'll use default values for now, and the 
				* .SaveToFrx() will create the node later.
				*---------------------------------------------
			else	
				*---------------------------------------
				* We have our element. Read out the 
				* attributes:
				*---------------------------------------
				THIS.declass    = nvl( oNode.getAttribute("declass"),    "" )
				THIS.declasslib = nvl( oNode.getAttribute("declasslib"), "" )	
				THIS.execute    = nvl( oNode.getAttribute("execute"),    "" )	
				THIS.execwhen   = nvl( oNode.getAttribute("execwhen"),   "" )	
			endif				
		else
			*------------------------------------------
			* Root node is not "VFPData". 
			* Error:
			*    "Metadata XML does not validate 
			*     against the MemberData XSD."
			*------------------------------------------
			error METADATA_XML_INVALID_LOC
		endif
	else
		*------------------------------------------
		* oDom.LoadXml() failed.
		* Error:
		*    "Metadata XML does not validate 
		*     against the MemberData XSD."
		*------------------------------------------
		error METADATA_XML_INVALID_LOC
	endif

catch to oErr
	*------------------------------------------
	* An error occurred somewhere in that previous 
	*------------------------------------------
	THIS.errorMsg = oErr.message
endtry
select (m.cursel)
return empty(THIS.errorMsg)

*-------------------------------------------------
* Reads the XML metadata from the STYLE column of the 
* alias specified by the TAG property, and populates the 
* .DeClass, .DeClassLib, .Execute, and .ExecWhen attributes.
*
* Assumes: we are located on the right record.
*-------------------------------------------------
procedure SaveToFrx
*-------------------------------------------------
lparameter lcFrxAlias

THIS.errorMsg = ""

if empty(m.lcFrxAlias)
	lcFrxAlias = THIS.Tag
endif	

local cursel, cXml, oDom, oNode, oNewNode
cursel = select()
select (m.lcFrxAlias)

*------------------------------------------------------
* If the STYLE field is empty, populate it with a 
* good default XML block:
*------------------------------------------------------
if empty( STYLE )
	replace STYLE with ;
		THIS.getDefaultXml()
endif

*------------------------------------------------------
* Create a DomDocument:
*------------------------------------------------------
oDom = null
try 
	try 
		oDom = createobject("MSXml.DomDocument")
	catch 
		*-------------------------------------------
		*  "Unable to create MSXml.DomDocument instance. 
		*   Metadata XML may not be available."
		*-------------------------------------------
		error METADATA_DOM_CREATE_FAILED_LOC
	endtry

	*------------------------------------------------------
	* We have a valid DOM. 
	*------------------------------------------------------
	
	*------------------------------------------------------
	* Read the XML metadata out of the STYLE tag:
	*------------------------------------------------------
	cXml = alltrim(STYLE)

	if oDom.loadXML( m.cXml )
		
		*------------------------------------
		* Check for valid root node/schema:
		*------------------------------------
		
		if oDom.firstChild.nodeName = "VFPData"
	
			*------------------------------------
			* look for our element:
			*------------------------------------		
			oNode = oDom.selectSingleNode( THIS.xpath )
			
			if isnull ( m.oNode )
				*---------------------------------------------
				* looks like our node doesn't exist. Let's create it:
				*---------------------------------------------
				oNewNode = oDom.createElement("reportdata")
				oNewNode.setAttribute("name","")
				oNewNode.setAttribute("type","R")
				oNewNode.setAttribute("script","")
				oNewNode.setAttribute("execute","")
				oNewNode.setAttribute("execwhen","")
				oNewNode.setAttribute("class","")
				oNewNode.setAttribute("classlib","")
				oNewNode.setAttribute("declass","" )
				oNewNode.setAttribute("declasslib","" )

				oDom.firstChild.appendChild( oNewNode )

				oNode = oDom.selectSingleNode( XPATH_REPORTDATA_DEFAULT )
			
			endif
			*---------------------------------------
			* We have our element. Save the changes:
			*---------------------------------------
			oNode.setAttribute("execute",    THIS.execute )
			oNode.setAttribute("execwhen",   THIS.execwhen )
			oNode.setAttribute("declass",    THIS.declass )
			oNode.setAttribute("declasslib", THIS.declasslib )

			*------------------------------------------------------
			* Write the XML back to the table:
			*------------------------------------------------------
			cXml = oDom.xml
			replace STYLE with m.cXml

		else
			*------------------------------------------
			* Root node is not "VFPData". 
			* Error:
			*    "Metadata XML does not validate 
			*     against the MemberData XSD."
			*------------------------------------------
			error METADATA_XML_INVALID_LOC
		endif
	else
		*------------------------------------------
		* oDom.LoadXml() failed.
		* Error:
		*    "Metadata XML does not validate 
		*     against the MemberData XSD."
		*------------------------------------------
		error METADATA_XML_INVALID_LOC
	endif

catch to oErr
	*------------------------------------------
	* An error occurred somewhere in that previous 
	*------------------------------------------
	THIS.errorMsg = oErr.message
endtry
select (m.curSel)
return empty(THIS.errorMsg)

endproc

*-------------------------------------------------
* Returns a default block of XML 
*-------------------------------------------------
procedure getDefaultXml
	return 	[<VFPData>] ;
		+   [<reportdata name="" type="R" script="" execute="" execwhen="" class="" classlib="" declass="" declasslib=""/>] ;
		+	[</VFPData>]
endproc

enddefine


