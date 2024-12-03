LOCAL lcCodigoAlumno, ;
	lcNombreAlumno

OPEN DATA ?
USE NTA_ALUMNOS

SCAN

	lcCodigoAlumno = ''
	lcNombreAlumno = ALLTRIM(NTA_ALUMNOS.Nombre)

	DO WHILE ! EMPTY(lcNombreAlumno)

		lcCodigoAlumno = SUBSTR(lcNombreAlumno, RAT(' ', lcNombreAlumno) + 1, 1) + lcCodigoAlumno
		lcNombreAlumno = LEFT(lcNombreAlumno, RAT(' ', lcNombreAlumno) - 1)
			
	ENDDO

	REPLACE NTA_ALUMNOS.Nombre WITH STRTRAN(NTA_ALUMNOS.Nombre, '¥', 'Ñ'), ;
			NTA_ALUMNOS.Alumno WITH lcCodigoAlumno + ;
				RIGHT('00' + ALLTRIM(STR(NTA_ALUMNOS.Nit - INT(NTA_ALUMNOS.Nit / 1000) * 1000)), 3)
				
ENDSCAN

CLOSE DATA
RETURN
