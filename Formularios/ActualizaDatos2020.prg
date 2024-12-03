SELECT 0
USE CTB_CIUDADES ORDER TAG Ciudad
SELECT 0
USE CTB_NITS ORDER TAG Nit
SELECT 0
USE NTA_ALUMNOS ORDER TAG Alumno
SELECT 0
USE ? ALIAS DATOS
SCAN 

	SELECT NTA_ALUMNOS
	LOCATE FOR NTA_ALUMNOS.Alumno = ALLTRIM(DATOS.Codigo)
	
	IF	FOUND()
	
		REPLACE NTA_ALUMNOS.Nombre WITH UPPER(ALLTRIM(DATOS.A1_A) + ' ' + ALLTRIM(DATOS.A2_A) + ' ' + ALLTRIM(DATOS.N1_A) + ALLTRIM(DATOS.N2_A)), ;
				NTA_ALUMNOS.Nit WITH ALLTRIM(DATOS.Doc_A), ;
				NTA_ALUMNOS.Direccion WITH ALLTRIM(DATOS.Dir_A), ;
				NTA_ALUMNOS.EMail WITH ALLTRIM(DATOS.EMail_A), ;
				NTA_ALUMNOS.FechaIngreso WITH CTOD(ALLTRIM(DATOS.FechaIng))
		
		DO	CASE
			CASE DATOS.TipoDoc = 'RC'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 1
			CASE DATOS.TipoDoc = 'TI'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 2
			CASE DATOS.TipoDoc = 'CC'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 3
			CASE DATOS.TipoDoc = 'CE'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 4
			CASE DATOS.TipoDoc = 'NIP'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 5
			CASE DATOS.TipoDoc = 'NUIP'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 5
			CASE DATOS.TipoDoc = 'V'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 6
			CASE DATOS.TipoDoc = 'P'
				REPLACE NTA_ALUMNOS.TipoIdentificacionAlumno WITH 8
		ENDCASE
		
		SELECT CTB_CIUDADES
		LOCATE FOR CTB_CIUDADES.Ciudad = DATOS.Ciu_A
		
		IF	FOUND()
			SELECT NTA_ALUMNOS
			REPLACE NTA_ALUMNOS.IdCiudad WITH CTB_CIUDADES.Id
		ELSE
			SELECT NTA_ALUMNOS
		ENDIF
		
		SELECT CTB_NITS
		LOCATE FOR CTB_NITS.Id = NTA_ALUMNOS.IdNitMadre
		
		IF	FOUND()
		
			REPLACE CTB_NITS.Nit WITH VAL(ALLTRIM(DATOS.Doc_M)), ;
					CTB_NITS.Nombre WITH UPPER(ALLTRIM(DATOS.A1_M) + ' ' + ALLTRIM(DATOS.A2_M) + ' ' + ALLTRIM(DATOS.N1_M) + ' ' + ALLTRIM(DATOS.N2_M)), ;
					CTB_NITS.FechaNacimiento WITH CTOD(ALLTRIM(DATOS.FN_M)), ;
					CTB_NITS.Celular WITH ALLTRIM(DATOS.Cel_M), ;
					CTB_NITS.EMail WITH ALLTRIM(DATOS.EMail_M), ;
					CTB_NITS.Telefonos WITH ALLTRIM(DATOS.Tel_M), ;
					CTB_NITS.Direccion WITH ALLTRIM(DATOS.Dir_M)
					
			SELECT CTB_CIUDADES
			LOCATE FOR CTB_CIUDADES.Ciudad = DATOS.Ciu_M
			
			IF	FOUND()
				SELECT CTB_NITS
				REPLACE CTB_NITS.IdCiudad WITH CTB_CIUDADES.Id
			ELSE
				SELECT CTB_NITS
			ENDIF
			
		ENDIF

		IF	! EMPTY(DATOS.Doc_P)
		
			LOCATE FOR CTB_NITS.Id = NTA_ALUMNOS.IdNitPadre
			IF	FOUND()
			
				REPLACE CTB_NITS.Nit WITH VAL(ALLTRIM(DATOS.Doc_P)), ;
						CTB_NITS.Nombre WITH UPPER(ALLTRIM(DATOS.A1_P) + ' ' + ALLTRIM(DATOS.A2_P) + ' ' + ALLTRIM(DATOS.N1_P) + ' ' + ALLTRIM(DATOS.N2_P)), ;
						CTB_NITS.FechaNacimiento WITH CTOD(ALLTRIM(DATOS.FN_P)), ;
						CTB_NITS.Celular WITH ALLTRIM(DATOS.Cel_P), ;
						CTB_NITS.EMail WITH ALLTRIM(DATOS.EMail_P), ;
						CTB_NITS.Telefonos WITH ALLTRIM(DATOS.Tel_P), ;
						CTB_NITS.Direccion WITH ALLTRIM(DATOS.Dir_P)
						
				SELECT CTB_CIUDADES
				LOCATE FOR CTB_CIUDADES.Ciudad = DATOS.Ciu_M
				
				IF	FOUND()
					SELECT CTB_NITS
					REPLACE CTB_NITS.IdCiudad WITH CTB_CIUDADES.Id
				ELSE
					SELECT CTB_NITS
				ENDIF
				
			ENDIF
			
		ENDIF
		
		IF	! EMPTY(DATOS.Doc_AC)

			LOCATE FOR CTB_NITS.Id = NTA_ALUMNOS.IdNitAcudiente
			IF	FOUND()

				IF	CTB_NITS.Nit = VAL(ALLTRIM(DATOS.Doc_AC))
			
					REPLACE CTB_NITS.Nit WITH VAL(ALLTRIM(DATOS.Doc_AC)), ;
							CTB_NITS.Nombre WITH UPPER(ALLTRIM(DATOS.A1_AC) + ' ' + ALLTRIM(DATOS.A2_AC) + ' ' + ALLTRIM(DATOS.N1_AC) + ' ' + ALLTRIM(DATOS.N2_AC)), ;
							CTB_NITS.FechaNacimiento WITH CTOD(ALLTRIM(DATOS.FN_AC)), ;
							CTB_NITS.Celular WITH ALLTRIM(DATOS.Cel_AC), ;
							CTB_NITS.EMail WITH ALLTRIM(DATOS.EMail_AC), ;
							CTB_NITS.Telefonos WITH ALLTRIM(DATOS.Tel_AC), ;
							CTB_NITS.Direccion WITH ALLTRIM(DATOS.Dir_AC), ;
							CTB_NITS.Profesion WITH UPPER(ALLTRIM(DATOS.Prof_AC))
							
					SELECT CTB_CIUDADES
					LOCATE FOR CTB_CIUDADES.Ciudad = DATOS.Ciu_AC
					
					IF	FOUND()
						SELECT CTB_NITS
						REPLACE CTB_NITS.IdCiudad WITH CTB_CIUDADES.Id
					ELSE
						SELECT CTB_NITS
					ENDIF
				
				ELSE
				
					LOCATE FOR CTB_NITS.Nit = VAL(ALLTRIM(DATOS.Doc_AC))
					
					IF	! FOUND()

						REPLACE CTB_NITS.Nit WITH VAL(ALLTRIM(DATOS.Doc_AC)), ;
								CTB_NITS.Nombre WITH UPPER(ALLTRIM(DATOS.A1_AC) + ' ' + ALLTRIM(DATOS.A2_AC) + ' ' + ALLTRIM(DATOS.N1_AC) + ' ' + ALLTRIM(DATOS.N2_AC)), ;
								CTB_NITS.FechaNacimiento WITH CTOD(ALLTRIM(DATOS.FN_AC)), ;
								CTB_NITS.Celular WITH ALLTRIM(DATOS.Cel_AC), ;
								CTB_NITS.EMail WITH ALLTRIM(DATOS.EMail_AC), ;
								CTB_NITS.Telefonos WITH ALLTRIM(DATOS.Tel_AC), ;
								CTB_NITS.Direccion WITH ALLTRIM(DATOS.Dir_AC), ;
								CTB_NITS.Profesion WITH UPPER(ALLTRIM(DATOS.Prof_AC))
								
						SELECT CTB_CIUDADES
						LOCATE FOR CTB_CIUDADES.Ciudad = DATOS.Ciu_AC
						
						IF	FOUND()
							SELECT CTB_NITS
							REPLACE CTB_NITS.IdCiudad WITH CTB_CIUDADES.Id
						ELSE
							SELECT CTB_NITS
						ENDIF

					ENDIF
				
				ENDIF
				
			ENDIF
			
		ENDIF
			
	ENDIF
	
	SELECT DATOS
	
ENDSCAN
