SELECT 0
USE ? ALIAS ctb_ciudades
SELECT 0
USE ciudades
SCAN
	SCATTER NAME loReg
	SELECT ctb_ciudades
	APPEND BLANK
	replace ciudad WITH loReg.Cod, ;
			nombre WITH loReg.Nom, ;
			departamento WITH loReg.dpto, ;
			pais WITH 'COLOMBIA', ;
			codigodane WITH loReg.Cod
	SELECT ciudades
ENDSCAN
