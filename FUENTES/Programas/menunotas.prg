* *********************************************************
* Programa...: MenuNotas.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......:
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows
* Notas......: Programa menu de la aplicación
* Cambios....:
* *********************************************************

oAplicacion.cMenuInicio = 'NOTAS'

SET SYSMENU TO
SET SYSMENU AUTOMATIC

DEFINE PAD Notas 			OF _MSYSMENU PROMPT '\<NOTAS' 				COLOR SCHEME 3 KEY ALT+N, ''
DEFINE PAD ArchivosBase 	OF _MSYSMENU PROMPT '\<Archivos básicos' 	COLOR SCHEME 3 KEY ALT+A, ''
DEFINE PAD Matriculas		OF _MSYSMENU PROMPT '\<Matrículas' 			COLOR SCHEME 3 KEY ALT+M, ''
DEFINE PAD Comunicaciones	OF _MSYSMENU PROMPT '\<Comunicaciones'		COLOR SCHEME 3 KEY ALT+M, ''
DEFINE PAD DOE				OF _MSYSMENU PROMPT '\<D.O.E.'				COLOR SCHEME 3 KEY ALT+M, ''
DEFINE PAD Evaluacion		OF _MSYSMENU PROMPT 'Eva\<luaciones' 		COLOR SCHEME 3 KEY ALT+L, ''
DEFINE PAD Reportes 		OF _MSYSMENU PROMPT '\<Reportes' 			COLOR SCHEME 3 KEY ALT+R, ''
DEFINE PAD Internet			OF _MSYSMENU PROMPT '\<Internet' 			COLOR SCHEME 3 KEY ALT+I, ''
DEFINE PAD Ventana 			OF _MSYSMENU PROMPT '\<Ventana' 			COLOR SCHEME 3 KEY ALT+V, ''
DEFINE PAD Ayuda 			OF _MSYSMENU PROMPT 'A\<yuda' 				COLOR SCHEME 3 KEY ALT+Y, ''

ON PAD Notas 			OF _MSYSMENU ACTIVATE POPUP Notas
ON PAD ArchivosBase 	OF _MSYSMENU ACTIVATE POPUP ArchivosBase
ON PAD Matriculas		OF _MSYSMENU ACTIVATE POPUP Matriculas
ON PAD Comunicaciones	OF _MSYSMENU ACTIVATE POPUP Comunicaciones
ON PAD DOE				OF _MSYSMENU ACTIVATE POPUP DOE
ON PAD Evaluacion 		OF _MSYSMENU ACTIVATE POPUP Evaluacion
ON PAD Reportes 		OF _MSYSMENU ACTIVATE POPUP Reportes
ON PAD Internet			OF _MSYSMENU ACTIVATE POPUP Internet
ON PAD Ventana 			OF _MSYSMENU ACTIVATE POPUP Ventana
ON PAD Ayuda 			OF _MSYSMENU ACTIVATE POPUP Ayuda

DEFINE POPUP Notas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Notas PROMPT 'Abrir una empresa' SKIP FOR .T.
DEFINE BAR 02 OF Notas PROMPT 'Cerrar la empresa' ;
	SKIP FOR (EMPTY(oAplicacion.cDirDatos) OR oAplicacion.nForms > 0) AND ! oAplicacion.lControlAccesos
DEFINE BAR 03 OF Notas PROMPT '\-'
DEFINE BAR 04 OF Notas PROMPT 'Imprimir' 			KEY CTRL+P, 'CTRL+P' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 05 OF Notas PROMPT 'Presentación preliminar' ;
	SKIP FOR ! (oAplicacion.nForms > 0 AND _SCREEN.ACTIVEFORM.lPuedeImprimir AND ;
	! oAplicacion.lControlAccesos)
DEFINE BAR 06 OF Notas PROMPT 'Parámetros de impresión'
DEFINE BAR 07 OF Notas PROMPT '\-'
DEFINE BAR 08 OF Notas PROMPT 'Exportar' INVERT
DEFINE BAR 09 OF Notas PROMPT 'Importar' INVERT
DEFINE BAR 10 OF Notas PROMPT 'Control de coherencia financiera' SKIP FOR .T.
DEFINE BAR 11 OF Notas PROMPT '\-'
DEFINE BAR 12 OF Notas PROMPT 'Preferencias'
DEFINE BAR 13 OF Notas PROMPT 'Cambio de clave'
DEFINE BAR 14 OF Notas PROMPT 'Conversiones' SKIP FOR .T.
DEFINE BAR 15 OF Notas PROMPT 'Muestra barra de navegación' ;
	SKIP FOR oAplicacion.nForms = 0 OR ! ISNULL(oAplicacion.oBarra)
DEFINE BAR 16 OF Notas PROMPT '\-'
IF	oAplicacion.Mod_Contabilidad
	DEFINE BAR 17 OF Notas PROMPT 'CONTABILIDAD' 		KEY CTRL+F1, 'CTRL+F1' ;
		SKIP FOR ! oAplicacion.Mod_Contabilidad
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	DEFINE BAR 18 OF Notas PROMPT 'CARTERA' 			KEY CTRL+F2, 'CTRL+F2' ;
		SKIP FOR ! oAplicacion.Mod_CuentasxCobrar
ENDIF
IF	oAplicacion.Mod_Notas
	DEFINE BAR 22 OF Notas PROMPT 'NOTAS'				KEY CTRL+F6, 'CTRL+F6' ;
		SKIP FOR .T.
ENDIF
DEFINE BAR 23 OF Notas PROMPT '\-'
DEFINE BAR 24 OF Notas PROMPT 'SISTEMA' 			KEY CTRL+F10, 'CTRL+F10'
DEFINE BAR 25 OF Notas PROMPT '\-'
IF	oAplicacion.lControlAccesos
	DEFINE BAR 26 OF Notas PROMPT 'Terminar (accesos)'
ELSE
	DEFINE BAR 26 OF Notas PROMPT 'TERMINAR' ;
		SKIP FOR oAplicacion.nForms > 0
ENDIF

ON SELECTION BAR 02 OF Notas DO CerrarEmpresa
ON SELECTION BAR 04 OF Notas _SCREEN.ACTIVEFORM.Imprimir()
ON SELECTION BAR 05 OF Notas _SCREEN.ACTIVEFORM.VistaPrevia()
ON SELECTION BAR 06 OF Notas DO ConfigurarImpresora
ON BAR 08 OF Notas ACTIVATE POPUP Exportar
ON BAR 09 OF Notas ACTIVATE POPUP Importar
ON SELECTION BAR 12 OF Notas oAplicacion.EjecutaFormularioRetorno('NOTAS', .F., 'SYS_Preferencias')
ON SELECTION BAR 13 OF Notas oAplicacion.EjecutaFormularioRetorno('NOTAS', .F., 'frm_SYS_CambioClave')
ON SELECTION BAR 15 OF Notas AbreBarra(_SCREEN.ACTIVEFORM.cBarraHerramientas)
IF	oAplicacion.Mod_Contabilidad
	ON SELECTION BAR 17 OF Notas DoMenu('Contabilidad')
ENDIF
IF	oAplicacion.Mod_CuentasxCobrar
	ON SELECTION BAR 18 OF Notas DoMenu('Cartera')
ENDIF
IF	oAplicacion.Mod_Notas
	ON SELECTION BAR 22 OF Notas DoMenu('Notas')
ENDIF
ON SELECTION BAR 24 OF Notas DoMenu('Sistema')
IF	oAplicacion.lControlAccesos
	ON SELECTION BAR 26 OF Notas FinControlAccesos()
ELSE
	ON SELECTION BAR 26 OF Notas DO Terminar
ENDIF

DEFINE POPUP Exportar MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Exportar PROMPT 'Evaluación conceptual'
DEFINE BAR 02 OF Exportar PROMPT '\-'
DEFINE BAR 03 OF Exportar PROMPT 'Formularios de evaluación por asignatura'
DEFINE BAR 05 OF Exportar PROMPT 'Formularios de evaluación por área'
DEFINE BAR 06 OF Exportar PROMPT 'Formularios de evaluación para WEB'
DEFINE BAR 07 OF Exportar PROMPT '\-'
DEFINE BAR 08 OF Exportar PROMPT 'Transferencia de pensum académico'
DEFINE BAR 09 OF Exportar PROMPT 'Transferencia de alumnos'
DEFINE BAR 10 OF Exportar PROMPT '\-'
DEFINE BAR 11 OF Exportar PROMPT 'Transferencia de archivos WEB'
DEFINE BAR 12 OF Exportar PROMPT '\-'
DEFINE BAR 13 OF Exportar PROMPT 'Matrículas'

ON SELECTION BAR 01 OF Exportar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ExportarEvaluacionConceptual')
ON SELECTION BAR 03 OF Exportar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ExportarFormularioEvaluacionPorAsignatura')
ON SELECTION BAR 05 OF Exportar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ExportarFormularioEvaluacionPorArea')
ON SELECTION BAR 06 OF Exportar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ExportarFormularioEvaluacionWEB')
ON SELECTION BAR 08 OF Exportar oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_TransferenciaPensumAcademico')
ON SELECTION BAR 09 OF Exportar oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_TransferenciaAlumnos')
ON SELECTION BAR 11 OF Exportar DO ExportarArchivosWEB
ON SELECTION BAR 13 OF Exportar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ExportarMatriculas')

DEFINE POPUP Importar MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!* DEFINE BAR 01 OF Importar PROMPT 'Evaluación conceptual (dbf)'
DEFINE BAR 02 OF Importar PROMPT 'Evaluación conceptual'
DEFINE BAR 03 OF Importar PROMPT '\-'
DEFINE BAR 04 OF Importar PROMPT 'Formularios de evaluación'
DEFINE BAR 05 OF Importar PROMPT 'Formularios de evaluación web'
DEFINE BAR 07 OF Importar PROMPT '\-'
DEFINE BAR 10 OF Importar PROMPT 'Matrículas'
DEFINE BAR 11 OF Importar PROMPT 'Matrículas desde Saberes'
*!* DEFINE BAR 06 OF Importar PROMPT '\-'
*!* DEFINE BAR 07 OF Importar PROMPT 'Evaluaciones de años anteriores'
*!* DEFINE BAR 08 OF Importar PROMPT 'Asignar detalles a evaluaciones de años anteriores'

*!* ON SELECTION BAR 01 OF Importar oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_ImportarEvaluacionConceptual')
ON SELECTION BAR 02 OF Importar oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_ImportarEvaluacionConceptualXLS')
ON SELECTION BAR 04 OF Importar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ImportarFormularioEvaluacion')
ON SELECTION BAR 05 OF Importar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ImportarFormularioEvaluacionWEB')
ON SELECTION BAR 10 OF Importar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ImportarMatriculas')
ON SELECTION BAR 11 OF Importar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ImportarMatriculasSaberes')
*!* ON SELECTION BAR 07 OF Importar oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_ImportarEvaluacionesAnosAnteriores')
*!* ON SELECTION BAR 08 OF Importar oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_AsignacionDetalleDefinitivo')

DEFINE POPUP ArchivosBase MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ArchivosBase PROMPT 'Grados académicos'
DEFINE BAR 02 OF ArchivosBase PROMPT 'Áreas y asignaturas'
DEFINE BAR 03 OF ArchivosBase PROMPT '\-'
DEFINE BAR 04 OF ArchivosBase PROMPT 'Banco de Nits.' PICTURE '..\..\imagenes\bmp\xp_users.gif'
DEFINE BAR 06 OF ArchivosBase PROMPT '\-'
DEFINE BAR 07 OF ArchivosBase PROMPT 'Pensum académico' PICTURE '..\..\imagenes\bmp\alllevel.gif'
DEFINE BAR 08 OF ArchivosBase PROMPT 'Evaluación conceptual'
DEFINE BAR 09 OF ArchivosBase PROMPT '\-'
DEFINE BAR 10 OF ArchivosBase PROMPT 'Horarios de clase'
DEFINE BAR 11 OF ArchivosBase PROMPT 'Rutas de transporte'
DEFINE BAR 12 OF ArchivosBase PROMPT '\-'
*!* DEFINE BAR 13 OF ArchivosBase PROMPT 'Alumnos'
DEFINE BAR 14 OF ArchivosBase PROMPT 'Categorías de alumnos'
DEFINE BAR 15 OF ArchivosBase PROMPT '\-'
DEFINE BAR 16 OF ArchivosBase PROMPT 'Ciudades'

ON SELECTION BAR 01 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Grados')
ON SELECTION BAR 02 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Asignaturas')
ON SELECTION BAR 04 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'CTB_Nits')
ON SELECTION BAR 07 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_PensumAcademico')
ON SELECTION BAR 08 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_EvaluacionConceptual')
ON SELECTION BAR 10 OF ArchivosBase oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_Horarios')
ON SELECTION BAR 11 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_RutasTransporte')
*!* ON SELECTION BAR 13 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Alumnos')
ON SELECTION BAR 14 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Categorias')
ON SELECTION BAR 16 OF ArchivosBase oAplicacion.EjecutaFormulario('NOTAS', .T., 'CTB_Ciudades')

DEFINE POPUP Matriculas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Matriculas PROMPT 'Documentos para matrícula'
DEFINE BAR 02 OF Matriculas PROMPT '\-'
DEFINE BAR 03 OF Matriculas PROMPT 'Admisiones'
DEFINE BAR 04 OF Matriculas PROMPT '\-'
DEFINE BAR 05 OF Matriculas PROMPT 'Matrícula de alumnos' PICTURE '..\..\imagenes\ico\tutor.ico'
DEFINE BAR 06 OF Matriculas PROMPT '\-'
DEFINE BAR 07 OF Matriculas PROMPT 'Prematrícula de alumnos antiguos'
DEFINE BAR 08 OF Matriculas PROMPT 'Asignación automática de cursos por grado'
DEFINE BAR 09 OF Matriculas PROMPT 'Cambio de curso'

ON SELECTION BAR 01 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Documentos')
ON SELECTION BAR 03 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'ADMISIONES')
ON SELECTION BAR 05 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'MATRICULAS')
ON SELECTION BAR 07 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Prematriculas')
ON SELECTION BAR 08 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_AsignacionCursos')
ON SELECTION BAR 09 OF Matriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_CambioDeCurso')

DEFINE POPUP Comunicaciones MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Comunicaciones PROMPT 'Actualización rutas de transporte'
DEFINE BAR 02 OF Comunicaciones PROMPT '\-'
DEFINE BAR 03 OF Comunicaciones PROMPT 'Actualización datos de contacto de alumnos'
DEFINE BAR 04 OF Comunicaciones PROMPT 'Actualización datos de correo de empleados'
DEFINE BAR 05 OF Comunicaciones PROMPT '\-'
DEFINE BAR 06 OF Comunicaciones PROMPT 'Consulta datos de alumnos'
DEFINE BAR 07 OF Comunicaciones PROMPT 'Directorio de alumnos por grado'
DEFINE BAR 08 OF Comunicaciones PROMPT 'Album fotográfico por grado'
DEFINE BAR 09 OF Comunicaciones PROMPT '\-'
DEFINE BAR 10 OF Comunicaciones PROMPT 'Correo electrónico'
DEFINE BAR 11 OF Comunicaciones PROMPT '\-'
DEFINE BAR 12 OF Comunicaciones PROMPT 'Encuestas a padres y acudientes'
DEFINE BAR 13 OF Comunicaciones PROMPT 'Análisis de encuestas'

ON SELECTION BAR 01 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'TRANSPORTE')
ON SELECTION BAR 03 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'DATOS')
ON SELECTION BAR 04 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ActualizacionDatosDeCorreoEmpleados')
ON SELECTION BAR 06 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'CONSULTA')
ON SELECTION BAR 07 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioAlumnosxGradoCOM')
ON SELECTION BAR 08 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlbumFotograficoPorGrado')
*!* ON SELECTION BAR 10 OF Comunicaciones oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_CorreoElectronico')
ON SELECTION BAR 10 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_CorreoElectronico')
ON SELECTION BAR 12 OF Comunicaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_Encuesta')
ON SELECTION BAR 13 OF Comunicaciones oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_FiltroDeEncuesta')

DEFINE POPUP DOE MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF DOE PROMPT 'Departamentos (D.O.E.)'
DEFINE BAR 02 OF DOE PROMPT 'Status (D.O.E.)'
DEFINE BAR 03 OF DOE PROMPT '\-'
DEFINE BAR 04 OF DOE PROMPT 'Seguimiento a alumnos'
DEFINE BAR 05 OF DOE PROMPT 'Seguimiento a funcionarios'

ON SELECTION BAR 01 OF DOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_DOES')
ON SELECTION BAR 02 OF DOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_StatusDOE')
ON SELECTION BAR 04 OF DOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_SeguimientoDOEAlumnos')
ON SELECTION BAR 05 OF DOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_SeguimientoDOEFuncionarios')


DEFINE POPUP Evaluacion MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Evaluacion PROMPT 'Alumnos por asignatura'
DEFINE BAR 02 OF Evaluacion PROMPT '\-'
DEFINE BAR 03 OF Evaluacion PROMPT 'Control disciplinario' PICTURE '..\..\imagenes\ico\point06.ico'
DEFINE BAR 04 OF Evaluacion PROMPT 'Asignación de control disciplinario en evaluaciones'
DEFINE BAR 05 OF Evaluacion PROMPT '\-'
DEFINE BAR 06 OF Evaluacion PROMPT 'Evaluación por asignatura'
DEFINE BAR 07 OF Evaluacion PROMPT 'Evaluación por docente'
DEFINE BAR 08 OF Evaluacion PROMPT '\-'
DEFINE BAR 09 OF Evaluacion PROMPT 'Observaciones del Director'
DEFINE BAR 10 OF Evaluacion PROMPT 'Observaciones del Médico'
DEFINE BAR 11 OF Evaluacion PROMPT 'Observaciones del Sicólogo'
DEFINE BAR 12 OF Evaluacion PROMPT 'Observaciones del Fonoaudiologo'
DEFINE BAR 13 OF Evaluacion PROMPT 'Observaciones Desarrollo de pensamiento'
DEFINE BAR 14 OF Evaluacion PROMPT '\-'
DEFINE BAR 15 OF Evaluacion PROMPT 'Consulta de evaluaciones por director de curso'
DEFINE BAR 16 OF Evaluacion PROMPT 'Consulta de evaluaciones por coordinador de área'
DEFINE BAR 17 OF Evaluacion PROMPT 'Consulta de evaluaciones por coordinador de sección'
DEFINE BAR 18 OF Evaluacion PROMPT '\-'
DEFINE BAR 19 OF Evaluacion PROMPT 'Evaluaciones definitivas'
DEFINE BAR 20 OF Evaluacion PROMPT 'Alumnos que nivelan'

ON SELECTION BAR 01 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_AlumnosxAsignatura')
ON SELECTION BAR 03 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_ControlDeAsistencia')
ON SELECTION BAR 04 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_AsignacionFallasEnEvaluaciones')
ON SELECTION BAR 06 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_EvaluacionxAsignatura')
ON SELECTION BAR 07 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_EvaluacionxDocente')
ON SELECTION BAR 09 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'DIRECTOR')
ON SELECTION BAR 10 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'MEDICO')
ON SELECTION BAR 11 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'SICOLOGO')
ON SELECTION BAR 12 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'FONOAUDIOLOGO')
ON SELECTION BAR 13 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_MatriculasAlumnos', 'DESARROLLO')
ON SELECTION BAR 15 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_ConsultaEvaluacionxDirector')
ON SELECTION BAR 16 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_ConsultaEvaluacionxArea')
ON SELECTION BAR 17 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'frm_NTA_ConsultaEvaluacionxSeccion')
ON SELECTION BAR 19 OF Evaluacion oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_EvaluacionesDefinitivas')
ON SELECTION BAR 20 OF Evaluacion oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_AlumnosQueNivelan')

DEFINE POPUP Reportes MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Reportes PROMPT 'Grados académicos'
DEFINE BAR 02 OF Reportes PROMPT 'Áreas y asignaturas'
DEFINE BAR 03 OF Reportes PROMPT 'Profesores' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 04 OF Reportes PROMPT 'Categorías de empleados'
DEFINE BAR 05 OF Reportes PROMPT 'Pensum académico' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 06 OF Reportes PROMPT 'Evaluación conceptual' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 07 OF Reportes PROMPT 'Horarios de clase' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 08 OF Reportes PROMPT 'Rutas de transporte' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 09 OF Reportes PROMPT '\-'
DEFINE BAR 10 OF Reportes PROMPT 'Alumnos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 11 OF Reportes PROMPT 'Categorías de alumnos'
DEFINE BAR 12 OF Reportes PROMPT '\-'
DEFINE BAR 13 OF Reportes PROMPT 'Documentos para matrícula' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 14 OF Reportes PROMPT 'Matrículas' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 15 OF Reportes PROMPT '\-'
DEFINE BAR 16 OF Reportes PROMPT 'D.O.E.' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 17 OF Reportes PROMPT '\-'
DEFINE BAR 18 OF Reportes PROMPT 'Listas auxiliares' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 19 OF Reportes PROMPT '\-'
DEFINE BAR 20 OF Reportes PROMPT 'Evaluaciones' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 21 OF Reportes PROMPT '\-'
DEFINE BAR 22 OF Reportes PROMPT 'Informes finales' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 23 OF Reportes PROMPT '\-'
DEFINE BAR 24 OF Reportes PROMPT 'Análisis estadístico' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'

ON SELECTION BAR 01 OF Reportes oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Grados')
ON SELECTION BAR 02 OF Reportes oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Asignaturas')
ON BAR 03 OF Reportes ACTIVATE POPUP InformesProfesores
ON SELECTION BAR 04 OF Reportes oAplicacion.EjecutaFormulario('NOTAS', .T., 'NOM_Inf_Categorias')
ON BAR 05 OF Reportes ACTIVATE POPUP InformesPensumAcademico
ON BAR 06 OF Reportes ACTIVATE POPUP InformesEvaluacionConceptual
ON BAR 07 OF Reportes ACTIVATE POPUP Horarios
ON BAR 08 OF Reportes ACTIVATE POPUP RutasTransporte
ON BAR 10 OF Reportes ACTIVATE POPUP InformesAlumnos
ON SELECTION BAR 11 OF Reportes oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Categorias')
ON BAR 13 OF Reportes ACTIVATE POPUP DocumentosMatricula
ON BAR 14 OF Reportes ACTIVATE POPUP InformesMatriculas
ON BAR 16 OF Reportes ACTIVATE POPUP InformesDOE
ON BAR 18 OF Reportes ACTIVATE POPUP ListasAuxiliares
ON BAR 20 OF Reportes ACTIVATE POPUP InformesEvaluaciones
ON BAR 22 OF Reportes ACTIVATE POPUP InformesFinales
ON BAR 24 OF Reportes ACTIVATE POPUP AnalisisEstadistico

DEFINE POPUP InformesProfesores MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesProfesores PROMPT 'Informe de profesores'
DEFINE BAR 02 OF InformesProfesores PROMPT 'Informe de profesores por asignatura'
DEFINE BAR 03 OF InformesProfesores PROMPT 'Informe de profesores por grado'
DEFINE BAR 04 OF InformesProfesores PROMPT 'Informe de asignaturas por profesor'
DEFINE BAR 05 OF InformesProfesores PROMPT 'Informe de profesores directores de curso'

ON SELECTION BAR 01 OF InformesProfesores oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Profesores')
ON SELECTION BAR 02 OF InformesProfesores oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ProfesoresPorAsignatura')
ON SELECTION BAR 03 OF InformesProfesores oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ProfesoresPorGrado')
ON SELECTION BAR 04 OF InformesProfesores oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AsignaturasPorProfesor')
ON SELECTION BAR 05 OF InformesProfesores oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ProfesoresDirectores')

DEFINE POPUP InformesPensumAcademico MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesPensumAcademico PROMPT 'Pensum académico por grado'
DEFINE BAR 02 OF InformesPensumAcademico PROMPT 'Pensum académico por asignatura'
DEFINE BAR 03 OF InformesPensumAcademico PROMPT 'Pensum académico por profesor'

ON SELECTION BAR 01 OF InformesPensumAcademico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_PensumAcademicoxGrado')
ON SELECTION BAR 02 OF InformesPensumAcademico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_PensumAcademicoxAsignatura')
ON SELECTION BAR 03 OF InformesPensumAcademico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_PensumAcademicoxProfesor')

DEFINE POPUP InformesEvaluacionConceptual MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesEvaluacionConceptual PROMPT 'Unidades académicas'
DEFINE BAR 02 OF InformesEvaluacionConceptual PROMPT 'Logros académicos'
DEFINE BAR 03 OF InformesEvaluacionConceptual PROMPT 'Indicadores de logros'
DEFINE BAR 04 OF InformesEvaluacionConceptual PROMPT 'Indicadores de logros (F/D/R)'
DEFINE BAR 05 OF InformesEvaluacionConceptual PROMPT 'Indicadores'
DEFINE BAR 06 OF InformesEvaluacionConceptual PROMPT 'Desarrollos'

ON SELECTION BAR 01 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_UnidadesAcademicas')
ON SELECTION BAR 02 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LogrosAcademicos')
ON SELECTION BAR 03 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_IndicadoresDeLogros')
ON SELECTION BAR 04 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_IndicadoresDeLogrosFDR')
ON SELECTION BAR 05 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Indicadores')
ON SELECTION BAR 06 OF InformesEvaluacionConceptual oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Desarrollos')

DEFINE POPUP Horarios MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF Horarios PROMPT 'Horario por grados'
DEFINE BAR 02 OF Horarios PROMPT 'Horario por profesor'

ON SELECTION BAR 01 OF Horarios oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_HorarioPorGrado')
ON SELECTION BAR 02 OF Horarios oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_HorarioPorProfesor')

DEFINE POPUP RutasTransporte MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF RutasTransporte PROMPT 'Rutas de transporte'
DEFINE BAR 02 OF RutasTransporte PROMPT '\-'
DEFINE BAR 03 OF RutasTransporte PROMPT 'Lista auxiliar por ruta'
DEFINE BAR 04 OF RutasTransporte PROMPT 'Lista auxiliar por ruta (salida 1)'
DEFINE BAR 05 OF RutasTransporte PROMPT 'Lista auxiliar por ruta (salida 2)'
DEFINE BAR 06 OF RutasTransporte PROMPT 'Lista auxiliar por ruta (salida 3)'
DEFINE BAR 07 OF RutasTransporte PROMPT '\-'
DEFINE BAR 08 OF RutasTransporte PROMPT 'Control de asistencia por ruta'
DEFINE BAR 09 OF RutasTransporte PROMPT 'Control de asistencia por ruta (salida 1)'
DEFINE BAR 10 OF RutasTransporte PROMPT 'Control de asistencia por ruta (salida 2)'
DEFINE BAR 11 OF RutasTransporte PROMPT 'Control de asistencia por ruta (salida 3)'

ON SELECTION BAR 01 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_RutasDeTransporte')
ON SELECTION BAR 03 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxRuta')
ON SELECTION BAR 04 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxRuta1')
ON SELECTION BAR 05 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxRuta2')
ON SELECTION BAR 06 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxRuta3')
ON SELECTION BAR 08 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta')
ON SELECTION BAR 09 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta1')
ON SELECTION BAR 10 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta2')
ON SELECTION BAR 11 OF RutasTransporte oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta3')

DEFINE POPUP InformesAlumnos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesAlumnos PROMPT 'Alumnos por categoría'
DEFINE BAR 02 OF InformesAlumnos PROMPT 'Alumnos por nombre'
DEFINE BAR 03 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 04 OF InformesAlumnos PROMPT 'Directorio de alumnos por grado'
DEFINE BAR 05 OF InformesAlumnos PROMPT 'Directorio general de alumnos'
DEFINE BAR 06 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 07 OF InformesAlumnos PROMPT 'Album fotográfico por grado'
DEFINE BAR 08 OF InformesAlumnos PROMPT 'Carnés de alumnos'
DEFINE BAR 09 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 10 OF InformesAlumnos PROMPT 'Cumpleaños de alumnos'
DEFINE BAR 11 OF InformesAlumnos PROMPT 'Cumpleaños de padres'
DEFINE BAR 12 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 13 OF InformesAlumnos PROMPT 'Estadística de alumnos'
DEFINE BAR 14 OF InformesAlumnos PROMPT 'Alumnos retirados'
DEFINE BAR 15 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 16 OF InformesAlumnos PROMPT 'Directorio de exalumnos'
DEFINE BAR 17 OF InformesAlumnos PROMPT '\-'
DEFINE BAR 18 OF InformesAlumnos PROMPT 'Etiquetas de correo para alumnos'
DEFINE BAR 19 OF InformesAlumnos PROMPT 'Etiquetas de correo para acudientes'
DEFINE BAR 20 OF InformesAlumnos PROMPT 'Etiquetas de correo para acudientes - alumnos'

ON SELECTION BAR 01 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosxCategoria')
ON SELECTION BAR 02 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosxNombre')
ON SELECTION BAR 04 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioAlumnosxGrado')
ON SELECTION BAR 05 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioAlumnos')
ON SELECTION BAR 07 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlbumFotograficoPorGrado')
ON SELECTION BAR 08 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CarnesAlumnos')
ON SELECTION BAR 10 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CumpleanosAlumnos')
ON SELECTION BAR 11 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CumpleanosPadres')
ON SELECTION BAR 13 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaAlumnos')
ON SELECTION BAR 14 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosRetirados')
ON SELECTION BAR 16 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioExalumnos')
ON SELECTION BAR 18 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EtiquetasCorreoAlumnos')
ON SELECTION BAR 19 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EtiquetasCorreoAcudientes')
ON SELECTION BAR 20 OF InformesAlumnos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EtiquetasCorreoAcudienteAlumnos')

DEFINE POPUP DocumentosMatricula MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF DocumentosMatricula PROMPT 'Documentos para matrícula'
DEFINE BAR 02 OF DocumentosMatricula PROMPT '\-'
DEFINE BAR 03 OF DocumentosMatricula PROMPT 'Documentación por alumno'
DEFINE BAR 04 OF DocumentosMatricula PROMPT 'Documentación pendiente por alumno'

ON SELECTION BAR 01 OF DocumentosMatricula oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_Documentos')
ON SELECTION BAR 03 OF DocumentosMatricula oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DocumentosPorAlumno')
ON SELECTION BAR 04 OF DocumentosMatricula oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DocumentacionPendientePorAlumno')

DEFINE POPUP InformesMatriculas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesMatriculas PROMPT 'Hoja de admisión'
DEFINE BAR 02 OF InformesMatriculas PROMPT 'Lista auxiliar de admisiones por grado'
DEFINE BAR 03 OF InformesMatriculas PROMPT '\-'
DEFINE BAR 04 OF InformesMatriculas PROMPT 'Hoja de matrícula'
DEFINE BAR 06 OF InformesMatriculas PROMPT 'Contrato de matrícula'
DEFINE BAR 07 OF InformesMatriculas PROMPT 'Estadística de matrículas'
DEFINE BAR 08 OF InformesMatriculas PROMPT 'Informe de matrículas por fecha'
DEFINE BAR 09 OF InformesMatriculas PROMPT '\-'
DEFINE BAR 10 OF InformesMatriculas PROMPT 'Observaciones del director de curso'
DEFINE BAR 11 OF InformesMatriculas PROMPT 'Observaciones médicas'
DEFINE BAR 12 OF InformesMatriculas PROMPT 'Observaciones sicológicas'
DEFINE BAR 13 OF InformesMatriculas PROMPT 'Observaciones fonoaudiología'
DEFINE BAR 14 OF InformesMatriculas PROMPT 'Observaciones desarrollo del pensamiento'
DEFINE BAR 15 OF InformesMatriculas PROMPT 'Observaciones en boletín'
DEFINE BAR 16 OF InformesMatriculas PROMPT '\-'
DEFINE BAR 17 OF InformesMatriculas PROMPT 'Directorio de padres y acudientes por profesión'
DEFINE BAR 18 OF InformesMatriculas PROMPT 'Directorio de alumnos por acudiente'
DEFINE BAR 19 OF InformesMatriculas PROMPT '\-'
DEFINE BAR 20 OF InformesMatriculas PROMPT 'Certificado de escolaridad'
DEFINE BAR 21 OF InformesMatriculas PROMPT 'Órdenes de matrícula'
DEFINE BAR 22 OF InformesMatriculas PROMPT 'Paz y Salvo escolar'

ON SELECTION BAR 01 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_HojaDeAdmision')
ON SELECTION BAR 02 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarAdmisionesXGrado')
ON SELECTION BAR 04 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_HojaDeMatricula')
ON SELECTION BAR 06 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ContratoDeMatricula')
ON SELECTION BAR 07 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaDeMatriculas')
ON SELECTION BAR 08 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_MatriculasPorFecha')
ON SELECTION BAR 10 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesDirector')
ON SELECTION BAR 11 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesMedicas')
ON SELECTION BAR 12 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesSicologicas')
ON SELECTION BAR 13 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesFonoaudiologia')
ON SELECTION BAR 14 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesDesarrolloPensamiento')
ON SELECTION BAR 15 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservacionesBoletin')
ON SELECTION BAR 17 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioPadresPorProfesion')
ON SELECTION BAR 18 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DirectorioAlumnosPorAcudiente')
ON SELECTION BAR 20 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CertificadoEscolaridad')
ON SELECTION BAR 21 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_OrdenesDeMatricula')
ON SELECTION BAR 22 OF InformesMatriculas oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_PazYSalvoEscolar')

DEFINE POPUP InformesDOE MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesDOE PROMPT 'Departamentos (D.O.E.)'
DEFINE BAR 02 OF InformesDOE PROMPT 'Status (D.O.E.)'
DEFINE BAR 03 OF InformesDOE PROMPT '\-'
DEFINE BAR 04 OF InformesDOE PROMPT 'Observador de alumnos'
DEFINE BAR 05 OF InformesDOE PROMPT 'Observador de funcionarios'
DEFINE BAR 06 OF InformesDOE PROMPT '\-'
DEFINE BAR 07 OF InformesDOE PROMPT 'Estadísticas (D.O.E.)'

ON SELECTION BAR 01 OF InformesDOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_DOES')
ON SELECTION BAR 02 OF InformesDOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_StatusDOE')
ON SELECTION BAR 04 OF InformesDOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservadorAlumnoDOE')
ON SELECTION BAR 05 OF InformesDOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservadorFuncionarioDOE')
ON SELECTION BAR 07 OF InformesDOE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticasDOE')


DEFINE POPUP ListasAuxiliares MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ListasAuxiliares PROMPT 'Listas auxiliares por grado' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 02 OF ListasAuxiliares PROMPT 'Listas auxiliares por asignatura' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 03 OF ListasAuxiliares PROMPT 'Controles de asistencia' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 04 OF ListasAuxiliares PROMPT 'Listas auxiliares por estado' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 05 OF ListasAuxiliares PROMPT '\-'
DEFINE BAR 06 OF ListasAuxiliares PROMPT 'Observador del alumno'

ON BAR 01 OF ListasAuxiliares ACTIVATE POPUP ListasAuxiliaresPorGrado
ON BAR 02 OF ListasAuxiliares ACTIVATE POPUP ListasAuxiliaresPorAsignatura
ON BAR 03 OF ListasAuxiliares ACTIVATE POPUP ControlesDeAsistencia
ON BAR 04 OF ListasAuxiliares ACTIVATE POPUP ListasAuxiliaresPorEstado
ON SELECTION BAR 06 OF ListasAuxiliares oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ObservadorAlumno')

DEFINE POPUP ListasAuxiliaresPorGrado MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ListasAuxiliaresPorGrado PROMPT 'Lista auxiliar por grado'
DEFINE BAR 02 OF ListasAuxiliaresPorGrado PROMPT 'Lista auxiliar por grado (50 x pág.)'

ON SELECTION BAR 01 OF ListasAuxiliaresPorGrado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxGrado')
ON SELECTION BAR 02 OF ListasAuxiliaresPorGrado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxGrado50')

DEFINE POPUP ListasAuxiliaresPorAsignatura MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ListasAuxiliaresPorAsignatura PROMPT 'Lista auxiliar por asignatura'
DEFINE BAR 02 OF ListasAuxiliaresPorAsignatura PROMPT 'Lista auxiliar por asignatura (50 x pág.)'
DEFINE BAR 03 OF ListasAuxiliaresPorAsignatura PROMPT 'Lista auxiliar por asignatura (50 x pág.) con valoración alfabética'
DEFINE BAR 04 OF ListasAuxiliaresPorAsignatura PROMPT 'Lista auxiliar por asignatura (50 x pág.) con valoración numérica'
DEFINE BAR 05 OF ListasAuxiliaresPorAsignatura PROMPT 'Lista auxiliar por asignaturas electivas'

ON SELECTION BAR 01 OF ListasAuxiliaresPorAsignatura oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxAsignatura')
ON SELECTION BAR 02 OF ListasAuxiliaresPorAsignatura oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxAsignatura50')
ON SELECTION BAR 03 OF ListasAuxiliaresPorAsignatura oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarConValoracionAlfabetica')
ON SELECTION BAR 04 OF ListasAuxiliaresPorAsignatura oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarConValoracionNumerica')
ON SELECTION BAR 05 OF ListasAuxiliaresPorAsignatura oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarxAsignaturasElectivas')

DEFINE POPUP ControlesDeAsistencia MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ControlesDeAsistencia PROMPT 'Control de asistencia por grado'
DEFINE BAR 02 OF ControlesDeAsistencia PROMPT 'Control de asistencia por servicio'
DEFINE BAR 03 OF ControlesDeAsistencia PROMPT 'Control de asistencia por asignatura'
DEFINE BAR 04 OF ControlesDeAsistencia PROMPT '\-'
DEFINE BAR 05 OF ControlesDeAsistencia PROMPT 'Control de asistencia por ruta'
DEFINE BAR 06 OF ControlesDeAsistencia PROMPT 'Control de asistencia por ruta (salida 1)'
DEFINE BAR 07 OF ControlesDeAsistencia PROMPT 'Control de asistencia por ruta (salida 2)'
DEFINE BAR 08 OF ControlesDeAsistencia PROMPT 'Control de asistencia por ruta (salida 3)'
DEFINE BAR 09 OF ControlesDeAsistencia PROMPT '\-'
DEFINE BAR 10 OF ControlesDeAsistencia PROMPT 'Control de asistencia de acudientes'

ON SELECTION BAR 01 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxGrado')
ON SELECTION BAR 02 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxServicio')
ON SELECTION BAR 03 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxAsignatura')
ON SELECTION BAR 05 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta')
ON SELECTION BAR 06 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta1')
ON SELECTION BAR 07 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta2')
ON SELECTION BAR 08 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxRuta3')
ON SELECTION BAR 10 OF ControlesDeAsistencia oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaxAcudiente')

DEFINE POPUP ListasAuxiliaresPorEstado MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ListasAuxiliaresPorEstado PROMPT 'Lista auxiliar de alumnos antiguos'
DEFINE BAR 02 OF ListasAuxiliaresPorEstado PROMPT 'Lista auxiliar de alumnos nuevos'
DEFINE BAR 03 OF ListasAuxiliaresPorEstado PROMPT 'Lista auxiliar de alumnos reintegrados'

ON SELECTION BAR 01 OF ListasAuxiliaresPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarAntiguos')
ON SELECTION BAR 02 OF ListasAuxiliaresPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarNuevos')
ON SELECTION BAR 03 OF ListasAuxiliaresPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarReintegrados')

DEFINE POPUP InformesEvaluaciones MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesEvaluaciones PROMPT 'Boletines alfabéticos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 02 OF InformesEvaluaciones PROMPT 'Boletines numéricos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 03 OF InformesEvaluaciones PROMPT 'Boletines alfanuméricos' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 04 OF InformesEvaluaciones PROMPT 'Boletines conceptuales' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 05 OF InformesEvaluaciones PROMPT '\-'
DEFINE BAR 06 OF InformesEvaluaciones PROMPT 'Control disciplinario' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 07 OF InformesEvaluaciones PROMPT '\-'
DEFINE BAR 08 OF InformesEvaluaciones PROMPT 'Rendimiento de alumnos por promedio' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 09 OF InformesEvaluaciones PROMPT '\-'
DEFINE BAR 10 OF InformesEvaluaciones PROMPT 'Evaluaciones por período'
DEFINE BAR 11 OF InformesEvaluaciones PROMPT 'Evaluaciones por docente'
DEFINE BAR 12 OF InformesEvaluaciones PROMPT 'Evaluaciones de dimensiones por docente'
DEFINE BAR 13 OF InformesEvaluaciones PROMPT 'Alumnos no evaluados'
DEFINE BAR 14 OF InformesEvaluaciones PROMPT '\-'
DEFINE BAR 15 OF InformesEvaluaciones PROMPT 'Evaluaciones por dimensión' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 16 OF InformesEvaluaciones PROMPT '\-'
DEFINE BAR 17 OF InformesEvaluaciones PROMPT 'Alumnos reprobados' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'

ON BAR 01 OF InformesEvaluaciones ACTIVATE POPUP BoletinesAlfabeticos
ON BAR 02 OF InformesEvaluaciones ACTIVATE POPUP BoletinesNumericos
ON BAR 03 OF InformesEvaluaciones ACTIVATE POPUP BoletinesAlfaNumericos
ON BAR 04 OF InformesEvaluaciones ACTIVATE POPUP BoletinesConceptuales
ON BAR 06 OF InformesEvaluaciones ACTIVATE POPUP ControlDisciplinario
ON BAR 08 OF InformesEvaluaciones ACTIVATE POPUP RendimientoAlumnosPorPromedio
ON SELECTION BAR 10 OF InformesEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EvaluacionesPorPeriodo')
ON SELECTION BAR 11 OF InformesEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EvaluacionesPorDocente')
ON SELECTION BAR 12 OF InformesEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EvaluacionesDimensionesPorDocente')
ON SELECTION BAR 13 OF InformesEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosNoEvaluados')
ON BAR 15 OF InformesEvaluaciones ACTIVATE POPUP EvaluacionesPorDimension
ON BAR 17 OF InformesEvaluaciones ACTIVATE POPUP AlumnosReprobados

DEFINE POPUP BoletinesAlfabeticos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético'
DEFINE BAR 02 OF BoletinesAlfabeticos PROMPT '\-'
DEFINE BAR 08 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Modelo de convivencia 1'
DEFINE BAR 09 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Modelo de convivencia 2'
DEFINE BAR 10 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Comportamiento y esfuerzo'
DEFINE BAR 11 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Mitad de período'
DEFINE BAR 12 OF BoletinesAlfabeticos PROMPT '\-'
DEFINE BAR 13 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Semestral'
DEFINE BAR 14 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Anual'
DEFINE BAR 15 OF BoletinesAlfabeticos PROMPT 'Boletín alfabético - Consolidado anual'

ON SELECTION BAR 01 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabetico1')
ON SELECTION BAR 08 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_InformeDeConvivencia')
ON SELECTION BAR 09 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_InformeDeConvivenciaAlfabetico')
ON SELECTION BAR 10 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabeticoComportamientoYEsfuerzo')
ON SELECTION BAR 11 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabeticoMitadPeriodo')
ON SELECTION BAR 13 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabetico6')
ON SELECTION BAR 14 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabetico5')
ON SELECTION BAR 15 OF BoletinesAlfabeticos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfabetico7')

DEFINE POPUP BoletinesNumericos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF BoletinesNumericos PROMPT 'Boletín numérico'
DEFINE BAR 02 OF BoletinesNumericos PROMPT '\-'
DEFINE BAR 05 OF BoletinesNumericos PROMPT 'Boletín numérico - Modelo de convivencia'
DEFINE BAR 06 OF BoletinesNumericos PROMPT 'Boletín numérico - Mitad de período'
DEFINE BAR 07 OF BoletinesNumericos PROMPT '\-'
DEFINE BAR 08 OF BoletinesNumericos PROMPT 'Boletín numérico - Semestral'
DEFINE BAR 09 OF BoletinesNumericos PROMPT 'Boletín numérico - Anual'
DEFINE BAR 10 OF BoletinesNumericos PROMPT 'Boletín numérico - Consolidado anual'

ON SELECTION BAR 01 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinNumerico1')
ON SELECTION BAR 05 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_InformeDeConvivenciaNumerico')
ON SELECTION BAR 06 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinNumericoMitadPeriodo')
ON SELECTION BAR 08 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinNumerico4')
ON SELECTION BAR 09 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinNumerico3')
ON SELECTION BAR 10 OF BoletinesNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinNumerico5')

DEFINE POPUP BoletinesAlfaNumericos MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF BoletinesAlfaNumericos PROMPT 'Boletín alfanumérico'

ON SELECTION BAR 01 OF BoletinesAlfaNumericos oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinAlfanumerico1')

DEFINE POPUP BoletinesConceptuales MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF BoletinesConceptuales PROMPT 'Boletín conceptual'
DEFINE BAR 04 OF BoletinesConceptuales PROMPT '\-'
DEFINE BAR 05 OF BoletinesConceptuales PROMPT 'Boletín conceptual alfabético'
DEFINE BAR 06 OF BoletinesConceptuales PROMPT 'Boletín conceptual alfabético - con recuperaciones'
DEFINE BAR 08 OF BoletinesConceptuales PROMPT '\-'
DEFINE BAR 09 OF BoletinesConceptuales PROMPT 'Boletín conceptual numérico'
DEFINE BAR 10 OF BoletinesConceptuales PROMPT 'Boletín conceptual numérico - con recuperaciones'
DEFINE BAR 12 OF BoletinesConceptuales PROMPT '\-'
DEFINE BAR 13 OF BoletinesConceptuales PROMPT 'Boletín conceptual alfanumérico'
DEFINE BAR 15 OF BoletinesConceptuales PROMPT '\-'
DEFINE BAR 16 OF BoletinesConceptuales PROMPT 'Boletín conceptual libre'
DEFINE BAR 17 OF BoletinesConceptuales PROMPT 'Boletín conceptual libre preimpreso'

ON SELECTION BAR 01 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptual1')
ON SELECTION BAR 05 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualAlfabetico')
ON SELECTION BAR 06 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualAlfabeticoConRecuperacion')
ON SELECTION BAR 09 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualNumerico')
ON SELECTION BAR 10 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualNumericoConRecuperacion')
ON SELECTION BAR 13 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualAlfanumerico')
ON SELECTION BAR 16 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualLibre')
ON SELECTION BAR 17 OF BoletinesConceptuales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_BoletinConceptualLibrePreimpreso')

DEFINE POPUP ControlDisciplinario MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF ControlDisciplinario PROMPT 'Control disciplinario mensual'
DEFINE BAR 02 OF ControlDisciplinario PROMPT 'Control disciplinario por alumno'

ON SELECTION BAR 01 OF ControlDisciplinario oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlAsistenciaMensual')
ON SELECTION BAR 02 OF ControlDisciplinario oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ControlDisciplinarioPorAlumno')

DEFINE POPUP RendimientoAlumnosPorPromedio MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF RendimientoAlumnosPorPromedio PROMPT 'Rendimiento de alumnos por promedio - grado'
DEFINE BAR 02 OF RendimientoAlumnosPorPromedio PROMPT 'Rendimiento de alumnos por promedio - asignatura'

ON SELECTION BAR 01 OF RendimientoAlumnosPorPromedio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_RendimientoAlumnosPorPromedioGrado')
ON SELECTION BAR 02 OF RendimientoAlumnosPorPromedio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_RendimientoAlumnosPorPromedioAsignatura')

DEFINE POPUP EvaluacionesPorDimension MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF EvaluacionesPorDimension PROMPT 'Evaluación de dimensiones por período'
DEFINE BAR 02 OF EvaluacionesPorDimension PROMPT 'Evaluación por dimensión'

ON SELECTION BAR 01 OF EvaluacionesPorDimension oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EvaluacionesDeDimensionesPorPeriodo')
ON SELECTION BAR 02 OF EvaluacionesPorDimension oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EvaluacionesPorDimension')

DEFINE POPUP AlumnosReprobados MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF AlumnosReprobados PROMPT 'Alumnos que deben nivelar en el período'
DEFINE BAR 02 OF AlumnosReprobados PROMPT 'Alumnos que deben nivelar para comité de evaluación'
DEFINE BAR 03 OF AlumnosReprobados PROMPT 'Alumnos que deben nivelar por promedio'
DEFINE BAR 04 OF AlumnosReprobados PROMPT '\-'
DEFINE BAR 05 OF AlumnosReprobados PROMPT 'Alumnos que deben nivelar en mitad de período'
DEFINE BAR 06 OF AlumnosReprobados PROMPT 'Alumnos que deben nivelar para comité de evaluación - mitad de período'
DEFINE BAR 07 OF AlumnosReprobados PROMPT '\-'
DEFINE BAR 08 OF AlumnosReprobados PROMPT 'Invitación de alumnos a recuperar'

ON SELECTION BAR 01 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelarPeriodo')
ON SELECTION BAR 02 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelarComiteEvaluacion')
ON SELECTION BAR 03 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelarPorPromedio')
ON SELECTION BAR 05 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelarMitadPeriodo')
ON SELECTION BAR 06 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelarComiteEvaluacionMitadPeriodo')
ON SELECTION BAR 08 OF AlumnosReprobados oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_InvitacionAlumnosARecuperar')

DEFINE POPUP InformesFinales MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF InformesFinales PROMPT 'Alumnos por estado final' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 02 OF InformesFinales PROMPT 'Certificados de estudio' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 03 OF InformesFinales PROMPT 'Registros finales de valoración' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 04 OF InformesFinales PROMPT 'Libros de evaluaciones' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'

ON BAR 01 OF InformesFinales ACTIVATE POPUP AlumnosPorEstado
ON BAR 02 OF InformesFinales ACTIVATE POPUP CertificadosDeEstudio
ON BAR 03 OF InformesFinales ACTIVATE POPUP RegistrosFinales
ON BAR 04 OF InformesFinales ACTIVATE POPUP LibrosDeEvaluaciones

DEFINE POPUP AlumnosPorEstado MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF AlumnosPorEstado PROMPT 'Alumnos que aprueban'
DEFINE BAR 02 OF AlumnosPorEstado PROMPT 'Alumnos que reprueban'
DEFINE BAR 03 OF AlumnosPorEstado PROMPT 'Alumnos que deben nivelar'
DEFINE BAR 04 OF AlumnosPorEstado PROMPT '\-'
DEFINE BAR 05 OF AlumnosPorEstado PROMPT 'Lista auxiliar para recuperaciones'

ON SELECTION BAR 01 OF AlumnosPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueAprueban')
ON SELECTION BAR 02 OF AlumnosPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueReprueban')
ON SELECTION BAR 03 OF AlumnosPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_AlumnosQueDebenNivelar')
ON SELECTION BAR 05 OF AlumnosPorEstado oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_ListaAuxiliarRecuperaciones')

DEFINE POPUP CertificadosDeEstudio MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF CertificadosDeEstudio PROMPT 'Certificado de estudios - Papel preimpreso'
DEFINE BAR 02 OF CertificadosDeEstudio PROMPT 'Certificado de estudios - Papel blanco'
DEFINE BAR 04 OF CertificadosDeEstudio PROMPT 'Certificado de estudios - Porcentual'
DEFINE BAR 05 OF CertificadosDeEstudio PROMPT 'Certificado de estudios'

ON SELECTION BAR 01 OF CertificadosDeEstudio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CertificadoEstudiosPreimpreso')
ON SELECTION BAR 02 OF CertificadosDeEstudio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CertificadoEstudios')
ON SELECTION BAR 04 OF CertificadosDeEstudio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CertificadoEstudiosPorcentual')
ON SELECTION BAR 05 OF CertificadosDeEstudio oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_CertificadoEstudiosGM')

DEFINE POPUP RegistrosFinales MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF RegistrosFinales PROMPT 'Registro final de valoración'

ON SELECTION BAR 01 OF RegistrosFinales oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_RegistroFinalValoracion')

DEFINE POPUP LibrosDeEvaluaciones MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF LibrosDeEvaluaciones PROMPT 'Libro de evaluaciones por grado'
DEFINE BAR 02 OF LibrosDeEvaluaciones PROMPT 'Libro de evaluaciones por grado - mitad de período'
DEFINE BAR 03 OF LibrosDeEvaluaciones PROMPT 'Libro de evaluaciones por grado - semestralizado'
DEFINE BAR 04 OF LibrosDeEvaluaciones PROMPT 'Libro de evaluaciones por asignatura'
DEFINE BAR 05 OF LibrosDeEvaluaciones PROMPT 'Libro de evaluaciones por asignatura - mitad de período'
DEFINE BAR 10 OF LibrosDeEvaluaciones PROMPT '\-'
DEFINE BAR 11 OF LibrosDeEvaluaciones PROMPT 'Libro de dimensiones por grado'
DEFINE BAR 12 OF LibrosDeEvaluaciones PROMPT 'Libro de convivencia por grado'

ON SELECTION BAR 01 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroEvaluacionesPorGrado')
ON SELECTION BAR 02 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroEvaluacionesPorGradoMitadPeriodo')
ON SELECTION BAR 03 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroEvaluacionesPorGradoSemestral')
ON SELECTION BAR 04 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroEvaluacionesPorAsignatura')
ON SELECTION BAR 05 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroEvaluacionesPorAsignaturaMitadPeriodo')
ON SELECTION BAR 11 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroDimensionesPorGrado')
ON SELECTION BAR 12 OF LibrosDeEvaluaciones oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_LibroConvivenciaPorGrado')

DEFINE POPUP AnalisisEstadistico MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF AnalisisEstadistico PROMPT 'Estadística por asignatura'
DEFINE BAR 02 OF AnalisisEstadistico PROMPT 'Estadística por grado'
DEFINE BAR 03 OF AnalisisEstadistico PROMPT 'Estadística por profesor'
DEFINE BAR 04 OF AnalisisEstadistico PROMPT '\-'
DEFINE BAR 05 OF AnalisisEstadistico PROMPT 'Estadística de alumnos reprobados'
DEFINE BAR 06 OF AnalisisEstadistico PROMPT '\-'
DEFINE BAR 07 OF AnalisisEstadistico PROMPT 'Estadística de dimensiones por asignatura'
DEFINE BAR 08 OF AnalisisEstadistico PROMPT 'Estadística de principios de convivencia'
DEFINE BAR 09 OF AnalisisEstadistico PROMPT '\-'
DEFINE BAR 10 OF AnalisisEstadistico PROMPT 'Estadística por frecuencias de valoración'
DEFINE BAR 11 OF AnalisisEstadistico PROMPT '\-'
DEFINE BAR 12 OF AnalisisEstadistico PROMPT 'Estadísticas para el DANE' INVERT PICTURE '..\..\imagenes\bmp\smAppFiles.gif'
DEFINE BAR 13 OF AnalisisEstadistico PROMPT '\-'
DEFINE BAR 14 OF AnalisisEstadistico PROMPT 'Análisis estadístico'

ON SELECTION BAR 01 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorAsignatura')
ON SELECTION BAR 02 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorGrado')
ON SELECTION BAR 03 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorProfesor')
ON SELECTION BAR 05 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaAlumnosReprobados')
ON SELECTION BAR 07 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorDimensiones')
ON SELECTION BAR 08 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorDOFA')
ON SELECTION BAR 10 OF AnalisisEstadistico oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaPorFrecuenciaValoracion')
ON BAR 12 OF AnalisisEstadistico ACTIVATE POPUP EstadisticasDANE
ON SELECTION BAR 14 OF AnalisisEstadistico oAplicacion.EjecutaFormularioRetorno('NOTAS', .T., 'frm_NTA_AnalisisEstadistico')

DEFINE POPUP EstadisticasDANE MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF EstadisticasDANE PROMPT 'Estadística de alumnos año actual'
DEFINE BAR 02 OF EstadisticasDANE PROMPT 'Estadística de alumnos año anterior'
DEFINE BAR 03 OF EstadisticasDANE PROMPT '\-'
DEFINE BAR 04 OF EstadisticasDANE PROMPT 'Estadística de profesores'

ON SELECTION BAR 01 OF EstadisticasDANE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaDANEAlumnosAnoActual')
ON SELECTION BAR 02 OF EstadisticasDANE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaDANEAlumnosAnoAnterior')
ON SELECTION BAR 04 OF EstadisticasDANE oAplicacion.EjecutaFormulario('NOTAS', .T., 'NTA_Inf_EstadisticaDANEProfesores')

DO PopUpInternet
DO PopUpVentana
DO PopUpAyuda

IF	! ISNULL(oAplicacion.oFormLauncher)
	*!* oAplicacion.oFormLauncher.ListBar.Notas.FolderHeader.Click()
	oAplicacion.oFormLauncher.Outlook2003Bar1.SelectedButton = oAplicacion.nMod_Notas
ENDIF
