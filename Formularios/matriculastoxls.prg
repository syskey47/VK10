CLOSE TABLES ALL 

OPEN DATABASE d:\vk\datos\emp001\datos

SELECT 0
USE d:\vk\vk9\datos\GENERAL ALIAS GENERAL1

SELECT 0
USE d:\vk\vk9\datos\GENERAL ALIAS GENERAL2 AGAIN

SELECT 0
USE d:\vk\vk9\datos\GENERAL ALIAS GENERAL3 AGAIN

SELECT 0
USE d:\vk\vk9\datos\GENERAL ALIAS GENERAL4 AGAIN

SELECT 0
USE d:\vk\vk9\datos\GENERAL ALIAS GENERAL5 AGAIN

*!*	SELECT DISTINC NTA_GRADOS.Grado, ;
*!*			NTA_GRADOS.Nombre, ;
*!*			GENERAL1.Detalle AS NivelAcademico, ;
*!*			GRADOS.Grado AS GradoSiguiente ;
*!*		FROM NTA_MATRICULAS ;
*!*			INNER JOIN NTA_GRADOS ;
*!*				ON NTA_MATRICULAS.IdGrado = NTA_GRADOS.Id ;
*!*			LEFT JOIN GENERAL1 ;
*!*				ON NTA_GRADOS.NivelAcademico = GENERAL1.Valor AND ;
*!*					GENERAL1.Campo = 'NivelAcademico' ;
*!*			LEFT JOIN NTA_GRADOS AS GRADOS ;
*!*				ON NTA_GRADOS.IdGradoSiguiente = GRADOS.Id ;
*!*		ORDER BY NTA_GRADOS.Grado ;
*!*		INTO CURSOR curGrados
*!*		
*!*	COPY TO GRADOS TYPE XL5

*!*	USE

SELECT DISTINC GENERAL1.Detalle AS TipoId, ;
		CTB_NITS.Nit AS Documento, ;
		CTB_NITS.Titulo, ;
		CTB_NITS.Nombre, ;
		CTB_NITS.Direccion, ;
		CTB_CIUDADES.Nombre AS Ciudad, ;
		CTB_NITS.Telefonos AS Telefono, ;
		CTB_NITS.Celular, ;
		CTB_NITS.Email, ;
		CTB_NITS.Profesion, ;
		CTB_NITS.EsExalumno, ;
		CTB_NITS.Promocion, ;
		PADR('PADRE', 25) AS Parentesco, ;
		CTB_NITS.FechaNacimiento, ;
		GENERAL2.Detalle AS Genero, ;
		CTB_NITS.EsEmpleado, ;
		.F. AS EsAcudiente, ;
		GENERAL3.Detalle AS TipoPersona, ;
		GENERAL4.Detalle AS TipoContribuyente, ;
		GENERAL5.Detalle AS ResponsabilidadFiscal, ;
		CAST(CTB_NITS.TipoTributo AS VARCHAR(100)) AS TipoTributo, ;
		CTB_NITS.FechaIngreso ;		
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN CTB_NITS ;
			ON NTA_ALUMNOS.IdNitPadre = CTB_NITS.Id ;
		LEFT JOIN CTB_CIUDADES ;
			ON CTB_NITS.IdCiudad = CTB_CIUDADES.Id ;
		LEFT JOIN GENERAL1 ;
			ON CTB_NITS.TipoNIt = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoNit' ;
		LEFT JOIN GENERAL2 ;
			ON CTB_NITS.Genero = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'Genero' ;
		LEFT JOIN GENERAL3 ;
			ON CTB_NITS.TipoPersona = GENERAL3.Valor AND ;
				GENERAL3.Campo = 'TipoPersona' ;
		LEFT JOIN GENERAL4 ;
			ON CTB_NITS.TipoContribuyente = GENERAL4.Valor AND ;
				GENERAL4.Campo = 'TipoContribuyente' ;
		LEFT JOIN GENERAL5 ;
			ON CTB_NITS.ResponsabilidadFiscal = GENERAL5.Valor AND ;
				GENERAL5.Campo = 'ResponsabilidadFiscal' ;
		ORDER BY CTB_NITS.Nombre ;
	INTO CURSOR curPADRES

COPY TO NITS_P TYPE XL5

USE
		
		
SELECT DISTINC GENERAL1.Detalle AS TipoId, ;
		CTB_NITS.Nit AS Documento, ;
		CTB_NITS.Titulo, ;
		CTB_NITS.Nombre, ;
		CTB_NITS.Direccion, ;
		CTB_CIUDADES.Nombre AS Ciudad, ;
		CTB_NITS.Telefonos AS Telefono, ;
		CTB_NITS.Celular, ;
		CTB_NITS.Email, ;
		CTB_NITS.Profesion, ;
		CTB_NITS.EsExalumno, ;
		CTB_NITS.Promocion, ;
		PADR('MADRE', 25) AS Parentesco, ;
		CTB_NITS.FechaNacimiento, ;
		GENERAL2.Detalle AS Genero, ;
		CTB_NITS.EsEmpleado, ;
		.F. AS EsAcudiente, ;
		GENERAL3.Detalle AS TipoPersona, ;
		GENERAL4.Detalle AS TipoContribuyente, ;
		GENERAL5.Detalle AS ResponsabilidadFiscal, ;
		CAST(CTB_NITS.TipoTributo AS VARCHAR(100)) AS TipoTributo, ;
		CTB_NITS.FechaIngreso ;		
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN CTB_NITS ;
			ON NTA_ALUMNOS.IdNitMadre = CTB_NITS.Id ;
		LEFT JOIN CTB_CIUDADES ;
			ON CTB_NITS.IdCiudad = CTB_CIUDADES.Id ;
		LEFT JOIN GENERAL1 ;
			ON CTB_NITS.TipoNIt = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoNit' ;
		LEFT JOIN GENERAL2 ;
			ON CTB_NITS.Genero = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'Genero' ;
		LEFT JOIN GENERAL3 ;
			ON CTB_NITS.TipoPersona = GENERAL3.Valor AND ;
				GENERAL3.Campo = 'TipoPersona' ;
		LEFT JOIN GENERAL4 ;
			ON CTB_NITS.TipoContribuyente = GENERAL4.Valor AND ;
				GENERAL4.Campo = 'TipoContribuyente' ;
		LEFT JOIN GENERAL5 ;
			ON CTB_NITS.ResponsabilidadFiscal = GENERAL5.Valor AND ;
				GENERAL5.Campo = 'ResponsabilidadFiscal' ;
	ORDER BY CTB_NITS.Nombre ;
	INTO CURSOR curMADRES
	
COPY TO NITS_M TYPE XL5

USE
		
SELECT DISTINC GENERAL1.Detalle AS TipoId, ;
		CTB_NITS.Nit AS Documento, ;
		CTB_NITS.Titulo, ;
		CTB_NITS.Nombre, ;
		CTB_NITS.Direccion, ;
		CTB_CIUDADES.Nombre AS Ciudad, ;
		CTB_NITS.Telefonos AS Telefono, ;
		CTB_NITS.Celular, ;
		CTB_NITS.Email, ;
		CTB_NITS.Profesion, ;
		CTB_NITS.EsExalumno, ;
		CTB_NITS.Promocion, ;
		CTB_NITS.Parentesco, ;
		CTB_NITS.FechaNacimiento, ;
		GENERAL2.Detalle AS Genero, ;
		CTB_NITS.EsEmpleado, ;
		.T. AS EsAcudiente, ;
		GENERAL3.Detalle AS TipoPersona, ;
		GENERAL4.Detalle AS TipoContribuyente, ;
		GENERAL5.Detalle AS ResponsabilidadFiscal, ;
		CAST(CTB_NITS.TipoTributo AS VARCHAR(100)) AS TipoTributo, ;
		CTB_NITS.FechaIngreso ;		
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN CTB_NITS ;
			ON NTA_ALUMNOS.IdNitAcudiente = CTB_NITS.Id ;
		LEFT JOIN CTB_CIUDADES ;
			ON CTB_NITS.IdCiudad = CTB_CIUDADES.Id ;
		LEFT JOIN GENERAL1 ;
			ON CTB_NITS.TipoNIt = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoNit' ;
		LEFT JOIN GENERAL2 ;
			ON CTB_NITS.Genero = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'Genero' ;
		LEFT JOIN GENERAL3 ;
			ON CTB_NITS.TipoPersona = GENERAL3.Valor AND ;
				GENERAL3.Campo = 'TipoPersona' ;
		LEFT JOIN GENERAL4 ;
			ON CTB_NITS.TipoContribuyente = GENERAL4.Valor AND ;
				GENERAL4.Campo = 'TipoContribuyente' ;
		LEFT JOIN GENERAL5 ;
			ON CTB_NITS.ResponsabilidadFiscal = GENERAL5.Valor AND ;
				GENERAL5.Campo = 'ResponsabilidadFiscal' ;
	ORDER BY CTB_NITS.Nombre ;
	INTO CURSOR curACUDIENTES 
	
COPY TO NITS_A TYPE XL5

USE
		
SELECT DISTINC GENERAL1.Detalle AS TipoId, ;
		CTB_NITS.Nit AS Documento, ;
		CTB_NITS.Titulo, ;
		CTB_NITS.Nombre, ;
		CTB_NITS.Direccion, ;
		CTB_CIUDADES.Nombre AS Ciudad, ;
		CTB_NITS.Telefonos AS Telefono, ;
		CTB_NITS.Celular, ;
		CTB_NITS.Email, ;
		CTB_NITS.Profesion, ;
		CTB_NITS.EsExalumno, ;
		CTB_NITS.Promocion, ;
		CTB_NITS.Parentesco, ;
		CTB_NITS.FechaNacimiento, ;
		GENERAL2.Detalle AS Genero, ;
		CTB_NITS.EsEmpleado, ;
		.F. AS EsAcudiente, ;
		GENERAL3.Detalle AS TipoPersona, ;
		GENERAL4.Detalle AS TipoContribuyente, ;
		GENERAL5.Detalle AS ResponsabilidadFiscal, ;
		CAST(CTB_NITS.TipoTributo AS VARCHAR(100)) AS TipoTributo, ;
		CTB_NITS.FechaIngreso ;		
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN CTB_NITS ;
			ON NTA_ALUMNOS.IdNitContacto = CTB_NITS.Id ;
		LEFT JOIN CTB_CIUDADES ;
			ON CTB_NITS.IdCiudad = CTB_CIUDADES.Id ;
		LEFT JOIN GENERAL1 ;
			ON CTB_NITS.TipoNIt = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoNit' ;
		LEFT JOIN GENERAL2 ;
			ON CTB_NITS.Genero = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'Genero' ;
		LEFT JOIN GENERAL3 ;
			ON CTB_NITS.TipoPersona = GENERAL3.Valor AND ;
				GENERAL3.Campo = 'TipoPersona' ;
		LEFT JOIN GENERAL4 ;
			ON CTB_NITS.TipoContribuyente = GENERAL4.Valor AND ;
				GENERAL4.Campo = 'TipoContribuyente' ;
		LEFT JOIN GENERAL5 ;
			ON CTB_NITS.ResponsabilidadFiscal = GENERAL5.Valor AND ;
				GENERAL5.Campo = 'ResponsabilidadFiscal' ;
	ORDER BY CTB_NITS.Nombre ;
	INTO CURSOR curCONSTACTOS
	
COPY TO NITS_C TYPE XL5

USE

SELECT DISTINCT NTA_ALUMNOS.Id AS IdAlumno, ;
		GENERAL1.Detalle AS TipoId, ;
		NTA_ALUMNOS.Alumno AS Codigo, ;
		NTA_ALUMNOS.Nombre, ;
		NTA_ALUMNOS.Nit, ;
		NTA_ALUMNOS.LibretaMilitar, ;
		NTA_ALUMNOS.DistritoMilitar, ;
		NTA_ALUMNOS.FechaIngreso, ;
		NTA_ALUMNOS.Direccion, ;
		NTA_ALUMNOS.Barrio, ;
		NTA_ALUMNOS.Estrato, ;
		CIUDADES1.Nombre AS Ciudad, ;
		NTA_ALUMNOS.Telefonos, ;
		NTA_ALUMNOS.Celular, ;
		NTA_ALUMNOS.Email, ;
		NTA_ALUMNOS.FechaNacimiento, ;
		CIUDADES2.Nombre AS CiudadNacimiento, ;
		GENERAL2.Detalle AS Genero, ;
		NTA_ALUMNOS.FactorRH, ;
		PADRES.Nit AS NitPadre, ; 
		MADRES.Nit AS NitMadre, ; 
		NTA_ALUMNOS.Exalumno AS EsExalumno, ;
		NTA_ALUMNOS.Promocion ;
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN GENERAL1 ;
			ON NTA_ALUMNOS.TipoIdentificacionAlumno = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoIdentificacionAlumno' ;
		LEFT JOIN CTB_CIUDADES AS CIUDADES1 ;
			ON NTA_ALUMNOS.IdCiudad = CIUDADES1.Id ;
		LEFT JOIN CTB_CIUDADES AS CIUDADES2 ;
			ON NTA_ALUMNOS.IdCiudadNacimiento = CIUDADES2.Id ;
		LEFT JOIN GENERAL2 ;
			ON NTA_ALUMNOS.Genero = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'Genero' ;
		LEFT JOIN CTB_NITS AS PADRES ;
			ON NTA_ALUMNOS.IdNitPadre = PADRES.Id ;
		LEFT JOIN CTB_NITS AS MADRES ;
			ON NTA_ALUMNOS.IdNitMadre = MADRES.Id ;
	ORDER BY NTA_ALUMNOS.Nombre ;
	INTO CURSOR curALUMNOS
	
COPY TO ALUMNOS TYPE XL5

USE

SELECT NTA_MATRICULAS.Referencia, ;
		NTA_MATRICULAS.Matricula AS Documento, ;
		NTA_MATRICULAS.Fecha, ;
		NTA_MATRICULAS.FechaRetiro, ;
		NTA_MATRICULAS.IdAlumno, ;
		NTA_ALUMNOS.Alumno AS Codigo, ;
		ACUDIENTES.Nit AS NitAcudiente, ;
		CONTACTOS.Nit AS NitContacto, ;
		NTA_GRADOS.Grado, ;
		NTA_MATRICULAS.Curso, ;
		GENERAL1.Detalle AS EstadoAlumno, ;
		GENERAL2.Detalle AS TipoAlumno, ;
		NTA_MATRICULAS.Bloqueado, ;
		NTA_MATRICULAS.FacturadoMatricula AS Facturado0, ;
		NTA_MATRICULAS.FacturadoMes1 AS Facturado1, ;
		NTA_MATRICULAS.FacturadoMes2 AS Facturado2, ;
		NTA_MATRICULAS.FacturadoMes3 AS Facturado3, ;
		NTA_MATRICULAS.FacturadoMes4 AS Facturado4, ;
		NTA_MATRICULAS.FacturadoMes5 AS Facturado5, ;
		NTA_MATRICULAS.FacturadoMes6 AS Facturado6, ;
		NTA_MATRICULAS.FacturadoMes7 AS Facturado7, ;
		NTA_MATRICULAS.FacturadoMes8 AS Facturado8, ;
		NTA_MATRICULAS.FacturadoMes9 AS Facturado9, ;
		NTA_MATRICULAS.FacturadoMes10 AS Facturado10, ;
		NTA_MATRICULAS.FacturadoMes11 AS Facturado11, ;
		NTA_MATRICULAS.FacturadoMes12 AS Facturado12 ;
	FROM NTA_MATRICULAS ;
		INNER JOIN NTA_ALUMNOS ;
			ON NTA_MATRICULAS.IdAlumno = NTA_ALUMNOS.Id ;
		LEFT JOIN CTB_NITS AS ACUDIENTES ;
			ON NTA_ALUMNOS.IdNitAcudiente = ACUDIENTES.Id ;
		LEFT JOIN CTB_NITS AS CONTACTOS ;
			ON NTA_ALUMNOS.IdNitContacto = CONTACTOS.Id ;
		LEFT JOIN NTA_GRADOS ;
			ON NTA_MATRICULAS.IdGrado = NTA_GRADOS.Id ;
		LEFT JOIN GENERAL1 ;
			ON NTA_MATRICULAS.TipoAlumno = GENERAL1.Valor AND ;
				GENERAL1.Campo = 'TipoAlumno' ;
		LEFT JOIN GENERAL2 ;
			ON NTA_MATRICULAS.TipoAlumno = GENERAL2.Valor AND ;
				GENERAL2.Campo = 'TipoAlumno' ;
	ORDER BY NTA_MATRICULAS.Referencia, NTA_MATRICULAS.Matricula ;
	INTO CURSOR curMATRICULAS 
	
COPY TO MATRICULAS TYPE XL5

CLOSE TABLES ALL

CLOSE DATABASES



	
