SELECT 0
USE CTB_TIPODOC ORDER TAG Id
SELECT 0
USE CTB_DIARIO ORDER TAG Id
SELECT 0
USE CTB_DOCUMENTOS ORDER TAG Id
SELECT 0
SELECT 0
USE NTA_MATRICULAS ORDER TAG Id
SELECT 0
USE NTA_ALUMNOS ORDER TAG Id
SELECT 0
USE NTA_CONCEPTOS ORDER TAG Id
SELECT 0
USE curDOCUMENTOS

SCAN 

	SELECT CTB_DOCUMENTOS
	LOCATE FOR CTB_DOCUMENTOS.Id = curDOCUMENTOS.Id
	
	lnIdDeudor = CTB_DOCUMENTOS.IdDeudor
	
	SELECT CTB_DOCUMENTOS.Id AS IdDocumento, ;
			CTB_DOCUMENTOS.SaldoDocumentoCxC AS SaldoFactura, ;
			CTB_DOCUMENTOS.ValorExtemporaneo ;
		FROM CTB_DOCUMENTOS ;
		WHERE CTB_DOCUMENTOS.IdDeudor = lnIdDeudor AND ;
			CTB_DOCUMENTOS.Aplicacion = 2 AND ;
			CTB_DOCUMENTOS.SaldoDocumentoCxC > 0 ;
		INTO CURSOR curFACTURAS NOFILTER

	IF	_TALLY > 0

		lnIdDocumento = curDOCUMENTOS.Id

		SELECT curFACTURAS
		GO TOP
		
		lnPagos = curDOCUMENTOS.Valor

		DO	WHILE ! EOF() AND ;
			lnPagos > 0

			*!* NOTA: Buscar los saldos de la factura incluyendo abonos.
			SELECT CTB_DIARIO.IdMatricula, ;
					IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
					IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
				FROM CTB_DIARIO ;
					INNER JOIN CTB_DOCUMENTOS ;
						ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
					INNER JOIN NTA_MATRICULAS ;
						ON CTB_DIARIO.IdMatricula = NTA_MATRICULAS.Id ;
					INNER JOIN NTA_ALUMNOS ;
						ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
					INNER JOIN NTA_CONCEPTOS ;
						ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
				WHERE CTB_DOCUMENTOS.Id = curFACTURAS.IdDocumento AND ;
					CTB_DIARIO.IdCuenta = 149 AND ;
					CTB_DIARIO.IdConcepto <> 0 AND ;
					CTB_DIARIO.IdDocumentoPadre = 0 ;
				UNION ALL ;
					( SELECT CTB_DIARIO.IdMatricula, ;
							IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
							IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
						FROM CTB_DIARIO ;
							INNER JOIN CTB_DOCUMENTOS ;
								ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
							INNER JOIN CTB_DOCUMENTOS DOCUMENTOSPADRE;
								ON CTB_DIARIO.IdDocumentoPadre = DOCUMENTOSPADRE.Id ;
							INNER JOIN NTA_MATRICULAS ;
								ON CTB_DIARIO.IdMatricula = NTA_MATRICULAS.Id ;
							INNER JOIN NTA_ALUMNOS ;
								ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
							INNER JOIN NTA_CONCEPTOS ;
								ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
						WHERE DOCUMENTOSPADRE.Id = curFACTURAS.IdDocumento AND ;
							CTB_DIARIO.IdCuenta = 149 AND ;
							CTB_DIARIO.IdConcepto <> 0 ) ;
				INTO CURSOR curTEMPORAL1

			IF	_TALLY > 0
			
				SELECT curTEMPORAL1.IdMatricula, ;
						curTEMPORAL1.IdConcepto, ;
						SUM(curTEMPORAL1.Valor) AS Valor ;
					FROM curTEMPORAL1 ;
					GROUP BY 1, 2 ;
					INTO CURSOR curTEMPORAL
				
				IF	_TALLY > 0

					GO TOP
						
					DO	WHILE ! EOF() AND ;
						lnPagos > 0
						
						IF	curTEMPORAL.Valor = 0
							SKIP 
							LOOP
						ENDIF
					
						SELECT CTB_DIARIO
						
						APPEND BLANK
						
						REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
								CTB_DIARIO.IdCuenta WITH 149, ;
								CTB_DIARIO.Imputacion WITH IIF(curTEMPORAL.Valor > 0, 2, 1), ;
								CTB_DIARIO.Valor WITH MIN(lnPagos, ABS(curTEMPORAL.Valor)), ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.IdMatricula WITH curTEMPORAL.IdMatricula, ;
								CTB_DIARIO.IdConcepto WITH curTEMPORAL.IdConcepto, ;
								CTB_DIARIO.IdDocumentoPadre WITH curFACTURAS.IdDocumento, ;
								CTB_DIARIO.TipoMovCar WITH 2 && Rec. Caja

						lnPagos = lnPagos + IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor)

						SELECT CTB_DOCUMENTOS
						IF	SEEK(curFACTURAS.IdDocumento, 'CTB_DOCUMENTOS', 'Id')

							REPLACE CTB_DOCUMENTOS.SaldoDocumentoCxC WITH CTB_DOCUMENTOS.SaldoDocumentoCxC + ;
									IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor)
									
						ENDIF

						SELECT curTEMPORAL
								
						SKIP
								
					ENDDO
				
					IF	lnPagos > 0 AND ;
						curFACTURAS.ValorExtemporaneo > 0
						
						SELECT CTB_DIARIO
						APPEND BLANK
						
						*!* Valor extemporaneo
						REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
								CTB_DIARIO.IdCuenta WITH 99999, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH MIN(lnPagos, curFACTURAS.ValorExtemporaneo), ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3 && Otros pagos
								
						lnPagos = lnPagos - CTB_DIARIO.Valor
						
					ENDIF
					
				ENDIF
				
				USE IN curTEMPORAL
					
			ENDIF
			
			SELECT curFACTURAS
					
			SKIP

		ENDDO

		SELECT CTB_DIARIO

		IF	lnPagos > 0
		
			APPEND BLANK
			
			*!* Anticipos
			REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
					CTB_DIARIO.IdCuenta WITH 99998, ;
					CTB_DIARIO.Imputacion WITH 2, ;
					CTB_DIARIO.Valor WITH lnPagos, ;
					CTB_DIARIO.MovContable WITH .T., ;
					CTB_DIARIO.TipoMovCar WITH 3 && Otros pagos
						
		ENDIF
		
		APPEND BLANK
		
		REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
				CTB_DIARIO.IdCuenta WITH 8, ;
				CTB_DIARIO.Imputacion WITH 1, ;
				CTB_DIARIO.Valor WITH curDOCUMENTOS.Valor, ;
				CTB_DIARIO.MovContable WITH .T., ;
				CTB_DIARIO.IdCuentaBancaria WITH curDOCUMENTOS.IdCuentaBa
	
	
	ELSE

		lnIdDocumento = curDOCUMENTOS.Id

		SELECT CTB_DIARIO
		
		APPEND BLANK
		
		*!* Anticipo
		REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
				CTB_DIARIO.IdCuenta WITH 99998, ;
				CTB_DIARIO.Imputacion WITH 2, ;
				CTB_DIARIO.Valor WITH curDOCUMENTOS.Valor, ;
				CTB_DIARIO.MovContable WITH .T., ;
				CTB_DIARIO.TipoMovCar WITH 3 && Otros pagos
				
		APPEND BLANK

		REPLACE CTB_DIARIO.IdDocumento WITH lnIdDocumento, ;
				CTB_DIARIO.IdCuenta WITH 8, ;
				CTB_DIARIO.Imputacion WITH 1, ;
				CTB_DIARIO.Valor WITH curDOCUMENTOS.Valor, ;
				CTB_DIARIO.MovContable WITH .T., ;
				CTB_DIARIO.IdCuentaBancaria WITH curDOCUMENTOS.IdCuentaBa

	ENDIF
	
	SELECT curDOCUMENTOS
	
	SET MESSAGE TO ALLTRIM(STR(curDOCUMENTOS.Id))
	
ENDSCAN

MESSAGEBOX('Recalcule saldos...')
	
CLOSE TABLES ALL 

RETURN 
