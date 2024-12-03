LOCAL lnIdTipoDocFac, ;
	lnSecuenciaFac, ;
	lcPrefijoFac, ;
	lnDecimalesFac,;
	lnIdTipoDocNC, ;
	lnSecuenciaNC, ;
	lcPrefijoNC, ;
	lnDecimalesNC, ;
	lnIdConcepto, ;
	lnIdCuentaCC, ;
	lnIdCuentaDb, ;
	lnIdCuentaCr, ;
	ldFecha, ;
	loRegDoc, ;
	loRegDiario, ;
	lnRegDoc, ;
	lnRegDiario, ;
	lnTotalDoc

SELECT 0
USE NTA_MATRICULAS ORDER TAG Id

SELECT 0
USE NTA_ALUMNOS ORDER TAG Id

*!* CREAR CC TIPO VENTAS NUM. AUTOMATICA
 
SELECT 0
USE CTB_TIPODOC
LOCATE FOR CTB_TIPODOC.TipoDoc = 'CC'
lnIdTipoDocFac = CTB_TIPODOC.Id
lnSecuenciaFac = CTB_TIPODOC.Secuencia
lcPrefijoFac = CTB_TIPODOC.Prefijo
lnDecimalesFac = CTB_TIPODOC.Decimales
LOCATE FOR CTB_TIPODOC.TipoDoc = 'NC'
lnIdTipoDocNC = CTB_TIPODOC.Id
lnSecuenciaNC = CTB_TIPODOC.Secuencia
lcPrefijoNC = CTB_TIPODOC.Prefijo
lnDecimalesNC = CTB_TIPODOC.Decimales

SELECT 0
USE NTA_CONCEPTOS ORDER TAG Id

*!* CREAR ESTAS CUENTAS

SELECT 0
USE CTB_CUENTAS
LOCATE FOR CTB_CUENTAS.Cuenta = '5199100000'
lnIdCuentaNC = CTB_CUENTAS.Id
LOCATE FOR CTB_CUENTAS.Cuenta = '8105050000'
lnIdCuentaDb = CTB_CUENTAS.Id
LOCATE FOR CTB_CUENTAS.Cuenta = '8305050000'
lnIdCuentaCr = CTB_CUENTAS.Id

SELECT 0
USE CTB_DIARIO ORDER TAG Documento
SELECT 0
USE CTB_DOCUMENTOS ORDER TAG Id

ldFecha = {^2015.11.30}

SCAN 

	IF	BETWEEN(CTB_DOCUMENTOS.Fecha, {^1999.01.01}, {^2013.11.30}) AND ! EMPTY(CTB_DOCUMENTOS.IdTipoDoc)
	
		IF	CTB_DOCUMENTOS.SaldoDocumentoCXC > 0
		
			SCATTER NAME loRegDoc

			lnRegDoc = RECNO()

			*!* Se genera NC cancelando la FAC
			lnSecuenciaNC = lnSecuenciaNC + 1 
					
			APPEND BLANK
			REPLACE CTB_DOCUMENTOS.Fecha WITH ldFecha, ;
					CTB_DOCUMENTOS.IdTipoDoc WITH lnIdTipoDocNC, ;
					CTB_DOCUMENTOS.Documento WITH ALLTRIM(lcPrefijoNC) + TRANSFORM(lnSecuenciaNC, '@L ' + REPLICATE('9', lnDecimalesNC)), ;
					CTB_DOCUMENTOS.Detalle WITH 'CARTERA CASTIGADA', ;
					CTB_DOCUMENTOS.Aplicacion WITH 2, ;
					CTB_DOCUMENTOS.IdDeudor WITH loRegDoc.IdDeudor, ;
					CTB_DOCUMENTOS.TipoRegistro WITH 4

			SELECT CTB_DIARIO.IdMatricula, ;
					IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
					NTA_CONCEPTOS.Aplica, ;
					IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
				FROM CTB_DIARIO ;
					INNER JOIN CTB_DOCUMENTOS ;
						ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
					INNER JOIN NTA_CONCEPTOS ;
						ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
				WHERE CTB_DOCUMENTOS.Id = loRegDoc.Id AND ;
					CTB_DIARIO.IdCuenta = oEMPRESA.IdDeudores AND ;
					CTB_DIARIO.IdConcepto # 0 AND ;
					CTB_DIARIO.IdDocumentoPadre = 0 ;
				UNION ALL ;
					( SELECT CTB_DIARIO.IdMatricula, ;
							IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
							NTA_CONCEPTOS.Aplica, ;
							IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
						FROM CTB_DIARIO ;
							INNER JOIN CTB_DOCUMENTOS ;
								ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
							INNER JOIN CTB_DOCUMENTOS DOCUMENTOSPADRE;
								ON CTB_DIARIO.IdDocumentoPadre = DOCUMENTOSPADRE.Id ;
							INNER JOIN NTA_CONCEPTOS ;
								ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
						WHERE DOCUMENTOSPADRE.Id = loRegDoc.Id AND ;
							CTB_DIARIO.IdCuenta = oEMPRESA.IdDeudores AND ;
							CTB_DIARIO.IdConcepto # 0 ) ;
				INTO CURSOR curTEMPORAL1

			IF	_TALLY > 0
			
				SELECT curTEMPORAL1.IdMatricula, ;
						curTEMPORAL1.IdConcepto, ;
						curTEMPORAL1.Aplica, ;
						SUM(curTEMPORAL1.Valor) AS Valor ;
					FROM curTEMPORAL1 ;
					GROUP BY 1, 2 ;
					INTO CURSOR curTEMPORAL
					
				IF	_TALLY > 0
						
					lnTotalDoc = 0

					SCAN FOR curTEMPORAL.Valor <> 0
					
						SELECT CTB_DIARIO

						APPEND BLANK
						REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
								CTB_DIARIO.MovContable WITH .T., ;
								CTB_DIARIO.IdCuenta WITH oEmpresa.IdDeudores, ;
								CTB_DIARIO.Imputacion WITH IIF(curTEMPORAL.Valor > 0, 2, 1), ;
								CTB_DIARIO.Valor WITH ABS(curTEMPORAL.Valor), ;
								CTB_DIARIO.IdMatricula WITH curTEMPORAL.IdMatricula, ;
								CTB_DIARIO.IdConcepto WITH curTEMPORAL.IdConcepto, ;
								CTB_DIARIO.IdDocumentoPadre WITH loRegDoc.Id, ;
								CTB_DIARIO.TipoMovCar WITH 2 && Rec. Caja
								
						SELECT curTEMPORAL
						
						lnTotalDoc = lnTotalDoc + IIF(CTB_DIARIO.Imputacion = 2, CTB_DIARIO.Valor, -CTB_DIARIO.Valor)
						
					ENDSCAN
					
					SELECT CTB_DIARIO

					APPEND BLANK
					REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
							CTB_DIARIO.MovContable WITH .T., ;
							CTB_DIARIO.IdCuenta WITH lnIdCuentaNC, ;
							CTB_DIARIO.Imputacion WITH 1, ;
							CTB_DIARIO.Valor WITH lnTotalDoc, ;
							CTB_DIARIO.TipoMovCar WITH 4
							
					SELECT CTB_DOCUMENTOS
					GO lnRegDoc
					REPLACE CTB_DOCUMENTOS.SaldoDocumentoCXC WITH 0

					*!* Se genera una nueva FAC en cuentas de orden
					lnSecuenciaFAC = lnSecuenciaFAC + 1 
							
					APPEND BLANK
					REPLACE CTB_DOCUMENTOS.Fecha WITH ldFecha, ;
							CTB_DOCUMENTOS.IdTipoDoc WITH lnIdTipoDocFac, ;
							CTB_DOCUMENTOS.Documento WITH ALLTRIM(lcPrefijoFac) + TRANSFORM(lnSecuenciaFac, '@L ' + REPLICATE('9', lnDecimalesFac)), ;
							CTB_DOCUMENTOS.Detalle WITH loRegDoc.Detalle, ;
							CTB_DOCUMENTOS.Aplicacion WITH loRegDoc.Aplicacion, ;
							CTB_DOCUMENTOS.IdDeudor WITH loRegDoc.IdDeudor, ;
							CTB_DOCUMENTOS.TipoRegistro WITH loRegDoc.TipoRegistro, ;
							CTB_DOCUMENTOS.FechaVcto WITH loRegDoc.FechaVcto, ;
							CTB_DOCUMENTOS.PorcentajeMora WITH loRegDoc.PorcentajeMora, ;
							CTB_DOCUMENTOS.ValorDocumentoCXC WITH loRegDoc.SaldoDocumentoCXC, ;
							CTB_DOCUMENTOS.SaldoDocumentoCXC WITH loRegDoc.SaldoDocumentoCXC
							
					SELECT CTB_DIARIO
					APPEND BLANK
					REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
							CTB_DIARIO.MovContable WITH .T., ;
							CTB_DIARIO.IdCuenta WITH lnIdCuentaDb, ;
							CTB_DIARIO.Imputacion WITH 1, ;
							CTB_DIARIO.Valor WITH lnTotalDoc, ;
							CTB_DIARIO.TipoMovCar WITH 2 && Rec. Caja
					
					APPEND BLANK
					REPLACE CTB_DIARIO.IdDocumento WITH CTB_DOCUMENTOS.Id, ;
							CTB_DIARIO.MovContable WITH .T., ;
							CTB_DIARIO.IdCuenta WITH lnIdCuentaCr, ;
							CTB_DIARIO.Imputacion WITH 2, ;
							CTB_DIARIO.Valor WITH lnTotalDoc

					SELECT CTB_DOCUMENTOS
					GO lnRegDoc
					
				ENDIF
				
			ELSE
			
				SET STEP ON 
				
			ENDIF 
			
		ELSE 
		
			REPLACE CTB_DOCUMENTOS.Transferido WITH .T. ;
			
		ENDIF 
		
	ENDIF
	
	SET MESSAGE TO REPLICATE('|', RECNO() / RECCOUNT() * 100) + ALLTRIM(STR(RECNO() / RECCOUNT() * 100)) + '%'

ENDSCAN		

SELECT CTB_TIPODOC
LOCATE FOR CTB_TIPODOC.TipoDoc = 'CC'
REPLACE CTB_TIPODOC.Secuencia WITH lnSecuenciaFac

LOCATE FOR CTB_TIPODOC.TipoDoc = 'NC'
REPLACE CTB_TIPODOC.Secuencia WITH lnSecuenciaNC
		
CLOSE TABLES ALL 
