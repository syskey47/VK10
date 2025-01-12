* APLICACION:
*   PROGRAMA: Procedimientos Generales
*      AUTOR: Gerardo Garcia Mantilla
*INSTALACION:
*      FECHA: Septiembre de 1991

*!* Clave
*!* *************************************
#INCLUDE ..\otros\Projecto.h

FUNCTION Clave(tcTexto, tlEncripta)

LOCAL lnCount, ;
	lcBase, ;
	lcClave

lcBase = REPLICATE('rphpg137', INT(LEN(tcTexto) / 8) + 1)
lcClave = ''
IF	tlEncripta
	FOR lnCount = 1 TO LEN(tcTexto)
		IF	ASC(SUBSTR(tcTexto, lnCount, 1)) + ASC(SUBSTR(lcBase, lnCount, 1)) > 255
			lcClave = lcClave + CHR(ASC(SUBSTR(tcTexto, lnCount, 1)) + ;
						ASC(SUBSTR(lcBase, lnCount, 1)) - 224)
		ELSE
			lcClave = lcClave + CHR(ASC(SUBSTR(tcTexto, lnCount, 1)) + ;
						ASC(SUBSTR(lcBase, lnCount, 1)))
		ENDIF
	ENDFOR
ELSE
	FOR lnCount = 1 TO LEN(tcTexto)
		IF	ASC(SUBSTR(tcTexto, lnCount, 1)) - ASC(SUBSTR(lcBase, lnCount, 1)) < 32
			lcClave = lcClave + CHR(ASC(SUBSTR(tcTexto, lnCount, 1)) - ;
						ASC(SUBSTR(lcBase, lnCount, 1)) + 224)
		ELSE
			lcClave = lcClave + CHR(ASC(SUBSTR(tcTexto, lnCount, 1)) - ;
						ASC(SUBSTR(lcBase, lnCount, 1)))
		ENDIF
	ENDFOR
ENDIF

RETURN lcClave


*!* ReemplaceAcceso
*!* *************************************
FUNCTION ReemplaceAcceso(tnPosicion)

REPLACE USUARIOS.Accesos WITH ;
	LEFT(USUARIOS.Accesos, tnPosicion - 1) + ;
	IIF(SUBSTR(USUARIOS.Accesos, tnPocision, 1) = CHR(236), CHR(255), CHR(236)) + ;
	SUBSTR(USUARIOS.Accesos, tnPosicion + 1)

RETURN


*!* StrZero
*!* *************************************
FUNCTION StrZero(tnNumero, tnLongitud, tnDecimales)

LOCAL lcNumero, ;
	lcCadena

DO CASE
	CASE tnDecimales = 0
		lcNumero = STR(tnNumero, tnLongitud)
	CASE tnLongitud = 0
		lcNumero = STR(tnNumero)
	OTHERWISE
		lcNumero = STR(tnNumero, tnLongitud, tnDecimales)
ENDCASE

IF '-' $ lcNumero
	lcCadena = '-' + REPLICATE('0', LEN(lcNumero) - LEN(LTRIM(lcNumero))) + ;
		+ SUBSTR(lcNumero, AT('-', lcNumero) + 1)
ELSE
	lcCadena = REPLICATE('0', LEN(lcNumero) - LEN(LTRIM(lcNumero))) + LTRIM(lcNumero)
ENDIF

RETURN lcCadena


*!* MontoEscrito
*!* *************************************
FUNCTION MontoEscrito(tnValor, tlDinero)

LOCAL lcNumero, ;
	lnValor, ;
	lcValorEnLetras

IF	PARAMETERS() = 1
	tlDinero = .T.
ENDIF

lcValorEnLetras = ''
lcNumero = StrZero(tnValor, 15, 2)

IF	EMPTY(VAL(SUBSTR(lcNumero, 1, 12)))
	lcValorEnLetras = 'Cero '
ENDIF

lnValor = VAL(LEFT(lcNumero, 3))

IF	lnValor > 0
	lcValorEnLetras = lcValorEnLetras + NumeroALetras(lnValor, tlDinero)
	lcValorEnLetras = lcValorEnLetras + 'Mil '
ENDIF

lnValor = VAL(SUBSTR(lcNumero, 4, 3))

IF	lnValor > 0
	lcValorEnLetras = lcValorEnLetras + NumeroALetras(lnValor, tlDinero)
	IF	VAL(LEFT(lcNumero, 6)) = 1
		lcValorEnLetras = lcValorEnLetras + 'Mill�n '
	ELSE
		lcValorEnLetras = lcValorEnLetras + 'Millones '
	ENDIF
	IF	VAL(SUBSTR(lcNumero, 7, 6)) = 0
		lcValorEnLetras = lcValorEnLetras + 'De '
	ENDIF
ELSE
	IF	! EMPTY(lnValor)
		lcValorEnLetras = lcValorEnLetras + 'Millones De '
	ENDIF
ENDIF

lnValor = VAL(SUBSTR(lcNumero, 7, 3))

IF	lnValor > 0
	lcValorEnLetras = lcValorEnLetras + NumeroALetras(lnValor, tlDinero)
	lcValorEnLetras = lcValorEnLetras + 'Mil '
ENDIF

lnValor = VAL(SUBSTR(lcNumero, 10, 3))

IF	lnValor > 0
	lcValorEnLetras = lcValorEnLetras + NumeroALetras(lnValor, tlDinero)
ENDIF

IF	tlDinero
	IF	tnValor = 1
		lcValorEnLetras = lcValorEnLetras + 'Peso Con '
	ELSE
		lcValorEnLetras = lcValorEnLetras + 'Pesos Con '
	ENDIF
	lcValorEnLetras = lcValorEnLetras + RIGHT(lcNumero, 2) + '/100 Moneda Corriente'
ELSE
	lcValorEnLetras = lcValorEnLetras + 'Punto '
	lnValor = VAL(SUBSTR(lcNumero, 14, 2))
	IF	EMPTY(lnValor)
		lcValorEnLetras = lcValorEnLetras + 'Cero'
	ELSE
		lcValorEnLetras = lcValorEnLetras + NumeroALetras(lnValor, tlDinero)
	ENDIF
ENDIF

RETURN(lcValorEnLetras)


*!* NumeroALetras
*!* *************************************
FUNCTION NumeroALetras(tnValor, tlDinero)

LOCAL lcValorEnLetras, ;
	lnDigito, ;
	laUnidades[9], ;
	ladecenas[9], ;
	laOnce[9], ;
	laCentenas[9]

IF	tlDinero
	laUnidades[1] = 'Un '
ELSE
	laUnidades[1] = 'Uno '
ENDIF
laUnidades[2] = 'Dos '
laUnidades[3] = 'Tres '
laUnidades[4] = 'Cuatro '
laUnidades[5] = 'Cinco '
laUnidades[6] = 'Seis '
laUnidades[7] = 'Siete '
laUnidades[8] = 'Ocho '
laUnidades[9] = 'Nueve '

laOnce[1] = 'Once '
laOnce[2] = 'Doce '
laOnce[3] = 'Trece '
laOnce[4] = 'Catorce '
laOnce[5] = 'Quince '
laOnce[6] = 'Dieciseis '
laOnce[7] = 'Diecisiete '
laOnce[8] = 'Dieciocho '
laOnce[9] = 'Diecinueve '

laDecenas[1] = 'Diez '
laDecenas[2] = 'Veinte '
laDecenas[3] = 'Treinta '
laDecenas[4] = 'Cuarenta '
laDecenas[5] = 'Cincuenta '
laDecenas[6] = 'Sesenta '
laDecenas[7] = 'Setenta '
laDecenas[8] = 'Ochenta '
laDecenas[9] = 'Noventa '

laCentenas[1] = 'Ciento '
laCentenas[2] = 'Doscientos '
laCentenas[3] = 'Trescientos '
laCentenas[4] = 'Cuatrocientos '
laCentenas[5] = 'Quinientos '
laCentenas[6] = 'Seiscientos '
laCentenas[7] = 'Setecientos '
laCentenas[8] = 'Ochocientos '
laCentenas[9] = 'Novecientos '

lcValorEnLetras = ''

IF	tnValor >= 100
	IF	tnValor = 100
		IF	tlDinero
			lcValorEnLetras = lcValorEnLetras + 'Un Cien '
		ELSE
			lcValorEnLetras = lcValorEnLetras + 'Cien '
		ENDIF
	ELSE
		lnDigito = INT(tnValor / 100)
		lcValorEnLetras = lcValorEnLetras + laCentenas[lnDigito]
	ENDIF
	tnValor = tnValor - INT(tnValor / 100) * 100
ENDIF

IF	tnValor >= 10
	IF	BETWEEN(tnValor, 11, 19)
		lnDigito = tnValor - 10
		lcValorEnLetras = lcValorEnLetras + laOnce[lnDigito]
		tnValor = 0
	ELSE
		lnDigito = INT(tnValor / 10)
		lcValorEnLetras = lcValorEnLetras + laDecenas[lnDigito]
		tnValor = tnValor - INT(tnValor / 10) * 10
		IF	tnValor >= 1
			lcValorEnLetras = lcValorEnLetras + 'Y '
		ENDIF
	ENDIF
ENDIF

IF	tnValor >= 1
	lcValorEnLetras = lcValorEnLetras + laUnidades[tnValor]
ENDIF

RETURN lcValorEnLetras


*!* FechaLarga
*!* *************************************
FUNCTION FechaLarga(tdFecha, tcFormato, tlNombreDia, tlMesAbreviado)

LOCAL lcFechaLarga

IF	EMPTY(tdFecha)
	lcFechaLarga = ''
ELSE
	IF	TYPE('tcFormato') # 'C'
		tcFormato = 'DMA'
	ENDIF

	IF	tlNombreDia
		lcFechaLarga = DiaDeLaSemana(tdFecha) + ', '
	ELSE
		lcFechaLarga = ''
	ENDIF

	DO	CASE
		CASE UPPER(tcFormato) == 'DMA'
			 lcFechaLarga = lcFechaLarga + ;
			 				ALLTRIM(STR(DAY(tdFecha))) + ' de ' + ;
			 				NombreMes(tdFecha, tlMesAbreviado) + ' de ' + ;
			 				ALLTRIM(STR(YEAR(tdFecha)))
		CASE UPPER(tcFormato) = 'DMAH'
			 lcFechaLarga = lcFechaLarga + ;
			 				ALLTRIM(STR(DAY(tdFecha))) + ' de ' + ;
			 				NombreMes(tdFecha, tlMesAbreviado) + ' de ' + ;
			 				ALLTRIM(STR(YEAR(tdFecha))) + ' a ' + LEFT(TIME(), 5)
		CASE UPPER(tcFormato) == 'MDA'
			 lcFechaLarga = lcFechaLarga + ;
			 				NombreMes(tdFecha, tlMesAbreviado) + ;
			 				ALLTRIM(STR(DAY(tdFecha))) + ' de ' + ;
			 				ALLTRIM(STR(YEAR(tdFecha)))
		CASE UPPER(tcFormato) = 'MDAH'
			 lcFechaLarga = lcFechaLarga + ;
			 				NombreMes(tdFecha, tlMesAbreviado) + ;
			 				ALLTRIM(STR(DAY(tdFecha))) + ' de ' + ;
			 				ALLTRIM(STR(YEAR(tdFecha))) + ' a ' + LEFT(TIME(), 5)
		CASE UPPER(tcFormato) = 'MA'
			 lcFechaLarga = NombreMes(tdFecha, tlMesAbreviado) + '/' + ;
			 				ALLTRIM(STR(YEAR(tdFecha)))
		CASE UPPER(tcFormato) = 'AM'
			 lcFechaLarga = ALLTRIM(STR(YEAR(tdFecha))) + '/' + ;
							NombreMes(tdFecha, tlMesAbreviado)

	ENDCASE
ENDIF

RETURN lcFechaLarga

 
*!* DiaDeLaSemana
*!* *************************************
FUNCTION DiaDeLaSemana(tdFecha)

LOCAL lcDia

DO CASE
	CASE DOW(tdFecha) = 1
		lcDia = 'Domingo'
	CASE DOW(tdFecha) = 2
		lcDia = 'Lunes'
	CASE DOW(tdFecha) = 3
		lcDia = 'Martes'
	CASE DOW(tdFecha) = 4
		lcDia = 'Mi�rcoles'
	CASE DOW(tdFecha) = 5
		lcDia = 'Jueves'
	CASE DOW(tdFecha) = 6
		lcDia = 'Viernes'
	CASE DOW(tdFecha) = 7
		lcDia = 'S�bado'
	OTHERWISE
		lcDia = ''
ENDCASE

RETURN lcDia


*!* NombreMes
*!* *************************************
FUNCTION NombreMes(tuMes, tlMesAbreviado)

LOCAL lcMes

DO	CASE
	CASE TYPE('tuMes') $ 'DT'
		DO CASE
			CASE MONTH(tuMes) = 1
				lcMes = 'Enero'
			CASE MONTH(tuMes) = 2
				lcMes = 'Febrero'
			CASE MONTH(tuMes) = 3
				lcMes = 'Marzo'
			CASE MONTH(tuMes) = 4
				lcMes = 'Abril'
			CASE MONTH(tuMes) = 5
				lcMes = 'Mayo'
			CASE MONTH(tuMes) = 6
				lcMes = 'Junio'
			CASE MONTH(tuMes) = 7
				lcMes = 'Julio'
			CASE MONTH(tuMes) = 8
				lcMes = 'Agosto'
			CASE MONTH(tuMes) = 9
				lcMes = 'Septiembre'
			CASE MONTH(tuMes) = 10
				lcMes = 'Octubre'
			CASE MONTH(tuMes) = 11
				lcMes = 'Noviembre'
			CASE MONTH(tuMes) = 12
				lcMes = 'Diciembre'
			OTHERWISE
				lcMes = ''
		ENDCASE
	CASE TYPE('tuMes') = 'N'
		DO CASE
			CASE tuMes = 1
				lcMes = 'Enero'
			CASE tuMes = 2
				lcMes = 'Febrero'
			CASE tuMes = 3
				lcMes = 'Marzo'
			CASE tuMes = 4
				lcMes = 'Abril'
			CASE tuMes = 5
				lcMes = 'Mayo'
			CASE tuMes = 6
				lcMes = 'Junio'
			CASE tuMes = 7
				lcMes = 'Julio'
			CASE tuMes = 8
				lcMes = 'Agosto'
			CASE tuMes = 9
				lcMes = 'Septiembre'
			CASE tuMes = 10
				lcMes = 'Octubre'
			CASE tuMes = 11
				lcMes = 'Noviembre'
			CASE tuMes = 12
				lcMes = 'Diciembre'
			OTHERWISE
				lcMes = ''
		ENDCASE
		 
	OTHERWISE
		lcMes = ''
ENDCASE

IF	! EMPTY(lcMes) AND tlMesAbreviado
	lcMes = LEFT(lcMes, 3) + '.'
ENDIF

RETURN lcMes


*!* ComienzoMes
*!* *************************************
FUNCTION ComienzoMes(tdFecha)

RETURN (tdFecha - DAY(tdFecha) + 1)


*!* FinMes
*!* *************************************
FUNCTION FinMes(tdFecha)

RETURN ComienzoMes(GOMONTH(tdFecha, 1)) - 1

*!* ComienzoAno
*!* *************************************
FUNCTION ComienzoAno(tdFecha)

RETURN (CTOD(STR(YEAR(tdFecha), 4, 0) + '.01.01'))


*!* FinAno
*!* *************************************
FUNCTION FinAno(tdFecha)

RETURN (CTOD(STR(YEAR(tdFecha), 4, 0) + '.12.31'))



*!* FechaCobol
*!* *************************************
FUNCTION FechaCobol(tdFecha)

RETURN RIGHT(DTOS(tdFecha), 6)


*!* FechaLegalizacion
*!* *************************************
FUNCTION FechaLegalizacion(tdFechaEntrega)

LOCAL ldFechaLegalizacion, ;
	lnDias, ;
	lnDiasLegalizacion, ;
	llSabadoHabil

ldFechaLegalizacion = tdFechaEntrega
IF	EMPTY(ldFechaLegalizacion)
	ldFechaLegalizacion = DATE()
ENDIF
lnDiasLegalizacion = oEMPRESA.DiasLegal
llSabadoHabil = oEMPRESA.SabadoHab
				
FOR lnDias = 1 TO lnDiasLegalizacion
					
	IF	llSabadoHabil
		IF	DOW(ldFechaLegalizacion) = 7  && S�bado
			ldFechaLegalizacion = ldFechaLegalizacion + 2  && Lunes
		ELSE
			ldFechaLegalizacion = ldFechaLegalizacion + 1  && Dia h�bil siguiente
		ENDIF
	ELSE
		IF	DOW(ldFechaLegalizacion) = 6  && Viernes
			ldFechaLegalizacion = ldFechaLegalizacion + 3  && Lunes
		ELSE
			ldFechaLegalizacion = ldFechaLegalizacion + 1  && Dia h�bil siguiente
		ENDIF
	ENDIF
	
ENDFOR
				
RETURN ldFechaLegalizacion


*!* EnMora
*!* *************************************
FUNCTION EnMoraSeriales(tdFechaEntrega, tdFechaDocumento)

RETURN IIF(MAX(DATE(), tdFechaDocumento) > FechaLegalizacion(tdFechaEntrega), .T., .F.)


*!* Funcion para buscar el path de desarrollo
FUNCTION Path(tcPathIni)
LOCAL laDir[1], lnDir, lnCount, lcPath, lcNewPath

lcPath = ''
lnDir  = ADIR(laDir, tcPathIni + '*.*', 'D')
FOR	lnCount = 3 TO lnDir
	IF	'D' $ laDir[lnCount, 5]  AND ;
		UPPER(laDir[lnCount, 1]) # 'DATOS'
		lcNewPath = Path(tcPathIni + laDir[lnCount, 1] + '\')
		IF	! EMPTY(lcNewPath)
			lcPath = IIF(EMPTY(lcPath), '', lcPath + ',') + lcNewPath
		ENDIF
	ENDIF
ENDFOR
IF	EMPTY(lcPath)
	RETURN tcPathIni
ELSE
	RETURN tcPathIni + ',' + lcPath
ENDIF


*!* DigitoChequeo
*!* *************************************

FUNCTION DigitoChequeo(tnCodigo)
*!* Esta funcion trabaja correctamente para el digito de chequeo de Nits.

LOCAL lcCodigo, ;
	lnCount, ;
	lnDigito, ;
	laPrimos[15]

laPrimos[01] = 3
laPrimos[02] = 7
laPrimos[03] = 13
laPrimos[04] = 17
laPrimos[05] = 19
laPrimos[06] = 23
laPrimos[07] = 29
laPrimos[08] = 37
laPrimos[09] = 41
laPrimos[10] = 43
laPrimos[11] = 47
laPrimos[12] = 53
laPrimos[13] = 59
laPrimos[14] = 67
laPrimos[15] = 71

lcCodigo = StrZero(tnCodigo, 15, 0)

lnDigito = 0

FOR lnCount = 1 TO 15
    lnDigito = lnDigito + VAL(SUBSTR(lcCodigo, 16 - lnCount, 1)) * laPrimos[lnCount]
ENDFOR

lnDigito = lnDigito % 11

IF	lnDigito = 0 or ;
	lnDigito = 1
	RETURN(lnDigito)
ELSE
	RETURN(11 - lnDigito)
ENDIF


FUNCTION NotaAlfabetica(tnNotaNumerica, tnNivelAcademico)
LOCAL lnCount, ;
	lcCount, ;
	lcNotaAlfabetica

lcNotaAlfabetica = SPACE(2)

IF	! EMPTY(tnNotaNumerica)

	FOR lnCount = 1 TO 5

		lcCount = ALLTRIM(STR(lnCount))
		
		DO	CASE
			CASE tnNivelAcademico = 1  &&NIVEL_PREESCOLAR
				IF	tnNotaNumerica <= oEMPRESA.VrNumPE&lcCount
					lcNotaAlfabetica = oEMPRESA.VrAlfPE&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 2  &&NIVEL_BASICAPRIMARIA
				IF	tnNotaNumerica <= oEMPRESA.VrNumBP&lcCount
					lcNotaAlfabetica = oEMPRESA.VrAlfBP&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 3  &&NIVEL_BASICASECUNDARIA
				IF	tnNotaNumerica <= oEMPRESA.VrNumBS&lcCount
					lcNotaAlfabetica = oEMPRESA.VrAlfBS&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 4  &&NIVEL_EDUCACIONMEDIA
				IF	tnNotaNumerica <= oEMPRESA.VrNumMD&lcCount
					lcNotaAlfabetica = oEMPRESA.VrAlfMD&lcCount
					EXIT
				ENDIF
		ENDCASE
		
	ENDFOR
	
ENDIF

RETURN(lcNotaAlfabetica)

FUNCTION NotaNumerica(tcNotaAlfabetica, tnNivelAcademico)
LOCAL lnCount, ;
	lcCount, ;
	lnNotaNumerica

lnNotaNumerica = 0

IF	! EMPTY(tcNotaAlfabetica)

	FOR lnCount = 1 TO 5

		lcCount = ALLTRIM(STR(lnCount))
		
		DO	CASE
			CASE tnNivelAcademico = 1  &&NIVEL_PREESCOLAR
				IF	tcNotaAlfabetica = oEMPRESA.VrAlfPE&lcCount
					lnNotaNumerica = oEMPRESA.VrNumPE&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 2  &&NIVEL_BASICAPRIMARIA
				IF	tcNotaAlfabetica = oEMPRESA.VrAlfBP&lcCount
					lnNotaNumerica = oEMPRESA.VrNumBP&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 3  &&NIVEL_BASICASECUNDARIA
				IF	tcNotaAlfabetica = oEMPRESA.VrAlfBS&lcCount
					lnNotaNumerica = oEMPRESA.VrNumBS&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 4  &&NIVEL_EDUCACIONMEDIA
				IF	tcNotaAlfabetica = oEMPRESA.VrAlfMD&lcCount
					lnNotaNumerica = oEMPRESA.VrNumMD&lcCount
					EXIT
				ENDIF
		ENDCASE
		
	ENDFOR
	
ENDIF

RETURN(lnNotaNumerica)



FUNCTION DetalleAlfabetico(tcNotaAlfabetica, tnNivelAcademico)
LOCAL lnCount, ;
	lcCount, ;
	lcDetalleAlfabetico

lcDetalleAlfabetico = SPACE(15)

IF	! EMPTY(tcNotaAlfabetica)

	FOR lnCount = 1 TO 5

		lcCount = ALLTRIM(STR(lnCount))
		
		DO	CASE
			CASE tnNivelAcademico = 1  &&NIVEL_PREESCOLAR
				IF	tcNotaAlfabetica == oEMPRESA.VrAlfPE&lcCount
					lcDetalleAlfabetico = oEMPRESA.DetallePE&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 2  &&NIVEL_BASICAPRIMARIA
				IF	tcNotaAlfabetica == oEMPRESA.VrAlfBP&lcCount
					lcDetalleAlfabetico = oEMPRESA.DetalleBP&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 3  &&NIVEL_BASICASECUNDARIA
				IF	tcNotaAlfabetica == oEMPRESA.VrAlfBS&lcCount
					lcDetalleAlfabetico = oEMPRESA.DetalleBS&lcCount
					EXIT
				ENDIF
			CASE tnNivelAcademico = 4  &&NIVEL_EDUCACIONMEDIA
				IF	tcNotaAlfabetica == oEMPRESA.VrAlfMD&lcCount
					lcDetalleAlfabetico = oEMPRESA.DetalleMD&lcCount
					EXIT
				ENDIF
		ENDCASE
		
	ENDFOR
	
ENDIF

RETURN(lcDetalleAlfabetico)

FUNCTION LineaDetalleAlfabetico(tnNivelAcademico, tnTipoDetalle)
LOCAL lnCount, ;
	lcCount, ;
	lcCountAnt, ;
	lcDetalleAlfabetico

lcDetalleAlfabetico = ''

FOR lnCount = 1 TO 5

	lcCount = ALLTRIM(STR(lnCount))
	
	DO	CASE
		CASE tnNivelAcademico = 1  &&NIVEL_PREESCOLAR
			IF	! EMPTY(oEMPRESA.VrAlfPE&lcCount)
				DO	CASE
					CASE tnTipoDetalle = 1  && Solo alfab�tico
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							ALLTRIM(oEMPRESA.VrAlfPE&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + '  '
					CASE tnTipoDetalle = 2  && Alfab�tico y num�rico
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfPE&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + ;
								' (' + TRANSFORM(oEMPRESA.VrNumPE&lcCountAnt + 0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumPE&lcCount, '99.9') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfPE&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + ;
								' (' + TRANSFORM(0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumPE&lcCount, '99.9') + ')  '
						ENDIF
					CASE tnTipoDetalle = 3  && Alfab�tico y porcentajes
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfPE&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + ;
								' (' + TRANSFORM((oEMPRESA.VrNumPE&lcCountAnt + 0.1) * 10, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumPE&lcCount * 10, '999%') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfPE&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + ;
								' (' + TRANSFORM(1, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumPE&lcCount * 10, '999%') + ')  '
						ENDIF
					CASE tnTipoDetalle = 4  && Secuencia alfab�tica
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							lcCount + ' = ' + ALLTRIM(oEMPRESA.DetallePE&lcCount) + '  '
				ENDCASE
			ENDIF
		CASE tnNivelAcademico = 2  &&NIVEL_BASICAPRIMARIA
			IF	! EMPTY(oEMPRESA.VrAlfBP&lcCount)
				DO	CASE
					CASE tnTipoDetalle = 1  && Solo alfab�tico
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							ALLTRIM(oEMPRESA.VrAlfBP&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + '  '
					CASE tnTipoDetalle = 2  && Alfab�tico y num�rico
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBP&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + ;
								' (' + TRANSFORM(oEMPRESA.VrNumBP&lcCountAnt + 0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBP&lcCount, '99.9') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBP&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + ;
								' (' + TRANSFORM(0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBP&lcCount, '99.9') + ')  '
						ENDIF
					CASE tnTipoDetalle = 3  && Alfab�tico y porcentajes
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBP&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + ;
								' (' + TRANSFORM((oEMPRESA.VrNumBP&lcCountAnt + 0.1) * 10, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBP&lcCount * 10, '999%') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBP&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + ;
								' (' + TRANSFORM(1, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBP&lcCount * 10, '999%') + ')  '
						ENDIF
					CASE tnTipoDetalle = 4  && Secuencia alfab�tica
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							lcCount + ' = ' + ALLTRIM(oEMPRESA.DetalleBP&lcCount) + '  '
				ENDCASE
			ENDIF
		CASE tnNivelAcademico = 3  &&NIVEL_BASICASECUNDARIA
			IF	! EMPTY(oEMPRESA.VrAlfBS&lcCount)
				DO	CASE
					CASE tnTipoDetalle = 1  && Solo alfab�tico
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							ALLTRIM(oEMPRESA.VrAlfBS&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + '  '
					CASE tnTipoDetalle = 2  && Alfab�tico y num�rico
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBS&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + ;
								' (' + TRANSFORM(oEMPRESA.VrNumBS&lcCountAnt + 0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBS&lcCount, '99.9') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBS&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + ;
								' (' + TRANSFORM(0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBS&lcCount, '99.9') + ')  '
						ENDIF
					CASE tnTipoDetalle = 3  && Alfab�tico y porcentajes
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBS&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + ;
								' (' + TRANSFORM((oEMPRESA.VrNumBS&lcCountAnt + 0.1) * 10, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBS&lcCount * 10, '999%') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfBS&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + ;
								' (' + TRANSFORM(1, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumBS&lcCount * 10, '999%') + ')  '
						ENDIF
					CASE tnTipoDetalle = 4  && Secuencia alfab�tica
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							lcCount + ' = ' + ALLTRIM(oEMPRESA.DetalleBS&lcCount) + '  '
				ENDCASE
			ENDIF
		CASE tnNivelAcademico = 4  &&NIVEL_EDUCACIONMEDIA
			IF	! EMPTY(oEMPRESA.VrAlfMD&lcCount)
				DO	CASE
					CASE tnTipoDetalle = 1  && Solo alfab�tico
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							ALLTRIM(oEMPRESA.VrAlfMD&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + '  '
					CASE tnTipoDetalle = 2  && Alfab�tico y num�rico
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfMD&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + ;
								' (' + TRANSFORM(oEMPRESA.VrNumMD&lcCountAnt + 0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumMD&lcCount, '99.9') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfMD&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + ;
								' (' + TRANSFORM(0.1, '99.9') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumMD&lcCount, '99.9') + ')  '
						ENDIF
					CASE tnTipoDetalle = 3  && Alfab�tico y porcentajes
						IF	lnCount > 1
							lcCountAnt = ALLTRIM(STR(lnCount - 1))
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfMD&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + ;
								' (' + TRANSFORM((oEMPRESA.VrNumMD&lcCountAnt + 0.1) * 10, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumMD&lcCount * 10, '999%') + ')  '
						ELSE
							lcDetalleAlfabetico = lcDetalleAlfabetico + ;
								ALLTRIM(oEMPRESA.VrAlfMD&lcCount) + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + ;
								' (' + TRANSFORM(1, '999%') + ;
								'-' + TRANSFORM(oEMPRESA.VrNumMD&lcCount * 10, '999%') + ')  '
						ENDIF
					CASE tnTipoDetalle = 4  && Secuencia alfab�tica
						lcDetalleAlfabetico = lcDetalleAlfabetico + ;
							lcCount + ' = ' + ALLTRIM(oEMPRESA.DetalleMD&lcCount) + '  '
				ENDCASE
			ENDIF
	ENDCASE
	
ENDFOR

RETURN(lcDetalleAlfabetico)

FUNCTION DetalleTipoEvaluacion(tnTipoEvaluacion)

LOCAL lcDetalleTipoEvaluacion

lcDetalleTipoEvaluacion = SPACE(10)

DO	CASE
	CASE tnTipoEvaluacion = 1  &&TIPOEVALUACION_NIVELO
		lcDetalleTipoEvaluacion = PADR('NIVEL�', 10)
	CASE tnTipoEvaluacion = 2  &&TIPOEVALUACION_RECUPERO
		lcDetalleTipoEvaluacion = PADR('RECUPER�', 10)
	CASE tnTipoEvaluacion = 3  &&TIPOEVALUACION_HOMOLOGO
		lcDetalleTipoEvaluacion = PADR('HOMOLOG�', 10)
	CASE tnTipoEvaluacion = 4  &&TIPOEVALUACION_VALIDO
		lcDetalleTipoEvaluacion = PADR('VALID�', 10)
ENDCASE

RETURN(lcDetalleTipoEvaluacion)

FUNCTION DetalleTipoCiencia

LOCAL lcDetalle, ;
	lnCount, ;
	laTipoCiencia[1]

lcDetalle = ''

SELECT Valor, Detalle ;
	FROM GENERAL ;
	WHERE Campo = 'TipoCiencia' ;
	INTO ARRAY laTipoCiencia

IF	_TALLY > 0

	FOR lnCount = 1 TO ALEN(laTipoCiencia, 1)
	
		lcDetalle = lcDetalle + ALLTRIM(STR(laTipoCiencia[lnCount, 1])) + ' = ' + ;
					ALLTRIM(laTipoCiencia[lnCount, 2]) + '   '
		
	ENDFOR
	
ENDIF

RETURN lcDetalle

FUNCTION val_tm
PARAMETERS p1
IF ! EMPTY(p1)
	IF LEFT(p1,2) < '00' .OR. ;
			LEFT(p1,2) > '24' .OR. ;
			RIGHT(p1,2) < '00' .OR. ;
			RIGHT(p1,2) > '59'
		RETURN(.F.)
	ENDIF
ENDIF
RETURN(.T.)

FUNCTION fec_360
PARAMETERS p1,p2
PRIVATE ano_i,ano_f,mes_i,mes_f,dia_i,dia_f,dias
IF p1 < p2
	RETURN(0)
ENDIF
ano_f = YEAR(p1)
mes_f = MONTH(p1)
dia_f = DAY(p1)
ano_i = YEAR(p2)
mes_i = MONTH(p2)
dia_i = DAY(p2)
IF dia_f < dia_i
	dia_f = dia_f + 30
	mes_f = mes_f - 1
ENDIF
IF mes_f < mes_i
	mes_f = mes_f + 12
	ano_f = ano_f - 1
ENDIF
dias = dia_f - dia_i + 1 + (mes_f - mes_i) * 30 + (ano_f - ano_i) * 360
RETURN(dias)

FUNCTION val_nta
PARAMETERS m.nota
PRIVATE i
IF UPPER(m.nota) = clg.no_eval
	RETURN(.T.)
ENDIF
FOR i = 1 TO 10
	DO CASE
	CASE grd.nivel = 'P'
		IF UPPER(m.nota) = SUBSTR(clg.pe_letras, (i - 1) * 2 + 1, 2)
			RETURN(.T.)
		ENDIF
	CASE grd.nivel = 'B'
		IF UPPER(m.nota) = SUBSTR(clg.bp_letras, (i - 1) * 2 + 1, 2)
			RETURN(.T.)
		ENDIF
	CASE grd.nivel = 'S'
		IF UPPER(m.nota) = SUBSTR(clg.bs_letras, (i - 1) * 2 + 1, 2)
			RETURN(.T.)
		ENDIF
	CASE grd.nivel = 'M'
		IF UPPER(m.nota) = SUBSTR(clg.md_letras, (i - 1) * 2 + 1, 2)
			RETURN(.T.)
		ENDIF
	ENDCASE
NEXT i
RETURN(.F.)

FUNCTION nta_num
PARAMETERS m.nota
PRIVATE i
FOR i = 1 TO 10
	DO CASE
	CASE grd.nivel = 'P'
		IF UPPER(m.nota) = SUBSTR(clg.pe_letras, (i - 1) * 2 + 1, 2)
			RETURN(VAL(SUBSTR(clg.pe_valor, (i - 1) * 3 + 1, 3)))
		ENDIF
	CASE grd.nivel = 'B'
		IF UPPER(m.nota) = SUBSTR(clg.bp_letras, (i - 1) * 2 + 1, 2)
			RETURN(VAL(SUBSTR(clg.bp_valor, (i - 1) * 3 + 1, 3)))
		ENDIF
	CASE grd.nivel = 'S'
		IF UPPER(m.nota) = SUBSTR(clg.bs_letras, (i - 1) * 2 + 1, 2)
			RETURN(VAL(SUBSTR(clg.bs_valor, (i - 1) * 3 + 1, 3)))
		ENDIF
	CASE grd.nivel = 'M'
		IF UPPER(m.nota) = SUBSTR(clg.md_letras, (i - 1) * 2 + 1, 2)
			RETURN(VAL(SUBSTR(clg.md_valor, (i - 1) * 3 + 1, 3)))
		ENDIF
	ENDCASE
NEXT i
RETURN(0)

FUNCTION nta_alf
PARAMETERS m.nota
PRIVATE i
FOR i = 1 TO 10
	DO CASE
	CASE grd.nivel = 'P'
		IF m.nota * 10 <= VAL(SUBSTR(clg.pe_valor, (i - 1) * 3 + 1, 3))
			RETURN(SUBSTR(clg.pe_letras, (i - 1) * 2 + 1, 2))
		ENDIF
	CASE grd.nivel = 'B'
		IF m.nota * 10 <= VAL(SUBSTR(clg.bp_valor, (i - 1) * 3 + 1, 3))
			RETURN(SUBSTR(clg.bp_letras, (i - 1) * 2 + 1, 2))
		ENDIF
	CASE grd.nivel = 'S'
		IF m.nota * 10 <= VAL(SUBSTR(clg.bs_valor, (i - 1) * 3 + 1, 3))
			RETURN(SUBSTR(clg.bs_letras, (i - 1) * 2 + 1, 2))
		ENDIF
	CASE grd.nivel = 'M'
		IF m.nota * 10 <= VAL(SUBSTR(clg.md_valor, (i - 1) * 3 + 1, 3))
			RETURN(SUBSTR(clg.md_letras, (i - 1) * 2 + 1, 2))
		ENDIF
	ENDCASE
NEXT i
RETURN('')

FUNCTION nta_prc
PARAMETERS m.periodo
DO CASE
CASE grd.nivel = 'P'
	RETURN(VAL(SUBSTR(clg.pe_porc, (m.periodo - 1) * 5 + 1, 5)) / 100)
CASE grd.nivel = 'B'
	RETURN(VAL(SUBSTR(clg.bp_porc, (m.periodo - 1) * 5 + 1, 5)) / 100)
CASE grd.nivel = 'S'
	RETURN(VAL(SUBSTR(clg.bs_porc, (m.periodo - 1) * 5 + 1, 5)) / 100)
CASE grd.nivel = 'M'
	RETURN(VAL(SUBSTR(clg.md_porc, (m.periodo - 1) * 5 + 1, 5)) / 100)
ENDCASE
RETURN(0.00)

*!*	FUNCTION nta_lgr
*!*	PARAMETERS m.grado, m.curso, m.asignatura, m.nota
*!*	IF ! evl(m.grado + m.curso + m.asignatura + LEFT(m.nota, 2), 'lgr', 'C', '')
*!*		IF ! evl(m.grado + SPACE(LEN(m.curso)) + m.asignatura + LEFT(m.nota, 2), 'lgr', 'C', '')
*!*			RETURN('')
*!*		ENDIF
*!*	ENDIF
*!*	IF ! EMPTY(lgr.enlace) AND ;
*!*			lgr.enlace # lgr.grado + lgr.CURSO + lgr.asignatura + lgr.logro
*!*		= evl(lgr.enlace, 'lgr', 'C', '')
*!*	ENDIF
*!*	RETURN(ALLTRIM(lgr.texto))

*!*	FUNCTION nta_cpt
*!*	PARAMETERS m.grado, m.curso, m.asignatura, m.nota
*!*	IF LEN(TRIM(m.nota)) <= 3
*!*		RETURN('')
*!*	ENDIF

*!*	* Logro
*!*	IF ! evl(m.grado + m.curso + m.asignatura + LEFT(m.nota, 2), 'lgr', 'C', '')
*!*		IF ! evl(m.grado + SPACE(LEN(m.curso)) + m.asignatura + LEFT(m.nota, 2), 'lgr', 'C', '')
*!*			RETURN('')
*!*		ENDIF
*!*	ENDIF

*!*	* Indicador de logro
*!*	IF ! evl(m.grado + m.curso + m.asignatura + m.nota, 'lgr', 'C', '')
*!*		IF ! evl(m.grado + SPACE(LEN(m.curso)) + m.asignatura + m.nota, 'lgr', 'C', 'Indicador de logro')

*!*	* Indicadores independientes (generales)
*!*			IF ! evl(m.grado + SPACE(LEN(m.curso)) + SPACE(LEN(m.asignatura)) + SPACE(2) + RIGHT(m.nota, 2), 'lgr', 'C', '')
*!*				IF ! evl(SPACE(LEN(m.grado)) + SPACE(LEN(m.curso)) + SPACE(LEN(m.asignatura)) + SPACE(2) + RIGHT(m.nota, 2), 'lgr', 'C', 'Indicador de logro')
*!*					RETURN('')
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF

*!*	IF ! EMPTY(lgr.enlace) AND ;
*!*			lgr.enlace # lgr.grado + lgr.CURSO + lgr.asignatura + lgr.logro + lgr.indicador
*!*		= evl(lgr.enlace, 'lgr', 'C', '')
*!*	ENDIF
*!*	RETURN(ALLTRIM(lgr.texto))

*!*	FUNCTION nta_dsr
*!*	PARAMETERS m.grado, m.curso, m.asignatura, m.nota
*!*	IF ! evl(m.grado + m.curso + m.asignatura + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*		IF ! evl(m.grado + m.curso + SPACE(LEN(m.asignatura)) + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*			IF ! evl(m.grado + SPACE(LEN(m.curso)) + m.asignatura + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*				IF ! evl(m.grado + SPACE(LEN(m.curso)) + SPACE(LEN(m.asignatura)) + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*					IF ! evl(SPACE(LEN(m.grado)) + m.curso + m.asignatura + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*						IF ! evl(SPACE(LEN(m.grado)) + m.curso + SPACE(LEN(m.asignatura)) + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*							IF ! evl(SPACE(LEN(m.grado)) + SPACE(LEN(m.curso)) + m.asignatura + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', '')
*!*								IF ! evl(SPACE(LEN(m.grado)) + SPACE(LEN(m.curso)) + SPACE(LEN(m.asignatura)) + SPACE(LEN(lgr.logro)) + m.nota, 'lgr', 'C', 'Desarrollo')
*!*									RETURN('')
*!*								ENDIF
*!*							ENDIF
*!*						ENDIF
*!*					ENDIF
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF
*!*	IF ! EMPTY(lgr.enlace) AND ;
*!*			lgr.enlace # lgr.grado + lgr.CURSO + lgr.asignatura + lgr.indicador
*!*		= evl(LEFT(lgr.enlace, 9) + SPACE(2) + SUBSTR(lgr.enlace, 10, 3), 'lgr', 'C', '')
*!*	ENDIF
*!*	RETURN(lgr.texto)


*!***********************************************************************************
*! Function Name: WriteLog()
*! Description: Write to a Log File or Foxpro free table or to WIN NT/WIN 2K Events
*! Parameters: tcAction->Action that has/will be taken. (Character)
*!  tnResult->Result of Action. (Numeric - See Logging Code below)
*!  tcOther->Any other information that should be noted. (String)
*! Returns: Nothing
*! Logging Code: 0 ->  Successful
*!  1  ->  Failed
*!  2  ->  Warning
*!  4  ->  Information
*!  8  ->  Audit Success
*!  16 ->  Audit Failure
*! Notes: Any Items marked optional with [braces] need to have a
*!  blank string passed into the function.
*!  For more Information email me (vreboton@hotmail.com)
*!***********************************************************************************

FUNCTION WriteLog(tiId, tiProceso, tcDetalle, tnTipoLogging)

LOCAL lcOldError, ;
		llError, ;
		lcOldAlias, ;
		lcLogFileName, ;
		lcLogInfo, ;
		WSHShell, ;
		lcTableName

lcOldError = ON('ERROR')
ON ERROR llError = .T.

lcOldAlias = ALIAS()

*-- Check to See what type of logging was selected
DO CASE
	CASE tnTipoLogging = 1 && No Logging

    CASE tnTipoLogging = 2 && Text File Logging

		*-- Create the Log file Name that will be used
		SELECT 0
		USE SYS_AUDITORIA
		lcLogFileName = STRTRAN(DBF(), 'SYS_AUDITORIA.DBF', 'Log' + STRTRAN(DTOC(DATE()), '/', '-') + '.txt')
		USE

		*-- Create New Log information
		lcLogInfo = TTOC(DATETIME()) + ', ' + ;
					ALLTRIM(STR(tiId)) + ', ' + ;
					IIF(! INLIST(tiProceso, 1, 2, 3, 4), '', lcOldAlias) + ', ' + ;
      				oAplicacion.cUsuario + ', ' + ;
      				STR(tiIdProceso) + ', ' + ;
      				tcDetalle

		*-- Write new entry to text file
		= STRTOFILE(lcLogInfo + CRLF, lcLogFileName, .T.)

    CASE tnTipoLogging = 3 && Foxpro free table Logging

		SELECT 0
		USE SYS_AUDITORIA SHARED AGAIN

		llError = .T.

		DO WHILE llError

			llError = .F.

			APPEND BLANK
			
			IF	llError

				SET MESSAGE TO 'Registro no disponible...'
				INKEY(1, 'H')
				
			ENDIF
			
		ENDDO

		SET MESSAGE TO ''

		DO WHILE ! RLOCK()
		
			INKEY(1, 'H')
			
		ENDDO

		REPLACE SYS_AUDITORIA.Fecha WITH DATETIME(), ;
				SYS_AUDITORIA.Id WITH tiId, ;
				SYS_AUDITORIA.Alias WITH IIF(! INLIST(tiProceso, 1, 2, 3, 4), '', lcOldAlias), ;
				SYS_AUDITORIA.Usuario WITH oAplicacion.cUsuario, ;
				SYS_AUDITORIA.Proceso WITH tiProceso, ;
				SYS_AUDITORIA.Detalle WITH tcDetalle

						
		FLUSH
		
		UNLOCK
		
		USE

    CASE tnTipoLogging = 4 && Event Log Logging

		*-- Build New Log information Line
		lcLogInfo = TTOC(DATETIME()) + ', ' + ;
					ALLTRIM(STR(tiId)) + ', ' + ;
					IIF(! INLIST(tiProceso, 1, 2, 3, 4), '', lcOldAlias) + ', ' + ;
      				oAplicacion.cUsuario + ', ' + ;
      				STR(tiIdProceso) + ', ' + ;
      				tcDetalle

		*-- Create Window scripting host object
		WSHShell = CREATEOBJECT("WScript.Shell")

		*-- Write Log Information
		IF	! llError
			WSHShell.LogEvent(8, lcLogInfo)
		ENDIF

		*-- Destroy Object
		WSHShell = NULL

ENDCASE

IF	! EMPTY(lcOldAlias)
	SELECT (lcOldAlias)
ENDIF

ON ERROR &lcOldError

ENDFUNC



*--------------------------------------------------------------------------
* PROGRAMA: CodBar.prg 
* FECHA   : 2000/04/25
* AUTOR   : Luis Mar�a Guay�n
* E-MAIL  : luis.guayan@vicentetrapani.com
*--------------------------------------------------------------------------
* Estas funciones convierten una cadena de caracteres a los siguientes 
* formatos:
*   Codigo 39    : _StrTo39()
*   Codigo 128-A : _StrTo128A()
*   Codigo 128-B : _StrTo128B()
*   Codigo 128-C : _StrTo128C()
*   Codigo EAN-13: _StrToEan13()
*   Codigo EAN-8 : _StrToEan8()
*--------------------------------------------------------------------------
* FUNCTION _StrTo39(tcString)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type Barcode 3 of 9
* USO: _StrTo39("Codigo 39")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrTo39(tcString)
	lcRet = "*"+tcString+"*"
	RETURN lcRet
ENDFUNC

*--------------------------------------------------------------------------
* FUNCTION _StrTo128A(tcString)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type Barcode 128 A
* Caracteres num�ricos y alfabeticos (solo may�sculas)
* Si un caracter es no v�lido lo remplaza por espacio
* USO: _StrTo128A("CODIGO 128")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrTo128A(tcString)

	LOCAL lcStart, lcStop, lcRet, lcCheck, ;
		lnLong, lnI, lnCheckSum, lnAsc

	lcStart = CHR(103 + 32)
	lcStop = CHR(106 + 32)
	lnCheckSum = ASC(lcStart) - 32

	lcRet = tcString
	lnLong = LEN(lcRet)
	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
		IF NOT BETWEEN(lnAsc, 0, 64)
			lcRet = STUFF(lcRet,lnI,1,CHR(32))
			lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
		ENDIF
		lnCheckSum = lnCheckSum + (lnAsc * lnI)
	ENDFOR
	lcCheck = CHR(MOD(lnCheckSum,103) + 32)
	lcRet = lcStart + lcRet + lcCheck + lcStop
	*--- Esto es para cambiar los espacios y caracteres invalidos
	lcRet = STRTRAN(lcRet, CHR(32), CHR(232))
	lcRet = STRTRAN(lcRet, CHR(127), CHR(192))
	lcRet = STRTRAN(lcRet, CHR(128), CHR(193))
	*---
	RETURN lcRet
ENDFUNC

*--------------------------------------------------------------------------
* FUNCTION _StrTo128B(tcString)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type Barcode 128 B
* Caracteres num�ricos y alfabeticos (may�sculas y min�sculas)
* Si un caracter es no v�lido lo remplaza por espacio
* USO: _StrTo128B("Codigo 128")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrTo128B(tcString)

	LOCAL lcStart, lcStop, lcRet, lcCheck, ;
		lnLong, lnI, lnCheckSum, lnAsc

	lcStart = CHR(104 + 32)
	lcStop = CHR(106 + 32)
	lnCheckSum = ASC(lcStart) - 32

	lcRet = tcString
	lnLong = LEN(lcRet)
	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
		IF NOT BETWEEN(lnAsc, 0, 99)
			lcRet = STUFF(lcRet,lnI,1,CHR(32))
			lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
		ENDIF
		lnCheckSum = lnCheckSum + (lnAsc * lnI)
	ENDFOR
	lcCheck = CHR(MOD(lnCheckSum,103) + 32)
	lcRet = lcStart + lcRet + lcCheck + lcStop
	*--- Esto es para cambiar los espacios y caracteres invalidos
	lcRet = STRTRAN(lcRet, CHR(32), CHR(232))
	lcRet = STRTRAN(lcRet, CHR(127), CHR(192))
	lcRet = STRTRAN(lcRet, CHR(128), CHR(193))
	*---
	RETURN lcRet
ENDFUNC

*--------------------------------------------------------------------------
* FUNCTION _StrTo128C(tcString)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type Barcode 128 C
* Solo caracteres num�ricos
* USO: _StrTo128C("01234567")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrTo128C(tcString)

	LOCAL lcStart, lcStop, lcRet, lcCheck, lcCar, ;
		lnLong, lnI, lnCheckSum, lnAsc

	lcStart = CHR(105 + 32)
	lcStop = CHR(106 + 32)
	lnCheckSum = ASC(lcStart) - 32

	lcRet = ALLTRIM(tcString)
	lnLong = LEN(lcRet)
	*--- La longitud debe ser par
	IF MOD(lnLong,2) # 0
		lcRet = "0" + lcRet
		lnLong = LEN(lcRet)
	ENDIF

	*--- Convierto los pares a caracteres
	lcCar = ""
	FOR lnI = 1 TO lnLong STEP 2
		lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 32)
	ENDFOR
	lcRet = lcCar
	lnLong = LEN(lcRet)

	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
		lnCheckSum = lnCheckSum + (lnAsc * lnI)
	ENDFOR
	lcCheck = CHR(MOD(lnCheckSum,103) + 32)
	lcRet = lcStart + lcRet + lcCheck + lcStop
	*--- Esto es para cambiar los espacios y caracteres invalidos
	lcRet = STRTRAN(lcRet, CHR(32), CHR(232))
	lcRet = STRTRAN(lcRet, CHR(127), CHR(192))
	lcRet = STRTRAN(lcRet, CHR(128), CHR(193))
	*---
	RETURN lcRet
ENDFUNC

*--------------------------------------------------------------------------
* FUNCTION _StrToEan13(tcString, .T.)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type EAN-13
* PARAMETROS:
*   tcString: Caracter de 12 d�gitos (0..9)
*   tlCheckD: .T. Solo genera el d�gito de control
*             .F. Genera d�gito y caracteres a imprimir
* USO: _StrToEan13("123456789012")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrToEan13(tcString, tlCheckD)

	LOCAL lcLat, lcMed, lcRet, lcJuego, ;
		lcIni, lcResto, lcCod, ;
		lnI, lnCheckSum, lnAux, laJuego(10), lnPri

	lcRet=ALLTRIM(tcString)

	IF LEN(lcRet) # 12
		*--- Error en par�metro
		*--- debe tener un len = 12
		RETURN ""
	ENDIF

	*--- Genero d�gito de control
	lnCheckSum=0
	FOR lnI = 1 TO 12
		IF MOD(lnI,2) = 0
			lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 3
		ELSE
			lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 1
		ENDIF
	ENDFOR
	lnAux = MOD(lnCheckSum,10)
	lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0, 0, 10-lnAux)))

	IF tlCheckD
		*--- Si solo genero d�gito de control
		RETURN lcRet
	ENDIF

	*--- Para imprimir con fuente True Type EAN13
	*--- 1er. d�gito (lnPri)
	lnPri = VAL(LEFT(lcRet, 1))
	*--- Tabla de Juegos de Caracteres
	*--- seg�n "lnPri" (�NO CAMBIAR!)
	laJuego(1) = "AAAAAACCCCCC"   && 0
	laJuego(2) = "AABABBCCCCCC"   && 1
	laJuego(3) = "AABBABCCCCCC"   && 2
	laJuego(4) = "AABBBACCCCCC"   && 3
	laJuego(5) = "ABAABBCCCCCC"   && 4
	laJuego(6) = "ABBAABCCCCCC"   && 5
	laJuego(7) = "ABBBAACCCCCC"   && 6
	laJuego(8) = "ABABABCCCCCC"   && 7
	laJuego(9) = "ABABBACCCCCC"   && 8
	laJuego(10) = "ABBABACCCCCC"   && 9

	*--- Caracter inicial (fuera del c�digo)
	lcIni = CHR(lnPri + 35)
	*--- Caracteres lateral y central
	lcLat = CHR(33)
	lcMed = CHR(45)

	*--- Resto de los caracteres
	lcResto = SUBS(lcRet, 2, 12)
	FOR lnI = 1 TO 12
		lcJuego = SUBS(laJuego(lnPri + 1), lnI, 1)
		DO CASE
			CASE lcJuego = "A"
				lcResto = STUFF(lcResto, lnI, 1, CHR(VAL(SUBS(lcResto, lnI, 1))+48))
			CASE lcJuego = "B"
				lcResto = STUFF(lcResto, lnI, 1, CHR(VAL(SUBS(lcResto, lnI, 1))+65))
			CASE lcJuego = "C"
				lcResto = STUFF(lcResto, lnI, 1, CHR(VAL(SUBS(lcResto, lnI, 1))+97))
		ENDCASE
	ENDFOR

	*--- Armo c�digo
	lcCod = lcIni + lcLat + SUBS(lcResto,1,6) + lcMed + SUBS(lcResto,7,6) + lcLat
	RETURN lcCod
ENDFUNC


*--------------------------------------------------------------------------
* FUNCTION _StrToEan8(tcString, .T.)
*--------------------------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type EAN-8
* PARAMETROS:
*   tcString: Caracter de 7 d�gitos (0..9)
*   tlCheckD: .T. Solo genera el d�gito de control
*             .F. Genera d�gito y caracteres a imprimir
* USO: _StrToEan8("1234567")
* RETORNA: Caracter
* AUTOR: Luis Mar�a Guay�n
*--------------------------------------------------------------------------
FUNCTION _StrToEan8(tcString, tlCheckD)

	LOCAL lcLat, lcMed, lcRet, ;
		lcIni, lcCod, ;
		lnI, lnCheckSum, lnAux

	lcRet=ALLTRIM(tcString)

	IF LEN(lcRet) # 7
		*--- Error en par�metro
		*--- debe tener un len = 7
		RETURN ""
	ENDIF

	*--- Genero d�gito de control
	lnCheckSum=0
	FOR lnI = 1 TO 7
		IF MOD(lnI,2) = 0
			lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 3
		ELSE
			lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 1
		ENDIF
	ENDFOR
	lnAux = MOD(lnCheckSum,10)
	lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0, 0, 10-lnAux)))

	IF tlCheckD
		*--- Si solo genero d�gito de control
		RETURN lcRet
	ENDIF

	*--- Para imprimir con fuente True Type EAN8
	*--- Caracteres lateral y central
	lcLat = CHR(33)
	lcMed = CHR(45)

	*--- Caracteres
	FOR lnI = 1 TO 8
		IF lnI <= 4
			lcRet = STUFF(lcRet, lnI, 1, CHR(VAL(SUBS(lcRet, lnI, 1))+48))
		ELSE
			lcRet = STUFF(lcRet, lnI, 1, CHR(VAL(SUBS(lcRet, lnI, 1))+97))
		ENDIF
	ENDFOR

	*--- Armo c�digo
	lcCod = lcLat + SUBS(lcRet,1,4) + lcMed + SUBS(lcRet,5,4) + lcLat
	RETURN lcCod
ENDFUNC

*--------------------------------------------------------------------------
* FIN CodBar.prg
*--------------------------------------------------------------------------

FUNCTION TomaNombre(tcNombre, tcTipo, tnPosicion)

LOCAL lcNombre

DO	CASE
	CASE tcTipo = 'N'  && Nombre
	
		lcNombre = ' ' + ALLTRIM(SUBSTR(tcNombre, AT(',', tcNombre) + 1))
	
	CASE tcTipo = 'A'  && Apellido

		lcNombre = ' ' + ALLTRIM(LEFT(tcNombre, AT(',', tcNombre) - 1))
		 
	OTHERWISE
	
		lcNombre = tcNombre
		 
ENDCASE

IF	tnPosicion # 0

	lcNombre = SUBSTR(lcNombre, ;
				 AT(' ', lcNombre, tnPosicion) + 1, ;
				 IIF(AT(' ', lcNombre, tnPosicion + 1) # 0, ;
				 	AT(' ', lcNombre, tnPosicion + 1) - AT(' ', lcNombre, tnPosicion) - 1, ;
				 	LEN(lcNombre) - AT(' ', lcNombre, tnPosicion) + 1))

ENDIF

RETURN ALLTRIM(lcNombre)


FUNCTION SaltoPagina(tlForzado)
IF	tlForzado OR ;
	MOD(_PAGENO, 2) # 0
	IF	SYS(2040) = '2'
		EJECT PAGE
	ENDIF
ENDIF
RETURN


FUNCTION ParpadeaVentana
*** Opciones De Parpadeo
#Define FlashW_Stop  0 &&Para el Parpadeo de una ventana.
#Define FlashW_Caption 0x1 &&Hace Parpadear El Titulo de Una Ventana
#Define FlashW_Tray  0x2 &&Hace Parpadear la Ventana en la TaskBar
#Define FlashW_All  3&&Parpadea El Titulo de la ventana y en la Taskbar
#Define FlashW_Timer  0x4 &&Parpadea Infinitamente, o hasta Enviar Un FlashW_Stop
#Define FlashW_TimerNoFg  0xC &&Parpadea hasta que Se Active la Ventana
*** Declaracion de Las Apis
Declare Long FlashWindowEx In "user32" String @CFlashWInfo
Declare Long FindWindow In User32 String cClass, String cCaption
*** Inicia El Codigo
Local cFlashInfo
cFlashInfo =Space(20)
*** Creamos La Estructura
cFlashInfo = Num2dWord(20)+; &&Longitud de la Estructura 
	Num2dWord(FindWindow(.Null.,_SCREEN.Caption))+; &&Handle de la Ventana a "Flashear"
	Num2dWord(FlashW_All+FlashW_TimerNoFg)+; &&Opciones
	Num2dWord(0)+;  && Cantidad de Veces que Parpadeara (0 =Infinito)
	Num2dWord(0)  && Tiempo entre Parpadeo (en Milisegundos, 0=Default)
*** Hacemos Parpadear la Ventana. 
FlashWindowEx(@cFlashInfo)

FUNCTION Num2dWord(tnNum)
Local c0,c1,c2,c3
lcresult = Chr(0)+Chr(0)+Chr(0)+Chr(0)
If tnNum < (2^31 - 1) then
	c3 = Chr(Int(tnNum/(256^3)))
	tnNum = Mod(tnNum,256^3)
	c2 = Chr(Int(tnNum/(256^2)))
	tnNum = Mod(tnNum,256^2)
	c1 = Chr(Int(tnNum/256))
	c0 = Chr(Mod(tnNum,256))
	lcresult = c0+c1+c2+c3
Endif
Return (lcresult)


FUNCTION DigitoChequeoDavivienda(tcNit)

LOCAL lnFactor1, ;
	lnFactor2, ;
	lnSuma1, ;
	lnSuma2, ;
	lnCount, ;
	lnParcial

IF	(LEN(ALLTRIM(tcNit)) % 2) = 0
	lnFactor1 = 1
	lnFactor2 = 3
ELSE
	lnFactor1 = 2
	lnFactor2 = 1
ENDIF

lnSuma1 = 0
lnSuma2 = 0

FOR lnCount = 1 TO LEN(ALLTRIM(tcNit))

	lnParcial = VAL(SUBSTR(tcNit, lnCount, 1)) * lnFactor1

	IF	lnParcial >= 10
		lnParcial = VAL(LEFT(ALLTRIM(STR(lnParcial)), 1)) + ;
					VAL(RIGHT(ALLTRIM(STR(lnParcial)), 1))
	ENDIF

	lnSuma1 = lnSuma1 + lnParcial 

	lnParcial = VAL(SUBSTR(tcNit, lnCount, 1)) * lnFactor2

	IF	lnParcial >= 10
		lnParcial = VAL(LEFT(ALLTRIM(STR(lnParcial)), 1)) + ;
					VAL(RIGHT(ALLTRIM(STR(lnParcial)), 1))
	ENDIF

	lnSuma2 = lnSuma2 + lnParcial 

	IF	lnFactor1 = 1
		lnFactor1 = 2
	ELSE
		lnFactor1 = 1
	ENDIF

	IF	lnFactor2 = 1
		lnFactor2 = 3
	ELSE
		lnFactor2 = 1
	ENDIF
	
ENDFOR

RETURN (RIGHT(ALLTRIM(STR(lnSuma1)), 1) + RIGHT(ALLTRIM(STR(lnSuma2)), 1))


FUNCTION SeekSQL(tcField, tcAlias, tcIndex)

LOCAL lcOldAlias, ;
	llFound

IF	oAplicacion.nTipoDB = TIPODB_VFP

	RETURN (SEEK(tcField, tcAlias, tcIndex))
	
ELSE

	lcOldAlias = ALIAS()

	SELECT (tcAlias)
	
	IF	TYPE('tcField') = 'C'
		LOCATE FOR &tcIndex == tcField
	ELSE
		LOCATE FOR &tcIndex = tcField
	ENDIF
	
	IF	FOUND()
		llFound = .T.
	ELSE
		llFound = .F.
	ENDIF
	
	IF	! EMPTY(lcOldAlias)
		SELECT (lcOldAlias)
	ENDIF
	
	RETURN (llFound)

ENDIF


FUNCTION ValidaEMail(tcEMail)

LOCAL loRegExp, llValid

IF VARTYPE(tcEMail) <> 'C'
	RETURN .F.
ENDIF
*	
loRegExp = CreateObject('VBScript.RegExp')
loRegExp.IgnoreCase = .T.
*!* OPCION POR DEFECTO
loRegExp.Pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)�*)\.([A-Za-z]{2,})$'
*!* OPCION 2
loRegExp.Pattern = '\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+'
llValid = loRegExp.Test(ALLTRIM(tcEMail))

RELEASE loRegExp

RETURN llValid


FUNCTION DireccionURL(tcDireccion)

tcDireccion = UPPER(tcDireccion)

tcDireccion = STRTRAN(tcDireccion, '�', 'A')
tcDireccion = STRTRAN(tcDireccion, '�', 'E')
tcDireccion = STRTRAN(tcDireccion, '�', 'I')
tcDireccion = STRTRAN(tcDireccion, '�', 'O')
tcDireccion = STRTRAN(tcDireccion, '�', 'U')
tcDireccion = STRTRAN(tcDireccion, '�', 'N')
tcDireccion = STRTRAN(tcDireccion, '�', 'a')
tcDireccion = STRTRAN(tcDireccion, '�', 'e')
tcDireccion = STRTRAN(tcDireccion, '�', 'i')
tcDireccion = STRTRAN(tcDireccion, '�', 'o')
tcDireccion = STRTRAN(tcDireccion, '�', 'u')
tcDireccion = STRTRAN(tcDireccion, '�', 'n')

tcDireccion = STRTRAN(tcDireccion, ' -', '-')
tcDireccion = STRTRAN(tcDireccion, '- ', '-')
*!* tcDireccion = STRTRAN(tcDireccion, '#', '')
tcDireccion = STRTRAN(tcDireccion, 'No.', '#')
tcDireccion = STRTRAN(tcDireccion, 'N.', '#')

tcDireccion = STRTRAN(tcDireccion, '   ', ' ')
tcDireccion = STRTRAN(tcDireccion, '  ', ' ')

IF	LEFT(tcDireccion, 2) = 'CR' OR ;
	LEFT(tcDireccion, 3) = 'CAR' OR ;
	LEFT(tcDireccion, 2) = 'KR'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), 'CARRERA')
ENDIF

IF	LEFT(tcDireccion, 3) = 'CAL' OR ;
	LEFT(tcDireccion, 2) = 'CL'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), 'CALLE')
ENDIF

IF	LEFT(tcDireccion, 3) = 'DIA' OR ;
	LEFT(tcDireccion, 2) = 'DG'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), 'DIAGONAL')
ENDIF

IF	LEFT(tcDireccion, 3) = 'TRA' OR ;
	LEFT(tcDireccion, 2) = 'TR'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), 'TRANSVERSAL')
ENDIF

IF	LEFT(tcDireccion, 2) = 'AV'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), '')
ENDIF

IF	LEFT(tcDireccion, 2) = 'AUTOP'
	tcDireccion = STRTRAN(tcDireccion, LEFT(tcDireccion, AT(' ', tcDireccion, 1) - 1), '')
ENDIF

RETURN tcDireccion

FUNCTION PdfCreatorReport(tcNameReport, tcNameDirTarget, tcNameFilePdf)

LOCAL oPdf as Object
oPdf = CREATEOBJECT("PDFCreator.PDFCreatorObj")
oPdf.cStartoPdf.cVisible = .T.
oPdf.cclearCache
oPdf.cPrinterStop = .F.
oPdf.cOption("AutosaveDirectory") = tcNameDirTarget
oPdf.cOption("AutosaveFilename") = tcNameFilePdf 
oPdf.cOption("UseAutosave") = 1
oPdf.cOption("UseAutosaveDirectory") = 1
oPdf.cOption("AutosaveFormat") = 0
oPdf.cSaveOptions()
SET PRINTER TO NAME 'PDFCreator'

REPORT FORM (tcNameReport) TO PRINTER NOCONSOLE

oPdf.cClearCache
oPdf.cClose
oPdf = NULL

RETURN

