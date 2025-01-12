* *********************************************************
* Programa...: MenuContabilidad.prg
* Versi�n....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicaci�n
* Cambios....:
* *********************************************************
oAplicacion.cMenuInicio = 'CONTABILIDAD'

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD Contabilidad	OF _MSYSMENU PROMPT '\<CONTABILIDAD' 		COLOR SCHEME 3 KEY ALT+C, ''
DEFINE PAD ArchivosBase	OF _MSYSMENU PROMPT '\<Archivos b�sicos'	COLOR SCHEME 3 KEY ALT+A, ''
DEFINE PAD Entradas		OF _MSYSMENU PROMPT '\<Entradas' 			COLOR SCHEME 3 KEY ALT+E, ''
DEFINE PAD Reportes		OF _MSYSMENU PROMPT '\<Reportes' 			COLOR SCHEME 3 KEY ALT+R, ''
DEFINE PAD Internet		OF _MSYSMENU PROMPT '\<Internet' 			COLOR SCHEME 3 KEY ALT+I, ''
DEFINE PAD Ventana		OF _MSYSMENU PROMPT '\<Ventana' 			COLOR SCHEME 3 KEY ALT+V, ''
DEFINE PAD Ayuda		OF _MSYSMENU PROMPT 'A\<yuda' 				COLOR SCHEME 3 KEY ALT+Y, ''

ON PAD Contabilidad	OF _MSYSMENU ACTIVATE POPUP Contabilidad
ON PAD ArchivosBase	OF _MSYSMENU ACTIVATE POPUP ArchivosBase
ON PAD Entradas		OF _MSYSMENU ACTIVATE POPUP Entradas
ON PAD Reportes		OF _MSYSMENU ACTIVATE POPUP Reportes
ON PAD Internet		OF _MSYSMENU ACTIVATE POPUP Internet
ON PAD Ventana		OF _MSYSMENU ACTIVATE POPUP Ventana
ON PAD Ayuda		OF _MSYSMENU ACTIVATE POPUP Ayuda

DEFINE POPUP Contabilidad MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Contabilidad PROMPT 'Abrir una empresa' SKIP FOR .T.
DEFINE BAR 02 OF Contabilidad PROMPT 'Cerrar la empresa' ;
	SKIP FOR (EMPTY(oAplicacion.cDirDatos) OR oAplicacion.nForms > 0) AND ! oAplicacion.lControlAccesos
DEFINE BAR 03 OF Contabilidad PROMPT '\-'
DEFINE BAR 04 OF Contabilidad PROMPT 'Imprimir' KEY CTRL+P, 'CTRL+P' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 05 OF Contabilidad PROMPT 'Presentaci�n preliminar' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 06 OF Contabilidad PROMPT 'Par�metros de impresi�n'
DEFINE BAR 07 OF Contabilidad PROMPT '\-'
DEFINE BAR 08 OF Contabilidad PROMPT 'Importar'
DEFINE BAR 09 OF Contabilidad PROMPT '\Exportar'
DEFINE BAR 10 OF Contabilidad PROMPT 'Control de coherencia financiera'
DEFINE BAR 11 OF Contabilidad PROMPT '\-'
DEFINE BAR 12 OF Contabilidad PROMPT 'Preferencias'
DEFINE BAR 13 OF Contabilidad PROMPT 'Cambio de clave'
DEFINE BAR 14 OF Contabilidad PROMPT '\Conversiones'
DEFINE BAR 15 OF Contabilidad PROMPT 'Muestra barra de navegaci�n' ;
	SKIP FOR oAplicacion.nForms = 0 OR ! ISNULL(oAplicacion.oBarra)
DEFINE BAR 16 OF Contabilidad PROMPT '\-'
IF	oAplicacion.Mod_Contabilidad
	DEFINE BAR 17 OF Contabilidad PROMPT 'CONTABILIDAD' 		KEY CTRL+F1, 'CTRL+F1' ;
		SKIP FOR .T.
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	DEFINE BAR 18 OF Contabilidad PROMPT 'CARTERA' 				KEY CTRL+F2, 'CTRL+F2' ;
		SKIP FOR ! oAplicacion.Mod_CuentasxCobrar
ENDIF
IF	oAplicacion.Mod_Notas
	DEFINE BAR 22 OF Contabilidad PROMPT 'NOTAS'				KEY CTRL+F6, 'CTRL+F6' ;
		SKIP FOR ! oAplicacion.Mod_Notas
ENDIF
DEFINE BAR 23 OF Contabilidad PROMPT '\-'
DEFINE BAR 24 OF Contabilidad PROMPT 'SISTEMA' 				KEY CTRL+F10, 'CTRL+F10'
DEFINE BAR 25 OF Contabilidad PROMPT '\-'
IF	oAplicacion.lControlAccesos
	DEFINE BAR 26 OF Contabilidad PROMPT 'Terminar (accesos)'
ELSE
	DEFINE BAR 26 OF Contabilidad PROMPT 'TERMINAR' ;
		SKIP FOR oAplicacion.nForms > 0
ENDIF

ON SELECTION BAR 02 OF Contabilidad DO CerrarEmpresa
ON SELECTION BAR 04 OF Contabilidad _SCREEN.ACTIVEFORM.Imprimir()
ON SELECTION BAR 05 OF Contabilidad _SCREEN.ACTIVEFORM.VistaPrevia()
ON SELECTION BAR 06 OF Contabilidad DO ConfigurarImpresora
ON BAR 08 OF Contabilidad ACTIVATE POPUP Importar
ON SELECTION BAR 10 OF Contabilidad oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_CoherenciaFinanciera')
ON SELECTION BAR 12 OF Contabilidad oAplicacion.EjecutaFormularioRetorno('CONTABILIDAD', .F., 'SYS_Preferencias')
ON SELECTION BAR 13 OF Contabilidad oAplicacion.EjecutaFormularioRetorno('CONTABILIDAD', .F., 'frm_SYS_CambioClave')
ON SELECTION BAR 15 OF Contabilidad AbreBarra(_SCREEN.ACTIVEFORM.cBarraHerramientas)
IF	oAplicacion.Mod_Contabilidad
	ON SELECTION BAR 17 OF Contabilidad DoMenu('Contabilidad')
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	ON SELECTION BAR 18 OF Contabilidad DoMenu('Cartera')
ENDIF
IF	oAplicacion.Mod_Notas
	ON SELECTION BAR 22 OF Contabilidad DoMenu('Notas')
ENDIF
ON SELECTION BAR 24 OF Contabilidad DoMenu('Sistema')
IF	oAplicacion.lControlAccesos
	ON SELECTION BAR 26 OF Contabilidad FinControlAccesos()
ELSE
	ON SELECTION BAR 26 OF Contabilidad DO Terminar
ENDIF

DEFINE POPUP Importar MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Importar PROMPT 'Banco de Nits.'

ON SELECTION BAR 01 OF Importar oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_ImportarNits')


DEFINE POPUP ArchivosBase MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ArchivosBase PROMPT 'Banco de Nits.' PICTURE '..\..\imagenes\bmp\xp_users.gif' COLOR b/r
DEFINE BAR 02 OF ArchivosBase PROMPT '\-'
DEFINE BAR 03 OF ArchivosBase PROMPT 'Cat�logo de cuentas' PICTURE '..\..\imagenes\ico\catalog.ico'
DEFINE BAR 04 OF ArchivosBase PROMPT 'Categor�as de cuentas'
DEFINE BAR 05 OF ArchivosBase PROMPT '\-'
DEFINE BAR 06 OF ArchivosBase PROMPT 'Categor�as de deudores'
DEFINE BAR 10 OF ArchivosBase PROMPT '\-'
DEFINE BAR 11 OF ArchivosBase PROMPT 'Anal�tica' INVERT
DEFINE BAR 12 OF ArchivosBase PROMPT 'Bancos' INVERT
DEFINE BAR 13 OF ArchivosBase PROMPT '\-'
DEFINE BAR 14 OF ArchivosBase PROMPT 'Otros' INVERT

ON SELECTION BAR 01 OF ArchivosBase oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Nits')
IF	'LOS PINOS' $ UPPER(oEmpresa.Nombre)
	ON SELECTION BAR 06 OF ArchivosBase oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_CuentasGLP')
ELSE
	ON SELECTION BAR 06 OF ArchivosBase oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Cuentas')
ENDIF
ON SELECTION BAR 04 OF ArchivosBase oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Categorias')
ON SELECTION BAR 06 OF ArchivosBase oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CAR_Categorias')

ON BAR 11 OF ArchivosBase ACTIVATE POPUP Analitica
ON BAR 12 OF ArchivosBase ACTIVATE POPUP Bancos
ON BAR 14 OF ArchivosBase ACTIVATE POPUP Otros

DEFINE POPUP Analitica MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Analitica PROMPT 'Planes anal�ticos'
DEFINE BAR 02 OF Analitica PROMPT 'Estructuras anal�ticas'

ON SELECTION BAR 01 OF Analitica oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_PlanesAnaliticos')
ON SELECTION BAR 02 OF Analitica oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_EstructurasAnaliticas')

DEFINE POPUP Bancos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Bancos PROMPT 'Caja y entidades bancarias'
DEFINE BAR 02 OF Bancos PROMPT 'Cuentas bancarias y cajas'

ON SELECTION BAR 01 OF Bancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_EntidadesBancarias')
ON SELECTION BAR 02 OF Bancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_CuentasBancarias')

DEFINE POPUP Otros MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Otros PROMPT 'Comprobantes de diario' PICTURE '..\..\imagenes\ico\foldrs01.ico'
DEFINE BAR 02 OF Otros PROMPT '\-'
DEFINE BAR 08 OF Otros PROMPT 'Ciudades'
*DEFINE BAR 06 OF Otros PROMPT '\C�digos de IVA'
*DEFINE BAR 07 OF Otros PROMPT '\Condiciones de pago'
*DEFINE BAR 08 OF Otros PROMPT '\C�digos de idiomas'
*DEFINE BAR 09 OF Otros PROMPT '\C�digos postales'
*DEFINE BAR 10 OF Otros PROMPT '\Notificaciones'

ON SELECTION BAR 01 OF Otros oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_TipoDocumentos')
ON SELECTION BAR 08 OF Otros oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Ciudades')

DEFINE POPUP Entradas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Entradas PROMPT 'Entradas de diario'
DEFINE BAR 02 OF Entradas PROMPT 'Entradas de diario otros m�dulos'
DEFINE BAR 03 OF Entradas PROMPT '\-'
*DEFINE BAR 06 OF Entradas PROMPT '\Entradas de presupuesto'
*DEFINE BAR 07 OF Entradas PROMPT '\Notificaciones'
*DEFINE BAR 08 OF Entradas PROMPT '\Revalorizar'
DEFINE BAR 11 OF Entradas PROMPT 'Cierre de a�o' INVERT

ON SELECTION BAR 01 OF Entradas oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Diarios')
ON SELECTION BAR 02 OF Entradas oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_DiariosModulos')

ON BAR 11 OF Entradas ACTIVATE POPUP CierreA�o

DEFINE POPUP CierreA�o MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF CierreA�o PROMPT 'Cierre cuentas de resultado'
DEFINE BAR 02 OF CierreA�o PROMPT 'Reclasificaci�n de nits. por cuenta'
*!*	DEFINE BAR 2 OF CierreA�o PROMPT '\Reapertura autom�tica'
*!*	DEFINE BAR 3 OF CierreA�o PROMPT '\Anular la reapertura'
*!*	DEFINE BAR 4 OF CierreA�o PROMPT '\Cierre definitivo'

ON SELECTION BAR 01 OF CierreA�o oAplicacion.EjecutaFormularioRetorno('CONTABILIDAD', .T., 'frm_CTB_CierreCuentasDeResultado')
ON SELECTION BAR 02 OF CierreA�o oAplicacion.EjecutaFormularioRetorno('CONTABILIDAD', .T., 'frm_CTB_ReclasificacionNitsPorCuenta')

DEFINE POPUP Reportes MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Reportes PROMPT 'Banco de Nits'
DEFINE BAR 02 OF Reportes PROMPT '\-'
DEFINE BAR 03 OF Reportes PROMPT 'Deudores' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 04 OF Reportes PROMPT 'Categor�as de deudores'
DEFINE BAR 05 OF Reportes PROMPT '\-'
DEFINE BAR 09 OF Reportes PROMPT 'Cuentas' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 10 OF Reportes PROMPT 'Categor�as de cuentas'
DEFINE BAR 11 OF Reportes PROMPT '\-'
IF	! oAplicacion.lConsolida
	DEFINE BAR 12 OF Reportes PROMPT 'Balances' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
ELSE
	DEFINE BAR 12 OF Reportes PROMPT 'Balances consolidados' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
ENDIF
DEFINE BAR 13 OF Reportes PROMPT 'Diarios' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 14 OF Reportes PROMPT 'Bancos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 15 OF Reportes PROMPT '\-'
DEFINE BAR 16 OF Reportes PROMPT 'Informes anal�ticos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 17 OF Reportes PROMPT '\-'
DEFINE BAR 18 OF Reportes PROMPT 'Documentos oficiales' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'

ON SELECTION BAR 01 OF Reportes oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_BancoDeNits')
ON BAR 03 OF Reportes ACTIVATE POPUP Deudores
ON SELECTION BAR 04 OF Reportes oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CAR_Inf_Categorias')
ON BAR 09 OF Reportes ACTIVATE POPUP Cuentas
ON SELECTION BAR 10 OF Reportes oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_Categorias')
IF	! oAplicacion.lConsolida
	ON BAR 12 OF Reportes ACTIVATE POPUP Balances
ELSE
	ON BAR 12 OF Reportes ACTIVATE POPUP BalancesConsolidados
ENDIF
ON BAR 13 OF Reportes ACTIVATE POPUP Diarios
ON BAR 14 OF Reportes ACTIVATE POPUP ReportesBancos
ON BAR 16 OF Reportes ACTIVATE POPUP InformesAnaliticos
ON BAR 18 OF Reportes ACTIVATE POPUP DocumentosOficiales

DEFINE POPUP Deudores MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Deudores PROMPT 'Cat�logo de deudores'
DEFINE BAR 02 OF Deudores PROMPT 'Saldos de deudores'

ON SELECTION BAR 01 OF Deudores oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CAR_Inf_Deudores')
ON SELECTION BAR 02 OF Deudores oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CAR_Inf_SaldoDeudores')

DEFINE POPUP Cuentas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Cuentas PROMPT 'Cat�logo de cuentas'
DEFINE BAR 02 OF Cuentas PROMPT 'Cuentas por categor�a'
DEFINE BAR 03 OF Cuentas PROMPT 'Cat�logo por cuenta alterna'

ON SELECTION BAR 01 OF Cuentas oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_CatalogoCuentas')
ON SELECTION BAR 02 OF Cuentas oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_CuentasPorCategoria')
ON SELECTION BAR 03 OF Cuentas oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_CuentasAlternas')

DEFINE POPUP Balances MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Balances PROMPT 'Balance de prueba'
DEFINE BAR 02 OF Balances PROMPT 'Balances general'
DEFINE BAR 03 OF Balances PROMPT '\-'
DEFINE BAR 04 OF Balances PROMPT 'Estado de resultados'

ON SELECTION BAR 01 OF Balances oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_BalancePrueba')
ON SELECTION BAR 02 OF Balances oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_BalanceGeneral')
ON SELECTION BAR 04 OF Balances oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_PerdidasyGanancias')

DEFINE POPUP BalancesConsolidados MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF BalancesConsolidados PROMPT 'Balance de prueba'
DEFINE BAR 02 OF BalancesConsolidados PROMPT 'Balances general'
DEFINE BAR 03 OF BalancesConsolidados PROMPT '\-'
DEFINE BAR 04 OF BalancesConsolidados PROMPT 'Estado de resultados'

ON SELECTION BAR 01 OF BalancesConsolidados oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_BalancePruebaConsolidado')
ON SELECTION BAR 02 OF BalancesConsolidados oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_BalanceGeneralConsolidado')
ON SELECTION BAR 04 OF BalancesConsolidados oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_PerdidasyGananciasConsolidado')

DEFINE POPUP Diarios MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Diarios PROMPT 'Comprobantes de diario por fecha'
DEFINE BAR 02 OF Diarios PROMPT '\-'
DEFINE BAR 03 OF Diarios PROMPT 'Movimientos por cuenta'
DEFINE BAR 04 OF Diarios PROMPT 'Movimientos por documento'
DEFINE BAR 05 OF Diarios PROMPT 'Movimientos por nit.'

ON SELECTION BAR 01 OF Diarios oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_DiarioPorFecha')
ON SELECTION BAR 03 OF Diarios oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_MovimientosPorCuenta')
ON SELECTION BAR 04 OF Diarios oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_MovimientosPorDocumento')
ON SELECTION BAR 05 OF Diarios oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CTB_Inf_MovimientosPorNit')

DEFINE POPUP ReportesBancos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ReportesBancos PROMPT 'Caja y entidades bancarias'
DEFINE BAR 02 OF ReportesBancos PROMPT 'Caja y cuentas bancarias'
DEFINE BAR 03 OF ReportesBancos PROMPT 'Movimiento por cuenta bancaria'
DEFINE BAR 04 OF ReportesBancos PROMPT 'Saldos diarios de bancos'

ON SELECTION BAR 01 OF ReportesBancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_Inf_EntidadesBancarias')
ON SELECTION BAR 02 OF ReportesBancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_Inf_CuentasBancarias')
ON SELECTION BAR 03 OF ReportesBancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_Inf_MovimientoPorCuentaBancaria')
ON SELECTION BAR 04 OF ReportesBancos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'CXP_Inf_SaldosDiariosBancarios')

DEFINE POPUP InformesAnaliticos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesAnaliticos PROMPT 'Comprobantes de diario por fecha con informaci�n anal�tica'
DEFINE BAR 02 OF InformesAnaliticos PROMPT 'Movimientos por cuenta con informaci�n anal�tica'
*!*	DEFINE BAR 03 OF InformesAnaliticos PROMPT '\Movimientos por documento con informaci�n anal�tica'
*!*	DEFINE BAR 04 OF InformesAnaliticos PROMPT '\Movimientos por nit. con informaci�n anal�tica'
*!*	DEFINE BAR 05 OF InformesAnaliticos PROMPT '\-'
*!*	DEFINE BAR 06 OF InformesAnaliticos PROMPT '\Balance de prueba con informaci�n anal�tica'
*!*	DEFINE BAR 07 OF InformesAnaliticos PROMPT '\Balances general con informaci�n anal�tica'
*!*	DEFINE BAR 08 OF InformesAnaliticos PROMPT '\-'
*!*	DEFINE BAR 09 OF InformesAnaliticos PROMPT '\Estado de resultados con informaci�n anal�tica'

ON SELECTION BAR 01 OF InformesAnaliticos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_DiarioPorFechaAnalitica')
ON SELECTION BAR 02 OF InformesAnaliticos oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_MovimientosPorCuentaAnalitica')

DEFINE POPUP DocumentosOficiales MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF DocumentosOficiales PROMPT 'Libro diario'
DEFINE BAR 02 OF DocumentosOficiales PROMPT 'Libro auxiliar'
DEFINE BAR 03 OF DocumentosOficiales PROMPT 'Libro mayor y balance'
DEFINE BAR 04 OF DocumentosOficiales PROMPT 'Libro inventario y balance'
DEFINE BAR 05 OF DocumentosOficiales PROMPT '\-'
DEFINE BAR 06 OF DocumentosOficiales PROMPT 'Certificados de retenci�n fuente'
DEFINE BAR 07 OF DocumentosOficiales PROMPT 'Certificados de retenci�n industria y comercio'
DEFINE BAR 08 OF DocumentosOficiales PROMPT '\-'
DEFINE BAR 09 OF DocumentosOficiales PROMPT 'Numeraci�n de libros'

ON SELECTION BAR 01 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_LibroDiario')
ON SELECTION BAR 02 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_LibroAuxiliar')
ON SELECTION BAR 03 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_LibroMayorYBalance')
ON SELECTION BAR 04 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_LibroInventarioYBalance')
ON SELECTION BAR 06 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_CertificadosRetencionFuente')
ON SELECTION BAR 07 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_CertificadosIndustriaYComercio')
ON SELECTION BAR 09 OF DocumentosOficiales oAplicacion.EjecutaFormulario('CONTABILIDAD', .T., 'frm_CTB_Inf_NumeracionLibros')

DO PopUpInternet
DO PopUpVentana
DO PopUpAyuda

IF	! ISNULL(oAplicacion.oFormLauncher)
	*!* oAplicacion.oFormLauncher.ListBar.Contabilidad.FolderHeader.Click()
	oAplicacion.oFormLauncher.Outlook2003Bar1.SelectedButton = oAplicacion.nMod_Contabilidad
ENDIF
