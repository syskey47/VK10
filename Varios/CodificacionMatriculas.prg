LOCAL lnMatricula

SELECT 0
USE nta_matriculas ORDER tag id
SET FILTER TO referencia = '2007' AND ;
	EstadoAlumno = 0
GO TOP

lnMatricula = 1

DO WHILE ! EOF()

	REPLACE Matricula WITH TRANSFORM(lnMatricula, '@L 99999')
	lnMatricula = lnMatricula + 1
	SKIP

ENDDO

MESSAGEBOX('Matr�culas actualizadas...', 64, 'Codificaci�n matr�culas')

CLOSE TABLES
