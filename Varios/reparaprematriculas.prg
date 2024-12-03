SELECT 0
USE nta_grados ORDER tag id
SELECT 0
USE nta_alumnos ORDER tag id
SELECT 0
USE nta_matriculas
SET RELATION TO idgrado INTO nta_grados, ;
	idalumno INTO nta_alumnos
GO top

DELETE FOR referencia = '2011' AND ;
	INLIST(nta_grados.grado, '02 ', '03 ', '04 ', '05 ', '06 ')

GO top
	
replace inscritoperiodosiguiente WITH .f. ;
	FOR referencia = '2010' AND ;
	INLIST(nta_grados.grado, '01 ', '02 ', '03 ', '04 ', '05 ', ;
		'062', '072', '082', '092', '102', '112')

GO top

replace nta_alumnos.exalumno WITH .f., ;
		nta_alumnos.promocion WITH '' ;
	FOR ! INLIST(nta_grados.grado, '11 ', '112 ')

CLOSE TABLES

