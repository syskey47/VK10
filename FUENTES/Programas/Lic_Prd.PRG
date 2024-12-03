LOCAL aModulo[5, 3]
LOCAL cLicencia, cCod_Instal, cVersion, lActivo
LOCAL inst_co, inst_cp, inst_cc, inst_no, inst_in

aModulo[1, 1] = 'CO'
aModulo[1, 2] = 'Contabilidad'
aModulo[1, 3] = .f.
aModulo[2, 1] = 'NO'
aModulo[2, 2] = 'Nomina'
aModulo[2, 3] = .f.
aModulo[3, 1] = 'CP'
aModulo[3, 2] = 'CuentasxPagar'
aModulo[3, 3] = .f.
aModulo[4, 1] = 'CC'
aModulo[4, 2] = 'CuentasxCobrar'
aModulo[4, 3] = .f.
aModulo[5, 1] = 'IN'
aModulo[5, 2] = 'Inventarios'
aModulo[5, 3] = .f.

cVersion = '5.0.0'


@ 5,5  say 'Contabilidad :' get inst_co
@ 6,5  say 'Nómina       :' get inst_no
@ 7,5  say 'C x P        :' get inst_cp
@ 8,5  say 'C x C        :' get inst_cc
@ 9,5  say 'Inventarios  :' get inst_in
@ 10,5 say 'Versión      :' get cVersion
read

aModulo[1, 3] = inst_co
aModulo[2, 3] = inst_no
aModulo[3, 3] = inst_cp
aModulo[4, 3] = inst_cc
aModulo[5, 3] = inst_in

cCod_Instal = ALLTRIM(SYS(2007, TTOC(DATETIME())))

cLicencia = RIGHT(SYS(2007, cVersion + cCod_Instal), 2)
lActivo = .F.
FOR	i = 1 TO ALEN(aModulo, 1)
	cLicencia = cLicencia + aModulo[i, 1]
	IF	aModulo[i, 3]
		IF	lActivo
			cLicencia = cLicencia + RIGHT(SYS(2007, aModulo[i, 1]), 3) + ;
						CHR(VAL(SYS(2007, '1' + aModulo[i, 2] + cCod_Instal)) % 94 + 32)
		ELSE
			cLicencia = cLicencia + RIGHT(SYS(2007, aModulo[i, 1] + cCod_Instal), 3) + ;
						CHR(VAL(SYS(2007, '1' + aModulo[i, 2])) % 94 + 32)
		ENDIF
		lActivo = ! lActivo
	ELSE
		cLicencia = cLicencia + CHR(VAL(SYS(2007, '0' + aModulo[i, 2] + cCod_Instal)) % 94 + 32)
	ENDIF
ENDFOR

? cLicencia
? cCod_Instal

RETURN
