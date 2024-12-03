*-- Cursor buffering modes
#DEFINE DB_BUFOFF               1
#DEFINE DB_BUFLOCKRECORD        2
#DEFINE DB_BUFOPTRECORD         3        
#DEFINE DB_BUFLOCKTABLE         4
#DEFINE DB_BUFOPTTABLE          5

DEFINE CLASS GrdColHorario AS Column

	Visible = .T.
	Sparse = .T.

	ADD OBJECT Header1 AS Header
	ADD OBJECT Shp AS ShpHorario

	CurrentControl = 'Shp'

ENDDEFINE

DEFINE CLASS ShpHorario AS Shape

	Enabled = .T.
	Visible = .T.
	cIdPensum = ''
	cProcesoClick = ''

	FUNCTION Click

		LOCAL lcProceso

		lcProceso = THIS.cProcesoClick

		&lcProceso.(THIS)
		
	ENDFUNC
	
ENDDEFINE

DEFINE CLASS GrdCol AS Grd_Col
	ReadOnly = .T.
	Visible = .T.
	nOldBackColor = 0
	
	FUNCTION Init
		THIS.nOldBackColor = THIS.BackColor
	ENDFUNC

	ADD OBJECT GrdHdr AS Grd_Hdr
	ADD OBJECT GrdTxt AS Grd_Txt
ENDDEFINE

DEFINE CLASS Grd_Col AS Column
ENDDEFINE

DEFINE CLASS Grd_Hdr AS Header
	
	FUNCTION MOUSEUP
		LPARAMETERS tnButton, tnShift, tnXCoord, tnYCoord

		LOCAL lnCount, lcField

		FOR	lnCount = 1 TO THIS.Parent.Parent.ColumnCount
			THIS.Parent.Parent.Columns(lnCount).BackColor = THIS.Parent.Parent.Columns(lnCount).nOldBackColor
		ENDFOR

		lcField = SUBSTR(THIS.Parent.GrdTxt.ControlSource, AT('.', THIS.Parent.GrdTxt.ControlSource) + 1)

		FOR	lnCount = 1 TO ALEN(THIS.Parent.Parent.aIndices)
			IF	THIS.Parent.Parent.aIndices[lnCount] == UPPER(lcField) OR ;
				THIS.Parent.Parent.aIndices[lnCount] == 'UPPER(' + UPPER(lcField) + ')' OR ;
				THIS.Parent.Parent.aIndices[lnCount] =  'STR(' + UPPER(lcField)
				IF	tnShift = 2
					SET ORDER TO lnCount DESCENDING
					THIS.Parent.BackColor = RGB(224,255,255)
				ELSE
					SET ORDER TO lnCount ASCENDING
					THIS.Parent.BackColor = RGB(255,255,224)
				ENDIF

				GO TOP
				EXIT
			ENDIF
		ENDFOR
		
		THIS.Parent.Parent.Refresh()

	ENDFUNC
ENDDEFINE

DEFINE CLASS Grd_Txt AS TextBox
	BackStyle = 0  && Transparente
	BorderStyle = 0
	Margin = 0
*	ReadOnly = .T.
ENDDEFINE

DEFINE CLASS Grd_Chk AS CheckBox
	BackStyle = 0  && Transparente
	BorderStyle = 0
	Caption = ''
	Margin = 0
*	ReadOnly = .T.
ENDDEFINE

DEFINE CLASS NewGrdCol AS cColumn
	ReadOnly = .T.
	Visible = .T.
	nOldBackColor = 0
	
	FUNCTION Init
		THIS.nOldBackColor = THIS.BackColor
	ENDFUNC

	ADD OBJECT Header1 AS cHeader
	ADD OBJECT Text1 AS cText1
ENDDEFINE

DEFINE CLASS cColumn AS Column
ENDDEFINE

DEFINE CLASS cHeader AS Header

	FontName = 'Tahoma'
	FontSize = 8
	lOrdenAscendente = .T.
		
	FUNCTION MOUSEUP
		LPARAMETERS tnButton, tnShift, tnXCoord, tnYCoord

		LOCAL lnCount, ;
			lcField, ;
			lcAlias, ;
			lcSQL, ;
			laFields[1]

		DECLARE laFields[THIS.Parent.Parent.ColumnCount]
		FOR	lnCount = 1 TO THIS.Parent.Parent.ColumnCount
			THIS.Parent.Parent.Columns(lnCount).BackColor = THIS.Parent.Parent.Columns(lnCount).nOldBackColor
			THIS.Parent.Parent.Columns(lnCount).Header1.FontBold = .F.
			laFields[lnCount] = THIS.Parent.Parent.Columns(lnCount).ControlSource
		ENDFOR

		lcField = SUBSTR(THIS.Parent.Text1.ControlSource, AT('.', THIS.Parent.Text1.ControlSource) + 1)
		lcAlias = THIS.Parent.Parent.RecordSource

		THIS.Parent.Parent.RecordSource = ''
		THIS.Parent.Parent.cOrder = lcField
		
		IF	THIS.lOrdenAscendente

			*!* lcSQL = 'SELECT * FROM ' + lcAlias + ;
				' ORDER BY ' + lcField + ' DESC' + ;
				' INTO CURSOR curTEMPORAL READWRITE'

			lcSQL = 'SELECT * FROM ' + lcAlias + ;
				' ORDER BY ' + lcField + ;
				' INTO CURSOR curTEMPORAL READWRITE'
				
*!*				THIS.Parent.BackColor = RGB(192,255,192)
*!*				THIS.Parent.Parent.cOrderType = 'DESC'
			
			THIS.lOrdenAscendente = .F.

		ELSE
		
			lcSQL = 'SELECT * FROM ' + lcAlias + ;
				' ORDER BY ' + lcField + ;
				' INTO CURSOR curTEMPORAL READWRITE'
				
*!*				THIS.Parent.BackColor = RGB(255,255,192)
*!*				THIS.Parent.Parent.cOrderType = 'ASC'

			THIS.lOrdenAscendente = .T.

		ENDIF
		THIS.FontBold = .T.
		
		&lcSQL
		USE IN (lcAlias)
		
		SELECT * FROM curTEMPORAL INTO CURSOR (lcAlias)
		USE IN curTEMPORAL
		
		GO TOP

		THIS.Parent.Parent.RecordSource = lcAlias
		FOR lnCount = 1 TO THIS.Parent.Parent.ColumnCount
			THIS.Parent.Parent.Columns(lnCount).ControlSource = laFields[lnCount]
		ENDFOR
		
		THIS.Parent.Parent.Refresh()

	ENDFUNC

ENDDEFINE

DEFINE CLASS cText1 AS TextBox
	BackStyle = 0  && Transparente
	BorderStyle = 0
	FontName = 'Tahoma'
	FontSize = 8
	Margin = 0

	FUNCTION GotFocus
		DODEFAULT()

		THIS.BackColor = RGB(255,255,224)
		THIS.ForeColor = RGB(0,0,255)
	ENDFUNC
	
	FUNCTION LostFocus
		DODEFAULT()

		THIS.BackColor = RGB(255,255,255)
		THIS.ForeColor = RGB(0,0,255)
	ENDFUNC
	
*	ReadOnly = .T.
ENDDEFINE

DEFINE CLASS cCheckBox1 AS CheckBox
	BackStyle = 0  && Transparente
	BorderStyle = 0
	Caption = ''
	FontName = 'Tahoma'
	FontSize = 8
	Margin = 0
*	ReadOnly = .T.
ENDDEFINE


DEFINE CLASS DataEnv AS DataEnvironment
	AutoCloseTables = .T.
	AutoOpentables  = .F.
	
ENDDEFINE

DEFINE CLASS Crs AS Cursor
	Alias = ''
	BufferModeOverride = 3
	CursorSource = ''
	Order = ''
ENDDEFINE

* -----------

DEFINE CLASS cDataEnvironment AS DATAENVIRONMENT
	AutoCloseTables	= .T.
	AutoOpentables	= .T.
	Name			= THIS.Class

	nInitialSelectedAlias	= 1
	cDefaultDatabaseName	= ''
	cDefaultDatabase		= ''
	lUseLocalData			= .T.
	DIMENSION aCursors[1]
	DIMENSION aRelations[1]

	FUNCTION Init()
		LOCAL lnCursor, lnRelation

*		IF	IsAbstract(THIS.CLASS, 'CDataEnvironment')
*			RETURN .F.
*		ENDIF
		THIS.cDefaultDatabase = THIS.GetDefaultDatabase()
		IF	EMPTY(THIS.cDefaultDatabase) OR ! FILE(THIS.cDefaultDatabase)
			MessageBox('No se encuentra la base de datos:' + CHR(13) + CHR(13) + ;
						THIS.cDefaultdatabaseName, 16, 'ERROR')
			RETURN .F.
		ENDIF
		THIS.LoadCursors()
		IF	TYPE('THIS.aCursors[1]') = 'C'
			FOR lnCursor = 1 TO ALEN(THIS.aCursors, 1)
				THIS.AddObject('o' + THIS.aCursors[lnCursor], THIS.aCursors[lnCursor])
			ENDFOR
			THIS.InitialSelectedAlias = THIS.aCursors[THIS.nInitialSelectedAlias]
		ENDIF

		THIS.LoadRelations()
		IF	TYPE('THIS.aRelations[1]') = 'C'
			FOR lnRelation = 1 TO ALEN(THIS.aRelations, 1)
				THIS.AddObject('o' + THIS.aRelations[lnRelation], THIS.aRelations[lnRelation])
			ENDFOR
		ENDIF

		IF	THIS.AutoOpentables
			THIS.OpenTables()
		ELSE
			IF	TYPE('THIS.aCursors[1]') = 'C'
				*---------------------------------------------------------------
				*-- Select the database for the InitalSelectedAlias only if
				*-- it is NOT a free table. If you need to set the current
				*-- database in this scenario, set it in the business object’s
				*-- oSessionEnvironment.cDatabase property.
				*---------------------------------------------------------------
				IF	UPPER(EVAL('THIS.o' + THIS.InitialSelectedAlias + '.ParentClass')) ;
						!= 'CFREETABLECURSOR'
					SET DATABASE TO ;
						(EVAL('THIS.o' + THIS.InitialSelectedAlias + '.Database'))
				ENDIF
				SELECT THIS.aCursors[1]
			ENDIF
		ENDIF
	ENDFUNC

	FUNCTION Destroy()
		IF	THIS.AutoCloseTables
			THIS.CloseTables()
		ENDIF
	ENDFUNC

	FUNCTION OpenTables()
		DODEFAULT()

		NODEFAULT
		IF	TYPE('THIS.aCursors[1]') = 'C' AND ;
			! EMPTY(EVAL('THIS.o' + THIS.InitialSelectedAlias + '.Database'))
			SET DATABASE TO (EVAL('THIS.o' + THIS.InitialSelectedAlias + '.Database'))
		ENDIF
	ENDFUNC

	FUNCTION CloseTables()
		LOCAL lcOnError, lnErrorNumber

		lnErrorNumber = 0
		lcOnError = ON('ERROR')
		ON ERROR lnErrorNumber = ERROR()
		DODEFAULT()
		ON ERROR &lcOnError
		NODEFAULT
		IF	lnErrorNumber # 0 AND lnErrorNumber # 1967
			ERROR lnErrorNumber
		ENDIF
	ENDFUNC

	FUNCTION LoadCursors()
	ENDFUNC

	FUNCTION LoadRelations()
	ENDFUNC

	FUNCTION GetDefaultDatabase()
		LOCAL lcDefaultDatabase, lcKey
		lcDefaultDatabase = ''
		IF	TYPE('oAplicacion') = 'O'
			IF	! EMPTY(THIS.cDefaultDatabaseName)
				IF	UPPER(oAplicacion.GetSetting("Data Settings", "Use Local Data", "YES")) == "YES"
					lcKey = DBCLOCATION_LOCALKEY
					THIS.lUseLocalData = .T.
				ELSE
					lcKey = DBCLOCATION_REMOTEKEY
					THIS.lUseLocalData = .F.
				ENDIF
				lcDefaultDatabase = ALLTRIM(oAplicacion.GetSetting(lcKey, THIS.cDefaultDatabaseName))
				IF	RIGHT(lcDefaultDatabase, 1) # '\'
					lcDefaultDatabase = lcDefaultDatabase + '\'
				ENDIF
				lcDefaultDatabase = lcDefaultDatabase + THIS.cDefaultDatabaseName + ".DBC"
			ENDIF
		ELSE
			IF	! EMPTY(DBC())
				lcDefaultDatabase = DBC()
			ELSE
				lcDefaultDatabase = 'DATA\' + THIS.cDefaultDatabaseName + '.DBC'
				IF	! FILE(lcDefaultDatabase)
					lcDefaultDatabase = ''
				ENDIF
			ENDIF
		ENDIF
		RETURN FULLPATH(lcDefaultDatabase)
	ENDFUNC
ENDDEFINE

DEFINE CLASS cCursor AS CURSOR
	BufferModeOverride = DB_BUFOPTRECORD
	DataBase		= ''
	Filter			= ''
	NoDataOnLoad	= .F.
	Order 			= ''
	ReadOnly		= .F.

	FUNCTION Init()
		IF	IsAbstract(THIS.Class, 'cCursor')
			RETURN .F.
		ENDIF

		THIS.Database = THIS.GetDefaultDatabase()
		IF	EMPTY(THIS.Database)
			RETURN .F.
		ENDIF
	ENDFUNC

	FUNCTION GetDefaultDatabase()
		RETURN THIS.Parent.cDefaultDatabase
	ENDFUNC
ENDDEFINE

DEFINE CLASS cDynamicViewCursor AS cCursor
	NoDataOnLoad	= .T.

	PROTECTED cCursorSource, lUseLocalData
	cCursorSource = ''
	lUseLocalData = .T.

	FUNCTION Init()
		LOCAL lcPrefix, lcAlias
*!*			IF	IsAbstract(THIS.Class, 'cDynamicViewCursor')
*!*				RETURN .F.
*!*			ENDIF

		THIS.lUseLocalData = THIS.Parent.lUseLocalData
		lcAlias = ''
		IF	! EMPTY(THIS.Alias)
			lcAlias = THIS.Alias
		ELSE
			lcAlias = THIS.cCursorSource
		ENDIF
		lcPrefix = IIF(THIS.lUseLocalData, 'l', 'r')
		THIS.CursorSource = lcPrefix + THIS.cCursorSource
		THIS.Alias = lcAlias

		RETURN DODEFAULT()
	ENDFUNC
ENDDEFINE

DEFINE CLASS cReportDynamicViewCursor AS cDynamicViewCursor
	NodataOnLoad	= .F.
	ReadOnly		= .T.

	FUNCTION Init()
		LOCAL lcPrefix
*!*			IF	IsAbstract(THIS.Class, 'cReportDynamicViewCursor')
*!*				RETURN .F.
*!*			ENDIF
		RETURN DODEFAULT()
	ENDFUNC
ENDDEFINE

DEFINE CLASS cTableCursor AS CCursor
	cAlias = ''

	FUNCTION Init()
		IF	EMPTY(THIS.cAlias)
			THIS.Alias = THIS.CursorSource
		ELSE
			THIS.Alias = THIS.cAlias
		ENDIF
		RETURN DODEFAULT()
	ENDFUNC
ENDDEFINE

DEFINE CLASS cFreeTableCursor AS CURSOR
	BufferModeOverride	= 1
	Database			= ''
	Filter				= ''
	NoDataOnLoad		= .F.
	Order				= ''
	ReadOnly			= .F.

	FUNCTION Init()
*!*			IF	IsAbstract(THIS.Class, 'cFreeCursor')
*!*				RETURN .F.
*!*			ENDIF
	ENDFUNC
ENDDEFINE

DEFINE CLASS cRelation AS RELATION
	ChildAlias		= ''
	OneToMany		= .F.
	ParentAlias		= ''
	RelationalExpr	= ''

	FUNCTION Init()
*!*			IF	IsAbstract(THIS.Class, 'cRelation')
*!*				RETURN .F.
*!*			ENDIF
	ENDFUNC
ENDDEFINE

DEFINE CLASS cTempCursor AS CURSOR
	FUNCTION Init()
*!*			IF	IsAbstract(THIS.Class, 'cTempCursor')
*!*				RETURN .F.
*!*			ENDIF
	ENDFUNC
ENDDEFINE

DEFINE CLASS cDataEnv AS cDataEnvironment
	cDefaultDatabaseName	= 'DATOS'
	lUseLocalData			= .T.
	OpenViews				= 1

	FUNCTION GetDefaultDatabase()
		LOCAL lcDefaultDatabase

*		lcDefaultDatabase = aStatus[ST_DIRDATA] + THIS.cDefaultDatabaseName + '.DBC'
		lcDefaultDatabase = THIS.cDefaultDatabaseName + '.DBC'
		IF	! DBUSED(THIS.cDefaultDataBaseName)
			OPEN DATABASE (lcDefaultDatabase) SHARED
			SET DATABASE TO (THIS.cDefaultDatabaseName)
		ENDIF
		RETURN lcDefaultDatabase
	ENDFUNC

	FUNCTION Init()
		LOCAL lnCursor, lnRelation
*!*			IF	IsAbstract(THIS.Class, 'cDataEnvironment')
*!*				RETURN .F.
*!*			ENDIF
		THIS.cDefaultDatabase = THIS.GetDefaultDatabase()
		IF	EMPTY(THIS.cDefaultDatabase) OR ! FILE(THIS.cDefaultDatabase)
			MessageBox('No se encuentra la base de datos:' + CHR(13) + CHR(13) + ;
						THIS.cDefaultdatabaseName, 16, 'ERROR')
			RETURN .F.
		ENDIF

		THIS.LoadCursors()
		IF	TYPE('THIS.aCursors[1]') = 'C'
			FOR lnCursor = 1 TO ALEN(THIS.aCursors, 1)
				THIS.AddObject('o' + THIS.aCursors[lnCursor], THIS.aCursors[lnCursor])
			ENDFOR
			THIS.InitialSelectedAlias = THIS.aCursors[this.nInitialSelectedAlias]
		ENDIF

		THIS.LoadRelations()
		IF	TYPE('THIS.aRelations[1]') = 'C'
			FOR lnRelation = 1 TO ALEN(THIS.aRelations, 1)
				THIS.AddObject('o' + THIS.aRelations[lnRelation], THIS.aRelations[lnRelation])
			ENDFOR
		ENDIF

		IF	THIS.AutoOpentables
			THIS.Opentables()
		ELSE
			IF	TYPE('THIS.aCursors[1]') = 'C'
				IF	UPPER(EVAL('THIS.o' + THIS.InitialSelectedAlias + '.ParentClass')) ;
						!= 'CFREETABLECURSOR'
					SET DATABASE TO (EVAL('THIS.o' + THIS.InitialSelectedAlias + '.Database'))
				ENDIF
				SELECT THIS.aCursors[1]
			ENDIF
		ENDIF
	ENDFUNC
ENDDEFINE

DEFINE CLASS c_Unit_DataEnv AS cDataEnv
	FUNCTION LoadCursors
		DIMENSION THIS.aCursors[1]
		THIS.aCursors[1] = 'v_Unit'
	ENDFUNC
ENDDEFINE

DEFINE CLASS v_Unit AS cDynamicViewCursor
	cCursorSource = 'v_Unit'
ENDDEFINE

DEFINE CLASS v_Debtor AS cFreeTableCursor
	FUNCTION Init()
		WITH THIS
*			.CursorSource		= aStatus[ST_DIRDATA] + 'ACT\CUST' + aStatus[ST_NOCIE]
			.CursorSource		= 'ACT\CUST'
			.Order				= 'K_REFNEXT'
			.ReadOnly			= .T.
			.Alias				= 'v_Debtor'
			.BufferModeOverride	= DB_BUFOPTRECORD
		ENDWITH
		DODEFAULT()
	ENDFUNC
ENDDEFINE

DEFINE CLASS v_ItemTable As cTableCursor
	FUNCTION Init()
		WITH THIS
			.CursorSource		= 'ITEM'
			.ReadOnly			= .T.
			.cAlias				= 'v_ItemTable'
			.BufferModeOverride	= DB_BUFOPTRECORD
		ENDWITH
		DODEFAULT()
	ENDFUNC
ENDDEFINE

DEFINE CLASS ScreenHook AS CUSTOM

	oScreen = _SCREEN
	oListBar = .NULL.

	PROCEDURE Init
		LPARAMETERS toListBarRef
		THIS.oListBar = toListbarRef
	ENDPROC

*!*		PROCEDURE oScreen.Resize
*!*			IF	TYPE('THIS.ScreenHook') = 'O'
*!*				THIS.ScreenHook.oListbar._RESIZE(90, _SCREEN.Height - 6 - SYSMETRIC (20) + (SYSMETRIC(4) + 1) * 2)
*!*			ENDIF
*!*		ENDPROC
	
ENDDEFINE

FUNCTION IsAbstract(tcClass, tcClassName)
	IF UPPER(tcClass) = UPPER(tcClassName)
		?? CHR(7)
		WAIT WINDOW "Cannot instantiate class '" + ;
			ALLT(tcClass) + ;
			"' directly!" TIMEOUT 2
		RETURN .T.
	ELSE
		RETURN .F.
	ENDIF
ENDFUNC
