LOCAL lnDescuento

SELECT 0
USE NTA_ALUMNOS ORDER TAG Id
SELECT 0
USE NTA_MATRICULAS ORDER TAG Id
SELECT 0
USE NTA_CONCEPTOS ORDER TAG Id
SELECT 0
USE NTA_CONCEPTOSXALUMNO ORDER TAG Id
SELECT 0
USE ? ALIAS DESCUENTOS

SCAN 

	SELECT NTA_ALUMNOS
	LOCATE FOR NTA_ALUMNOS.Alumno = PADL(ALLTRIM(DESCUENTOS.Codigo), 9, '0')
	
	IF	FOUND()
	
		SELECT NTA_MATRICULAS
		LOCATE FOR NTA_MATRICULAS.Referencia = '2016' AND ;
				NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id
		
		IF	FOUND()
		
			SELECT NTA_CONCEPTOS
			LOCATE FOR NTA_CONCEPTOS.Concepto = ALLTRIM(DESCUENTOS.Concepto)
			
			IF	FOUND()
			
				SELECT NTA_CONCEPTOSXALUMNO
				LOCATE FOR NTA_CONCEPTOSXALUMNO.IdMatricula = NTA_MATRICULAS.Id AND ;
							NTA_CONCEPTOSXALUMNO.IdConcepto = NTA_CONCEPTOS.Id
							
				IF	FOUND()
					lnDescuento = DESCUENTOS.Dcto1 + (100 - (100 * DESCUENTOS.Dcto1 / 100)) * DESCUENTOS.Dcto2 / 100
					REPLACE NTA_CONCEPTOSXALUMNO.PorcDcto WITH lnDescuento
				ELSE
					? 'No existe concepto ' + ALLTRIM(DESCUENTOS.Concepto) + ' para el alumno ' + ALLTRIM(DESCUENTOS.Codigo)
				ENDIF
						
			ELSE
				? 'No existe concepto ' + ALLTRIM(DESCUENTOS.Concepto)
			ENDIF
			
		ELSE
			? 'No existe matrícula de alumno ' + ALLTRIM(DESCUENTOS.Codigo)
		ENDIF
		
	ELSE 
		? 'No existe alumno ' + ALLTRIM(DESCUENTOS.Codigo)
	ENDIF
	
	SELECT DESCUENTOS
		
ENDSCAN

CLOSE TABLES ALL 
