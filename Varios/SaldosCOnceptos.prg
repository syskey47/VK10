CLOSE TABLES

SELECT 0
USE NTA_CONCEPTOS
SELECT 0
USE CTB_DIARIO
SELECT 0
USE CTB_DOCUMENTOS

select ctb_documentos.documento, ;
		'A' as tipo, ;
		nta_conceptos.concepto, ;
		ctb_diario.imputacion, ;
		ctb_diario.valor ;
	from ctb_diario ;
		inner join ctb_documentos ;
			on ctb_diario.iddocumento = ctb_documentos.id ;
		inner join nta_conceptos ;
			on ctb_diario.idconcepto = nta_conceptos.id ;
	where ctb_documentos.documento = 'FAC00510' ;
	union ;
		(select ctb_documentos.documento, ;
				'B' as tipo, ;
				nta_conceptos.concepto, ;
				ctb_diario.imputacion, ;
				ctb_diario.valor ;
			from ctb_diario ;
				inner join ctb_documentos ;
					on ctb_diario.iddocumentopadre = ctb_documentos.id ;
				inner join nta_conceptos ;
					on ctb_diario.idconcepto = nta_conceptos.id ;
			where ctb_documentos.documento = 'FAC00510' ) ;
	order by 1, 2, 3
