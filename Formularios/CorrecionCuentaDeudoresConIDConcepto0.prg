LOCAL laValor[1]

SET STEP ON 

SELECT 0
USE CTB_DIARIO

INDEX ON STR(IdDocumento) + ;
		STR(IdDocumentoPadre) + ;
		STR(IdMatricula) + ;
		STR(IdConcepto) ;
	TO DIARIO_TEMP

SET FILTER TO IdCuenta = 149 AND INLIST(IdConcepto, 0, 6)

GO TOP

SELECT CTB_DIARIO.IdDocumento, ;
		CTB_DIARIO.IdDocumentoPadre, ;
		CTB_DIARIO.IdMatricula ;
	FROM CTB_DIARIO ;
	WHERE CTB_DIARIO.IdCuenta = 149 AND ;
		CTB_DIARIO.IdConcepto = 0 AND ;
		CTB_DIARIO.IdDocumentoPadre # 0 ;
	INTO CURSOR curDOCUMENTOS
	
IF	_TALLY > 0

	SCAN

		SELECT SUM(IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor)) AS Valor ;
			FROM CTB_DIARIO ;
			WHERE CTB_DIARIO.IdDocumento = curDOCUMENTOS.IdDocumento AND ;
				CTB_DIARIO.IdDocumentoPadre = curDOCUMENTOS.IdDocumentoPadre AND ;
				CTB_DIARIO.IdMatricula = curDOCUMENTOS.IdMatricula AND ;
				CTB_DIARIO.IdCuenta = 149 AND ;
				CTB_DIARIO.IdConcepto IN (0, 6) ;
			INTO ARRAY laValor
	
		IF	_TALLY > 0

			SELECT CTB_DIARIO
			LOCATE FOR CTB_DIARIO.IdDocumento = curDOCUMENTOS.IdDocumento AND ;
					CTB_DIARIO.IdDocumentoPadre = curDOCUMENTOS.IdDocumentoPadre AND ;
					CTB_DIARIO.IdMatricula = curDOCUMENTOS.IdMatricula

			IF	FOUND()
	
				DO WHILE CTB_DIARIO.IdDocumento = curDOCUMENTOS.IdDocumento AND ;
						CTB_DIARIO.IdDocumentoPadre = curDOCUMENTOS.IdDocumentoPadre AND ;
						CTB_DIARIO.IdMatricula = curDOCUMENTOS.IdMatricula AND ! EOF()
				
					IF	CTB_DIARIO.IdConcepto = 0
						DELETE
					ELSE
						IF	laValor[1] > 0
							REPLACE CTB_DIARIO.Imputacion WITH 1, ;
									CTB_DIARIO.Valor WITH laValor[1]
						ELSE
							REPLACE CTB_DIARIO.Imputacion WITH 2, ;
									CTB_DIARIO.Valor WITH ABS(laValor[1])
						ENDIF
					ENDIF
		
					SKIP
			
				ENDDO
	
			ENDIF
			
		ENDIF
	
		SELECT curDOCUMENTOS
		
		SET MESSAGE TO ALLTRIM(STR(RECNO())) + '/' + ALLTRIM(STR(RECCOUNT()))
	
	ENDSCAN
	
ENDIF

CLOSE TABLES ALL

RETURN
