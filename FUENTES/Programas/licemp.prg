LPARAMETERS xLicencia, xCodigo

cEmpresaPrd = PADR('INFORMÁTICA Y GESTIÓN S. A.', 60)

LOCAL llLicenciaValida, ;
	lcNombreEmpresa, ;
	lcCodigoEmp, ;
	lnCount, ;
	llSwitchActivo, ;
	lcLicencia, ;
	lcRestoLicAct, ;
	lcRestoLicNAct, ;
	lcModulo

LOCAL laModulo[6, 3]
laModulo[1, 1] = 'CO'
laModulo[1, 2] = 'Contabilidad'
laModulo[1, 3] = .F.
laModulo[2, 1] = 'CC'
laModulo[2, 2] = 'CuentasxCobrar'
laModulo[2, 3] = .F.
laModulo[3, 1] = 'CP'
laModulo[3, 2] = 'CuentasxPagar'
laModulo[3, 3] = .F.
laModulo[4, 1] = 'IN'
laModulo[4, 2] = 'Inventarios'
laModulo[4, 3] = .F.
laModulo[5, 1] = 'NO'
laModulo[5, 2] = 'Nomina'
laModulo[5, 3] = .F.
laModulo[6, 1] = 'NT'
laModulo[6, 2] = 'Notas'
laModulo[6, 3] = .F.

llLicenciaValida = .T.

	IF	EMPTY(cEmpresaPrd) OR ;
		EMPTY(xLicencia) OR ;
		EMPTY(xCodigo)
		llLicenciaValida = .F.
	ENDIF
	
	IF	llLicenciaValida
		* Se eliminan los espacios intermedios sobrantes,
		* solo se deja uno entre palabras
		lcNombreEmpresa = ALLTRIM(UPPER(cEmpresaPrd))
		DO	WHILE (AT('  ', lcNombreEmpresa) > 0)
			lcNombreEmpresa = STRTRAN(lcNombreEmpresa, '  ', ' ')
		ENDDO

		lcCodigoEmp = ALLTRIM(xCodigo)
		IF	RIGHT(SYS(2007, lcCodigoEmp), 2) # LEFT(xLicencia, 2)
			llLicenciaValida = .f.
		ENDIF
	ENDIF

	IF	llLicenciaValida
		lcLicencia = RIGHT(SYS(2007, lcCodigoEmp), 2)
		llSwitchActivo = .F.
		FOR	lnCount = 1 TO ALEN(laModulo, 1)
			lcLicencia = lcLicencia + laModulo[lnCount, 1]
			
			IF	llSwitchActivo
				lcRestoLicAct = RIGHT(SYS(2007, laModulo[lnCount, 1]), 2) + ;
							CHR(VAL(SYS(2007, '1' + laModulo[lnCount, 2] + lcCodigoEmp)) % 94 + 32)
			ELSE
				lcRestoLicAct = RIGHT(SYS(2007, laModulo[lnCount, 1] + lcCodigoEmp), 2) + ;
							CHR(VAL(SYS(2007, '1' + laModulo[lnCount, 2])) % 94 + 32)
			ENDIF
			
			lcRestoLicNAct = CHR(VAL(SYS(2007, '0' + laModulo[lnCount, 2] + lcCodigoEmp)) % 94 + 32)
			
			IF	lcRestoLicAct == SUBSTR(xLicencia, LEN(lcLicencia) + 1, 3)
				lcLicencia = lcLicencia + lcRestoLicAct
				laModulo[lnCount, 3] = .T.
				llSwitchActivo = ! llSwitchActivo
			ELSE
				lcLicencia = lcLicencia + lcRestoLicNAct
				laModulo[lnCount, 3] = .F.
			ENDIF
		ENDFOR
		IF	ALLTRIM(xLicencia) # lcLicencia
			llLicenciaValida = .F.
		ENDIF
	ENDIF

	IF	llLicenciaValida
		FOR lnCount = 1 TO ALEN(laModulo, 1)
			? laModulo[lnCount, 1], laModulo[lnCount, 2], laModulo[lnCount, 3]
		ENDFOR
	ENDIF


RETURN llLicenciaValida
