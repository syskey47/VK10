CREATE CURSOR curCONCEPTOS ;
(Acudiente B, ;
NombreAcudiente C(40), ;
Concepto C(5), ;
NombreConcepto C(40), ;
Valor Y)

lcWhere = 'CTB_DOCUMENTOS.Fecha <= DATE() AND CTB_DOCUMENTOS.SaldoDocumentoCXC > 0'

lcSQL = 'SELECT CTB_NITS.Nit AS Acudiente, ' + ;
		'CTB_NITS.Nombre AS NombreAcudiente, ' + ;
		'IIF(CTB_DIARIO.IdConcepto = 0, SPACE(5), NTA_CONCEPTOS.Concepto) AS Concepto, ' + ;
		'IIF(CTB_DIARIO.IdConcepto = 0, SPACE(40), NTA_CONCEPTOS.Nombre) AS NombreConcepto, ' + ;
		'CTB_DIARIO.Valor * IIF(CTB_DIARIO.Imputacion = 1, 1, -1) AS Valor ' + ;
		'FROM CTB_DIARIO ' + ;
		'INNER JOIN CTB_DOCUMENTOS ' + ;
		'ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ' + ;
		'INNER JOIN CTB_NITS ' + ;
		'ON CTB_DOCUMENTOS.IdDeudor = CTB_NITS.Id ' + ;
		'INNER JOIN NTA_CONCEPTOS ' + ;
		'ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ' + ;
		'WHERE [Where] AND ' + ;
		'CTB_DOCUMENTOS.IdTipoDoc = 1 AND ' + ;
		'CTB_DIARIO.IdCuenta = 2820 ' + ;
		'UNION ALL ( ' + ;
		'SELECT CTB_NITS.Nit AS Acudiente, ' + ;
		'CTB_NITS.Nombre AS NombreAcudiente, ' + ;
		'IIF(CTB_DIARIO.IdConcepto = 0, SPACE(5), NTA_CONCEPTOS.Concepto) AS Concepto, ' + ;
		'IIF(CTB_DIARIO.IdConcepto = 0, SPACE(40), NTA_CONCEPTOS.Nombre) AS NombreConcepto, ' + ;
		'CTB_DIARIO.Valor * IIF(CTB_DIARIO.Imputacion = 1, 1, -1) AS Valor ' + ;
		'FROM CTB_DIARIO ' + ;
		'INNER JOIN CTB_DOCUMENTOS ' + ;
		'ON CTB_DIARIO.IdDocumentoPadre = CTB_DOCUMENTOS.Id ' + ;
		'INNER JOIN CTB_NITS ' + ;
		'ON CTB_DOCUMENTOS.IdDeudor = CTB_NITS.Id ' + ;
		'INNER JOIN NTA_CONCEPTOS ' + ;
		'ON CTB_DIARIO.IdConcepto = NTA_CONCEPTOS.Id ' + ;
		'WHERE [Where] AND ' + ;
		'CTB_DOCUMENTOS.IdTipoDoc = 1 AND ' + ;
		'CTB_DIARIO.IdCuenta = 2820 ) ' + ;
		'ORDER BY 1, 3 ' + ;
		'INTO CURSOR curTEMPORAL NOFILTER'

lcSQL = STRTRAN(lcSQL, '[Where]', lcWhere)

&lcSQL

IF	_TALLY > 0

	SELECT curTEMPORAL.Acudiente, ;
			curTEMPORAL.NombreAcudiente, ;
			curTEMPORAL.Concepto, ;
			curTEMPORAL.NombreConcepto, ;
			SUM(curTEMPORAL.Valor) AS Valor ;
		FROM curTEMPORAL ;
		GROUP BY 1, 3 ;
		ORDER BY 2, 4 ;
		INTO CURSOR curTEMPORAL2 READWRITE
		
*!*	DELETE FROM curTEMPORAL2 ;
		WHERE curTEMPORAL2.Valor <= 0
		
	GO TOP
	
	COPY TO SALDOSXCONCEPTO TYPE XL5
	
ENDIF

CLOSE TABLES ALL

RETURN
