* *********************************************************
* Programa...: MenuInicio.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicación
* Cambios....:
* *********************************************************
SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD Archivo			OF _MSYSMENU PROMPT '\<Archivo'			COLOR SCHEME 3 KEY ALT+A, ''
DEFINE PAD Configuracion	OF _MSYSMENU PROMPT '\<Configuración'	COLOR SCHEME 3 KEY ALT+C, ''
DEFINE PAD Internet			OF _MSYSMENU PROMPT 'Inter\<Net'		COLOR SCHEME 3 KEY ALT+N, ''
DEFINE PAD Ventana 			OF _MSYSMENU PROMPT '\<Ventana'			COLOR SCHEME 3 KEY ALT+V, ''
DEFINE PAD Ayuda			OF _MSYSMENU PROMPT 'A\<yuda'			COLOR SCHEME 3 KEY ALT+Y, ''

ON PAD Archivo			OF _MSYSMENU ACTIVATE POPUP Archivo
ON PAD Configuracion	OF _MSYSMENU ACTIVATE POPUP Configuracion
ON PAD Internet			OF _MSYSMENU ACTIVATE POPUP Internet
ON PAD Ventana 			OF _MSYSMENU ACTIVATE POPUP Ventana
ON PAD Ayuda			OF _MSYSMENU ACTIVATE POPUP Ayuda

DEFINE POPUP Archivo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF Archivo PROMPT 'Abrir una empresa'
DEFINE BAR 2 OF Archivo PROMPT 'Cerrar la empresa' SKIP FOR .T.
DEFINE BAR 3 OF Archivo PROMPT '\-'
DEFINE BAR 4 OF Archivo PROMPT 'Terminar' ;
	SKIP FOR oAplicacion.nForms > 0

ON SELECTION BAR 1 OF Archivo DO AbrirEmpresa
ON SELECTION BAR 4 OF Archivo DO Terminar

DEFINE POPUP Configuracion MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Configuracion PROMPT 'Mantenimiento a base de datos' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 02 OF Configuracion PROMPT 'Directorio de la empresa' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin OR EMPTY(oAplicacion.cDirDatos)
DEFINE BAR 03 OF Configuracion PROMPT 'Consolidación de empresas' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 04 OF Configuracion PROMPT '\-'
DEFINE BAR 05 OF Configuracion PROMPT '\Usuarios' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 06 OF Configuracion PROMPT '\-'
DEFINE BAR 07 OF Configuracion PROMPT 'Parámetros generales' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin OR EMPTY(oAplicacion.cDirDatos)

ON SELECTION BAR 01 OF Configuracion oAplicacion.EjecutaFormulario('SISTEMA', .T., 'SYS_MantenimientoBaseDatos', NULL, .T.)
ON SELECTION BAR 02 OF Configuracion oAplicacion.EjecutaFormularioRetorno('SISTEMA', .T., 'frm_SYS_DirectorioEmpresas', NULL, .T.)
ON SELECTION BAR 03 OF Configuracion oAplicacion.EjecutaFormulario('SISTEMA', .T., 'frm_SYS_ConsolidacionEmpresas', NULL,.T.)
ON SELECTION BAR 07 OF Configuracion oAplicacion.EjecutaFormularioRetorno('SISTEMA', .T., 'frm_SYS_ParametrosGenerales', NULL, .T.)

DO PopUpInternet
DO PopUpVentana
DO PopUpAyuda
