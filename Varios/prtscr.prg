*!* Beginning of program code example:
DEFINE CLASS PrtScr AS CUSTOM OLEPUBLIC

	NAME = "PrtScr"
	ScreenPrinted = .F.
	oWordObj = ""
	cMensajeError = ''
	
	PROCEDURE ScreenCapture
	
		WITH THIS

			.ReleaseWord()
			.ScreenPrinted = .T.
			
			DECLARE INTEGER keybd_event IN Win32API ;
				INTEGER, INTEGER, INTEGER, INTEGER
			
			VK_SNAPSHOT = 44
			= keybd_event(VK_SNAPSHOT, 1, 0, 0)
			
			.oWordObj = CREATEOBJECT("Word.Application")
			.oWordObj.Documents.ADD
			.oWordObj.ActiveDocument.PageSetup.ORIENTATION = 1

			WITH .oWordObj.WordBasic
				.Insert(THIS.cMensajeError)
				.EditPaste
				.FileSaveAs('ErrorVK_' + TTOC(DATETIME(), 1))
				*!* .FilePrint
				.FileClose(2)
			ENDWITH
			
		ENDWITH
		
		RELEASE keybd_event, VK_SNAPSHOT
		
	ENDPROC

	PROCEDURE ReleaseWord
	
		WITH THIS

			IF	.ScreenPrinted
				.oWordObj.QUIT
				.oWordObj = ""
				.ScreenPrinted = .F.
			ENDIF

		ENDWITH

	ENDPROC

	PROCEDURE DESTROY
		THIS.ReleaseWord()
	ENDPROC

ENDDEFINE
*!* End of program code example:
