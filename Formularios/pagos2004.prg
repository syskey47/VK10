close all
set default to ?

select 0
use grados alias grd
set order to tag grado
select 0
use alumnos alias alm
set order to tag nit_alm
select 0
use clientes alias cli
set order to tag cliente
select 0
use concepto alias cpt
set order to tag concepto
select 0
use mtrclas alias mtr
set order to tag alumno
select 0
use mov_fac alias mvf

select mvf.cliente as nit, ;
		cli.nombre as nombre, ;
		mvf.alumno, ;
		alm.nombre as nombreal, ;
		mtr.grado, ;
		grd.nombre as nombreg, ;
		mtr.curso, ;
		cpt.concepto, ;
		cpt.nombre as nombrec, ;
		sum(mvf.valor) as valor ;
	from mvf ;
		inner join cli ;
			on mvf.cliente = cli.cliente ;
		inner join cpt ;
			on mvf.concepto = cpt.concepto ;
		inner join mtr ;
			on mvf.alumno = mtr.alumno ;
		inner join alm ;
			on mtr.nit_alm = alm.nit_alm ;
		inner join grd ;
			on mtr.grado = grd.grado ;
	where between(mvf.fecha, {^2004.01.01}, {^2004.06.30}) and ;
		cpt.imputacion = 'C' and ;
		cpt.deducible = .T. ;
	group by 1, 3, 4 ;
	into cursor curTEMPORAL NOFILTER
	
IF	_TALLY > 0

	copy to pagos2004
	
ENDIF

close all
return

