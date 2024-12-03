set step on


SELECT 0
USE NTA_ALUMNOS ORDER TAG Id
SELECT 0
USE NTA_MATRICULAS ORDER TAG Id
SELECT 0
USE CTB_DOCUMENTOS ORDER TAG Id
SELECT 0
USE CTB_DIARIO ORDER TAG Id
SELECT 0
USE CTB_NITS ORDER TAG Id
SELECT 0
USE CTB_TIPODOC ORDER TAG Id
LOCATE FOR CTB_TIPODOC.TipoDoc = 'RC'

IF	FOUND()

	SELECT 0
	USE CTB_CUENTAS ORDER TAG Id
	LOCATE FOR CTB_CUENTAS.Cuenta = '13050501 '

	IF	FOUND()

		lnIdCuentaD = CTB_CUENTAS.Id
		LOCATE FOR CTB_CUENTAS.Cuenta = '27054501 '

		IF	FOUND()

			lnIdCuentaAnt = CTB_CUENTAS.Id
			
			SELECT 0
			USE ? ALIAS ANTICIPOS

			lnDocumento = 1545

			SCAN 
			
				SELECT NTA_ALUMNOS
				LOCATE FOR ALLTRIM(NTA_ALUMNOS.Alumno) = ALLTRIM(ANTICIPOS.Codigo)
				
				IF	! FOUND()
					? 'Alumno no existe ' + ANTICIPOS.Codigo
					SELECT ANTICIPOS
					LOOP
				ENDIF
				
				SELECT NTA_MATRICULAS
				LOCATE FOR ALLTRIM(NTA_MATRICULAS.Referencia) = '2016' AND ;
						NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id
						
				IF	! FOUND()
					? 'Alumno no existe ' + ANTICIPOS.Codigo
					SELECT ANTICIPOS
					LOOP
				ENDIF

				SELECT CTB_NITS
				LOCATE FOR CTB_NITS.Nit = VAL(ALLTRIM(ANTICIPOS.Acudiente))
				
				IF	FOUND()

					SELECT CTB_DOCUMENTOS
					LOCATE FOR CTB_DOCUMENTOS.IdTipoDoc = CTB_TIPODOC.Id AND ;
								CTB_DOCUMENTOS.IdDeudor = CTB_NITS.Id AND ;
								CTB_DOCUMENTOS.Fecha = {^2016.03.08} AND ;
								CTB_DOCUMENTOS.Documento = PADL(lnDocumento, 7, '0')
					IF	FOUND()
					
						lnDocumento = lnDocumento + 1 
							
						SELECT CTB_DIARIO

						IF	ANTICIPOS.C_11 > 0
						
							LOCATE FOR CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id AND ;
										CTB_DIARIO.IdConcepto = 7
										
							IF	FOUND()
								REPLACE CTB_DIARIO.IdMatricula WITH NTA_MATRICULAS.Id
							ENDIF
							
						ENDIF
							
						IF	ANTICIPOS.C_12 > 0

							LOCATE FOR CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id AND ;
										CTB_DIARIO.IdConcepto = 8
										
							IF	FOUND()
								REPLACE CTB_DIARIO.IdMatricula WITH NTA_MATRICULAS.Id
							ENDIF
								
						ENDIF
							
						IF	ANTICIPOS.C_13 > 0
								
							LOCATE FOR CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id AND ;
										CTB_DIARIO.IdConcepto = 9
										
							IF	FOUND()
								REPLACE CTB_DIARIO.IdMatricula WITH NTA_MATRICULAS.Id
							ENDIF
								
						ENDIF
							
						IF	ANTICIPOS.C_14 > 0
								
							LOCATE FOR CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id AND ;
										CTB_DIARIO.IdConcepto = 10
										
							IF	FOUND()
								REPLACE CTB_DIARIO.IdMatricula WITH NTA_MATRICULAS.Id
							ENDIF
								
						ENDIF
							
						IF	ANTICIPOS.C_37 > 0
								
							LOCATE FOR CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id AND ;
										CTB_DIARIO.IdConcepto = 27
										
							IF	FOUND()
								REPLACE CTB_DIARIO.IdMatricula WITH NTA_MATRICULAS.Id
							ENDIF
								
						ENDIF
						
					ELSE 
						? 'Documento no existe ' + ALLTRIM(STR(lnDocumento))
					ENDIF
							
				ELSE
					? 'Acudiente no existe ' + ALLTRIM(ANTICIPOS.Acudiente)
				ENDIF	
				
				SELECT ANTICIPOS	
				
			ENDSCAN
			
		ELSE
			? 'No existe la cuenta de anticipos'
		ENDIF
	ELSE
		? 'No existe la cuenta deudores'
	ENDIF
ELSE
	? 'No existe el tipo documento RC'
ENDIF

CLOSE TABLES ALL
