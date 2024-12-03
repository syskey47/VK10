* *********************************************************
* Programa...: MenuCartera.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicación
* Cambios....:
* *********************************************************
oAplicacion.cMenuInicio = 'CARTERA'

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD Cartera 		OF _MSYSMENU PROMPT '\<CARTERA' 			COLOR SCHEME 3 KEY ALT+C, ''
DEFINE PAD ArchBase 	OF _MSYSMENU PROMPT '\<Archivos básicos' 	COLOR SCHEME 3 KEY ALT+A, ''
DEFINE PAD Movimiento	OF _MSYSMENU PROMPT '\<Movimiento' 			COLOR SCHEME 3 KEY ALT+M, ''
DEFINE PAD Reportes 	OF _MSYSMENU PROMPT '\<Reportes' 			COLOR SCHEME 3 KEY ALT+R, ''
DEFINE PAD Internet		OF _MSYSMENU PROMPT '\<Internet' 			COLOR SCHEME 3 KEY ALT+I, ''
DEFINE PAD Ventana 		OF _MSYSMENU PROMPT '\<Ventana' 			COLOR SCHEME 3 KEY ALT+V, ''
DEFINE PAD Ayuda 		OF _MSYSMENU PROMPT '\<Ayuda' 				COLOR SCHEME 3 KEY ALT+Y, ''

ON PAD Cartera 		OF _MSYSMENU ACTIVATE POPUP Cartera
ON PAD ArchBase 	OF _MSYSMENU ACTIVATE POPUP ArchBase
ON PAD Movimiento	OF _MSYSMENU ACTIVATE POPUP Movimiento
ON PAD Reportes 	OF _MSYSMENU ACTIVATE POPUP Reportes
ON PAD Internet		OF _MSYSMENU ACTIVATE POPUP Internet
ON PAD Ventana 		OF _MSYSMENU ACTIVATE POPUP Ventana
ON PAD Ayuda 		OF _MSYSMENU ACTIVATE POPUP Ayuda

DEFINE POPUP Cartera MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Cartera PROMPT 'Abrir una empresa' SKIP FOR .T.
DEFINE BAR 02 OF Cartera PROMPT 'Cerrar la empresa' ;
	SKIP FOR (EMPTY(oAplicacion.cDirDatos) OR oAplicacion.nForms > 0) AND ! oAplicacion.lControlAccesos
DEFINE BAR 03 OF Cartera PROMPT '\-'
DEFINE BAR 04 OF Cartera PROMPT 'Imprimir' 		KEY CTRL+P, 'CTRL+P' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 05 OF Cartera PROMPT 'Presentación preliminar' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 06 OF Cartera PROMPT 'Parámetros de impresión'
DEFINE BAR 07 OF Cartera PROMPT '\-'
DEFINE BAR 08 OF Cartera PROMPT 'Importar' INVERT
DEFINE BAR 09 OF Cartera PROMPT '\Exportar' INVERT
DEFINE BAR 10 OF Cartera PROMPT 'Control de coherencia financiera' SKIP FOR .T.
DEFINE BAR 11 OF Cartera PROMPT '\-'
DEFINE BAR 12 OF Cartera PROMPT 'Preferencias'
DEFINE BAR 13 OF Cartera PROMPT 'Cambio de clave'
DEFINE BAR 14 OF Cartera PROMPT 'Conversiones' SKIP FOR .T.
DEFINE BAR 15 OF Cartera PROMPT 'Muestra barra de navegación' ;
	SKIP FOR oAplicacion.nForms = 0 OR ! ISNULL(oAplicacion.oBarra)
DEFINE BAR 16 OF Cartera PROMPT '\-'
IF	oAplicacion.Mod_Contabilidad
	DEFINE BAR 17 OF Cartera PROMPT 'CONTABILIDAD' 		KEY CTRL+F1, 'CTRL+F1' ;
		SKIP FOR ! oAplicacion.Mod_Contabilidad
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	DEFINE BAR 18 OF Cartera PROMPT 'CARTERA' 			KEY CTRL+F2, 'CTRL+F2' ;
		SKIP FOR .T.
ENDIF
IF	oAplicacion.Mod_Notas
	DEFINE BAR 22 OF Cartera PROMPT 'NOTAS' 			KEY CTRL+F6, 'CTRL+F6' ;
		SKIP FOR ! oAplicacion.Mod_Notas
ENDIF
DEFINE BAR 23 OF Cartera PROMPT '\-'
DEFINE BAR 24 OF Cartera PROMPT 'SISTEMA' 			KEY CTRL+F10, 'CTRL+F10'
DEFINE BAR 25 OF Cartera PROMPT '\-'
IF	oAplicacion.lControlAccesos
	DEFINE BAR 26 OF Cartera PROMPT 'Terminar (accesos)'
ELSE
	DEFINE BAR 26 OF Cartera PROMPT 'TERMINAR' ;
		SKIP FOR oAplicacion.nForms > 0
ENDIF

ON SELECTION BAR 02 OF Cartera DO CerrarEmpresa
ON SELECTION BAR 04 OF Cartera _SCREEN.ACTIVEFORM.Imprimir()
ON SELECTION BAR 05 OF Cartera _SCREEN.ACTIVEFORM.VistaPrevia()
ON SELECTION BAR 06 OF Cartera DO ConfigurarImpresora
ON BAR 08 OF Cartera ACTIVATE POPUP Importar
ON BAR 09 OF Cartera ACTIVATE POPUP Exportar
ON SELECTION BAR 12 OF Cartera oAplicacion.EjecutaFormularioRetorno('CARTERA', .F., 'SYS_Preferencias')
ON SELECTION BAR 13 OF Cartera oAplicacion.EjecutaFormularioRetorno('CARTERA', .F., 'frm_SYS_CambioClave')
ON SELECTION BAR 15 OF Cartera AbreBarra(_SCREEN.ACTIVEFORM.cBarraHerramientas)
IF	oAplicacion.Mod_Contabilidad
	ON SELECTION BAR 17 OF Cartera DoMenu('Contabilidad')
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	ON SELECTION BAR 18 OF Cartera DoMenu('Cartera')
ENDIF
IF	oAplicacion.Mod_Notas
	ON SELECTION BAR 22 OF Cartera DoMenu('Notas')
ENDIF
ON SELECTION BAR 24 OF Cartera DoMenu('Sistema')
IF	oAplicacion.lControlAccesos
	ON SELECTION BAR 26 OF Cartera FinControlAccesos()
ELSE
	ON SELECTION BAR 26 OF Cartera DO Terminar
ENDIF

DEFINE POPUP Importar MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Importar PROMPT 'Saldos de facturas'
DEFINE BAR 02 OF Importar PROMPT 'Ajustar saldos de facturas'

ON SELECTION BAR 01 OF Importar oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_ImportarSaldosDeFacturas')
ON SELECTION BAR 02 OF Importar oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_AjustarSaldosDeFacturas')

DEFINE POPUP ArchBase MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ArchBase PROMPT 'Banco de Nits. (Deudores)' PICTURE '..\..\imagenes\bmp\xp_users.gif'
DEFINE BAR 02 OF ArchBase PROMPT 'Categorías de deudores'
DEFINE BAR 03 OF ArchBase PROMPT '\-'
DEFINE BAR 04 OF ArchBase PROMPT 'Conceptos de pago' PICTURE '..\..\imagenes\ico\crdfle12.ico'
DEFINE BAR 05 OF ArchBase PROMPT '\-'
DEFINE BAR 06 OF ArchBase PROMPT 'Catálogo de cuentas' PICTURE '..\..\imagenes\ico\catalog.ico'
DEFINE BAR 07 OF ArchBase PROMPT 'Entidades bancarias'
DEFINE BAR 08 OF ArchBase PROMPT 'Cuentas bancarias'
DEFINE BAR 09 OF ArchBase PROMPT '\-'
DEFINE BAR 10 OF ArchBase PROMPT 'Comprobantes de diario' PICTURE '..\..\imagenes\ico\foldrs01.ico'
DEFINE BAR 11 OF ArchBase PROMPT 'Ciudades'

ON SELECTION BAR 01 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_Nits')
ON SELECTION BAR 02 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Categorias')
ON SELECTION BAR 04 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Conceptos')
ON SELECTION BAR 06 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_Cuentas')
ON SELECTION BAR 07 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CXP_EntidadesBancarias')
ON SELECTION BAR 08 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CXP_CuentasBancarias')
ON SELECTION BAR 10 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_TipoDocumentos')
ON SELECTION BAR 11 OF ArchBase oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_Ciudades')

DEFINE POPUP Movimiento MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Movimiento PROMPT 'Actualización de conceptos'
DEFINE BAR 02 OF Movimiento PROMPT 'Asignación automática de conceptos'
DEFINE BAR 03 OF Movimiento PROMPT 'Novedades de conceptos'
DEFINE BAR 04 OF Movimiento PROMPT '\-'
DEFINE BAR 05 OF Movimiento PROMPT 'Facturación de servicios educativos' PICTURE '..\..\imagenes\ico\cust.ico'
DEFINE BAR 06 OF Movimiento PROMPT 'Facturación otros servicios' PICTURE '..\..\imagenes\ico\cust.ico'
DEFINE BAR 07 OF Movimiento PROMPT 'Facturación y recaudo automático' PICTURE '..\..\imagenes\ico\cust.ico'
DEFINE BAR 08 OF Movimiento PROMPT '\-'
DEFINE BAR 09 OF Movimiento PROMPT 'Anticipos de deudores'
DEFINE BAR 10 OF Movimiento PROMPT 'Cruce de anticipos'
DEFINE BAR 11 OF Movimiento PROMPT 'Facturar anticipos'
DEFINE BAR 12 OF Movimiento PROMPT 'Modificar facturas'
DEFINE BAR 13 OF Movimiento PROMPT '\-'
DEFINE BAR 14 OF Movimiento PROMPT 'Recibos de caja' PICTURE '..\..\imagenes\bmp\money.gif'
DEFINE BAR 15 OF Movimiento PROMPT '\-'
DEFINE BAR 16 OF Movimiento PROMPT 'Recibo de cheques postfechados'
DEFINE BAR 22 OF Movimiento PROMPT 'Notas crédito a facturas'
DEFINE BAR 23 OF Movimiento PROMPT 'Notas débito a facturas'
DEFINE BAR 24 OF Movimiento PROMPT '\-'
DEFINE BAR 25 OF Movimiento PROMPT 'Correo electrónico'
DEFINE BAR 26 OF Movimiento PROMPT '\-'
DEFINE BAR 27 OF Movimiento PROMPT 'Novedades para bancos' INVERT
DEFINE BAR 28 OF Movimiento PROMPT 'Recaudo bancario' INVERT
DEFINE BAR 29 OF Movimiento PROMPT '\-'
DEFINE BAR 30 OF Movimiento PROMPT 'Consignaciones bancarias'
DEFINE BAR 31 OF Movimiento PROMPT 'Edición de consignaciones bancarias' ;
	SKIP FOR ! oAplicacion.lUsuarioAdmin
DEFINE BAR 32 OF Movimiento PROMPT 'Castigar cartera'
DEFINE BAR 33 OF Movimiento PROMPT 'Trasladar cartera'
DEFINE BAR 34 OF Movimiento PROMPT 'Notas contables'
DEFINE BAR 35 OF Movimiento PROMPT 'Recuado contable'

ON SELECTION BAR 01 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'NTA_MatriculasAlumnos', 'CONCEPTOS')
ON SELECTION BAR 02 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_AsignacionAutomaticaConceptos')
ON SELECTION BAR 03 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'NTA_ImportarNovedadesDeConceptos')
*!* ON SELECTION BAR 05 OF Movimiento oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_NTA_Facturacion')
ON SELECTION BAR 05 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_FacturacionEducativa')
ON SELECTION BAR 06 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_FacturacionOtrosServicios')
ON SELECTION BAR 07 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_FacturacionYRecaudoAutomatico')
ON SELECTION BAR 09 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_AnticiposDeudores')
ON SELECTION BAR 10 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_CruceAnticipos')
ON SELECTION BAR 11 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_FacturarAnticipos')
ON SELECTION BAR 12 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'frm_CAR_ModificarFacturas')
ON SELECTION BAR 14 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_ReciboCajaEducativo')
ON SELECTION BAR 16 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'frm_NTA_ReciboChequesPostfechados')
ON SELECTION BAR 22 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_NotaCreditoEducativa')
ON SELECTION BAR 23 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'frm_CAR_NotaDebito')
ON SELECTION BAR 25 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_CorreoElectronico')
ON BAR 27 OF Movimiento ACTIVATE POPUP NovedadesBancarias
ON BAR 28 OF Movimiento ACTIVATE POPUP RecaudoBancario
ON SELECTION BAR 30 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_ConsignacionesBancarias')
ON SELECTION BAR 31 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_EdicionConsignacionesBancarias')
ON SELECTION BAR 32 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_CastigarCartera')
ON SELECTION BAR 33 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_TrasladarCartera')
ON SELECTION BAR 34 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_NotasContables')
ON SELECTION BAR 35 OF Movimiento oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_RecaudoContable')

DEFINE POPUP NovedadesBancarias MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF NovedadesBancarias PROMPT 'Banco Davivienda'
DEFINE BAR 02 OF NovedadesBancarias PROMPT 'Bancolombia' INVERT
DEFINE BAR 03 OF NovedadesBancarias PROMPT 'A C H'
DEFINE BAR 04 OF NovedadesBancarias PROMPT 'PSE'

ON SELECTION BAR 01 OF NovedadesBancarias oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_NovedadesBancariasBancoSuperior')
ON BAR 02 OF NovedadesBancarias ACTIVATE POPUP NovedadesBancolombia
ON SELECTION BAR 03 OF NovedadesBancarias oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_ACHDebitoAutomatico')
ON SELECTION BAR 04 OF NovedadesBancarias oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_NovedadesBancariasPSE')

DEFINE POPUP NovedadesBancolombia MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF NovedadesBancolombia PROMPT 'Novedades por débito automático'
DEFINE BAR 02 OF NovedadesBancolombia PROMPT 'Novedades por débito virtual'

ON SELECTION BAR 01 OF NovedadesBancolombia oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_BancolombiaDebitoAutomatico')
ON SELECTION BAR 02 OF NovedadesBancolombia oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_BancolombiaDebitoVirtual')

DEFINE POPUP RecaudoBancario MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF RecaudoBancario PROMPT 'Banco Davivienda'
DEFINE BAR 02 OF RecaudoBancario PROMPT 'Bancolombia' INVERT
DEFINE BAR 03 OF RecaudoBancario PROMPT 'Banco de Bogotá'
DEFINE BAR 04 OF RecaudoBancario PROMPT 'Banco de Occidente'
DEFINE BAR 05 OF RecaudoBancario PROMPT 'A C H'
DEFINE BAR 06 OF RecaudoBancario PROMPT 'Banco BBVA'
DEFINE BAR 07 OF RecaudoBancario PROMPT 'PSE'
DEFINE BAR 08 OF RecaudoBancario PROMPT '\-'
DEFINE BAR 09 OF RecaudoBancario PROMPT 'Genérico (xls)'

ON SELECTION BAR 01 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioBancoSuperior')
ON BAR 02 OF RecaudoBancario ACTIVATE POPUP RecaudoBancolombia
ON SELECTION BAR 03 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioBancoBogota')
ON SELECTION BAR 04 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioBancoOccidenteGLP')
ON SELECTION BAR 05 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioACH')
ON SELECTION BAR 06 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioBBVA')
ON SELECTION BAR 07 OF RecaudoBancario oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioPSEGLP')
ON SELECTION BAR 09 OF RecaudoBancario oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_RecaudoCajaBancos')

DEFINE POPUP RecaudoBancolombia MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF RecaudoBancolombia PROMPT 'Recaudo por débito automático'
DEFINE BAR 02 OF RecaudoBancolombia PROMPT 'Recaudo por débito virtual'

ON SELECTION BAR 01 OF RecaudoBancolombia oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioDebitoAutomaticoBancolombia')
ON SELECTION BAR 02 OF RecaudoBancolombia oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_RecaudoBancarioBancolombia')

DEFINE POPUP Reportes MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Reportes PROMPT 'Deudores' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 02 OF Reportes PROMPT 'Categorías de deudores'
DEFINE BAR 03 OF Reportes PROMPT '\-'
DEFINE BAR 04 OF Reportes PROMPT 'Conceptos de facturación' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 05 OF Reportes PROMPT '\-'
DEFINE BAR 06 OF Reportes PROMPT 'Facturación' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 07 OF Reportes PROMPT 'Recibos de caja' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 08 OF Reportes PROMPT 'Diarios' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 09 OF Reportes PROMPT '\-'
DEFINE BAR 10 OF Reportes PROMPT 'Recordatorios de pago'
DEFINE BAR 11 OF Reportes PROMPT 'Certificados de pago'
DEFINE BAR 13 OF Reportes PROMPT '\-'
DEFINE BAR 14 OF Reportes PROMPT 'Análisis estadístico'

ON BAR 01 OF Reportes ACTIVATE POPUP Deudores
ON SELECTION BAR 02 OF Reportes oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_Categorias')
ON BAR 04 OF Reportes ACTIVATE POPUP Conceptos
ON BAR 06 OF Reportes ACTIVATE POPUP Facturacion
ON BAR 07 OF Reportes ACTIVATE POPUP ReciboCaja
ON BAR 08 OF Reportes ACTIVATE POPUP Diarios
ON SELECTION BAR 10 OF Reportes oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_RecordatoriosDePago')
ON SELECTION BAR 11 OF Reportes oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_CertificadosDePago')
ON SELECTION BAR 14 OF Reportes oAplicacion.EjecutaFormularioRetorno('CARTERA', .T., 'frm_CAR_AnalisisEstadistico')

DEFINE POPUP Deudores MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Deudores PROMPT 'Catálogo de deudores'
DEFINE BAR 02 OF Deudores PROMPT 'Saldos de deudores'
DEFINE BAR 03 OF Deudores PROMPT 'Saldos por deudor - alumno'
DEFINE BAR 07 OF Deudores PROMPT '\-'
DEFINE BAR 08 OF Deudores PROMPT 'Etiquetas de correo para acudientes'
DEFINE BAR 09 OF Deudores PROMPT 'Etiquetas de correo para acudientes - alumnos'
DEFINE BAR 10 OF Deudores PROMPT '\-'
DEFINE BAR 11 OF Deudores PROMPT 'Cuentas de deudor por alumno'

ON SELECTION BAR 01 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_Deudores')
ON SELECTION BAR 02 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_SaldoDeudores')
ON SELECTION BAR 03 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_SaldosPorDeudorAlumno')
ON SELECTION BAR 08 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'NTA_Inf_EtiquetasCorreoAcudientes')
ON SELECTION BAR 09 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'NTA_Inf_EtiquetasCorreoAcudienteAlumnos')
ON SELECTION BAR 11 OF Deudores oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_CuentasPorDeudorAlumno')

DEFINE POPUP Conceptos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Conceptos PROMPT 'Conceptos de facturación'
DEFINE BAR 02 OF Conceptos PROMPT '\-'
DEFINE BAR 03 OF Conceptos PROMPT 'Conceptos por deudor'
DEFINE BAR 04 OF Conceptos PROMPT 'Alumnos por concepto'
DEFINE BAR 05 OF Conceptos PROMPT 'Alumnos sin conceptos'
DEFINE BAR 06 OF Conceptos PROMPT 'Conceptos pendientes por alumno'
DEFINE BAR 07 OF Conceptos PROMPT '\-'
DEFINE BAR 08 OF Conceptos PROMPT 'Saldos de facturas por concepto'

ON SELECTION BAR 01 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_Conceptos')
ON SELECTION BAR 03 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ConceptosPorDeudor')
ON SELECTION BAR 04 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_AlumnosPorConcepto')
ON SELECTION BAR 05 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_AlumnosSinConceptos')
ON SELECTION BAR 06 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ConceptosPendientesPorAlumno')
ON SELECTION BAR 08 OF Conceptos oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_SaldosFacturasPorConcepto')

DEFINE POPUP Facturacion MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Facturacion PROMPT 'Facturas'
DEFINE BAR 09 OF Facturacion PROMPT '\-'
DEFINE BAR 10 OF Facturacion PROMPT 'Consecutivo de facturas'
DEFINE BAR 11 OF Facturacion PROMPT 'Facturas por deudor'
DEFINE BAR 12 OF Facturacion PROMPT 'Facturas por fecha'
DEFINE BAR 13 OF Facturacion PROMPT 'Facturas por fecha de proceso'
DEFINE BAR 14 OF Facturacion PROMPT '\-'
DEFINE BAR 15 OF Facturacion PROMPT 'Facturación anual'
DEFINE BAR 16 OF Facturacion PROMPT '\-'
DEFINE BAR 17 OF Facturacion PROMPT 'Análisis de cartera por edades (90-180-360)'
DEFINE BAR 18 OF Facturacion PROMPT 'Análisis de cartera por edades (60-90-120)'
DEFINE BAR 19 OF Facturacion PROMPT 'Presupuesto de caja'
DEFINE BAR 20 OF Facturacion PROMPT '\-'
DEFINE BAR 21 OF Facturacion PROMPT 'Anticipos de deudores'
DEFINE BAR 22 OF Facturacion PROMPT '\-'
DEFINE BAR 23 OF Facturacion PROMPT 'Órdenes de matrículas'
*!* DEFINE BAR 24 OF Facturacion PROMPT 'Matrículas a facturar'

ON SELECTION BAR 01 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_FacturasEducativas')
ON SELECTION BAR 10 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ConsecutivoFacturas')
ON SELECTION BAR 11 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_FacturasPorDeudor')
ON SELECTION BAR 12 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_FacturasPorFecha')
ON SELECTION BAR 13 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_FacturasPorFechaProceso')
ON SELECTION BAR 15 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_FacturacionAnual')
ON SELECTION BAR 17 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_CarteraPorEdades1')
ON SELECTION BAR 18 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_CarteraPorEdades2')
ON SELECTION BAR 19 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_PresupuestoCaja')
ON SELECTION BAR 21 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_AnticiposDeudores')
ON SELECTION BAR 23 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_OrdenDeMatricula')
*!* ON SELECTION BAR 24 OF Facturacion oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_MatriculasAFacturar')

DEFINE POPUP ReciboCaja MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ReciboCaja PROMPT 'Impresión recibos de caja'
DEFINE BAR 02 OF ReciboCaja PROMPT '\-'
DEFINE BAR 03 OF ReciboCaja PROMPT 'Recaudo de caja por deudor'
DEFINE BAR 04 OF ReciboCaja PROMPT 'Recaudo de caja por fecha'
DEFINE BAR 05 OF ReciboCaja PROMPT 'Recaudo de caja por documento'
DEFINE BAR 07 OF ReciboCaja PROMPT '\-'
DEFINE BAR 08 OF ReciboCaja PROMPT 'Informe de recaudo de cheques postfechados'

ON SELECTION BAR 01 OF ReciboCaja oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ReciboDeCajaEducativo')
ON SELECTION BAR 03 OF ReciboCaja oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_RecaudoCajaPorDeudor')
ON SELECTION BAR 04 OF ReciboCaja oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_RecaudoCajaPorFecha')
ON SELECTION BAR 05 OF ReciboCaja oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_RecaudoCajaPorDocumento')
ON SELECTION BAR 08 OF ReciboCaja oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_RecaudoChequesPostfechados')

DEFINE POPUP Diarios MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Diarios PROMPT 'Movimientos por cuenta'
DEFINE BAR 02 OF Diarios PROMPT 'Movimientos por documento'
DEFINE BAR 03 OF Diarios PROMPT 'Movimientos por nit.'
DEFINE BAR 04 OF Diarios PROMPT 'Movimientos por concepto'
DEFINE BAR 05 OF Diarios PROMPT '\-'
DEFINE BAR 06 OF Diarios PROMPT 'Contabilización de facturas en SIIGO'
DEFINE BAR 07 OF Diarios PROMPT 'Contabilización de facturas en SIIGO-e'
DEFINE BAR 08 OF Diarios PROMPT 'Contabilización de N.C. en SIIGO-e'
DEFINE BAR 09 OF Diarios PROMPT 'Contabilización de recibos de caja en SIIGO'
DEFINE BAR 10 OF Diarios PROMPT 'Contabilización de consignaciones bancarias en SIIGO'
DEFINE BAR 11 OF Diarios PROMPT 'Causación de anticipos en SIIGO'
DEFINE BAR 12 OF Diarios PROMPT '\-'
DEFINE BAR 22 OF Diarios PROMPT 'Contabilización en Visual Key Contable'

ON SELECTION BAR 01 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_MovimientosPorCuenta')
ON SELECTION BAR 02 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_Inf_MovimientosPorDocumento')
ON SELECTION BAR 03 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CTB_Inf_MovimientosPorNit')
ON SELECTION BAR 04 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_MovimientosPorConcepto')
ON SELECTION BAR 06 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionFacturasSIIGO')
ON SELECTION BAR 07 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionFacturasSIIGOe')
ON SELECTION BAR 08 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionNCSIIGOe')
ON SELECTION BAR 09 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionRecibosSIIGO')
ON SELECTION BAR 10 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionConsignacionesSIIGO')
ON SELECTION BAR 11 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_CausacionAnticiposSIIGO')
ON SELECTION BAR 22 OF Diarios oAplicacion.EjecutaFormulario('CARTERA', .T., 'CAR_Inf_ContabilizacionVisualKey')

DO PopUpInternet
DO PopUpVentana
DO PopUpAyuda

IF	! ISNULL(oAplicacion.oFormLauncher)
	*!* oAplicacion.oFormLauncher.ListBar.CuentasxCobrar.FolderHeader.CLICK()
	oAplicacion.oFormLauncher.Outlook2003Bar1.SelectedButton = oAplicacion.nMod_CuentasxCobrar
ENDIF 
