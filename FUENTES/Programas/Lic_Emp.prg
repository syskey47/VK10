LOCAL Codigo, Licencia, Cadena, pos_f, lActivo

Empresa = 'Avianca S. A.     '

Cadena = ALLTRIM(UPPER(Empresa))
DO	WHILE (AT('  ', Cadena) > 0)
	Cadena = STRTRAN(Cadena, '  ', ' ')
ENDDO

Codigo = ALLTRIM(SYS(2007, TTOC(DateTime())))
Licencia = SYS(2007, Codigo)
lActivo = .F.
DO	WHILE ! EMPTY(Cadena)
	pos_f = AT(' ', Cadena)
	IF	EMPTY(pos_f)
		pos_f = LEN(Cadena)
	ELSE
		pos_f = pos_f - 1
	ENDIF
	IF	lActivo
		Licencia = Licencia + CHR(VAL(SYS(2007, SUBSTR(Cadena, 1, pos_f) + Codigo)) % 94 + 32) + ;
					SYS(2007, SUBSTR(Cadena, 1, pos_f))
	ELSE
		Licencia = Licencia + CHR(VAL(SYS(2007, SUBSTR(Cadena, 1, pos_f))) % 94 + 32) + ;
					SYS(2007, SUBSTR(Cadena, 1, pos_f) + Codigo)
	ENDIF
	lActivo = ! lActivo
	IF	pos_f >= LEN(Cadena)
		Cadena = ''
	ELSE
		Cadena = SUBSTR(Cadena, pos_f + 2)
	ENDIF
ENDDO
? Licencia
? Codigo

* Para validar la informacion, se digita:
* 1. Nombre empresa
* 2. Licencia
* 3. Codigo
* Se hace la misma rutina de generacion y si las licencias coinciden, entonces
* la Empresa es valida.
* Si no coincide la licencia no se deja instalar la empresa.

