   �   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              %ORIENTATION=0
PAPERSIZE=1
COLOR=1
00D
OUTPUT=192.168      YTop = 0
Left = 0
Width = 0
Height = 0
DataSource = .NULL.
Name = "Dataenvironment"
                                     dataenvironment                                               Tahoma                                                        Tahoma                                                        Tahoma                                                        Grado                                                         Curso                                                         Alumno                                                        Left(Asignatura, 2)                                           "NOTAS SOBRE EVALUACI�N"                                      Tahoma                                                        NombreEmpresa                                                                                                               Tahoma                                                        _pageno                                                       "9999"                                                                                                                      Tahoma                                                        	"p�gina:"                                                     Tahoma                                                        
DATETIME()                                                                                                                  Tahoma                                                        "FECHA:"                                                      Tahoma                                                        '(' + CodigoUsuario + ')'                                                                                                   Tahoma                                                        NombreAlumno                                                                                                                Tahoma                                                        NombreAsignatura                                                                                                            Tahoma                                                        NombreProfesor                                                                                                              Tahoma                                                        
NombreArea                                                                                                                  Tahoma                                                        "ALLTRIM(NombreGrado) + ' ' + Curso                                                                                          Tahoma                                                        IntensidadHorariaSemanal                                      "999"                                                                                                                       Tahoma                                                        "�REA / PROFESOR"                                             Tahoma                                                        "I.H.S."                                                      Tahoma                                                        	"PER�ODO"                                                     Tahoma                                                        "VALORACI�N DEFINITIVA"                                       Tahoma                                                        
Referencia                                                                                                                  Tahoma                                                        "REFERENCIA:"                                                 Tahoma                                                        oEMPRESA.Logotipo                                                                                                           FILE(oEMPRESA.Logotipo)                                       "-01-"                                                        Tahoma                                                        "-02-"                                                        Tahoma                                                        "-03-"                                                        Tahoma                                                        "-04-"                                                        Tahoma                                                        "-05-"                                                        Tahoma                                                        "-06-"                                                        Tahoma                                                        "-07-"                                                        Tahoma                                                        "-08-"                                                        Tahoma                                                        "-09-"                                                        Tahoma                                                        "-10-"                                                        Tahoma                                                        DetalleIndicador                                              Tahoma                                                        DefinitivaNumerica                                            	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica1                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica2                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica3                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica4                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica5                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica6                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica7                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica8                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica9                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica10                                          	"@Z 99.9"                                                                                                                   Tahoma                                                        -"RENDIMIENTO POR DIMENSIONES DEL PENSAMIENTO"                 Tahoma                                                        oEmpresa.Actividad                                                                                                          Tahoma                                                        DetalleAlfabetico                                                                                                           Tahoma                                                        EvaluacionNumerica1                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica2                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica3                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica4                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica5                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica6                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica7                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica8                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica9                                           	"@Z 99.9"                                                                                                                   Tahoma                                                        EvaluacionNumerica10                                          	"@Z 99.9"                                                                                                                   Tahoma                                                        "P R O M E D I O S"                                           Tahoma                                                        DefinitivaNumerica                                            	"@Z 99.9"                                                                                                                   Tahoma                                                        QIIF(TipoGrado = 1, 'Primer semestre', IIF(TipoGrado = 2, 'Segundo semestre', ''))                                                                                                           Tahoma                                                        [IIF(BETWEEN(Periodo, 21, 41), 'I-' + LEFT(ALLTRIM(STR(Periodo)), 1), ALLTRIM(STR(Periodo)))                                                                                                 Tahoma                                                        �IIF(Periodo = 1, ObservacionesPeriodo1, IIF(Periodo = 2, ObservacionesPeriodo2, IIF(Periodo = 3, ObservacionesPeriodo3, IIF(Periodo = 4, ObservacionesPeriodo4, IIF(Periodo = 5, ObservacionesPeriodo5, '')))))                                               Tahoma                                                        8"OBSERVACIONES Y RECOMENDACIONES DEL DIRECTOR DE GRUPO:"      Tahoma                                                        �! EMPTY(ObservacionesPeriodo1) OR ! EMPTY(ObservacionesPeriodo2) OR ! EMPTY(ObservacionesPeriodo3) OR ! EMPTY(ObservacionesPeriodo4) OR ! EMPTY(ObservacionesPeriodo5)                        {IIF(! EMPTY(Asignaturas), 'ASIGNATURAS DE A�OS ANTERIORES PENDIENTES POR RECUPERAR:' + CHR(13) + CHR(10) + Asignaturas, '')                                                                   Tahoma                                                        NombreEmpresa                                                 oAplicacion.cEmpresa                                          oAplicacion.cEmpresa                                          ReferenciaEmpresa                                             oAplicacion.cReferenciaEmp                                    oAplicacion.cReferenciaEmp                                    CodigoEmpresa                                                 oAplicacion.cCodEmpresa                                       oAplicacion.cCodEmpresa                                       DirectorioDatos                                               oAplicacion.cDirDatos                                         oAplicacion.cDirDatos                                         CodigoUsuario                                                 oAplicacion.cUsuario                                          oAplicacion.cUsuario                                          Tahoma                                                        Tahoma                                                        Tahoma                                                        Tahoma                                                        Tahoma                                                        Tahoma                                                        Tahoma                                                  