*!* APLICA PARA EL GIMNASIO INFANTIL LAS VILLAS

LOCAL lnPeriodo

MESSAGEBOX('Haga clic para iniciar el proceso.')

DO WHILE .T.

	lnPeriodo = VAL(INPUTBOX('Período a exportar:', 'EXPORTAR NOTAS', '0', 0, '0', '0'))

	IF	INLIST(lnPeriodo, 0, 1, 2, 3, 4, 11, 21, 31, 41)
		EXIT
	ENDIF
	
ENDDO

CREATE TABLE ..\Notas FREE ( ;
	IdPensum N(11, 0), ;
	IdMatricul N(11, 0), ;
	Periodo N(2, 0), ;
	Eval N(2, 0), ;
	EvAlf C(2), ;
	Texto M, ;
	Texto2 M)

SELECT 0
USE NTA_ALUMNOS
COPY TO ..\Alumnos ;
	TYPE FOXPLUS
USE NTA_ASIGNATURAS
COPY TO ..\Asignaturas ;
	TYPE FOXPLUS
USE NTA_ASIGNATURASXGRADO
COPY TO ..\AsignaturasXGrado ;
	FOR Referencia = oAplicacion.cReferenciaEmp ;
	TYPE FOXPLUS 
*!* USE NTA_ALUMNOSXASIGNATURA
*!* COPY TO ..\AlumnosXAsignatura TYPE FOXPLUS 
USE NTA_GRADOS
COPY TO ..\Grados ;
	TYPE FOXPLUS 
USE NTA_LOGROS
COPY TO ..\Logros ;
	FOR Referencia = oAplicacion.cReferenciaEmp AND ;
		Periodo = lnPeriodo AND ;
		TipoRegistro = 4 ;
	TYPE FOXPLUS 
USE NTA_MATRICULAS
COPY TO ..\Matriculas ;
	FOR Referencia = oAplicacion.cReferenciaEmp AND ;
		EstadoAlumno = 0 ;
	TYPE FOXPLUS 
USE CTB_NITS
COPY TO ..\Profesores ;
	FOR EsEmpleado ;
	TYPE FOXPLUS 
USE

IF	lnPeriodo > 0

	SELECT NTA_ASIGNATURASXGRADO.Id AS IdPensum, ;
			NTA_MATRICULAS.Id AS IdMatricula, ;
			NTA_LOGROS.Secuencia, ;
			NTA_LOGROS.Texto, ;
			NTA_LOGROS.Texto2 ;
		FROM NTA_LOGROS ;
			INNER JOIN NTA_ASIGNATURASXGRADO ;
				ON NTA_LOGROS.Referencia = NTA_ASIGNATURASXGRADO.Referencia AND ;
					NTA_LOGROS.IdGrado = NTA_ASIGNATURASXGRADO.IdGrado AND ;
					NTA_LOGROS.IdAsignatura = NTA_ASIGNATURASXGRADO.IdAsignatura ;
			RIGHT JOIN NTA_MATRICULAS ;
				ON NTA_ASIGNATURASXGRADO.Referencia = NTA_MATRICULAS.Referencia AND ;
					NTA_ASIGNATURASXGRADO.IdGrado = NTA_MATRICULAS.IdGrado AND ;
					NTA_ASIGNATURASXGRADO.Curso = NTA_MATRICULAS.Curso ;
		WHERE NTA_LOGROS.Referencia = oAplicacion.cReferenciaEmp AND ;
			NTA_LOGROS.Periodo = lnPeriodo AND ;
			NTA_LOGROS.TipoRegistro = 4 ;
		ORDER BY IdPensum, IdMatricula, Secuencia ;
		INTO CURSOR curLOGROS
			
	IF	_TALLY > 0

		SCAN
		
		 	SELECT NTA_EVALUACIONES.IdPensum, ;
					NTA_EVALUACIONES.IdMatricula, ;
					NTA_EVALUACIONES.Periodo, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica1, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica2, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica3, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica4, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica5, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica6, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica7, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica8, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica9, ;
					NTA_EVALUACIONES.EvaluacionAlfabetica10 ;
				FROM NTA_EVALUACIONES ;
				WHERE NTA_EVALUACIONES.IdPensum = curLOGROS.IdPensum AND ;
					NTA_EVALUACIONES.IdMatricula = curLOGROS.IdMatricula AND ;
					NTA_EVALUACIONES.Periodo = lnPeriodo ;
				INTO CURSOR curEVAL
				
			IF	_TALLY > 0
			
				lcCount = ALLTRIM(STR(VAL(curLOGROS.Secuencia)))
			
				SELECT Notas
				APPEND BLANK
				REPLACE Notas.IdPensum WITH curEVAL.IdPensum, ;
						Notas.IdMatricul WITH curEVAL.IdMatricula, ;
						Notas.Periodo WITH curEVAL.Periodo, ;
						Notas.Eval WITH VAL(curLOGROS.Secuencia), ;
						Notas.EvAlf WITH curEVAL.EvaluacionAlfabetica&lcCount, ;
						Notas.Texto WITH curLOGROS.Texto, ;
						Notas.Texto2 WITH curLOGROS.Texto2
						
			ELSE

				lcCount = ALLTRIM(STR(VAL(curLOGROS.Secuencia)))
			
				SELECT Notas
				APPEND BLANK
				REPLACE Notas.IdPensum WITH curLOGROS.IdPensum, ;
						Notas.IdMatricul WITH curLOGROS.IdMatricula, ;
						Notas.Periodo WITH lnPeriodo, ;
						Notas.Eval WITH VAL(curLOGROS.Secuencia), ;
						Notas.EvAlf WITH '  ', ;
						Notas.Texto WITH curLOGROS.Texto, ;
						Notas.Texto2 WITH curLOGROS.Texto2
							
			ENDIF

			SELECT curLOGROS
	
		ENDSCAN	
	
	ENDIF
	
ENDIF

CLOSE TABLES ALL 

MESSAGEBOX('Archivos generados correctamente.')

RETURN
