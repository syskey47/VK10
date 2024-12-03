* *********************************************************
* Programa...: MenuSistema.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicación
* Cambios....:
* *********************************************************

*!*oAplicacion.cMenuInicio = 'SISTEMA'

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD Sistema			OF _MSYSMENU PROMPT '\<SISTEMA'			COLOR SCHEME 3 KEY ALT+S, ''
DEFINE PAD Configuracion	OF _MSYSMENU PROMPT '\<Configuración'	COLOR SCHEME 3 KEY ALT+C, ''
DEFINE PAD Imprimir			OF _MSYSMENU PROMPT 'Im\<primir'		COLOR SCHEME 3 KEY ALT+P, ''
DEFINE PAD Utilidades		OF _MSYSMENU PROMPT '\<Utilidades'		COLOR SCHEME 3 KEY ALT+U, ''
DEFINE PAD Internet			OF _MSYSMENU PROMPT '\<Internet'		COLOR SCHEME 3 KEY ALT+I, ''
DEFINE PAD Ventana 			OF _MSYSMENU PROMPT '\<Ventana'			COLOR SCHEME 3 KEY ALT+V, ''
DEFINE PAD Ayuda 			OF _MSYSMENU PROMPT 'A\<yuda' 			COLOR SCHEME 3 KEY ALT+Y, ''

ON PAD Sistema			OF _MSYSMENU ACTIVATE POPUP Sistema
ON PAD Configuracion	OF _MSYSMENU ACTIVATE POPUP Configuracion
ON PAD Imprimir 		OF _MSYSMENU ACTIVATE POPUP Imprimir
ON PAD Utilidades 		OF _MSYSMENU ACTIVATE POPUP Utilidades
ON PAD Internet			OF _MSYSMENU ACTIVATE POPUP Internet
ON PAD Ventana 			OF _MSYSMENU ACTIVATE POPUP Ventana
ON PAD Ayuda 			OF _MSYSMENU ACTIVATE POPUP Ayuda

DEFINE POPUP Sistema MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Sistema PROMPT 'Abrir una empresa' SKIP FOR ! EMPTY(oAplicacion.cDirDatos)
DEFINE BAR 02 OF Sistema PROMPT 'Cerrar la empresa' ;
	SKIP FOR (EMPTY(oAplicacion.cDirDatos) OR oAplicacion.nForms > 0) AND ! oAplicacion.lControlAccesos
DEFINE BAR 03 OF Sistema PROMPT '\-'
DEFINE BAR 04 OF Sistema PROMPT 'Imprimir' KEY CTRL+P, 'CTRL+P' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 05 OF Sistema PROMPT 'Presentación preliminar' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 06 OF Sistema PROMPT 'Parámetros de impresión'
DEFINE BAR 07 OF Sistema PROMPT '\-'
DEFINE BAR 08 OF Sistema PROMPT 'Preferencias'
DEFINE BAR 09 OF Sistema PROMPT 'Cambio de clave'
DEFINE BAR 10 OF Sistema PROMPT '\Conversiones'
DEFINE BAR 11 OF Sistema PROMPT 'Muestra barra de navegación' ;
	SKIP FOR oAplicacion.nForms = 0 OR ! ISNULL(oAplicacion.oBarra)
DEFINE BAR 12 OF Sistema PROMPT '\-'
IF	oAplicacion.Mod_Contabilidad
	DEFINE BAR 13 OF Sistema PROMPT 'CONTABILIDAD' 			KEY CTRL+F1, 'CTRL+F1' ;
		SKIP FOR ! oAplicacion.Mod_Contabilidad OR EMPTY(oAplicacion.cDirDatos)
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	DEFINE BAR 14 OF Sistema PROMPT 'CARTERA' 				KEY CTRL+F2, 'CTRL+F2' ;
		SKIP FOR ! oAplicacion.Mod_CuentasxCobrar OR EMPTY(oAplicacion.cDirDatos)
ENDIF
IF	oAplicacion.Mod_CuentasxPagar
	DEFINE BAR 15 OF Sistema PROMPT 'CUENTAS POR PAGAR' 	KEY CTRL+F3, 'CTRL+F3' ;
		SKIP FOR ! oAplicacion.Mod_CuentasxPagar OR EMPTY(oAplicacion.cDirDatos)
ENDIF
IF	oAplicacion.Mod_Inventarios
	DEFINE BAR 16 OF Sistema PROMPT 'INVENTARIOS' 			KEY CTRL+F4, 'CTRL+F4' ;
		SKIP FOR ! oAplicacion.Mod_Inventarios OR EMPTY(oAplicacion.cDirDatos)
ENDIF
IF	oAplicacion.Mod_Nomina
	DEFINE BAR 17 OF Sistema PROMPT 'NÓMINA' 				KEY CTRL+F5, 'CTRL+F5' ;
		SKIP FOR ! oAplicacion.Mod_Nomina OR EMPTY(oAplicacion.cDirDatos)
ENDIF
IF	oAplicacion.Mod_Notas
	DEFINE BAR 18 OF Sistema PROMPT 'NOTAS' 				KEY CTRL+F6, 'CTRL+F6' ;
		SKIP FOR ! oAplicacion.Mod_Notas OR EMPTY(oAplicacion.cDirDatos)
ENDIF
DEFINE BAR 19 OF Sistema PROMPT '\-'
DEFINE BAR 20 OF Sistema PROMPT 'SISTEMA' 				KEY CTRL+F10, 'CTRL+F10' ;
	SKIP FOR .T.
DEFINE BAR 21 OF Sistema PROMPT '\-'
IF	oAplicacion.lControlAccesos
	DEFINE BAR 22 OF Sistema PROMPT 'Terminar (accesos)'
ELSE
	DEFINE BAR 22 OF Sistema PROMPT 'TERMINAR' ;
		SKIP FOR oAplicacion.nForms > 0
ENDIF

ON SELECTION BAR 01 OF Sistema DO AbrirEmpresa
ON SELECTION BAR 02 OF Sistema DO CerrarEmpresa
ON SELECTION BAR 04 OF Sistema _SCREEN.ACTIVEFORM.Imprimir()
ON SELECTION BAR 05 OF Sistema _SCREEN.ACTIVEFORM.VistaPrevia()
ON SELECTION BAR 06 OF Sistema DO ConfigurarImpresora
ON SELECTION BAR 08 OF Sistema oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'SYS_Preferencias')
ON SELECTION BAR 09 OF Sistema oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_CambioClave')
ON SELECTION BAR 11 OF Sistema AbreBarra(_SCREEN.ACTIVEFORM.cBarraHerramientas)
IF	oAplicacion.Mod_Contabilidad
	ON SELECTION BAR 13 OF Sistema DoMenu('Contabilidad')
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	ON SELECTION BAR 14 OF Sistema DoMenu('Cartera')
ENDIF
IF	oAplicacion.Mod_CuentasxPagar
	ON SELECTION BAR 15 OF Sistema DoMenu('CuentasxPagar')
ENDIF
IF	oAplicacion.Mod_Inventarios
	ON SELECTION BAR 16 OF Sistema DoMenu('Inventarios')
ENDIF
IF	oAplicacion.Mod_Nomina
	ON SELECTION BAR 17 OF Sistema DoMenu('Nomina')
ENDIF
IF	oAplicacion.Mod_Notas
	ON SELECTION BAR 18 OF Sistema DoMenu('Notas')
ENDIF
ON SELECTION BAR 20 OF Sistema DoMenu('Sistema')
IF	oAplicacion.lControlAccesos
	ON SELECTION BAR 22 OF Sistema FinControlAccesos()
ELSE
	ON SELECTION BAR 22 OF Sistema DO Terminar
ENDIF

DEFINE POPUP Configuracion MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Configuracion PROMPT 'Licencias de empresas' ;
	SKIP FOR .T.
DEFINE BAR 02 OF Configuracion PROMPT 'Directorio de la empresa' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin OR EMPTY(oAplicacion.cDirDatos)
DEFINE BAR 03 OF Configuracion PROMPT '\-'
DEFINE BAR 04 OF Configuracion PROMPT 'Usuarios' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 05 OF Configuracion PROMPT 'Forzar cambio clave' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 06 OF Configuracion PROMPT '\-'
DEFINE BAR 07 OF Configuracion PROMPT 'Parámetros generales' ;
	PICTURE '..\..\imagenes\bmp\xp_config.gif'	;
	SKIP FOR ! oAplicacion.lUsuarioAdmin OR EMPTY(oAplicacion.cDirDatos)

ON SELECTION BAR 01 OF Configuracion oAplicacion.EjecutaFormulario('SISTEMA', .T., 'frm_SYS_Empresas')
ON SELECTION BAR 02 OF Configuracion oAplicacion.EjecutaFormularioRetorno('SISTEMA', .T., 'frm_SYS_DirectorioEmpresas')
ON SELECTION BAR 04 OF Configuracion oAplicacion.EjecutaFormulario('SISTEMA', .T., 'frm_SYS_Usuarios')
ON SELECTION BAR 05 OF Configuracion oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_ForzarCambioClave')
ON SELECTION BAR 07 OF Configuracion oAplicacion.EjecutaFormulario('SISTEMA', .T., 'SYS_ParametrosGenerales')

DEFINE POPUP Imprimir MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF Imprimir PROMPT 'Datos de la empresa'
DEFINE BAR 2 OF Imprimir PROMPT 'Usuarios'
DEFINE BAR 3 OF Imprimir PROMPT 'Ayuda'

DEFINE POPUP Utilidades MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Utilidades PROMPT 'Recálculos' ;
	SKIP FOR EMPTY(oAplicacion.cDirDatos) INVERT 
IF	oEmpresa.Operador = 5  && Entidad educativa
	DEFINE BAR 02 OF Utilidades PROMPT 'Edición de evaluaciones' ;
		SKIP FOR ! oAplicacion.lUsuarioAdmin AND ! EMPTY(oAplicacion.cDirDatos)
ENDIF
DEFINE BAR 03 OF Utilidades PROMPT 'Unificar nits repetidos' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin AND ! EMPTY(oAplicacion.cDirDatos)
*!*	DEFINE BAR 04 OF Utilidades PROMPT 'Corte de movimientos' ;
*!*		SKIP FOR ! oAplicacion.lUsuarioAdmin AND ! EMPTY(oAplicacion.cDirDatos)
DEFINE BAR 05 OF Utilidades PROMPT '\-'
DEFINE BAR 06 OF Utilidades PROMPT 'Copias de seguridad' INVERT 
DEFINE BAR 07 OF Utilidades PROMPT '\-'
DEFINE BAR 08 OF Utilidades PROMPT 'Modificar los datos de la licencia' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 09 OF Utilidades PROMPT '\-'
DEFINE BAR 10 OF Utilidades PROMPT 'Auditoría' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin INVERT
DEFINE BAR 11 OF Utilidades PROMPT '\-'
DEFINE BAR 12 OF Utilidades PROMPT 'Ejecutar formulario externo'
*!* DEFINE BAR 13 OF Utilidades PROMPT 'Ventana de comandos' ;
*!*		SKIP FOR ! oAplicacion.lUsuarioAdmin AND ! EMPTY(oAplicacion.cDirDatos)
*!*	DEFINE BAR 14 OF Utilidades PROMPT 'Modificar reportes' ;
*!*		SKIP FOR ! oAplicacion.lUsuarioAdmin AND ! EMPTY(oAplicacion.cDirDatos)

ON BAR 01 OF Utilidades ACTIVATE POPUP Recalculos
IF	oEmpresa.Operador = 5  && Entidad educativa
	ON SELECTION BAR 02 OF Utilidades oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_EdicionEvaluaciones')
ENDIF
ON SELECTION BAR 03 OF Utilidades oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_UnificarNits')
*!* ON SELECTION BAR 04 OF Utilidades oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_CorteMovimientos')
ON BAR 06 OF Utilidades ACTIVATE POPUP CopiaSeguridad
ON BAR 10 OF Utilidades ACTIVATE POPUP Auditoria
ON SELECTION BAR 12 OF Utilidades oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_EjecutarFormularioExterno')
*!* ON SELECTION BAR 13 OF Utilidades DO FORM SYS_Comandos
*!*	ON SELECTION BAR 14 OF Utilidades MODIFY REPORT Informes\Notas\Nta_ListaAuxiliarXGrado

DEFINE POPUP Recalculos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Recalculos PROMPT 'Recalcular saldos de cartera'
DEFINE BAR 02 OF Recalculos PROMPT 'Recalcular saldos de cuentas x pagar'

ON SELECTION BAR 01 OF Recalculos oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_RecalculoSaldosCxC')
ON SELECTION BAR 02 OF Recalculos oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_RecalculoSaldosCxP')

DEFINE POPUP CopiaSeguridad MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF CopiaSeguridad PROMPT 'Crear una copia de seguridad' PICTURE '..\..\imagenes\bmp\xpdisk.gif'
DEFINE BAR 02 OF CopiaSeguridad PROMPT 'Crear una copia de seguridad general' PICTURE '..\..\imagenes\bmp\xpdisk.gif'
DEFINE BAR 03 OF CopiaSeguridad PROMPT '\-'
DEFINE BAR 04 OF CopiaSeguridad PROMPT 'Restaurar una copia de seguridad' PICTURE '..\..\imagenes\bmp\xpdisk.gif'

ON SELECTION BAR 01 OF CopiaSeguridad oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_CopiaDeSeguridad', '1')
ON SELECTION BAR 02 OF CopiaSeguridad oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_CopiaDeSeguridad', '2')
ON SELECTION BAR 04 OF CopiaSeguridad oAplicacion.EjecutaFormulario('SISTEMA', .F., 'SYS_CopiaDeSeguridad', '3')

DEFINE POPUP Auditoria MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Auditoria PROMPT 'Usuarios activos' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 02 OF Auditoria PROMPT '\-'
DEFINE BAR 03 OF Auditoria PROMPT 'Consulta de auditoría' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 04 OF Auditoria PROMPT 'Copia de auditoría' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 05 OF Auditoria PROMPT 'Borrado de auditoría' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin

ON SELECTION BAR 01 OF Auditoria oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_UsuariosActivos')
ON SELECTION BAR 03 OF Auditoria oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_ConsultaAuditoria')
ON SELECTION BAR 04 OF Auditoria oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_CopiaAuditoria')
ON SELECTION BAR 05 OF Auditoria oAplicacion.EjecutaFormularioRetorno('SISTEMA', .F., 'frm_SYS_BorradoAuditoria')

DO PopUpInternet
DO PopUpVentana
DO PopUpAyuda

IF	! ISNULL(oAplicacion.oFormLauncher)
	*!* oAplicacion.oFormLauncher.ListBar.Sistema.FolderHeader.Click()
	oAplicacion.oFormLauncher.Outlook2003Bar1.SelectedButton = oAplicacion.nMod_Sistema
ENDIF
