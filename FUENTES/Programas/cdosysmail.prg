DEFINE CLASS CDOSYSMAIL AS CUSTOM

	SMTPServer = ""
	SMTPPort = ""
	UserName = ""
	PASSWORD = ""
	FROM = ""
	TO = ""
	Body = ""
	Subject = ""
	CC = ""
	BCC = ""
	HTMLFormat = .F.
	Priority = 0
	Importance = 1
	ReadReceipt = .F.
	DIMENSION aFiles(1)

	PROCEDURE AddAttachment(tcFile)
	
		LOCAL lnFiles
		
		IF VARTYPE(tcFile) = "C" AND FILE(tcFile)
			lnFiles = ALEN(THIS.aFiles)
			DIMENSION THIS.aFiles(lnFiles + 1)
			THIS.aFiles(lnFiles+1) = tcFile
		ENDIF
		
	ENDPROC

	PROCEDURE SEND
	
		#DEFINE CdoReferenceTypeName 1
		#DEFINE CdoReferenceTypeId 0

		LOCAL lcSchema, ;
			loConfig, ;
			loMsg, ;
			loConfig AS "CDO.Configuration", ;
			loMsg AS "CDO.Message", ;
			lnCount, ;
			lcFile, ;
			lcPictRef, ;
			lcHTML, ;
			lcImgTag

		lcSchema = "http://schemas.microsoft.com/cdo/configuration/"

		TRY
		
			loConfig = CREATEOBJECT("CDO.Configuration")

			WITH loConfig.FIELDS

				.ITEM(lcSchema + "smtpserver") = THIS.SMTPServer && host of smtp server
				.ITEM(lcSchema + "smtpserverport") = THIS.SMTPPort && SMTP Port
				.ITEM(lcSchema + "sendusing") = 2 && Send it using port
				.ITEM(lcSchema + "sendusername") = THIS.UserName && login
				.ITEM(lcSchema + "sendpassword") = THIS.PASSWORD && your password
				.ITEM(lcSchema + "smtpconnectiontimeout") = 10 && Assign timeout in seconds

				*!* AUTENTICACION Y CIFRADO SSL
				.ITEM(lcSchema + "smtpauthenticate") = .T. && Authenticate
				.ITEM(lcSchema + "smtpusessl") = .T.
				.UPDATE()

			ENDWITH

			loMsg = CREATEOBJECT ("CDO.Message")

			WITH loMsg

				.Configuration = loConfig
				.Subject = THIS.Subject
				.FROM = THIS.FROM

				.TO = THIS.TO

				IF VARTYPE(THIS.CC) = "C"
					.CC = THIS.CC
				ENDIF
				
				IF VARTYPE(THIS.BCC) = "C"
					.BCC = THIS.BCC
				ENDIF

				DO CASE
					CASE FILE(THIS.Body)
						loMsg.CreateMHTMLBody("file://" + THIS.Body)

					CASE LOWER(LEFT(THIS.Body,7)) = "http://"
						loMsg.CreateMHTMLBody(THIS.Body) && This.Body

					CASE THIS.HTMLFormat = .T.

						lcHTML = THIS.Body
						lnCount = 1

						DO WHILE .T.
							lcImgTag = STREXTRACT(lcHTML, "<IMG", ">", lnCount, 1)
							lcFile = STREXTRACT(lcImgTag, ["], ["])

							IF EMPTY(lcImgTag)
								EXIT
							ENDIF
							IF "http:" $ LOWER(lcFile) && reference to a picture stored on the web, so skip !
								lnCount = lnCount + 1 
								LOOP
							ENDIF

							lcPictRef = "cid:" + JUSTFNAME(lcFile)

							lcHTML = STRTRAN(lcHTML, lcFile, lcPictRef, 1, 1)
							loMsg.AddRelatedBodyPart(lcFile, JUSTFNAME(lcFile), CdoReferenceTypeId)
							loMsg.FIELDS.ITEM("urn:schemas:mailheader:Content-ID") = "<" + (JUSTFNAME(lcFile)) + ">"
							loMsg.FIELDS.UPDATE()
							lnCount = lnCount + 1
						ENDDO
						
						.HTMLBody = lcHTML

					OTHERWISE
						.TextBody = THIS.Body
				ENDCASE

				IF	ALEN(THIS.aFiles) > 1
					FOR lnCount = 2 TO ALEN(THIS.aFiles)
						.AddAttachment(THIS.aFiles(lnCount))
						.FIELDS.UPDATE()
					ENDFOR
				ENDIF

				* CONFIGURACION DE PRIORIDAD E IMPORTANCIA
				IF	THIS.Priority <> 0
					.FIELDS.ITEM("urn:schemas:httpmail:priority") = THIS.Priority && -1=Low, 0=Normal, 1=High
					.FIELDS.ITEM("urn:schemas:mailheader:X-Priority") = THIS.Priority && -1=Low, 0=Normal, 1=High
					.FIELDS.ITEM("urn:schemas:httpmail:importance") = THIS.Importance
					.FIELDS.UPDATE()
				ENDIF

				*!* CONFIRMACION DE LECTURA
				IF	THIS.ReadReceipt = .T.
					.FIELDS("urn:schemas:mailheader:disposition-notification-to") = "ggarcia@altek.com.co"
					.FIELDS("urn:schemas:mailheader:return-receipt-to") = "ggarcia@altek.com.co"
					.FIELDS.UPDATE()
				ENDIF

				* Set DSN options. This still needs some checking.
				* For some SMTP servers this makes CDOSYS not to send the msg.
				* Name Value Description
				* cdoDSNDefault 0 No DSN commands are issued.
				* cdoDSNNever 1 No DSN commands are issued.
				* cdoDSNFailure 2 Return a DSN if delivery fails.
				* cdoDSNSuccess 4 Return a DSN if delivery succeeds.
				* cdoDSNDelay 8 Return a DSN if delivery is delayed.
				* cdoDSNSuccessFailOrDelay 14 Return a DSN if delivery succeeds, fails, or is delayed.
				.MDNRequested = .T.
				* .DSNOptions = 2
				.FIELDS.UPDATE()
				.SEND()

			ENDWITH

		CATCH TO loErr
			MESSAGEBOX("No se pudo enviar el mensaje" + CHR(13) + ;
				"Error: " + TRANSFORM(loErr.ERRORNO) + CHR(13) + ;
				"Mensaje: " + loErr.MESSAGE , 16, "Error")
		FINALLY
			loMsg = NULL
			loConfig = NULL
		ENDTRY

	ENDPROC

ENDDEFINE
