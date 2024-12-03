SELECT 0
USE NTA_MATRICULAS ORDER tag id
SELECT 0 
USE NTA_EVALUACIONES
SET RELATION TO IdMatricula INTO NTA_MATRICULAS

FOR lnCount = 1 TO 10

	lcCount = ALLTRIM(STR(lnCount))
	
	REPLACE EvaluacionAlfabetica&lcCount WITH 'D' FOR BETWEEN(EvaluacionNumerica&lcCount, 0.1, 2.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
	REPLACE EvaluacionAlfabetica&lcCount WITH 'I' FOR BETWEEN(EvaluacionNumerica&lcCount, 2.1, 3.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
	REPLACE EvaluacionAlfabetica&lcCount WITH 'A' FOR BETWEEN(EvaluacionNumerica&lcCount, 3.5, 3.9) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
	REPLACE EvaluacionAlfabetica&lcCount WITH 'S' FOR BETWEEN(EvaluacionNumerica&lcCount, 4.0, 4.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
	REPLACE EvaluacionAlfabetica&lcCount WITH 'E' FOR BETWEEN(EvaluacionNumerica&lcCount, 4.5, 5.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'

*!*		REPLACE EvaluacionNumerica&lcCount WITH 0.1 FOR EvaluacionAlfabetica&lcCount = 'D'
*!*		REPLACE EvaluacionNumerica&lcCount WITH 3.0 FOR EvaluacionAlfabetica&lcCount = 'I'
*!*		REPLACE EvaluacionNumerica&lcCount WITH 6.0 FOR EvaluacionAlfabetica&lcCount = 'A'
*!*		REPLACE EvaluacionNumerica&lcCount WITH 8.0 FOR EvaluacionAlfabetica&lcCount = 'S'
*!*		REPLACE EvaluacionNumerica&lcCount WITH 10.0 FOR EvaluacionAlfabetica&lcCount = 'E'
	
ENDFOR

REPLACE DefinitivaAlfabetica WITH 'D' FOR BETWEEN(DefinitivaNumerica, 0.1, 2.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE DefinitivaAlfabetica WITH 'I' FOR BETWEEN(DefinitivaNumerica, 2.1, 3.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE DefinitivaAlfabetica WITH 'A' FOR BETWEEN(DefinitivaNumerica, 3.5, 3.9) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE DefinitivaAlfabetica WITH 'S' FOR BETWEEN(DefinitivaNumerica, 4.0, 4.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE DefinitivaAlfabetica WITH 'E' FOR BETWEEN(DefinitivaNumerica, 4.5, 5.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
	
*!*	REPLACE DefinitivaNumerica WITH 0.1 FOR DefinitivaAlfabetica = 'D'
*!*	REPLACE DefinitivaNumerica WITH 3.0 FOR DefinitivaAlfabetica = 'I'
*!*	REPLACE DefinitivaNumerica WITH 6.0 FOR DefinitivaAlfabetica = 'A'
*!*	REPLACE DefinitivaNumerica WITH 8.0 FOR DefinitivaAlfabetica = 'S'
*!*	REPLACE DefinitivaNumerica WITH 10.0 FOR DefinitivaAlfabetica = 'E'

REPLACE RecuperacionAlfabetica WITH 'D' FOR BETWEEN(RecuperacionNumerica, 0.1, 2.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE RecuperacionAlfabetica WITH 'I' FOR BETWEEN(RecuperacionNumerica, 2.1, 3.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE RecuperacionAlfabetica WITH 'A' FOR BETWEEN(RecuperacionNumerica, 3.5, 3.9) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE RecuperacionAlfabetica WITH 'S' FOR BETWEEN(RecuperacionNumerica, 4.0, 4.4) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'
REPLACE RecuperacionAlfabetica WITH 'E' FOR BETWEEN(RecuperacionNumerica, 4.5, 5.0) AND ALLTRIM(NTA_MATRICULAS.Referencia) = '2009'

*!*	REPLACE RecuperacionNumerica WITH 0.1 FOR RecuperacionAlfabetica = 'D'
*!*	REPLACE RecuperacionNumerica WITH 3.0 FOR RecuperacionAlfabetica = 'I'
*!*	REPLACE RecuperacionNumerica WITH 6.0 FOR RecuperacionAlfabetica = 'A'
*!*	REPLACE RecuperacionNumerica WITH 8.0 FOR RecuperacionAlfabetica = 'S'
*!*	REPLACE RecuperacionNumerica WITH 10.0 FOR RecuperacionAlfabetica = 'E'

USE
