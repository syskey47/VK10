LOCAL lnIdDocumento, ;
	ldFechaLimite, ;
	llAjuste, ;
	llok

SELECT 0
USE CTB_DIARIO

SELECT 0
USE CTB_DOCUMENTOS

SCAN FOR CTB_DOCUMENTOS.SaldoDocumentoCXC = 22000
	
	lnIdDocumento = CTB_DOCUMENTOS.Id
	ldFechaLimite = CTB_DOCUMENTOS.FechaExtemporanea
	llAjuste = .F.
	
	SELECT CTB_DIARIO.IdMatricula, ;
			CTB_DIARIO.IdConcepto, ;
			IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
		FROM CTB_DIARIO ;
			INNER JOIN CTB_DOCUMENTOS ;
				ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
		WHERE CTB_DOCUMENTOS.Id = lnIdDocumento AND ;
			CTB_DIARIO.IdMatricula > 0 AND ;
			CTB_DIARIO.IdConcepto > 0 ;
	UNION ALL ( ;
	SELECT CTB_DIARIO.IdMatricula, ;
			CTB_DIARIO.IdConcepto, ;
			IIF(CTB_DIARIO.Imputacion = 1, CTB_DIARIO.Valor, -CTB_DIARIO.Valor) AS Valor ;
		FROM CTB_DIARIO ;
			INNER JOIN CTB_DOCUMENTOS ;
				ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
			INNER JOIN CTB_DOCUMENTOS AS DOC_PADRE ;
				ON CTB_DIARIO.IdDocumentoPadre = DOC_PADRE.Id ;
		WHERE DOC_PADRE.Id = lnIdDocumento AND ;
			CTB_DIARIO.IdMatricula > 0 AND ;
			CTB_DIARIO.IdConcepto > 0 ) ;
	INTO CURSOR curTEMPORAL NOFILTER
					
	IF	_TALLY > 0
	
		SELECT curTEMPORAL.IdMatricula, ;
				curTEMPORAL.IdConcepto, ;
				SUM(curTEMPORAL.Valor) AS Valor ;
			FROM curTEMPORAL ;
			GROUP BY 1, 2 ;
			INTO CURSOR curSALDOS
			
		IF	_TALLY > 0
		
*!*				IF	! llOk
*!*					BROWSE
*!*					llok = .T.
*!*				ENDIF
	
			SCAN FOR curSALDOS.Valor = 22000
					
				SELECT DISTINCT CTB_DIARIO.IdDocumento ;
					FROM CTB_DIARIO ;
						INNER JOIN CTB_DOCUMENTOS ;
							ON CTB_DIARIO.IdDocumento = CTB_DOCUMENTOS.Id ;
					WHERE CTB_DIARIO.IdDocumentoPadre = lnIdDocumento AND ;
						CTB_DOCUMENTOS.Fecha <= ldFechaLimite ;
					INTO CURSOR curPAGOS 
					
				IF	_TALLY > 0
				
					SCAN
				
						SELECT CTB_DIARIO
						LOCATE FOR CTB_DIARIO.IdDocumento = curPAGOS.IdDocumento AND ;
								CTB_DIARIO.IdCuenta = 2619 AND ;
								CTB_DIARIO.Valor = 22000
								
						IF	FOUND()
						
							REPLACE CTB_DIARIO.IdCuenta WITH 149, ;
									CTB_DIARIO.IdDocumentoPadre WITH lnIdDocumento, ;
									CTB_DIARIO.IdMatricula WITH curSALDOS.IdMatricula, ;
									CTB_DIARIO.IdConcepto WITH curSALDOS.IdConcepto
									
							llAjuste = .T.
									
							EXIT 
						
						ENDIF
						
						SELECT curPAGOS
						
					ENDSCAN
				
				ENDIF
				
				IF	llAjuste
					EXIT
				ENDIF
				
				SELECT curSALDOS
				
			ENDSCAN
		
		ENDIF
		
	ENDIF
	
	SELECT CTB_DOCUMENTOS
	
ENDSCAN 


CLOSE TABLES ALL 