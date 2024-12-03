xEmpresa = PADR('INFORMÁTICA Y GESTIÓN S. A.', 60)
xVersion = '5.0.0  '


LOCAL aModulo[6, 3]
LOCAL cLicencia, cCod_Instal, cVersion, cCadena, lSwitchActivo, nCount

aModulo[1, 1] = 'CO'
aModulo[1, 2] = 'Contabilidad'
aModulo[1, 3] = .f.
aModulo[2, 1] = 'CC'
aModulo[2, 2] = 'CuentasxCobrar'
aModulo[2, 3] = .f.
aModulo[3, 1] = 'CP'
aModulo[3, 2] = 'CuentasxPagar'
aModulo[3, 3] = .f.
aModulo[4, 1] = 'IN'
aModulo[4, 2] = 'Inventarios'
aModulo[4, 3] = .f.
aModulo[5, 1] = 'NO'
aModulo[5, 2] = 'Nomina'
aModulo[5, 3] = .f.
aModulo[6, 1] = 'NT'
aModulo[6, 2] = 'Notas'
aModulo[6, 3] = .f.
*!*	aModulo[7, 1] = 'BB'
*!*	aModulo[7, 2] = 'Biblioteca'
*!*	aModulo[7, 3] = .f.
*!*	aModulo[8, 1] = ''
*!*	aModulo[8, 2] = ''
*!*	aModulo[8, 3] = .f.
*!*	aModulo[9, 1] = ''
*!*	aModulo[9, 2] = ''
*!*	aModulo[9, 3] = .f.
*!*	aModulo[10, 1] = ''
*!*	aModulo[10, 2] = ''
*!*	aModulo[10, 3] = .f.

cVersion = ALLTRIM(xVersion)

* Se eliminan los espacios intermedios sobrantes,
* solo se deja uno entre palabras
cCadena = ALLTRIM(UPPER(xEmpresa))
DO	WHILE (AT('  ', cCadena) > 0)
	cCadena = STRTRAN(cCadena, '  ', ' ')
ENDDO

aModulo[1, 3] = .T.
aModulo[2, 3] = .F.
aModulo[3, 3] = .T.
aModulo[4, 3] = .F.
aModulo[5, 3] = .T.
aModulo[6, 3] = .F.
*	aModulo[7, 3] = .chkBiblioteca.Value

* Se genera el código de instalación con base en el instante 
* en que se genero la licencia. no se invluye la versión
* por empresa, pues la misma licencia sierve 
* para todas las versiones. Pero si se involucra el nombre
cInstante = TTOC(DateTime())
cCod_Instal = ALLTRIM(SYS(2007, cCadena + cInstante))

cLicencia = RIGHT(SYS(2007, cCod_Instal), 2)
lSwitchActivo = .F.
FOR	nCount = 1 TO ALEN(aModulo, 1)
	cLicencia = cLicencia + aModulo[nCount, 1]
	IF	aModulo[nCount, 3]
		IF	lSwitchActivo
			cLicencia = cLicencia + RIGHT(SYS(2007, aModulo[nCount, 1]), 2) + ;
						CHR(VAL(SYS(2007, '1' + aModulo[nCount, 2] + cCod_Instal)) % 94 + 32)
		ELSE
			cLicencia = cLicencia + RIGHT(SYS(2007, aModulo[nCount, 1] + cCod_Instal), 2) + ;
						CHR(VAL(SYS(2007, '1' + aModulo[nCount, 2])) % 94 + 32)
		ENDIF
		lSwitchActivo = ! lSwitchActivo
	ELSE
		cLicencia = cLicencia + CHR(VAL(SYS(2007, '0' + aModulo[nCount, 2] + cCod_Instal)) % 94 + 32)
	ENDIF
ENDFOR

? cLicencia
? cCod_Instal

IF	LicEmp(cLicencia, cCod_Instal)
	? 'OK'
ENDIF

RETURN
