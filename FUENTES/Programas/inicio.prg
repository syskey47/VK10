* Programa...: Inicio.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......: 
* Derechos...: Copyright (c) 1998
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows 
* Notas......: Programa de inicio de la aplicación
* Cambios....: 
*********************************************************
PARAMETERS tlIniExe

ON ERROR DO FORM SYS_ErrorSistema WITH  ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()

*!* ON ERROR DO Proc_Errores WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()

PUBLIC gcOldTalk, gcOldDir, gcOldPath, gcOldClassLib, gcOldProcedure

IF	SET('TALK') = 'ON'
	SET TALK OFF
	gcOldTalk = 'ON'
ELSE
	gcOldTalk = 'OFF'
ENDIF

_SCREEN.WINDOWSTATE = 2
_SCREEN.VISIBLE     = .F.
_SCREEN.Icon        = 'Imagenes\Ico\Postl.ico'
_SCREEN.Refresh()
*!* _SCREEN.VISIBLE     = .T.

CLEAR
CLEAR DLLS
CLEAR MEMORY
CLEAR MENUS
CLEAR POPUPS
CLEAR RESOURCES
CLOSE DATABASES ALL

IF	INLIST(RIGHT(SYS(16, 1), 3), 'APP', 'EXE') AND PCOUNT() = 0
	_SCREEN.AddProperty('ScreenWidth', _SCREEN.Width)
	_SCREEN.AddProperty('ScreenHeight', _SCREEN.Height)
	_SCREEN.AddObject('Img', 'Image')
	_SCREEN.Img.Picture = 'Wallpaper.jpg'
	_SCREEN.Img.Stretch = 2
	_SCREEN.Img.Left = 0
	_SCREEN.Img.Top = 0
	_SCREEN.Img.Width = _SCREEN.Width
	_SCREEN.Img.Height = _SCREEN.Height
	_SCREEN.Img.Visible = .T.
ELSE
	_SCREEN.BackColor = RGB(0,0,0)
	_SCREEN.ForeColor = RGB(255,255,255)
ENDIF

gcOldPath      = SET('PATH')
gcOldClassLib  = SET('CLASSLIB')
gcOldProcedure = SET('PROCEDURE')
SET CLASSLIB TO cAplicacion, cBase, cBase70, cBasicas, cBasicas70, cFrms70, ;
				cFormulario, FrmModal, cUtils, IO, Mensajes, SpellCheck, Graphs, Outlook, ;
				MSOExp, ctl32_balloontip, ctl32_progressbar, PR_PDFX

SET CLASSLIB TO _ReportListener ADDITIVE

ON SHUTDOWN Do TerminarTodo

PUBLIC oAplicacion, oEmpresa
oAplicacion = CREATEOBJECT('Inicio', 'DATOS.DBC', 'Visual Key ', '10.0.0')
IF	TYPE('oAplicacion') == 'O'
*	IF	RIGHT(SYS(16, 0), 3) == 'EXE'
*		oAplicacion.EjecutaFormulario('SISTEMA', .F., 'Frm_Sys_Welcome', 'Sistema')
*	ENDIF
	oAplicacion.Ejecuta()
	oAplicacion = NULL
ENDIF

SET PROCEDURE TO (gcOldProcedure)
SET CLASSLIB TO (gcOldClassLib)
SET PATH TO (gcOldPath)

IF	INLIST(RIGHT(SYS(16, 1), 3), 'APP', 'EXE') AND VARTYPE(_SCREEN.Img) = 'O'
	_SCREEN.RemoveObject('Img')
ENDIF

RELEASE ALL EXTENDED
CLOSE DATABASES ALL
CLEAR ALL
ON SHUTDOWN
ON ERROR
CLEAR

RETURN

* Programa...: SetPath
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......: 
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows 
* Notas......: Programa de busqueda de paths de bases de datos y programas
* Cambios....: 
*********************************************************
FUNCTION SetPath(tcPathIni)
LOCAL laDir[1], lnDir, lnCount, lcPath, lcNewPath

lcPath = ''
lnDir  = ADIR(laDir, tcPathIni + '*.*', 'D')
FOR	lnCount = 3 TO lnDir
	IF	'D' $ laDir[lnCount, 5]  AND ;
		UPPER(laDir[lnCount, 1]) # 'DATOS'
		lcNewPath = SetPath(tcPathIni + laDir[lnCount, 1] + '\')
		IF	! EMPTY(lcNewPath)
			lcPath = IIF(EMPTY(lcPath), '', lcPath + ',') + lcNewPath
		ENDIF
	ENDIF
ENDFOR
IF	EMPTY(lcPath)
	RETURN tcPathIni
ELSE
	RETURN tcPathIni + ',' + lcPath
ENDIF

* Programa...: Proc_Errores
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......: 
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows 
* Notas......: Programa de manejo de errores
*********************************************************
PROCEDURE Proc_Errores
LPARAMETERS  tnError, tcMessage, tcMessage1, tcProgram, tnLineNo

MESSAGEBOX('ERROR: ' + CHR(9) + CHR(9) + ALLTRIM(STR(tnError)) + CHR(13) + ;
			'Mensaje: ' + CHR(9) + CHR(9) + tcMessage + CHR(13) + ;
			'Mensaje: ' + CHR(9) + CHR(9) + tcMessage1 + CHR(13) + ;
			'Programa: ' + CHR(9) + tcProgram + CHR(13) + ;
			'Línea: ' + CHR(9) + CHR(9) + ALLTRIM(STR(tnLineNo)), 0, 'Se ha presentado un error')

RETURN
