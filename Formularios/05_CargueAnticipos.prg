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

			lnDocumento = CTB_TIPODOC.Secuencia + 1

			SCAN 

				SELECT CTB_NITS
				LOCATE FOR CTB_NITS.Nit = VAL(ALLTRIM(ANTICIPOS.Acudiente))
				
				IF	FOUND()

					SELECT CTB_DOCUMENTOS
					APPEND BLANK
					REPLACE CTB_DOCUMENTOS.Fecha WITH {^2016.01.01}, ;
							CTB_DOCUMENTOS.IdTipoDoc WITH CTB_TIPODOC.Id, ;
							CTB_DOCUMENTOS.Documento WITH PADL(lnDocumento, 7, '0'), ;
							CTB_DOCUMENTOS.Detalle WITH 'Anticipo de ' + ALLTRIM(CTB_NITS.Nombre), ;
							CTB_DOCUMENTOS.Aplicacion WITH 2, ;
							CTB_DOCUMENTOS.TipoRegistro WITH 3, ;
							CTB_DOCUMENTOS.IdDeudor WITH CTB_NITS.Id, ;
							CTB_DOCUMENTOS.ValorEfectivo WITH ANTICIPOS.Anticipo, ;
							CTB_DOCUMENTOS.FechaProceso WITH DATETIME(), ;
							CTB_DOCUMENTOS.Transferido WITH .T.
							
					lnDocumento = lnDocumento + 1 
							
					SELECT CTB_DIARIO
					APPEND BLANK
					REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
							CTB_DIARIO.IdCuenta WITH lnIdCuentaD, ;
							CTB_DIARIO.Imputacion WITH 1, ;
							CTB_DIARIO.Valor WITH ANTICIPOS.Anticipo, ;
							CTB_DIARIO.MovContable WITH .T., ;
							CTB_DIARIO.IdCuentaBancaria WITH 1
								
					IF	ANTICIPOS.C_11 > 0
							
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH lnIdCuentaAnt, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH ANTICIPOS.C_11 * ANTICIPOS.N_11, ;
								CTB_DIARIO.IdConcepto WITH 7, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3
								
					ENDIF
							
					IF	ANTICIPOS.C_12 > 0
							
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH lnIdCuentaAnt, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH ANTICIPOS.C_12 * ANTICIPOS.N_12, ;
								CTB_DIARIO.IdConcepto WITH 8, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3
								
					ENDIF
							
					IF	ANTICIPOS.C_13 > 0
							
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH lnIdCuentaAnt, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH ANTICIPOS.C_13 * ANTICIPOS.N_13, ;
								CTB_DIARIO.IdConcepto WITH 9, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3
								
					ENDIF
							
					IF	ANTICIPOS.C_14 > 0
							
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH lnIdCuentaAnt, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH ANTICIPOS.C_14 * ANTICIPOS.N_14, ;
								CTB_DIARIO.IdConcepto WITH 10, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3
								
					ENDIF
							
					IF	ANTICIPOS.C_37 > 0
							
						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.IdCuenta WITH lnIdCuentaAnt, ;
								CTB_DIARIO.Imputacion WITH 2, ;
								CTB_DIARIO.Valor WITH ANTICIPOS.C_37 * ANTICIPOS.N_37, ;
								CTB_DIARIO.IdConcepto WITH 27, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.TipoMovCar WITH 3
								
					ENDIF
							
				ELSE
					? 'Acudiente no existe ' + ALLTRIM(ANTICIPOS.Acudiente)
				ENDIF	
				
				SELECT ANTICIPOS	
				
			ENDSCAN
			
			SELECT CTB_TIPODOC
			REPLACE CTB_TIPODOC.Secuencia WITH lnDocumento
			
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