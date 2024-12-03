DEFINE CLASS ProgressTimer AS CUSTOM

	nToProcess = 0
	nStart = 0
	cTimeRemaining = ''
	cCompletionTime = ''
	nReportInterval = 50
	
	PROCEDURE RESET
		LPARAMETERS tnToProcess
		THIS.nToProcess = tnToProcess
		THIS.nStart = SECONDS()
	ENDPROC
	
	PROCEDURE cTimeRemaining_Assign
		LPARAMETERS tcTimeRemaining
		THIS.cTimeRemaining = tcTimeRemaining
	ENDPROC
	
	PROCEDURE cCompleteTime_Assign
		LPARAMETERS tcCompletionTime
		THIS.cCompletionTime = tcCompletioTime
	ENDPROC
	
	PROCEDURE TimeProgress
		LPARAMETERS tnProcessed
		LOCAL lnUnitsRemaining, ;
			lnTimePerUnit, ;
			lnSecondsRemaining, ;
			lnHrs, ;
			lnMin, ;
			lnSec
		lnElapsed = SECONDS() - THIS.nStart
		IF	MOD(tnProcessed, THIS.nReportInterval) = 0
			lnUnitsRemaining = THIS.nToProcess - tnProcessed
			lnTimePerUnit = lnElapsed / tnProcessed
			lnSecondsRemaining = lnTimePerUnit * lnUnitsRemaining
			lnHrs = INT(lnSecondsRemaining / 3600)
			lnFractHours = MOD(lnSecondsRemaining, 3600)
			lnMin = INT(lnFractHours / 60)
			lnSec = MOD(lnFractHours, 60)
			THIS.cTimeRemaining = PADL(ALLTRIM(STR(lnHrs)), 3) + ' hrs. ' + ;
				PADL(ALLTRIM(STR(lnMin)), 2) + ' Min. ' + ;
				PADL(ALLTRIM(STR(lnSec)), 2) + ' Sec. '
			THIS.cCompletionTime = TTOC(DATETIME() + lnSecondsRemaining)
		ENDIF
	ENDPROC
ENDDEFINE
