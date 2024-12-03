open data
select 0
use nta_asignaturasxgrado order tag id
select 0
use nta_matriculas order tag id
select 0
use nta_evaluaciones order tag id
set relation to idpensum into nta_asignaturasxgrado, ;
		idmatricula into nta_matriculas
set filter to nta_asignaturasxgrado.idgrado # nta_matriculas.idgrado
go top
browse fields idpensum, idmatricula, ;
	nta_asignaturasxgrado.id, nta_asignaturasxgrado.idgrado, ;
	nta_matriculas.id, nta_matriculas.idgrado
close data
return
