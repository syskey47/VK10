Local oFile, ;
	nReportCount

CLEAR ALL

nReportCount = 0

*!* MODIFY PROJECT VK6 NOSHOW NOWAIT

FOR EACH oFile IN _VFP.ActiveProject.Files

	IF	oFile.Type = 'R'
		
		WAIT WINDOW 'Borrando campos en: ' + ;
			oFile.Name TIMEOUT 0.5
			
		USE (oFile.Name)
		GO TOP
		LOCATE FOR ObjType = 1 AND ObjCode = 53
		
		IF	FOUND()
			REPLACE Tag WITH '', ;
					Tag2 WITH ''
			
			nReportCount = nReportCount + 1
		ENDIF
		
		USE
		
	ENDIF

ENDFOR

WAIT WINDOW ALLTRIM(STR(nReportCount)) + ;
	' Reporte(s) modificados en el proyecto ' + ;
	_VFP.ActiveProject.Name TIMEOUT 2

IF	_VFP.ActiveProject.Build('VisualKey', 3, .T., .F., .T.) = .F.
	WAIT WINDOW 'Se encontraron errores en el proyecto ' + ;
	_VFP.ActiveProject.Name TIMEOUT 2
ENDIF
