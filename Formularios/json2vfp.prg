LPARAMETERS tcJson

LOCAL loJSon, ;
	lcObj, ;
	lcCampo, ;
	lcValue, ;
	llCampo, ;
	llOpen, ;
	lnPos, ;
	lnLen, ;
	lnPorc, ;
	lnPorAnt, ;
	lnReg, ;
	lcTipo, ;
	laProp[1]

CLEAR 

SET MESSAGE TO ''

*!*	TEXT TO tcJson PRETEXT 15 NOSHOW 
*!*	[{"course_student":{
*!*			"id":89578,
*!*			"course_id":5106,
*!*			"current":true,
*!*			"number":"201500001",
*!*			"date":null,
*!*			"student":{
*!*				"id":1849,
*!*				"code":20110052,
*!*				"person":{
*!*					"id":2337,
*!*					"name1":"SANTIAGO",
*!*					"name2":"",
*!*					"lastname1":"AMEZQUITA",
*!*					"lastname2":"CALDAS",
*!*					"identification":"1019842970",
*!*					"address":"CRA 55 # 151-69, TORRE 5 APTO 701",
*!*					"phone":"4870164",
*!*					"email":"santiagoamc@gmoderno.co",
*!*					"document_type":{
*!*						"id":6,
*!*						"name":"Número Único de Identificación Personal",
*!*						"initials":"N.U.I.P."
*!*					}
*!*				},
*!*				"guardian":{
*!*					"id":1913,
*!*					"company":"CONSTRUCTORA COLPATRIA",
*!*					"work_address":"CARRERA 54A 127A 45",
*!*					"work_phone":"6439080",
*!*					"person":{
*!*						"id":5391,
*!*						"name1":"ANDRES",
*!*						"name2":"ALFONSO",
*!*						"lastname1":"AMEZQUITA",
*!*						"lastname2":"LOZADA",
*!*						"identification":"79940874",
*!*						"address":"CRA 55 # 151-69 TORRE 5 APTO 701",
*!*						"phone":"4870164",
*!*						"email":"andres.amezquita@gmail.com",
*!*						"document_type":{
*!*							"id":1,
*!*							"name":"Cédula de ciudadanía",
*!*							"initials":"C.C."
*!*						}
*!*					}
*!*				}
*!*			}
*!*		}
*!*	},
*!*	{"course_student":{
*!*			"id":89579,
*!*			"course_id":5106,
*!*			"current":true,
*!*			"number":"201500002",
*!*			"date":null,
*!*			"student":{
*!*				"id":1850,
*!*				"code":20110051,
*!*				"person":{
*!*					"id":2338,
*!*					"name1":"TOMAS",
*!*					"name2":"",
*!*					"lastname1":"ANGEL",
*!*					"lastname2":"SANCHEZ",
*!*					"identification":"1016912472",
*!*					"address":"Carrera 12 # 102-06 apto 402",
*!*					"phone":"7588902",
*!*					"email":"tomasas@gmoderno.co",
*!*					"document_type":{
*!*						"id":6,
*!*						"name":"Número Único de Identificación Personal",
*!*						"initials":"N.U.I.P."
*!*					}
*!*				},
*!*				"guardian":{
*!*					"id":1917,
*!*					"company":"",
*!*					"work_address":"",
*!*					"work_phone":"",
*!*					"person":{
*!*						"id":5395,
*!*						"name1":"JUAN",
*!*						"name2":"PABLO",
*!*						"lastname1":"ANGEL",
*!*						"lastname2":"CASTILLO",
*!*						"identification":"80420111",
*!*						"address":"yerbabonita Bosque nativo casa 41",
*!*						"phone":"8639344",
*!*						"email":"jpangelc@gmail.com",
*!*						"document_type":{
*!*							"id":1,
*!*							"name":"Cédula de ciudadanía",
*!*							"initials":"C.C."
*!*						}
*!*					}
*!*				}
*!*			}
*!*		}
*!*	}]
*!*	ENDTEXT 

*!* tcJson = FILETOSTR('estudiantes_saberes.txt')

loJson = CREATEOBJECT('empty')

lcObj = ''

lcCampo = ''
lcValue = ''
llCampo = .F.
llOpen = .F.

lnPos = 1
lnLen = LEN(tcJSon)
lnPorc = 0
lnPorcAnt = 0

FOR	lnPos = 1 TO lnLen

	lcChar = SUBSTR(tcJSon, lnPos, 1)
	lcChar2 = SUBSTR(tcJSon, lnPos, 2)

	DO	CASE
		CASE lcChar $ '[]'

		CASE lcChar = '{'

			lcObj = 'loJson'
			llCampo = .T.

		CASE lcChar2 = ':{'

			IF	lcObj == 'loJson'
			
				IF	AMEMBERS(laProp, &lcObj, 0) > 0
				
					IF	ASCAN(laProp, UPPER(lcCampo)) > 0
					
						&lcObj..Count = &lcObj..Count + 1
						lnReg = ALEN(&lcObj..&lcCampo, 1)
						DIMENSION &lcObj..&lcCampo.[lnReg + 1]
						lcObj = lcObj + '.' + lcCampo + '[' + ALLTRIM(STR(lnReg + 1)) + ']'
						&lcObj = CREATEOBJECT('empty')
						
					ELSE

						ADDPROPERTY(&lcObj., 'Count', 1)
						ADDPROPERTY(&lcObj., lcCampo + '[1]')
						lcObj = lcObj + '.' + lcCampo + '[1]'
						&lcObj = CREATEOBJECT('empty')
					
					ENDIF
					
				ELSE
				
					ADDPROPERTY(&lcObj., 'Count', 1)
					ADDPROPERTY(&lcObj., lcCampo + '[1]')
					lcObj = lcObj + '.' + lcCampo + '[1]'
					&lcObj = CREATEOBJECT('empty')
					
				ENDIF
				
			ELSE
				ADDPROPERTY(&lcObj., lcCampo)
				lcObj = lcObj + '.' + lcCampo
				&lcObj = CREATEOBJECT('empty')
			ENDIF
			lcCampo = ''

			lnPos = lnPos + 1 		

		CASE lcChar = ':'
		
			llCampo = .F.
			
			IF	RIGHT(lcChar2, 1) = '"'
				lcTipo = 'C'
			ELSE
				lcTipo = 'N'
			ENDIF

		CASE lcChar = '"'
		
			llOpen = ! llOpen

		CASE lcChar = ','

			IF	! llOpen
				IF	! EMPTY(lcCampo)
				
					IF	lcTipo = 'C'
						IF	SUBSTR(lcValue, 5, 1) = '-' AND ;
							SUBSTR(lcValue, 8, 1) = '-'
							IF	SUBSTR(lcValue, 14, 1) = ':' AND ;
								SUBSTR(lcValue, 17, 1) = ':'
								IF	! EMPTY(CTOT(lcValue))
									ADDPROPERTY(&lcObj., lcCampo, CTOT(lcValue))
								ELSE
									ADDPROPERTY(&lcObj., lcCampo, lcValue)
								ENDIF
							ELSE
								IF	! EMPTY(CTOD(lcValue))
									ADDPROPERTY(&lcObj., lcCampo, CTOD(lcValue))
								ELSE
									ADDPROPERTY(&lcObj., lcCampo, lcValue)
								ENDIF
							ENDIF
						ELSE
							ADDPROPERTY(&lcObj., lcCampo, lcValue)
						ENDIF 
					ELSE
						DO	CASE
							CASE INLIST(UPPER(lcValue), 'TRUE', 'FALSE')
								ADDPROPERTY(&lcObj., lcCampo, IIF(UPPER(lcValue) = 'TRUE', .T., .F.))
							CASE 'NULL' $ UPPER(lcValue)
								ADDPROPERTY(&lcObj., lcCampo, NULL)
							OTHERWISE
								ADDPROPERTY(&lcObj., lcCampo, VAL(lcValue))
						ENDCASE
					ENDIF
					
					lcCampo = ''
					lcValue = ''
					llCampo = .T.
				ENDIF
			ELSE
				lcValue = lcValue + lcChar
			ENDIF
				
		CASE lcChar = '}'

			IF	! llOpen
				IF	! EMPTY(lcCampo)
				
					IF	lcTipo = 'C'
						IF	SUBSTR(lcValue, 5, 1) = '-' AND ;
							SUBSTR(lcValue, 8, 1) = '-'
							IF	SUBSTR(lcValue, 14, 1) = ':' AND ;
								SUBSTR(lcValue, 17, 1) = ':'
								IF	! EMPTY(CTOT(lcValue))
									ADDPROPERTY(&lcObj., lcCampo, CTOT(lcValue))
								ELSE
									ADDPROPERTY(&lcObj., lcCampo, lcValue)
								ENDIF
							ELSE
								IF	! EMPTY(CTOD(lcValue))
									ADDPROPERTY(&lcObj., lcCampo, CTOD(lcValue))
								ELSE
									ADDPROPERTY(&lcObj., lcCampo, lcValue)
								ENDIF
							ENDIF
						ELSE
							ADDPROPERTY(&lcObj., lcCampo, lcValue)
						ENDIF 
					ELSE
						DO	CASE
							CASE INLIST(UPPER(lcValue), 'TRUE', 'FALSE')
								ADDPROPERTY(&lcObj., lcCampo, IIF(UPPER(lcValue) = 'TRUE', .T., .F.))
							CASE 'NULL' $ UPPER(lcValue)
								ADDPROPERTY(&lcObj., lcCampo, NULL)
							OTHERWISE
								ADDPROPERTY(&lcObj., lcCampo, VAL(lcValue))
						ENDCASE
					ENDIF
					
					lcCampo = ''
					lcValue = ''
					llCampo = .T.
				ENDIF
			ELSE
				lcValue = lcValue + lcChar
			ENDIF

			lcObj = LEFT(lcObj, RAT('.', lcObj) - 1)
		
		CASE lcChar = ' '
		
			IF	! llCampo
				lcValue = lcValue + lcChar
			ENDIF

		OTHERWISE
		
			IF	llCampo
				IF	! EMPTY(LEFT(tcJson, 1))
					lcCampo = lcCampo + lcChar
				ENDIF
			ELSE
				lcValue = lcValue + lcChar
			ENDIF
			
	ENDCASE
	
	lnPorc = ROUND(lnPos / lnLen * 100, 0)
	
	IF	lnPorc <> lnPorcAnt
		SET MESSAGE TO 'JSON2VFP ' + ALLTRIM(STR(lnPorc)) + '% ' + REPLICATE('|', lnPorc)
		lnPorcAnt = lnPorc
	ENDIF
	
ENDFOR

RETURN loJSon
