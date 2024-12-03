LOCAL lnSecuencia, ;
	lnIdCuentaCaja, ;
	lnIdCaja, ;
	lnIdDocumento, ;
	lnIdNit, ;
	lnAbonos

SELECT 0
USE CTB_TIPODOC
LOCATE FOR CTB_TIPODOC.TipoDoc = 'RC '
lnSecuencia = CTB_TIPODOC.Secuencia + 1
SELECT 0
USE CTB_CUENTAS
LOCATE FOR CTB_CUENTAS.Cuenta = '110505 '
lnIdCuentaCaja = CTB_CUENTAS.Id
SELECT 0
USE CXP_CUENTASBANCARIAS
LOCATE FOR CXP_CUENTASBANCARIAS.Cuenta = 'CAJA '
lnIdCaja = CXP_CUENTASBANCARIAS.Id
SELECT 0
USE CTB_DOCUMENTOS ORDER TAG Id
SELECT 0 
USE CTB_DIARIO ORDER TAG Id
SELECT 0
USE ? ALIAS ABONOS

SCAN 

	IF	ABONOS.Saldo_fact < ABONOS.Total_fact
	
		SELECT CTB_DOCUMENTOS
		LOCATE FOR ALLTRIM(CTB_DOCUMENTOS.Documento) = PADL(ALLTRIM(ABONOS.Documento), 7, '0') AND ;
				CTB_DOCUMENTOS.IdTipoDoc = 134
				
		IF	FOUND()
		
			REPLACE CTB_DOCUMENTOS.SaldoDocumentoCXC WITH ABONOS.Saldo_fact

			lnAbonos = CTB_DOCUMENTOS.ValorDocumentoCXC - CTB_DOCUMENTOS.SaldoDocumentoCXC
		
			lnIdDocumento = CTB_DOCUMENTOS.Id
			lnIdNIt = CTB_DOCUMENTOS.IdDeudor
			
			SELECT CTB_DIARIO.*, ;
					NTA_CONCEPTOS.Concepto ;
				FROM CTB_DIARIO ;
					INNER JOIN NTA_CONCEPTOS ;
						ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
				WHERE CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
				ORDER BY NTA_CONCEPTOS.Concepto, CTB_DIARIO.Imputacion ;
				INTO CURSOR curTEMPORAL
				
			IF	_TALLY > 0


				SELECT CTB_DOCUMENTOS
				APPEND BLANK
				REPLACE CTB_DOCUMENTOS.Fecha WITH {^2016.03.08}, ;
						CTB_DOCUMENTOS.IdTipoDoc WITH CTB_TIPODOC.Id, ;
						CTB_DOCUMENTOS.Documento WITH TRANSFORM(lnSecuencia, '@L 9999999'), ;
						CTB_DOCUMENTOS.Detalle WITH 'AJUSTE SALDO INICIAL FACTURA', ;
						CTB_DOCUMENTOS.Aplicacion WITH 2, ;
						CTB_DOCUMENTOS.IdDeudor WITH lnIdNit, ;
						CTB_DOCUMENTOS.TipoRegistro WITH 3, ;
						CTB_DOCUMENTOS.ValorEfectivo WITH lnAbonos
						
				lnSecuencia = lnSecuencia + 1 

				SELECT CTB_DIARIO
				APPEND BLANK
				REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
						CTB_DIARIO.IdCuenta WITH lnIdCuentaCaja, ;
						CTB_DIARIO.Imputacion WITH 1, ;
						CTB_DIARIO.Valor WITH lnAbonos, ;
						CTB_DIARIO.MovContable WITH .T., ;
						CTB_DIARIO.IdCuentaBancaria WITH lnIdCaja

				SELECT curTEMPORAL
				
				SCAN					
					
					SELECT CTB_DIARIO				
					
					IF	curTEMPORAL.Imputacion = 1
					
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH curTEMPORAL.IdCuenta, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH MIN(lnAbonos, curTEMPORAL.Valor), ;
								CTB_DIARIO.IdDocumentoPadre WITH lnIdDocumento, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.IdMatricula WITH curTEMPORAL.IdMatricula, ;
								CTB_DIARIO.IdConcepto WITH curTEMPORAL.IdConcepto, ;
								CTB_DIARIO.TipoMovCar WITH 2
							
						lnAbonos = lnAbonos - MIN(lnAbonos, curTEMPORAL.Valor)
						
					ELSE

						REPLACE CTB_DIARIO.Valor WITH CTB_DIARIO.Valor - curTEMPORAL.Valor
							
						lnAbonos = lnAbonos + curTEMPORAL.Valor
						
					ENDIF
					
					IF	EMPTY(lnAbonos)
						EXIT 
					ENDIF
					
					SELECT curTEMPORAL
						
				ENDSCAN
				
			ELSE

				? 'Diario no existe ' + ABONOS.Documento
			
			ENDIF
			
		ELSE
		
			? 'Documento no existe ' + ABONOS.Documento
		
		ENDIF
	
	ENDIF
	
	SELECT ABONOS
	
ENDSCAN

SELECT CTB_TIPODOC
REPLACE CTB_TIPODOC.Secuencia WITH lnSecuencia - 1

CLOSE TABLES ALL 

RETURN
