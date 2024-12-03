SET EXACT ON 
LOCAL lcMensaje

lcMensaje = ''

SELECT 0
USE NTA_GRADOS ORDER TAG Id
SELECT 0
USE NTA_MATRICULAS 
SELECT 0
USE NTA_TRANSPORTE ORDER TAG Id

SELECT 0
USE ? ALIAS RUTAS

SCAN

	IF	ALLTRIM(RUTAS.Matricula) = '2292'
		SET STEP ON 
	ENDIF

	IF	! EMPTY(RUTAS.Ruta1) OR ;
		! EMPTY(RUTAS.Ruta2) OR ;
		! EMPTY(RUTAS.Ruta3) OR ;
		! EMPTY(RUTAS.Ruta4)
		
		SELECT NTA_GRADOS
		
		IF	! EMPTY(RUTAS.Grado2)
		
			LOCATE FOR NTA_GRADOS.Grado = LEFT(ALLTRIM(RUTAS.Grado2), AT(' ', RUTAS.Grado2) - 1)
			
			IF	FOUND()
				lnIdGrado2 = NTA_GRADOS.Id
				lcCurso2 = RIGHT(ALLTRIM(RUTAS.Grado2), 1)
			ELSE
				lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' grado alterno no encontrado' + CHR(13) + CHR(10)
				lnIdGrado2 = 0
				lcCurso2 = ''
			ENDIF
			
		ELSE
			lnIdGrado2 = 0
			lcCurso2 = ''
		ENDIF
	
		SELECT NTA_TRANSPORTE
		
		IF	! EMPTY(RUTAS.Ruta1)
			LOCATE FOR NTA_TRANSPORTE.Referencia = '2015' AND ;
				NTA_TRANSPORTE.Ruta = STRTRAN(RUTAS.Ruta1, ' ', '')
			IF	FOUND()
				lnIdRuta1 = NTA_TRANSPORTE.Id
			ELSE
				lnIdRuta1 = 0
				lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' ruta 1 no encontrada' + CHR(13) + CHR(10)
			ENDIF
		ELSE
			lnIdRuta1 = 0
		ENDIF

		IF	! EMPTY(RUTAS.Ruta2)
			LOCATE FOR NTA_TRANSPORTE.Referencia = '2015' AND ;
				NTA_TRANSPORTE.Ruta = STRTRAN(RUTAS.Ruta2, ' ', '')
			IF	FOUND()
				lnIdRuta2 = NTA_TRANSPORTE.Id
			ELSE
				lnIdRuta2 = 0
				lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' ruta 2 no encontrada' + CHR(13) + CHR(10)
			ENDIF
		ELSE
			lnIdRuta2 = 0
		ENDIF

		IF	! EMPTY(RUTAS.Ruta3)
			LOCATE FOR NTA_TRANSPORTE.Referencia = '2015' AND ;
				NTA_TRANSPORTE.Ruta = STRTRAN(RUTAS.Ruta3, ' ', '')
			IF	FOUND()
				lnIdRuta3 = NTA_TRANSPORTE.Id
			ELSE
				lnIdRuta3 = 0
				lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' ruta 3 no encontrada' + CHR(13) + CHR(10)
			ENDIF
		ELSE
			lnIdRuta3 = 0
		ENDIF
		
		IF	! EMPTY(RUTAS.Ruta4)
			LOCATE FOR NTA_TRANSPORTE.Referencia = '2015' AND ;
				NTA_TRANSPORTE.Ruta = STRTRAN(RUTAS.Ruta4, ' ', '')
			IF	FOUND()
				lnIdRuta4 = NTA_TRANSPORTE.Id
			ELSE
				lnIdRuta4 = 0
				lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' ruta 4 no encontrada' + CHR(13) + CHR(10)
			ENDIF
		ELSE
			lnIdRuta4 = 0
		ENDIF
		
		SELECT NTA_MATRICULAS
		LOCATE FOR NTA_MATRICULAS.Referencia = '2015' AND ;
			ALLTRIM(NTA_MATRICULAS.Matricula) = ALLTRIM(RUTAS.Matricula)
		
		IF	FOUND()

			IF	! EMPTY(RUTAS.Grado2)
				REPLACE NTA_MATRICULAS.IdGrado2 WITH lnIdGrado2, ;
						NTA_MATRICULAS.Curso2 WITH lcCurso2
			ENDIF
			
			IF	! EMPTY(lnIdRuta1)
				REPLACE NTA_MATRICULAS.Direccion WITH IIF(EMPTY(RUTAS.Direccion), NTA_MATRICULAS.Direccion, RUTAS.Direccion), ;
						NTA_MATRICULAS.Barrio WITH IIF(EMPTY(RUTAS.Conjunto) AND EMPTY(RUTAS.Barrio), NTA_MATRICULAS.Barrio, ;
							ALLTRIM(RUTAS.Conjunto) + ' ' + ALLTRIM(RUTAS.Barrio)), ;
						NTA_MATRICULAS.IdRuta WITH lnIdRuta1
			ENDIF

			IF	! EMPTY(lnIdRuta2)
				REPLACE NTA_MATRICULAS.Direccion1 WITH IIF(EMPTY(RUTAS.Direccion), NTA_MATRICULAS.Direccion1, RUTAS.Direccion), ;
						NTA_MATRICULAS.Barrio1 WITH IIF(EMPTY(RUTAS.Conjunto) AND EMPTY(RUTAS.Barrio), NTA_MATRICULAS.Barrio1, ;
							ALLTRIM(RUTAS.Conjunto) + ' ' + ALLTRIM(RUTAS.Barrio)), ;
						NTA_MATRICULAS.IdRuta1 WITH lnIdRuta2, ;
						NTA_MATRICULAS.Dias1 WITH '0' + ;
							IIF(! EMPTY(RUTAS.Lun2), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mart2), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mie2), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Jue2), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Vie2), '1', '0') + '0'
			ENDIF

			IF	! EMPTY(lnIdRuta3)
				REPLACE NTA_MATRICULAS.Direccion2 WITH IIF(EMPTY(RUTAS.Direccion), NTA_MATRICULAS.Direccion2, RUTAS.Direccion), ;
						NTA_MATRICULAS.Barrio2 WITH IIF(EMPTY(RUTAS.Conjunto) AND EMPTY(RUTAS.Barrio), NTA_MATRICULAS.Barrio2, ;
							ALLTRIM(RUTAS.Conjunto) + ' ' + ALLTRIM(RUTAS.Barrio)), ;
						NTA_MATRICULAS.IdRuta2 WITH lnIdRuta3, ;
						NTA_MATRICULAS.Dias2 WITH '0' + ;
							IIF(! EMPTY(RUTAS.Lun3), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mart3), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mie3), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Jue3), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Vie3), '1', '0') + '0'
			ENDIF
			
			IF	! EMPTY(lnIdRuta4)
				REPLACE NTA_MATRICULAS.Direccion3 WITH IIF(EMPTY(RUTAS.Direccion), NTA_MATRICULAS.Direccion3, RUTAS.Direccion), ;
						NTA_MATRICULAS.Barrio3 WITH IIF(EMPTY(RUTAS.Conjunto) AND EMPTY(RUTAS.Barrio), NTA_MATRICULAS.Barrio3, ;
							ALLTRIM(RUTAS.Conjunto) + ' ' + ALLTRIM(RUTAS.Barrio)), ;
						NTA_MATRICULAS.IdRuta3 WITH lnIdRuta4, ;
						NTA_MATRICULAS.Dias3 WITH '0' + ;
							IIF(! EMPTY(RUTAS.Lun4), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mart4), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Mie4), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Jue4), '1', '0') + ;
							IIF(! EMPTY(RUTAS.Vie4), '1', '0') + '0'
			ENDIF
			
		ELSE
			lcMensaje = lcMensaje + ALLTRIM(RUTAS.Nombre) + ' no encontrado' + CHR(13) + CHR(10)
		ENDIF
		
	ENDIF
	
	SELECT RUTAS	

ENDSCAN

? lcMensaje

CLOSE TABLES ALL

RETURN
