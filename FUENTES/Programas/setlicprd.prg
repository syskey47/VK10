xEmpresaPrd = PADR('INFORMÁTICA Y GESTIÓN S. A.', 60)
xVersion = '5.0.0  '

LOCAL cVersion, cCadena, cInstante, cCodigo, cLicencia, nPos_f, lSwitchActivo

cVersion = ALLTRIM(xVersion)

* Se eliminan los espacios intermedios sobrantes,
* solo se deja uno entre palabras
cCadena = ALLTRIM(UPPER(xEmpresaPrd))
DO	WHILE (AT('  ', cCadena) > 0)
	cCadena = STRTRAN(cCadena, '  ', ' ')
ENDDO

* Se genera el código de instalación con base en la versión y
* el instante en que se genero la licencia. Esto obliga a que
* por cada actualización de versión se actualice la licencia
* para evitar piratería
cInstante = TTOC(DateTime())
cCodigo = ALLTRIM(SYS(2007, cVersion + cInstante))

cLicencia = SYS(2007, cCodigo)
lSwitchActivo = .F.
DO	WHILE ! EMPTY(cCadena)
	nPos_f = AT(' ', cCadena)
	IF	EMPTY(nPos_f)
		nPos_f = LEN(cCadena)
	ELSE
		nPos_f = nPos_f - 1
	ENDIF
	IF	lSwitchActivo
		cLicencia = cLicencia + CHR(VAL(SYS(2007, SUBSTR(cCadena, 1, nPos_f) + cCodigo)) % 94 + 32) + ;
					SYS(2007, SUBSTR(cCadena, 1, nPos_f))
	ELSE
		cLicencia = cLicencia + CHR(VAL(SYS(2007, SUBSTR(cCadena, 1, nPos_f))) % 94 + 32) + ;
					SYS(2007, SUBSTR(cCadena, 1, nPos_f) + cCodigo)
	ENDIF
	lSwitchActivo = ! lSwitchActivo
	IF	nPos_f >= LEN(cCadena)
		cCadena = ''
	ELSE
		cCadena = SUBSTR(cCadena, nPos_f + 2)
	ENDIF
ENDDO

? cLicencia
? cCodigo

IF	LicPrd(cLicencia, cCodigo)
	? 'OK'
ENDIF
