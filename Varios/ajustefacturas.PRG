SELECT 0
USE nta_alumnos ORDER tag id
SELECT 0
USE nta_matriculas ORDER tag id
SET RELATION TO idalumno INTO nta_alumnos
SELECT 0
USE ctb_nits ORDER tag id
SELECT 0
USE ctb_documentos ORDER tag id
SET RELATION TO iddeudor INTO ctb_nits
SELECT 0
USE ctb_diario ORDER tag id
SET RELATION TO iddocumento INTO ctb_documentos, ;
	idmatricula INTO nta_matriculas

DO WHILE .t.
	
	lcNit = INPUTBOX('Nit', 'ACUDIENTE')
	
	IF	EMPTY(lcNit)
		EXIT
	ENDIF 

	SELECT ctb_nits
	GO TOP
	LOCATE FOR nit = VAL(ALLTRIM(lcNit))

	IF	! EOF()

		lnIdNit = ctb_nits.id
		
		SELECT ctb_diario

		BROWSE FIELDS ctb_documentos.documento, ctb_documentos.iddeudor, ;
				iddocumento, valor, idmatricula, nta_alumnos.nombre ;
			FOR ctb_documentos.iddeudor = lnIdNit AND ctb_documentos.idtipodoc = 1

		lcMatricula = INPUTBOX('Matricula', 'ALUMNO')
		
		IF	EMPTY(lcMatricula)
			EXIT
		ENDIF 

		BROWSE FIELDS ctb_documentos.documento, ctb_documentos.iddeudor, ;
				iddocumento, valor, idmatricula, nta_alumnos.nombre ;
			FOR ctb_documentos.iddeudor = lnIdNit AND ;
				ctb_documentos.idtipodoc = 1 AND ;
				idmatricula = VAL(ALLTRIM(lcMatricula))
			
	ENDIF

ENDDO

CLOSE TABLES
RETURN
