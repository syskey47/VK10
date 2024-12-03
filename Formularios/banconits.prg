SET STEP ON

	SELECT TRANSFORM(CTB_NITS.Nit, '@L 9999999999999') AS Nit, ;
			REPLICATE('0', 3) AS Sucursal, ;
			IIF(INLIST(CTB_NITS.TipoNit, 2, 6), ' ', ALLTRIM(STR(DigitoChequeo(CTB_NITS.Nit)))) AS DigitoVerificacion, ;
			PADR(CTB_NITS.Nombre, 60) AS Nombre, ;
			IIF(INLIST(CTB_NITS.TipoNit, 2, 6), 'N', 'S') AS TipoNit, ;
			IIF(INLIST(CTB_NITS.TipoNit, 3, 4), TRANSFORM(CTB_NITS.Nit, '@L 9999999999999'), '') AS CedulaExtranjeria, ;
			' ' AS IdentificacionFiscal, ;
			PADR(CTB_NITS.Nombre, 50) AS Contacto, ;
			PADR(CTB_NITS.Direccion, 100) AS Direccion, ;
			'001' AS CodPais, ;
			'0001' AS CodCiudad, ;
			'A' AS Estado, ;
			TRANSFORM(VAL(LEFT(CTB_NITS.Telefonos, 7)), '@L 99999999999') AS Telefono1, ;
			IIF(INLIST(CTB_NITS.TipoNit, 2, 6), IIF(CTB_NITS.Genero = 1, 'F', 'M'), 'E') AS Sexo, ;
			'01' AS TipoPersona, ;
			PADR(CTB_NITS.EMail, 100) AS EMail, ;
			PADR(CTB_NITS.Nombre, 50) AS ContactoFacturacion, ;
			PADR(CTB_NITS.EMail, 100) AS EMailFacturacion, ;
			IIF(CTB_NITS.TipoNit = 1, 'N', 'C') AS TipoNitContacto, ;
			'C' AS Clasificacion, ;
			'1' AS ListaPrecio1, ;
			'9' AS FormaPago, ;
			'1' AS Calificacion, ;
			CTB_NITS.TipoContribuyente, ;
			'1' AS Vendedor, ;
			'101' AS Cobrador, ;
			PADR(CTB_NITS.Nombre, 60) AS NombreComercial, ;
			' ' AS CodigoPostal, ;
			CTB_NITS.ResponsabilidadFiscal AS Responsabilidad, ;
			CTB_NITS.TipoTributo AS Tributos ;
		FROM CTB_NITS ;
		WHERE CTB_NITS.EsDeudor ;
		INTO CURSOR curNITS NOFILTER

	IF 	_TALLY > 0
	
		loExcel = CREATEOBJECT('Excel.Application')

		WITH loExcel
					
			.Visible = .F.

			.Workbooks.Add()
			.Sheets(1).Activate()
			.Sheets(1).Visible = .T.

			.Cells(1, 1).Value = 'FUNDACION GIMNASIO MODERNO'
			.Cells(2, 1).Value = 'MODELO TERCEROS'

			.Cells(5, 1).Value = 'IDENTIFICACIÓN  (OBLIGATORIO)'
			.Cells(5, 2).Value = 'SUCURSAL  (OBLIGATORIO)'
			.Cells(5, 3).Value = 'DIGITO DE VERIFICACIÓN'
			.Cells(5, 4).Value = 'NOMBRE'
			.Cells(5, 5).Value = 'RAZÓN SOCIAL'
			.Cells(5, 6).Value = 'PRIMER NOMBRE'
			.Cells(5, 7).Value = 'SEGUNDO NOMBRE'
			.Cells(5, 8).Value = 'PRIMER APELLIDO'
			.Cells(5, 9).Value = 'SEGUNDO APELLIDO'
			.Cells(5, 10).Value = 'NÚMERO DE IDENTIFICACIÓN DEL EXTRANJERO'
			.Cells(5, 11).Value = 'CÓDIGO IDENTIFICACIÓN FISCAL'
			.Cells(5, 12).Value = 'NOMBRE DEL CONTACTO'
			.Cells(5, 13).Value = 'DIRECCIÓN'
			.Cells(5, 14).Value = 'PAÍS'
			.Cells(5, 15).Value = 'CIUDAD'
			.Cells(5, 16).Value = 'ACTIVO'
			.Cells(5, 17).Value = 'TELÉFONO 1'
			.Cells(5, 18).Value = 'SEXO'
			.Cells(5, 19).Value = 'TIPO DE PERSONA'
			.Cells(5, 20).Value = 'CORREO ELECTRÓNICO'
			.Cells(5, 21).Value = 'CONTACTO DE FACTURACIÓN'
			.Cells(5, 22).Value = 'CORREO ELECT. CONTACTO DE FACTURACIÓN'
			.Cells(5, 23).Value = 'TIPO DE IDENTIFICACIÓN'
			.Cells(5, 24).Value = 'CLASIFICACIÓN - CLASE DE TERCERO'
			.Cells(5, 25).Value = 'LISTA DE PRECIO'
			.Cells(5, 26).Value = 'FORMA DE PAGO'
			.Cells(5, 27).Value = 'CALIFICACIÓN'
			.Cells(5, 28).Value = 'TIPO CONTRIBUYENTE'
			.Cells(5, 29).Value = 'VENDEDOR'
			.Cells(5, 30).Value = 'COBRADOR'
			.Cells(5, 31).Value = 'NOMBRE COMERCIAL'
			.Cells(5, 32).Value = 'CODIGO POSTAL'
			.Cells(5, 33).Value = 'RESPONSABILIDAD FISCAL'
			.Cells(5, 34).Value = 'TRIBUTOS'

			lnFila = 6
			
			SELECT curNITS

			SCAN
			
				.Cells(lnFila, 1).Value = curNITS.Nit
				.Cells(lnFila, 2).Value = curNITS.Sucursal
				.Cells(lnFila, 3).Value = curNITS.DigitoVerificacion
				.Cells(lnFila, 4).Value = STRTRAN(curNITS.Nombre, ',', '')
				.Cells(lnFila, 5).Value = curNITS.TipoNit
				
				IF	curNITS.TipoNit = 'S'
					.Cells(lnFila, 6).Value = ''
					.Cells(lnFila, 7).Value = ''
					.Cells(lnFila, 8).Value = ''
					.Cells(lnFila, 9).Value = ''
				ELSE
					DO	CASE
						CASE GETWORDCOUNT(curNITS.Nombre) = 2
							.Cells(lnFila, 8).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 1), ',', '')
							.Cells(lnFila, 9).Value = ''
							.Cells(lnFila, 6).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 2), ',', '')
							.Cells(lnFila, 7).Value = ''
						CASE GETWORDCOUNT(curNITS.Nombre) = 3
							.Cells(lnFila, 8).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 1), ',', '')
							.Cells(lnFila, 9).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 2), ',', '')
							.Cells(lnFila, 6).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 3), ',', '')
							.Cells(lnFila, 7).Value = ''
						OTHERWISE
							.Cells(lnFila, 8).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 1), ',', '')
							.Cells(lnFila, 9).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 2), ',', '')
							.Cells(lnFila, 6).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 3), ',', '')
							.Cells(lnFila, 7).Value = STRTRAN(GETWORDNUM(curNITS.Nombre, 4), ',', '')
							 
					ENDCASE
				ENDIF
				
				.Cells(lnFila, 10).Value = curNITS.CedulaExtranjeria
				.Cells(lnFila, 11).Value = curNITS.IdentificacionFiscal
				.Cells(lnFila, 12).Value = STRTRAN(curNITS.Contacto, ',', '')
				.Cells(lnFila, 13).Value = curNITS.Direccion
				.Cells(lnFila, 14).Value = curNITS.CodPais
				.Cells(lnFila, 15).Value = curNITS.CodCiudad
				.Cells(lnFila, 16).Value = curNITS.Estado
				.Cells(lnFila, 17).Value = curNITS.Telefono1
				.Cells(lnFila, 18).Value = curNITS.Sexo
				.Cells(lnFila, 19).Value = curNITS.TipoPersona

				IF	AT(';', curNITS.EMail) > 0
					.Cells(lnFila, 20).Value = SUBSTR(curNITS.EMail, 1, AT(';', curNITS.EMail) - 1)
				ELSE
					.Cells(lnFila, 20).Value = curNITS.EMail
				ENDIF
				
				.Cells(lnFila, 21).Value = STRTRAN(curNITS.ContactoFacturacion, ',', '')
				.Cells(lnFila, 22).Value = curNITS.EMailFacturacion
				.Cells(lnFila, 23).Value = curNITS.TipoNitContacto
				.Cells(lnFila, 24).Value = curNITS.Clasificacion
				.Cells(lnFila, 25).Value = curNITS.ListaPrecio1
				.Cells(lnFila, 26).Value = curNITS.FormaPago
				.Cells(lnFila, 27).Value = curNITS.Calificacion
				.Cells(lnFila, 28).Value = curNITS.TipoContribuyente
				.Cells(lnFila, 29).Value = curNITS.Vendedor
				.Cells(lnFila, 30).Value = curNITS.Cobrador
				.Cells(lnFila, 31).Value = STRTRAN(curNITS.NombreComercial, ',', '')
				.Cells(lnFila, 32).Value = curNITS.CodigoPostal
				
				IF	curNITS.Responsabilidad = 99
					.Cells(lnFila, 33).Value = 'R-99-PN'
				ELSE
					.Cells(lnFila, 33).Value = 'O-' + STRZERO(curNITS.Responsabilidad, 2, 0)
				ENDIF
				
				.Cells(lnFila, 34).Value = "'" + curNITS.Tributos
				
				lnFila = lnFila + 1 
				
			ENDSCAN

			lcNombreArchivo = 'Terceros_' + DTOS(DATE()) + STRTRAN(TIME(), ':', '')
			
			.Columns.Select()
			.Columns.AutoFit()

			.Cells(1, 1).Select()
			.DisplayFullScreen = .F.
			.DisplayAlerts = .F.
			.WorkBooks(1).SaveAs(lcNombreArchivo)
			.WorkBooks(1).Close()

			.Quit()

		ENDWITH	
								
		RELEASE loExcel
	ENDIF
	
	
