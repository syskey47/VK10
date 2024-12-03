

FUNCTION GetNumericAmountInLetters(tnAmount, tcFillChar)

LOCAL cAmount, cAmountInLetters

IF	tnAmount > 999999999999.99 OR ;
	tnAmount < 0.00
	RETURN('** Invalid Amount **')
ENDIF
DO CASE
   CASE PARAMETERS() = 1
		tcFillChar = ' '
   CASE PARAMETERS() = 2
   		IF	tcFillChar = CHR(0)
   			tcFillChar = ''
   		ENDIF
   		IF	LEN(tcFillChar) > 1
   			tcFillChar = LEFT(tcFillChar, 1)
   		ENDIF
ENDCASE

cAmount = ALLTRIM(LEFT(STR(tnAmount, 15, 2), 12))
cAmountInLetters = ''

DO	WHILE LEN(cAmount) > 0
	cTempAmount = cAmount
	DO	WHILE LEN(cTempAmount) > 3
		cTempAmount = SUBSTR(cTempAmount, 1, LEN(cTempAmount) - 3)
	ENDDO
	cAmountInLetters = cAmountInLetters + CalculateAmountInLetters(cTempAmount)
	DO CASE
	   CASE LEN(cAmount) > 9
	   		IF	VAL(cTempAmount) > 0
	   			cAmountInLetters = cAmountInLetters + 'mil '
	   		ENDIF
	   CASE LEN(cAmount) > 6
	   		IF	VAL(cTempAmount) = 1
	   			cAmountInLetters = cAmountInLetters + 'millón '
	   		ELSE
	   			cAmountInLetters = cAmountInLetters + 'millones '
	   		ENDIF
	   CASE LEN(cAmount) > 3
	   		IF	VAL(cTempAmount) > 0
	   			cAmountInLetters = cAmountInLetters + 'mil '
	   		ENDIF
	   OTHERWISE
	   		IF	INT(tnAmount) = 1
		   		cAmountInLetters = cAmountInLetters + 'peso '
		   	ELSE
		   		IF	INT(tnAmount) >= 1000000 AND ;
	   				INT(tnAmount) % 1000000 = 0
			   		cAmountInLetters = cAmountInLetters + 'de pesos '
			   	ELSE
			   		cAmountInLetters = cAmountInLetters + 'pesos '
			   	ENDIF
		   	ENDIF
	ENDCASE
	cAmount = SUBSTR(cAmount, LEN(cTempAmount) + 1)
ENDDO
IF	INT(tnAmount) = 0
	cAmountInLetters = 'cero pesos '
ENDIF
cAmountInLetters = cAmountInLetters + 'con ' + ;
					ALLTRIM(STR((tnAmount - INT(tnAmount)) * 100, 2, 0)) + '/100 ' + ;
					'm./cte.'
					
cAmountInLetters = STRTRAN(UPPER(cAmountInLetters), ' ', tcFillChar)

RETURN cAmountInLetters



FUNCTION CalculateAmountInLetters(tcTempAmount)

LOCAL aAmntInLetters, cAmountInLetters, nDigit

cAmountInLetters = ''
IF	LEN(tcTempAmount) < 3
	tcTempAmount = PADL(tcTempAmount, 3)
ENDIF

DECLARE aAmntInLetters[9, 4]

aAmntInLetters[1, 1] = 'un '
aAmntInLetters[2, 1] = 'dos '
aAmntInLetters[3, 1] = 'tres '
aAmntInLetters[4, 1] = 'cuatro '
aAmntInLetters[5, 1] = 'cinco '
aAmntInLetters[6, 1] = 'seis '
aAmntInLetters[7, 1] = 'siete '
aAmntInLetters[8, 1] = 'ocho '
aAmntInLetters[9, 1] = 'nueve '
aAmntInLetters[1, 2] = 'once '
aAmntInLetters[2, 2] = 'doce '
aAmntInLetters[3, 2] = 'trece '
aAmntInLetters[4, 2] = 'catorce '
aAmntInLetters[5, 2] = 'quince '
aAmntInLetters[6, 2] = 'dieciseis '
aAmntInLetters[7, 2] = 'diecisiete '
aAmntInLetters[8, 2] = 'dieciocho '
aAmntInLetters[9, 2] = 'diecinueve '
aAmntInLetters[1, 3] = 'diez '
aAmntInLetters[2, 3] = 'veinte '
aAmntInLetters[3, 3] = 'treinta '
aAmntInLetters[4, 3] = 'cuarenta '
aAmntInLetters[5, 3] = 'cincuenta '
aAmntInLetters[6, 3] = 'sesenta '
aAmntInLetters[7, 3] = 'setenta '
aAmntInLetters[8, 3] = 'ochenta '
aAmntInLetters[9, 3] = 'noventa '
aAmntInLetters[1, 4] = 'ciento '
aAmntInLetters[2, 4] = 'doscientos '
aAmntInLetters[3, 4] = 'trescientos '
aAmntInLetters[4, 4] = 'cuatrocientos '
aAmntInLetters[5, 4] = 'quinientos '
aAmntInLetters[6, 4] = 'seiscientos '
aAmntInLetters[7, 4] = 'setecientos '
aAmntInLetters[8, 4] = 'ochocientos '
aAmntInLetters[9, 4] = 'novecientos '

nDigitHundreds = VAL(LEFT(tcTempAmount, 1))
nDigitTenth		= VAL(SUBSTR(tcTempAmount, 2, 1))
nDigitUnits		= VAL(RIGHT(tcTempAmount, 1))

IF	nDigitHundreds > 0
	IF	nDigitHundreds = 1
		IF	VAL(tcTempAmount) = 100
			cAmountInLetters = cAmountInLetters + 'cien '
		ELSE
   			cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitHundreds, 4]
		ENDIF
	ELSE
		cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitHundreds, 4]
	ENDIF
ENDIF

IF	nDigitTenth > 0
	IF	nDigitTenth = 1
		IF	nDigitUnits > 0
   			cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitUnits, 2]
   		ELSE
			cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitTenth, 3]
			IF	nDigitUnits > 0
				cAmountInLetters = cAmountInLetters + 'y '
			ENDIF
		ENDIF
	ELSE
		cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitTenth, 3]
		IF	nDigitUnits > 0
			cAmountInLetters = cAmountInLetters + 'y '
		ENDIF
	ENDIF
ENDIF

IF	nDigitUnits > 0
	IF	nDigitTenth # 1
		cAmountInLetters = cAmountInLetters + aAmntInLetters[nDigitUnits, 1]
	ENDIF
ENDIF

RETURN cAmountInLetters

   		
