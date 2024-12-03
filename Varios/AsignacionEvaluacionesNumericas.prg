USE NTA_EVALUACIONES

FOR lnCount = 1 TO 10

	lcCount = ALLTRIM(STR(lnCount))
	
	REPLACE EvaluacionNumerica&lcCount WITH 0.1 FOR EvaluacionAlfabetica&lcCount = 'D'
	REPLACE EvaluacionNumerica&lcCount WITH 3.0 FOR EvaluacionAlfabetica&lcCount = 'I'
	REPLACE EvaluacionNumerica&lcCount WITH 6.0 FOR EvaluacionAlfabetica&lcCount = 'A'
	REPLACE EvaluacionNumerica&lcCount WITH 8.0 FOR EvaluacionAlfabetica&lcCount = 'S'
	REPLACE EvaluacionNumerica&lcCount WITH 10.0 FOR EvaluacionAlfabetica&lcCount = 'E'
	
ENDFOR
	
REPLACE DefinitivaNumerica WITH 0.1 FOR DefinitivaAlfabetica = 'D'
REPLACE DefinitivaNumerica WITH 3.0 FOR DefinitivaAlfabetica = 'I'
REPLACE DefinitivaNumerica WITH 6.0 FOR DefinitivaAlfabetica = 'A'
REPLACE DefinitivaNumerica WITH 8.0 FOR DefinitivaAlfabetica = 'S'
REPLACE DefinitivaNumerica WITH 10.0 FOR DefinitivaAlfabetica = 'E'

REPLACE RecuperacionNumerica WITH 0.1 FOR RecuperacionAlfabetica = 'D'
REPLACE RecuperacionNumerica WITH 3.0 FOR RecuperacionAlfabetica = 'I'
REPLACE RecuperacionNumerica WITH 6.0 FOR RecuperacionAlfabetica = 'A'
REPLACE RecuperacionNumerica WITH 8.0 FOR RecuperacionAlfabetica = 'S'
REPLACE RecuperacionNumerica WITH 10.0 FOR RecuperacionAlfabetica = 'E'

USE
