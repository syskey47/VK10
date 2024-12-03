*!* ACTUALIZACION DE EJECUTABLES 
*!* SI HAY UNA VERSION MAS ACTUAL LA INICIA Y CANCELA EL PROGRAMA ACTUAL
SET STEP ON 
IF	RIGHT(JUSTFNAME(SYS(16)), 3) = 'EXE'

	Ex = ADIR(Executables, '*.EXE')

	= ASORT(Executables, 3, -1, 1)

	ThisExe = UPPER(JUSTFNAME(SYS(16)))
	NewExe = UPPER(Executables[1])

	IF	NewExe <> ThisExe

		WAIT WINDOW 'Running latest exe' NOWAIT
		LOCAL lcFileName,lcWorkDir,lcOperation
		tcOperation=""
		tcWorkDir = SYS(5) + SYS(2003) + "\"
		tcFileName = NewExe
		IF	EMPTY(tcFileName)
			RETURN -1
		ENDIF

		lcFileName = ALLTRIM(tcFileName)
		lcWorkDir = IIF(TYPE("tcWorkDir") = "C", ALLTRIM(tcWorkDir), "")
		lcOperation = IIF(TYPE("tcOperation") = "C" ;
						AND NOT EMPTY(tcOperation), ALLTRIM(tcOperation), "Open")

		DECLARE INTEGER ShellExecute ; 
			IN SHELL32.DLL ;
			INTEGER nWinHandle,;
			STRING cOperation,;
			STRING cFileName,;
			STRING cParameters,;
			STRING cDirectory,;
			INTEGER nShowWindow
			
		= ShellExecute(0, lcOperation, lcFileName, "", lcWorkDir, 1)

		QUIT

	ENDIF

ENDIF
