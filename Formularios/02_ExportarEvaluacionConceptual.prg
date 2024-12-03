SET STEP ON 

SELECT NTA_LOGROS.Referencia, ;
		NTA_LOGROS.Periodo, ;
		NTA_GRADOS.Grado, ;
		NTA_ASIGNATURAS.Asignatura, ;
		NTA_LOGROS.TipoRegistro AS TipoReg, ;
		IIF(NTA_LOGROS.TipoRegistro = 1, 'UNIDAD    ', ;
			IIF(NTA_LOGROS.TipoRegistro = 2, 'LOGRO     ', ;
			IIF(NTA_LOGROS.TipoRegistro = 3, 'IND. LOGRO', ;
			IIF(NTA_LOGROS.TipoRegistro = 4, 'INDICADOR ', ;
			IIF(NTA_LOGROS.TipoRegistro = 5, 'DESARROLLO', SPACE(10)))))) AS TipoRegistro, ;
		NTA_LOGROS.Texto, ;
		NTA_LOGROS.Texto2, ;
		NTA_LOGROS.Texto3 ;
	FROM NTA_LOGROS ;
		INNER JOIN NTA_GRADOS ;
			ON NTA_LOGROS.IdGrado = NTA_GRADOS.Id ;
		INNER JOIN NTA_ASIGNATURAS ;
			ON NTA_LOGROS.IdAsignatura = NTA_ASIGNATURAS.Id ;
	WHERE ! EMPTY(NTA_LOGROS.Referencia) AND ;
		! EMPTY(NTA_LOGROS.IdGrado) AND ;
		! EMPTY(NTA_LOGROS.IdAsignatura) ;
	ORDER BY 1, 2, 3, 4, 5 ;
	INTO CURSOR curTEMPORAL
	
IF	_TALLY > 0

	loExcel = CREATEOBJECT("Excel.Application")

	WITH loExcel
	
		.Workbooks.Add()
		.Sheets(1).Activate()

		.Columns.Select()
		.Columns.NumberFormat = '@'

		lnRow = 1

		.Cells(lnRow, 1).Value = 'REFERENCIA'
		.Cells(lnRow, 2).Value = 'PERIODO'
		.Cells(lnRow, 3).Value = 'GRADO'
		.Cells(lnRow, 4).Value = 'ASIGNATURA'
		.Cells(lnRow, 5).Value = 'TIPO REGISTRO'
		.Cells(lnRow, 6).Value = 'TEXTO'
		.Cells(lnRow, 7).Value = 'TEXTO 2'
		.Cells(lnRow, 8).Value = 'TEXTO 3'
	
		lnRow = lnRow + 1 
	
		SCAN 
		
			.Cells(lnRow, 1).Value = curTEMPORAL.Referencia
			.Cells(lnRow, 2).Value = curTEMPORAL.Periodo
			.Cells(lnRow, 3).Value = ALLTRIM(curTEMPORAL.Grado)
			.Cells(lnRow, 4).Value = ALLTRIM(curTEMPORAL.Asignatura)
			.Cells(lnRow, 5).Value = ALLTRIM(curTEMPORAL.TipoRegistro)
			.Cells(lnRow, 6).Value = ALLTRIM(curTEMPORAL.Texto)
			.Cells(lnRow, 7).Value = ALLTRIM(curTEMPORAL.Texto2)
			.Cells(lnRow, 8).Value = ALLTRIM(curTEMPORAL.Texto3)
			
			lnRow = lnRow + 1 
			
		ENDSCAN

		.Columns.Select()
		.Columns.AutoFit()

		.Cells(1, 1).Select()
		.DisplayFullScreen = .F.
		.DisplayAlerts = .F.

		.WorkBooks(1).SaveAs('EvaluacionConceptual.xls')
		.WorkBooks(1).Close()
	
	ENDWITH
	
	loExcel.Quit()
	
ENDIF
