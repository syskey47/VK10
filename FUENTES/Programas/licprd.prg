PARAMETERS xLicencia, xCodigoPrd

cEmpresaPrd = PADR('INFORMÁTICA Y GESTIÓN S. A.', 60)

LOCAL llLicenciaValida, ;
	lcNombreEmpresa, ;
	lcCodigoInstalacion, ;
	lcLicencia, ;
	lnPos_f, ;
	llSwitchActivo

llLicenciaValida = .T.

IF	EMPTY(cEmpresaPrd) OR ;
	EMPTY(xLicencia) OR ;
	EMPTY(xCodigoPrd)
	llLicenciaValida = .F.
ENDIF

IF	llLicenciaValida
	* Se eliminan los espacios intermedios sobrantes,
	* solo se deja uno entre palabras
	lcNombreEmpresa = ALLTRIM(UPPER(cEmpresaPrd))
	DO	WHILE (AT('  ', lcNombreEmpresa) > 0)
		lcNombreEmpresa = STRTRAN(lcNombreEmpresa, '  ', ' ')
	ENDDO

	lcCodigoInstalacion = ALLTRIM(xCodigoPrd)

	lcLicencia = SYS(2007, lcCodigoInstalacion)
	llSwitchActivo = .F.
	DO	WHILE ! EMPTY(lcNombreEmpresa)
		lnPos_f = AT(' ', lcNombreEmpresa)
		IF	EMPTY(lnPos_f)
			lnPos_f = LEN(lcNombreEmpresa)
		ELSE
			lnPos_f = lnPos_f - 1
		ENDIF
		IF	llSwitchActivo
			lcLicencia = lcLicencia + CHR(VAL(SYS(2007, SUBSTR(lcNombreEmpresa, 1, lnPos_f) + lcCodigoInstalacion)) % 94 + 32) + ;
						SYS(2007, SUBSTR(lcNombreEmpresa, 1, lnPos_f))
		ELSE
			lcLicencia = lcLicencia + CHR(VAL(SYS(2007, SUBSTR(lcNombreEmpresa, 1, lnPos_f))) % 94 + 32) + ;
						SYS(2007, SUBSTR(lcNombreEmpresa, 1, lnPos_f) + lcCodigoInstalacion)
		ENDIF
		llSwitchActivo = ! llSwitchActivo
		IF	lnPos_f >= LEN(lcNombreEmpresa)
			lcNombreEmpresa = ''
		ELSE
			lcNombreEmpresa = SUBSTR(lcNombreEmpresa, lnPos_f + 2)
		ENDIF
	ENDDO

	IF	ALLTRIM(xLicencia) # lcLicencia
		llLicenciaValida = .F.
	ENDIF
ENDIF
	
RETURN llLicenciaValida
