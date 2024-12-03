* Programa...: It.prg
* Versión....: 1.0
* Autor......: Gerardo Garcia Mantilla
* Fecha......: 
* Derechos...: Copyright (c) 1999
* Compilador.: Visual FoxPro 05.00.00.0415 para Windows 
* Notas......: Programa de inicio de la aplicación en modo desarrollo
* Cambios....: 
*********************************************************
LPARAMETERS tlDebug

IF	tlDebug
	SET STEP ON 
ENDIF

CLEAR
CLEAR DLLS
CLEAR MEMORY
CLEAR MENUS
CLEAR POPUPS
CLEAR RESOURCES
CLOSE DATABASES ALL

IF	WEXIST('Project Manager - Vk10')
	HIDE WINDOW 'Project manager - Vk10'
ENDIF

IF	! INLIST(RIGHT(SYS(16, 1), 3), 'APP', 'EXE')
	LOCAL lcPath
	lcPath = Path(ADDBS(SYS(5) + SYS(2003))) + ',' + ;
			ADDBS(ADDBS(SYS(5) + SYS(2003)) + 'DATOS')
	SET PATH TO (lcPath)
ENDIF
SET DEVELOPMENT ON

DO INICIO

IF	WEXIST('Project Manager - Vk10')
	SHOW WINDOW 'Project Manager - Vk10'
ELSE
	MODIFY PROJECT VK10 NOWAIT
ENDIF

CLEAR

RETURN


*!* Funcion para buscar el path de desarrollo
FUNCTION Path(tcPathIni)
LOCAL laDir[1], lnDir, lnCount, lcPath, lcNewPath

lcPath = ''
lnDir  = ADIR(laDir, tcPathIni + '*.*', 'D')
FOR	lnCount = 3 TO lnDir
	IF	'D' $ laDir[lnCount, 5]  AND ;
		UPPER(laDir[lnCount, 1]) # 'DATOS'
		lcNewPath = Path(tcPathIni + laDir[lnCount, 1] + '\')
		IF	! EMPTY(lcNewPath)
			lcPath = IIF(EMPTY(lcPath), '', lcPath + ',') + lcNewPath
		ENDIF
	ENDIF
ENDFOR
IF	EMPTY(lcPath)
	RETURN tcPathIni
ELSE
	RETURN tcPathIni + ',' + lcPath
ENDIF
