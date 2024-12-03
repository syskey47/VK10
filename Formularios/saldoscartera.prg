LOCAL ldFecha, ;
	lnIdDoc

SELECT 0
CREATE CURSOR curCONT ( ;
	TipoComprobante C(1), ;
	CodigoComprobante C(3), ;
	Documento C(11), ;
	Secuencia C(5), ;
	Nit C(13), ;
	Sucursal C(3), ;
	Cuenta C(10), ;
	Producto C(13), ;
	Fecha C(8), ;
	Centro C(4), ;
	Subcentro C(3), ;
	Detalle C(50), ;
	Imputacion C(1), ;
	Valor C(15), ;
	Monto C(15), ;
	Vendedor C(4), ;
	Ciudad C(4), ;
	Zona C(3), ;
	Bodega C(4), ;
	Ubicacion c(3), ;
	Cantidad C(15), ;
	TipoDocumentoCruce C(1), ;
	CodigoComprobanteCruce C(3), ;
	DocumentoCruce C(11), ;
	SecuenciaCruce C(3), ;
	FechaDocumentoCruce C(8), ;
	FormaPago C(4), ;
	Banco C(2))

SELECT 0
CREATE CURSOR curTRASLADO ( ;
	IdDocumento I, ;
	Documento C(10), ;
	IdDeudor I, ;
	Nit N(13, 0), ;
	IdConcepto I, ;
	Cuenta C(10), ;
	Centro C(5), ;
	NombreConcepto C(40), ;
	Valor Y)

SELECT 0
USE CTB_TIPODOC
LOCATE FOR CTB_TIPODOC.TipoDoc = 'FAC'

SELECT 0
USE NTA_CONCEPTOS ORDER TAG Id
SELECT 0
USE CTB_CUENTAS
SELECT 0
USE CTB_NITS ORDER TAG Id
SELECT 0
USE CTB_DIARIO ORDER TAG Documento
SELECT 0
USE CTB_DOCUMENTOS ORDER TAG Id

ldFecha = {^2015.12.31}

SCAN 

	IF	CTB_DOCUMENTOS.SaldoDocumentoCXC > 0 AND ;
		CTB_DOCUMENTOS.IdTipoDoc = CTB_TIPODOC.Id
		
		lnIdDoc = CTB_DOCUMENTOS.Id
		
		SELECT CTB_DIARIO.IdMatricula, ;
				CTB_NITS.Nit, ;
				IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
				NTA_CONCEPTOS.CuentaDeudores AS Cuenta, ;
				NTA_CONCEPTOS.CentroDeudores AS Centro, ;
				NTA_CONCEPTOS.Nombre AS NombreConcepto, ;
				NTA_CONCEPTOS.Aplica, ;
				IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
			FROM CTB_DIARIO ;
				INNER JOIN CTB_DOCUMENTOS ;
					ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
				INNER JOIN CTB_NITS ;
					ON CTB_DOCUMENTOS.IdDeudor = CTB_NITS.Id ;
				INNER JOIN NTA_CONCEPTOS ;
					ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
			WHERE CTB_DOCUMENTOS.Id = lnIdDoc AND ;
				CTB_DIARIO.IdCuenta = oEMPRESA.IdDeudores AND ;
				CTB_DIARIO.IdConcepto <> 0 AND ;
				CTB_DIARIO.IdDocumentoPadre = 0 ;
			UNION ALL ;
				( SELECT CTB_DIARIO.IdMatricula, ;
						CTB_NITS.Nit, ;
						IIF(EMPTY(NTA_CONCEPTOS.IdConceptoPadre), CTB_DIARIO.IdConcepto, NTA_CONCEPTOS.IdConceptoPadre) AS IdConcepto, ;
						NTA_CONCEPTOS.CuentaDeudores AS Cuenta, ;
						NTA_CONCEPTOS.CentroDeudores AS Centro, ;
						NTA_CONCEPTOS.Nombre AS NombreConcepto, ;
						NTA_CONCEPTOS.Aplica, ;
						IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
					FROM CTB_DIARIO ;
						INNER JOIN CTB_DOCUMENTOS ;
							ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
						INNER JOIN CTB_DOCUMENTOS DOCUMENTOSPADRE;
							ON CTB_DIARIO.IdDocumentoPadre = DOCUMENTOSPADRE.Id ;
						INNER JOIN CTB_NITS ;
							ON DOCUMENTOSPADRE.IdDeudor = CTB_NITS.Id ;
						INNER JOIN NTA_CONCEPTOS ;
							ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ;
					WHERE DOCUMENTOSPADRE.Id = lnIdDoc AND ;
						CTB_DIARIO.IdCuenta = oEMPRESA.IdDeudores AND ;
						CTB_DIARIO.IdConcepto <> 0 ) ;
			INTO CURSOR curTEMPORAL1

		IF	_TALLY > 0

			SELECT curTEMPORAL1.IdMatricula, ;
					curTEMPORAL1.Nit, ;
					curTEMPORAL1.IdConcepto, ;
					curTEMPORAL1.Cuenta, ;
					curTEMPORAL1.Centro, ;
					curTEMPORAL1.NombreConcepto, ;
					curTEMPORAL1.Aplica, ;
					SUM(curTEMPORAL1.Valor) AS Valor ;
				FROM curTEMPORAL1 ;
				GROUP BY 2, 3 ;
				INTO CURSOR curTEMPORAL
				
			IF	_TALLY > 0
			
				SCAN FOR curTEMPORAL.Valor <> 0
				
					SELECT NTA_CONCEPTOS
					
					SELECT curTRASLADO
					APPEND BLANK
					REPLACE curTRASLADO.IdDocumento WITH lnIdDoc, ;
							curTRASLADO.Documento WITH CTB_DOCUMENTOS.Documento, ;
							curTRASLADO.IdDeudor WITH CTB_DOCUMENTOS.IdDeudor, ;
							curTRASLADO.Nit WITH curTEMPORAL.Nit, ;
							curTRASLADO.IdConcepto WITH curTEMPORAL.IdConcepto, ;
							curTRASLADO.Cuenta WITH curTEMPORAL.Cuenta, ;
							curTRASLADO.NombreConcepto WITH curTEMPORAL.NombreConcepto, ;
							curTRASLADO.Valor WITH curTEMPORAL.Valor
				
					SELECT curTEMPORAL

				ENDSCAN
				
			ENDIF
			
		ENDIF 
		
	ENDIF 
		
	SELECT CTB_DOCUMENTOS
		
	SET MESSAGE TO REPLICATE('|', RECNO() / RECCOUNT() * 100) + ALLTRIM(STR(RECNO() / RECCOUNT() * 100)) + '%'

ENDSCAN

SELECT curTRASLADO
BROWSE 

SELECT SUM(curTRASLADO.Valor) FROM curTRASLADO

SELECT curTRASLADO

lnSecuencia = 1

SCAN

	SELECT curCONT
	APPEND BLANK
	REPLACE curCONT.TipoComprobante WITH 'A', ;
			curCONT.CodigoComprobante WITH '001', ;
			curCONT.Documento WITH TRANSFORM(201601, '@L 99999999999'), ;
			curCONT.Secuencia WITH TRANSFORM(lnSecuencia, '@L 99999'), ;
			curCONT.Nit WITH TRANSFORM(curTRASLADO.Nit, '@L 9999999999999'), ;
			curCONT.Sucursal WITH '000', ;
			curCONT.Cuenta WITH PADR('13050501', 10, '0'), ;
			curCONT.Producto WITH REPLICATE('0', 13), ;
			curCONT.Fecha WITH DTOS(ldFecha), ;
			curCONT.Centro WITH LEFT(curTRASLADO.Centro, 4), ;
			curCONT.Subcentro WITH REPLICATE('0', 3), ;
			curCONT.Detalle WITH PADR(curTRASLADO.NombreConcepto, 50), ;
			curCONT.Imputacion WITH IIF(curTRASLADO.Valor > 0, 'D', 'C'), ;
			curCONT.Valor WITH TRANSFORM(ABS(curTRASLADO.Valor) * 100, '@L 999999999999999'), ;
			curCONT.Monto WITH REPLICATE('0', 15), ;
			curCONT.Vendedor WITH '0001', ;
			curCONT.Ciudad WITH '0001', ;
			curCONT.Zona WITH REPLICATE('0', 3), ;
			curCONT.Bodega WITH REPLICATE('0', 4), ;
			curCONT.Ubicacion WITH REPLICATE('0', 3), ;
			curCONT.Cantidad WITH REPLICATE('0', 15), ;
			curCONT.TipoDocumentoCruce WITH SPACE(1), ;
			curCONT.CodigoComprobanteCruce WITH SPACE(3), ;
			curCONT.DocumentoCruce WITH REPLICATE('0', 11), ;
			curCONT.SecuenciaCruce WITH REPLICATE('0', 3), ;
			curCONT.FechaDocumentoCruce WITH REPLICATE('0', 8), ;
			curCONT.FormaPago WITH REPLICATE('0', 4), ;
			curCONT.Banco WITH REPLICATE('0', 2)

	APPEND BLANK
	REPLACE curCONT.TipoComprobante WITH 'L', ;
			curCONT.CodigoComprobante WITH '001', ;
			curCONT.Documento WITH TRANSFORM(VAL(curTRASLADO.Documento), '@L 99999999999'), ;
			curCONT.Secuencia WITH TRANSFORM(lnSecuencia + 1, '@L 99999'), ;
			curCONT.Nit WITH TRANSFORM(curTRASLADO.Nit, '@L 9999999999999'), ;
			curCONT.Sucursal WITH '000', ;
			curCONT.Cuenta WITH PADR(curTRASLADO.Cuenta, 10, '0'), ;
			curCONT.Producto WITH REPLICATE('0', 13), ;
			curCONT.Fecha WITH DTOS(ldFecha), ;
			curCONT.Centro WITH LEFT(curTRASLADO.Centro, 4), ;
			curCONT.Subcentro WITH REPLICATE('0', 3), ;
			curCONT.Detalle WITH PADR(curTRASLADO.NombreConcepto, 50), ;
			curCONT.Imputacion WITH IIF(curTRASLADO.Valor > 0, 'C', 'D'), ;
			curCONT.Valor WITH TRANSFORM(ABS(curTRASLADO.Valor) * 100, '@L 999999999999999'), ;
			curCONT.Monto WITH REPLICATE('0', 15), ;
			curCONT.Vendedor WITH '0001', ;
			curCONT.Ciudad WITH '0001', ;
			curCONT.Zona WITH REPLICATE('0', 3), ;
			curCONT.Bodega WITH REPLICATE('0', 4), ;
			curCONT.Ubicacion WITH REPLICATE('0', 3), ;
			curCONT.Cantidad WITH REPLICATE('0', 15), ;
			curCONT.TipoDocumentoCruce WITH SPACE(1), ;
			curCONT.CodigoComprobanteCruce WITH SPACE(3), ;
			curCONT.DocumentoCruce WITH REPLICATE('0', 11), ;
			curCONT.SecuenciaCruce WITH REPLICATE('0', 3), ;
			curCONT.FechaDocumentoCruce WITH REPLICATE('0', 8), ;
			curCONT.FormaPago WITH REPLICATE('0', 4), ;
			curCONT.Banco WITH REPLICATE('0', 2)
			
	SELECT curTRASLADO
	
	lnSecuencia = lnSecuencia + 2

	SET MESSAGE TO REPLICATE('|', RECNO() / RECCOUNT() * 100) + ALLTRIM(STR(RECNO() / RECCOUNT() * 100)) + '%'		
	
ENDSCAN 

SELECT curCONT
GO TOP
COPY TO InterfaceSIIGO TYPE SDF
BROWSE
CLOSE TABLES ALL 
