* *********************************************************
* Programa...: Menu.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicación
* Cambios....:
* *********************************************************

* *********************************************************
* Procedure: AbrirEmpresa
* *********************************************************
FUNCTION AbrirEmpresa

LPARAMETERS tlPrimerVez

_SCREEN.Visible = .F.

IF	! oAplicacion.Login(tlPrimerVez)
	oAplicacion.ResetEntorno()
	RETURN .F.
ENDIF

RETURN .T.

* *********************************************************
* Procedure: CerrarEmpresa
* *********************************************************
PROCEDURE CerrarEmpresa

LOCAL lcOldClassLib, ;
	lcOldProcedure

lcSeccion  = 'DATOS'
lcElemento = 'MenuInicio'
lcValor    = oAplicacion.cMenuInicio
GuardaINI(lcSeccion, lcElemento, lcValor, oAplicacion.cFicheroINI)

DO CierraUsuario

WriteLog(0, 0, '*** CERRAR EMPRESA ***', 3)

IF	! ISNULL(oAplicacion.oFormLauncher)
	oAplicacion.oFormLauncher.Release()
ENDIF

lcOldClassLib = SET('CLASSLIB')
lcOldProcedure = SET('PROCEDURE')

CLOSE ALL

*!* Esta propiedad no se borra para que se pueda leer en Licencias de Empresas
*!* oAplicacion.cCodEmpresa		= ''
oAplicacion.cEmpresa		= ''
oAplicacion.cLicenciaEmp	= ''
oAplicacion.cCodigoEmp		= ''
oAplicacion.cDirDatos		= ''
oAplicacion.cReferenciaEmp  = ''
oAplicacion.cReferenciaIni  = ''
oAplicacion.dFechaInicial   = {}
oAplicacion.dFechaFinal     = {}
oAplicacion.lConsolida      = .F.

SET CLASSLIB TO &lcOldClassLib
SET PROCEDURE TO &lcOldProcedure

_SCREEN.CAPTION = oAplicacion.cTituloVentanaPrincipal

IF	INLIST(RIGHT(SYS(16, 1), 3), 'APP', 'EXE') AND TYPE('SCREEN.Img') = 'O'
	_SCREEN.Img.PICTURE = 'WallPaper.JPG'
ENDIF

SET PATH TO (oAplicacion.cPathDesarrollo)

IF	TYPE('oAplicacion.cToolBarAplicacion') == 'C' AND ;
		! EMPTY(oAplicacion.cToolBarAplicacion)
	oAplicacion.oToolBarAplicacion.RELEASE
ENDIF

DO MenuInicio

RETURN


* *********************************************************
* Procedure: PopUpVentana
* *********************************************************
PROCEDURE PopUpVentana
LOCAL nBarra, cFormulario, cName

DEFINE POPUP Ventana MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF Ventana PROMPT 'Cascada'
DEFINE BAR 2 OF Ventana PROMPT 'Cerrar todas' ;
	SKIP FOR TYPE('_SCREEN.ActiveForm') = 'U'

ON SELECTION BAR 1 OF Ventana DO Cascada
ON SELECTION BAR 2 OF Ventana oAplicacion.CloseAllForms()

IF	oAplicacion.nForms > 0
	DEFINE BAR 3 OF Ventana PROMPT '\-'

	FOR nBarra = 1 TO oAplicacion.nForms
		DEFINE BAR nBarra + 3 OF Ventana PROMPT oAplicacion.aForms[nBarra, 2]
		cFormulario = oAplicacion.aForms[nBarra, 1]
		cName = cFormulario.NAME
		ON SELECTION BAR nBarra + 3 OF Ventana ACTIVATE WINDOW &cName
	ENDFOR
ENDIF
RETURN


* *********************************************************
* Procedure: Cascada
* *********************************************************
PROCEDURE Cascada
LOCAL lcSeccion, lcElemento, lcValor

WITH oAplicacion
	IF	! .lVentanaCascada
		.nLeftWindowPos = 0
		.nTopWindowPos = 0
	ENDIF
	.lVentanaCascada = ! .lVentanaCascada

	lcSeccion  = 'DATOS'
	lcElemento = 'Cascada'
	lcValor    = IIF(.lVentanaCascada, '1', '0')
	GuardaINI(lcSeccion, lcElemento, lcValor, .cFicheroINI)

	SET MARK OF BAR 1 OF 'Ventana' TO .lVentanaCascada
ENDWITH
RETURN


* *********************************************************
* Function: DoMenu
* *********************************************************
FUNCTION DoMenu(tcMenu)

*!*	IF	! oAplicacion.lControlAccesos
*!*		IF	RIGHT(SYS(16, 0), 3) == 'EXE'
*!*			oAplicacion.EjecutaFormulario('SISTEMA', .F., 'Frm_Sys_Welcome', tcMenu)
*!*		ENDIF
*!*	ENDIF
DO ('Menu' + tcMenu)
SET MARK OF BAR 1 OF 'Ventana' TO oAplicacion.lVentanaCascada
RETURN


* *********************************************************
* Procedure: PopUpAyuda
* *********************************************************
PROCEDURE PopUpAyuda

DEFINE POPUP Ayuda MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF Ayuda PROMPT 'Contenido'
DEFINE BAR 2 OF Ayuda PROMPT 'Acerca de...'

ON SELECTION BAR 1 OF Ayuda HELP
ON SELECTION BAR 2 OF Ayuda oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_AcercaDe')
RETURN


*****************************************************************************************
* Procedure: iNet
* Version....:	1.01
* Author.....:  Bernard Bout
*
* Date.......: 08/05/2003 11:12:07 AM
* Notice.....:	Copyright (c) 2003

* Change No..:
* Compiler...:	VFP7 SP1
* Purpose....:	Adds a menu item for the VFP Browser
* Changes....:
*****************************************************************************************
PROCEDURE PopUpInternet

DEFINE POPUP Internet MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF Internet PROMPT 'Cargar Navegador' PICTURE '..\..\imagenes\ico\internet.ico'
DEFINE BAR 2 OF Internet PROMPT 'Ir A' PICTURE '..\..\imagenes\bmp\tablego.gif'
DEFINE BAR 3 OF Internet PROMPT 'Descargar Navegador'

* You will need to change the paths to point to the directory where you copy this file
ON SELECTION BAR 1 OF Internet DO AddBrowserToScreen
ON SELECTION BAR 2 OF Internet DO BrowseTo
ON SELECTION BAR 3 OF Internet _SCREEN.REMOVEOBJECT("myBrowse")


* *********************************************************
* Procedure: BrowseTo
* *********************************************************
PROCEDURE BrowseTo

LOCAL lcURL

IF VARTYPE(_SCREEN.myBrowse) = 'O'
	lcURL = INPUTBOX('Dirección URL a navegar','Navegar a...')

	IF ! EMPTY(lcURL)
		_SCREEN.myBrowse.OleControl1.Navigate(lcURL)
	ENDIF
ENDIF


* *********************************************************
* Procedure: AddBrowserToScreeen
* *********************************************************
PROCEDURE AddBrowserToScreen

IF VARTYPE(_SCREEN.myBrowse) = 'O'
	WAIT WINDOW TIMEOUT 3 'Navegador ya está cargado !'
	RETURN
ENDIF

_SCREEN.ADDOBJECT('myBrowse', 'iNet')
_SCREEN.myBrowse.VISIBLE = .T.
WAIT WINDOW TIMEOUT 2 'Navegador cargado.'

DEFINE CLASS iNet AS CONTAINER
	WIDTH = _SCREEN.WIDTH
	HEIGHT = _SCREEN.HEIGHT
	NAME = 'MyBrowser'

	ADD OBJECT OleControl1 AS OLECONTROL WITH ;
		NAME = 'OleControl1', ;
		OLECLASS = 'Shell.Explorer.2'
	TOP=0
	LEFT=0
	HEIGHT=_SCREEN.HEIGHT
	WIDTH=_SCREEN.WIDTH

	PROCEDURE LOAD
	ON ERROR RETRY
	ENDPROC
*!* to remove it use
*!* _screen.RemoveObject("myBrowse")
	PROCEDURE INIT
	WITH THIS
		.OleControl1.TOP = 0
		.OleControl1.WIDTH = .WIDTH
		.OleControl1.LEFT = 0
		.OleControl1.HEIGHT = .HEIGHT
		.OleControl1.Navigate('http://pwp.etb.net.co/VisualKey')
		.VISIBLE = .T.
	ENDWITH
	ENDPROC
ENDDEFINE


* *********************************************************
* Procedure: ConfigurarImpresora
* *********************************************************
PROCEDURE ConfigurarImpresora
LOCAL lcSeccion, ;
	lcElemento, ;
	lcValor, ;
	lnValor

oAplicacion.cPrinter = GETPRINTER()
lcSeccion  = 'DATOS'
lcElemento = 'Impresora'
lcValor    = PADR(oAplicacion.cPrinter, 80)
lnValor    = LEN(lcValor)
GuardaINI(lcSeccion, lcElemento, lcValor, oAplicacion.cFicheroINI)
SET PRINTER TO NAME (oAplicacion.cPrinter)

RETURN

* *********************************************************
* Function: FinControlAccesos
* *********************************************************
FUNCTION FinControlAccesos

CLEAR MENUS
oAplicacion.lControlAccesos = .F.
oAplicacion.oBarra.SHOW()
POP MENU _MSYSMENU

RETURN

* *********************************************************
* Procedure: CierraUsuario
* *********************************************************
PROCEDURE CierraUsuario

LOCAL lcUsuarios

lcUsuarios = LEFT(oAplicacion.cTablaEmpresas, RAT('\', oAplicacion.cTablaEmpresas)) + 'USUARIOS.DBF'

SELECT 0
USE (lcUsuarios) ORDER TAG Usuario

IF	SEEK(oAplicacion.cUsuario)
	REPLACE USUARIOS.LOGOUT WITH DATETIME()
ENDIF

USE IN USUARIOS

RETURN


* *********************************************************
* Procedure: Terminar
* *********************************************************
PROCEDURE Terminar

IF	oAplicacion.nForms = 0

	lcSeccion  = 'DATOS'
	lcElemento = 'MenuInicio'
	lcValor    = oAplicacion.cMenuInicio
	GuardaINI(lcSeccion, lcElemento, lcValor, oAplicacion.cFicheroINI)

	DO CierraUsuario

	IF	DBUSED('DATOS')
		WriteLog(0, 0, '*** SALIDA DEL SISTEMA ***', 3)
	ENDIF

	IF	! ISNULL(oAplicacion.oFormLauncher)
		oAplicacion.oFormLauncher.Release()
	ENDIF

	IF	oAplicacion.lUsuarioAdmin
	
		ON KEY LABEL F10
		
	ENDIF

	ON KEY LABEL F2
	ON KEY LABEL F3

	CLEAR EVENTS
	
ENDIF

RETURN

* *********************************************************
* Procedure: TerminarTodo
* *********************************************************
PROCEDURE TerminarTodo

IF	oAplicacion.nForms > 0

	oAplicacion.CloseAllForms()
	
ENDIF

DO Terminar

RETURN


* *********************************************************
* Procedure: AbreBarra
* *********************************************************
FUNCTION AbreBarra(tcBarra)

WITH oAplicacion
	.oBarra = CREATEOBJECT(tcBarra)
	.oBarra.SHOW()
ENDWITH
