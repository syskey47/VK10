PARAMETERS nomemp, nomrep, nomhoja, fecharep, nomtabla

lcnomhoja=ALLTRIM(nomhoja)
USE &nomtabla
totcols=FCOUNT()

oExcel = CREATEOBJECT("Excel.Application")

*!*	IF VARTYPE(oExcel ) # "O"
*!*		MESSAGEBOX("No Se Puede Ejecutar este Programa, No Está Instalado Excel en este Equipo",64,"Mensaje del Sistema")
*!*		RETURN
*!*	ENDIF

WITH oExcel
	.Visible = .T.
	.Workbooks.Add
	.Worksheets(1).Activate
	.Worksheets(1).Name = lcnomhoja  && NOMBRE DE LA HOJA
	SELECT &nomtabla
	lcnumlet=65
	lcvallet=""
	lccola=.f.
	FOR Lcnum=1 TO FCOUNT()
		lcnomcol='col'+ALLTRIM(STR(lcnum))
		&lcnomcol=FIELD(lcnum)
		IF lccola=.t.
			Lcdircol=CHR(lcnumlet)+CHR(lcvallet)
		ELSE
			Lcdircol=CHR(lcnumlet)
		ENDIF
		.Columns("&Lcdircol:&Lcdircol").ColumnWidth = FSIZE(&lcnomcol)
		IF TYPE(&lcnomcol)="N"
			.Columns("&Lcdircol:&Lcdircol").Select
			.Selection.NumberFormat = "#,##0.00;[Red]-#,#0.00"  
		ENDIF
		IF TYPE(&lcnomcol)="C"
			.Columns("&Lcdircol:&Lcdircol").Select
			.Selection.NumberFormat = "@"  
		ENDIF
		IF lcnumlet=90
			lccola=.t.
			lcnumlet=65
			lcvallet=64
		ENDIF
		IF lccola=.t.
			lcvallet=lcvallet+1
		ELSE
			lcnumlet=lcnumlet+1
		ENDIF
	ENDFOR

	FOR i=1 TO 6
		lcdi1col="A"+ALLTRIM(STR(I))
		lcdi2col=Lcdircol+ALLTRIM(STR(I))
		.Range("&lcdi1col:&lcdi2col").Select  && BLANCO
	    WITH .Selection
			 .Merge
			 .MergeCells = .T.
			 .HorizontalAlignment  = 2
			 .VerticalAlignment    = 1
		ENDWITH 	 
	ENDFOR

	.Range("A1:A1").Select  && TITULO
	WITH .Selection.Font
         .Bold=.T.
         .Size = 14
         .Name = "ARIAL"
	ENDWITH 	 

    WITH .Worksheets(1)
         .Cells(1,1).Value = nomemp  && EMPRESA 
    ENDWITH      
    
	.Range("A3:A5").Select  && SUBTITULOS
	WITH .Selection.Font
         .Bold=.T.
         .Size = 10
         .Name = "ARIAL"
    ENDWITH 

    WITH .Worksheets(1)
         .Cells(3,1).Value = nomrep		&& REPORTE 
         .Cells(5,1).Value = fecharep	&& Fecha 
    ENDWITH      

	lcultcol=Lcdircol+"7"
	.Range("A7:&lcultcol").Select  && SUBTITULOS
	WITH .Selection.Font
         .Bold=.T.
         .Size = 8
         .Name = "ARIAL"
    ENDWITH 
    WITH .Selection
		 .Borders(3).LineStyle = 1
		 .Borders(4).LineStyle = 1
	ENDWITH 	 

	FOR Lcnum=1 TO FCOUNT()
		lcnomcol='col'+ALLTRIM(STR(lcnum))
	    WITH .Worksheets(1)
        	.Cells(7,Lcnum).Value = &lcnomcol
		ENDWITH	
	ENDFOR
	
	lclinxls=8
	GO TOP
	DO WHILE NOT EOF()
		FOR Lcnum=1 TO FCOUNT()
			lcvalcol=FIELD(lcnum)
		    WITH .Worksheets(1)
	        	.Cells(lclinxls,lcnum).Value = &lcvalcol
			ENDWITH	
		ENDFOR
		SKIP
		lclinxls=lclinxls+1
	ENDDO

	lcultcol=Lcdircol+"7"
	.Range("A7:&lcultcol").Select  && SUBTITULOS
    .selection.autofilter

	lcnumlet=65
	lcvallet=""
	lccola=.f.
	FOR Lcnum=1 TO FCOUNT()
		lcnomcol='col'+ALLTRIM(STR(lcnum))
		&lcnomcol=FIELD(lcnum)
		IF lccola=.t.
			Lcdircol=CHR(lcnumlet)+CHR(lcvallet)
		ELSE
			Lcdircol=CHR(lcnumlet)
		ENDIF
		.Columns("&Lcdircol:&Lcdircol").columns.autofit
		IF lcnumlet=90
			lccola=.t.
			lcnumlet=65
			lcvallet=64
		ENDIF
		IF lccola=.t.
			lcvallet=lcvallet+1
		ELSE
			lcnumlet=lcnumlet+1
		ENDIF
	ENDFOR
ENDWITH
oExcel = .NULL.
RELEASE oExcel
