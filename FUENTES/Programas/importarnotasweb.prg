#INCLUDE ..\otros\Projecto.h

LOCAL lnPeriodoOriginal, ;
	lnPeriodo, ;
	lnNivelAcademico, ;
	lnTotalDimCog, ;
	lnTotalDimArg, ;
	lnTotalDimPrp, ;
	lnTotalDimCom, ;
	lnTotalDimPrc, ;
	lnTotalInd, ;
	lnPromedioCog, ;
	lnPromedioArg, ;
	lnPromedioPrp, ;
	lnPromedioCom, ;
	lnPromedioPrc, ;
	lnPromedioInd, ;
	lnExtCog, ;
	lnExtArg, ;
	lnExtPrp, ;
	lnExtCom, ;
	lnExtPrc, ;
	lnTotalExtCog, ;
	lnTotalExtArg, ;
	lnTotalExtPrp, ;
	lnTotalExtCom, ;
	lnTotalExtPrc, ;
	lnDefinitivaNumerica, ;
	lnPromedio

MESSAGEBOX('Haga clic para iniciar el proceso.')

lnPeriodoOriginal = VAL(INPUTBOX('Período a importar:', 'IMPORTAR NOTAS', '0', 0, '0', '0'))

IF	BETWEEN(lnPeriodoOriginal, 1, 4) OR ;
	INLIST(lnPeriodoOriginal, 11, 21, 31, 41)

	DO	CASE
		CASE lnPeriodoOriginal = 11
			lnPeriodo = 1
		CASE lnPeriodoOriginal = 21
			lnPeriodo = 2
		CASE lnPeriodoOriginal = 31
			lnPeriodo = 3
		CASE lnPeriodoOriginal = 41
			lnPeriodo = 4
		OTHERWISE
			lnPeriodo = lnPeriodoOriginal
	ENDCASE

	SELECT 0
	USE NTA_GRADOS ORDER TAG Id
	SELECT 0
	USE NTA_ASIGNATURASXGRADO ORDER TAG Id
	SELECT 0
	USE NTA_EVALUACIONES ORDER TAG Id
	SELECT 0
	USE NTA_PARCIALES ORDER TAG Id
	SELECT 0
	USE NTA_DIMENSIONES ORDER TAG Id
	
	SELECT 0
	USE Internet\Notas

	SCAN
	
		SELECT NTA_ASIGNATURASXGRADO
		LOCATE FOR NTA_ASIGNATURASXGRADO.Id = NOTAS.IdPensum
		IF	! FOUND()
			SELECT NOTAS
			LOOP
		ENDIF
		
		SELECT NTA_GRADOS
		LOCATE FOR NTA_GRADOS.Id = NTA_ASIGNATURASXGRADO.IdGrado
		IF	! FOUND()
			SELECT NOTAS
			LOOP
		ENDIF
		
		lnNivelAcademico = NTA_GRADOS.NivelAcademico

		SELECT NTA_DIMENSIONES
		
		LOCATE FOR NTA_DIMENSIONES.IdPensum = NOTAS.IdPensum AND ;
				NTA_DIMENSIONES.IdMatricula = NOTAS.IdMatricul AND ;
				NTA_DIMENSIONES.Periodo = lnPeriodo
				
		IF	! FOUND()

			APPEND BLANK
			REPLACE NTA_DIMENSIONES.IdPensum WITH NOTAS.IdPensum, ;
					NTA_DIMENSIONES.IdMatricula WITH NOTAS.IdMatricul, ;
					NTA_DIMENSIONES.Periodo WITH lnPeriodo
					
		ENDIF

		lnTotalDimCog = 0
		lnTotalDimArg = 0
		lnTotalDimPrp = 0
		lnTotalDimCom = 0
		lnTotalDimPrc = 0
		lnTotalInd = 0
		
		lnPromedioCog = 0
		lnPromedioArg = 0
		lnPromedioPrp = 0
		lnPromedioCom = 0
		lnPromedioPrc = 0
		lnPromedioInd = 0
		
		lnTotalExtCog = 0
		lnTotalExtArg = 0
		lnTotalExtPrp = 0
		lnTotalExtCom = 0
		lnTotalExtPrc = 0
				
		FOR	lnCount = 1 TO 10
		
			lcCount = ALLTRIM(STR(lnCount))
		
			REPLACE NTA_DIMENSIONES.Cog_&lcCount WITH NVL(NOTAS.Cogn&lcCount, 0), ;
					NTA_DIMENSIONES.Arg_&lcCount WITH NVL(NOTAS.Argu&lcCount, 0), ;
					NTA_DIMENSIONES.Prp_&lcCount WITH NVL(NOTAS.Prop&lcCount, 0), ;
					NTA_DIMENSIONES.Com_&lcCount WITH NVL(NOTAS.Comu&lcCount, 0), ;
					NTA_DIMENSIONES.Prc_&lcCount WITH NVL(NOTAS.Proc&lcCount, 0), ;
					NTA_DIMENSIONES.Ind&lcCount WITH NVL(NOTAS.Ind&lcCount, '')
					
			lnTotalDimCog = lnTotalDimCog + NTA_DIMENSIONES.Cog_&lcCount
			IF	NTA_DIMENSIONES.Cog_&lcCount > 0
				lnPromedioCog = lnPromedioCog + 1 
			ENDIF
			
			lnTotalDimArg = lnTotalDimArg + NTA_DIMENSIONES.Arg_&lcCount
			IF	NTA_DIMENSIONES.Arg_&lcCount > 0
				lnPromedioArg = lnPromedioArg + 1 
			ENDIF

			lnTotalDimPrp = lnTotalDimPrp + NTA_DIMENSIONES.Prp_&lcCount
			IF	NTA_DIMENSIONES.Prp_&lcCount > 0
				lnPromedioPrp = lnPromedioPrp + 1 
			ENDIF

			lnTotalDimCom = lnTotalDimCom + NTA_DIMENSIONES.Com_&lcCount
			IF	NTA_DIMENSIONES.Com_&lcCount > 0
				lnPromedioCom = lnPromedioCom + 1 
			ENDIF

			lnTotalDimPrc = lnTotalDimPrc + NTA_DIMENSIONES.Prc_&lcCount
			IF	NTA_DIMENSIONES.Prc_&lcCount > 0
				lnPromedioPrc = lnPromedioPrc + 1 
			ENDIF

			lnTotalInd = lnTotalInd + NotaNumerica(NTA_DIMENSIONES.Ind&lcCount, lnNivelAcademico)
			IF	! EMPTY(NTA_DIMENSIONES.Ind&lcCount)
				lnPromedioInd = lnPromedioInd + 1 
			ENDIF
					
			IF	lnCount <= 4
			
				DO	CASE
					CASE NVL(NOTAS.Cogn_E_&lcCount, 0) < 70
						lnExtCog = 0
					CASE BETWEEN(NVL(NOTAS.Cogn_E_&lcCount, 0), 70, 74)
						lnExtCog = 10
					CASE BETWEEN(NVL(NOTAS.Cogn_E_&lcCount, 0), 75, 79)
						lnExtCog = 15
					CASE BETWEEN(NVL(NOTAS.Cogn_E_&lcCount, 0), 80, 84)
						lnExtCog = 20
					CASE BETWEEN(NVL(NOTAS.Cogn_E_&lcCount, 0), 85, 89)
						lnExtCog = 25
					OTHERWISE
						lnExtCog = 30
				ENDCASE

				DO	CASE
					CASE NVL(NOTAS.Argu_E_&lcCount, 0) < 70
						lnExtArg = 0
					CASE BETWEEN(NVL(NOTAS.Argu_E_&lcCount, 0), 70, 74)
						lnExtArg = 10
					CASE BETWEEN(NVL(NOTAS.Argu_E_&lcCount, 0), 75, 79)
						lnExtArg = 15
					CASE BETWEEN(NVL(NOTAS.Argu_E_&lcCount, 0), 80, 84)
						lnExtArg = 20
					CASE BETWEEN(NVL(NOTAS.Argu_E_&lcCount, 0), 85, 89)
						lnExtArg = 25
					OTHERWISE
						lnExtArg = 30
				ENDCASE

				DO	CASE
					CASE NVL(NOTAS.Prop_E_&lcCount, 0) < 70
						lnExtPrp = 0
					CASE BETWEEN(NVL(NOTAS.Prop_E_&lcCount, 0), 70, 74)
						lnExtPrp = 10
					CASE BETWEEN(NVL(NOTAS.Prop_E_&lcCount, 0), 75, 79)
						lnExtPrp = 15
					CASE BETWEEN(NVL(NOTAS.Prop_E_&lcCount, 0), 80, 84)
						lnExtPrp = 20
					CASE BETWEEN(NVL(NOTAS.Prop_E_&lcCount, 0), 85, 89)
						lnExtPrp = 25
					OTHERWISE
						lnExtPrp = 30
				ENDCASE

				DO	CASE
					CASE NVL(NOTAS.Comu_E_&lcCount, 0) < 70
						lnExtCom = 0
					CASE BETWEEN(NVL(NOTAS.Comu_E_&lcCount, 0), 70, 74)
						lnExtCom = 10
					CASE BETWEEN(NVL(NOTAS.Comu_E_&lcCount, 0), 75, 79)
						lnExtCom = 15
					CASE BETWEEN(NVL(NOTAS.Comu_E_&lcCount, 0), 80, 84)
						lnExtCom = 20
					CASE BETWEEN(NVL(NOTAS.Comu_E_&lcCount, 0), 85, 89)
						lnExtCom = 25
					OTHERWISE
						lnExtCom = 30
				ENDCASE

				DO	CASE
					CASE NVL(NOTAS.Proc_E_&lcCount, 0) < 70
						lnExtPrc = 0
					CASE BETWEEN(NVL(NOTAS.Proc_E_&lcCount, 0), 70, 74)
						lnExtPrc = 10
					CASE BETWEEN(NVL(NOTAS.Proc_E_&lcCount, 0), 75, 79)
						lnExtPrc = 15
					CASE BETWEEN(NVL(NOTAS.Proc_E_&lcCount, 0), 80, 84)
						lnExtPrc = 20
					CASE BETWEEN(NVL(NOTAS.Proc_E_&lcCount, 0), 85, 89)
						lnExtPrc = 25
					OTHERWISE
						lnExtPrc = 30
				ENDCASE
				
				REPLACE NTA_DIMENSIONES.Ext_Cog_&lcCount WITH lnExtCog, ;
						NTA_DIMENSIONES.Ext_Arg_&lcCount WITH lnExtArg, ;
						NTA_DIMENSIONES.Ext_Prp_&lcCount WITH lnExtPrp, ;
						NTA_DIMENSIONES.Ext_Com_&lcCount WITH lnExtCom, ;
						NTA_DIMENSIONES.Ext_Prc_&lcCount WITH lnExtPrc
						
				lnTotalExtCog = lnTotalExtCog + NTA_DIMENSIONES.Ext_Cog_&lcCount
				lnTotalExtArg = lnTotalExtArg + NTA_DIMENSIONES.Ext_Arg_&lcCount
				lnTotalExtPrp = lnTotalExtPrp + NTA_DIMENSIONES.Ext_Prp_&lcCount
				lnTotalExtCom = lnTotalExtCom + NTA_DIMENSIONES.Ext_Com_&lcCount
				lnTotalExtPrc = lnTotalExtPrc + NTA_DIMENSIONES.Ext_Prc_&lcCount
				
			ENDIF
			
		ENDFOR
		
		REPLACE NTA_DIMENSIONES.Ult_Mod WITH NOTAS.Ult_Mod
		
		IF	lnPromedioCog > 0
			lnTotalDimCog = MIN((lnTotalDimCog + lnTotalExtCog) / lnPromedioCog, 100)
		ENDIF
		IF	lnPromedioArg > 0
			lnTotalDimArg = MIN((lnTotalDimArg + lnTotalExtArg) / lnPromedioArg, 100)
		ENDIF
		IF	lnPromedioPrp > 0
			lnTotalDimPrp = MIN((lnTotalDimPrp + lnTotalExtPrp) / lnPromedioPrp, 100)
		ENDIF
		IF	lnPromedioCom > 0
			lnTotalDimCom = MIN((lnTotalDimCom + lnTotalExtCom) / lnPromedioCom, 100)
		ENDIF
		IF	lnPromedioPrc > 0
			lnTotalDimPrc = MIN((lnTotalDimPrc + lnTotalExtPrc) / lnPromedioPrc, 100)
		ENDIF
		IF	lnPromedioInd > 0
			lnTotalInd = MIN(lnTotalInd / lnPromedioInd, 10)
		ENDIF

		lnPromedio = 0
		
		IF	lnTotalDimCog > 0
			lnPromedio = lnPromedio + 1 
		ENDIF
		IF	lnTotalDimArg > 0
			lnPromedio = lnPromedio + 1 
		ENDIF
		IF	lnTotalDimPrp > 0
			lnPromedio = lnPromedio + 1 
		ENDIF
		IF	lnTotalDimCom > 0
			lnPromedio = lnPromedio + 1 
		ENDIF
		IF	lnTotalDimPrc > 0
			lnPromedio = lnPromedio + 1 
		ENDIF

		IF	lnPromedio > 0		
			lnDefinitivaNumerica = (lnTotalDimCog + lnTotalDimArg + lnTotalDimPrp + lnTotalDimCom + lnTotalDimPrc) / (lnPromedio * 10)
		ELSE
			lnDefinitivaNumerica = lnTotalInd
		ENDIF
		
		DO	CASE
			CASE oEMPRESA.TipoDef = TIPOCALCULODEFINITIVA_REDONDEO
				lnDefinitivaNumerica = ROUND(lnDefinitivaNumerica, 1)
			CASE oEMPRESA.TipoDef = TIPOCALCULODEFINITIVA_SINREDONDEO
				lnDefinitivaNumerica = ROUND(lnDefinitivaNumerica - 0.05, 1)
			CASE oEMPRESA.TipoDef = TIPOCALCULODEFINITIVA_SINDECIMALES
				lnDefinitivaNumerica = INT(lnDefinitivaNumerica)
		ENDCASE

		IF	BETWEEN(lnPeriodoOriginal, 1, 4)
		
			SELECT NTA_EVALUACIONES
			LOCATE FOR NTA_EVALUACIONES.IdPensum = NOTAS.IdPensum AND ;
					NTA_EVALUACIONES.IdMatricula = NOTAS.IdMatricul AND ;
					NTA_EVALUACIONES.Periodo = lnPeriodoOriginal
					
			IF	! FOUND()

				APPEND BLANK
				REPLACE NTA_EVALUACIONES.IdPensum WITH NOTAS.IdPensum, ;
						NTA_EVALUACIONES.IdMatricula WITH NOTAS.IdMatricul, ;
						NTA_EVALUACIONES.Periodo WITH lnPeriodoOriginal
						
			ENDIF
			
			IF	lnTotalInd = 0

				REPLACE NTA_EVALUACIONES.EvaluacionNumerica1 WITH lnTotalDimCog / 10, ;
						NTA_EVALUACIONES.EvaluacionNumerica2 WITH lnTotalDimArg / 10, ;
						NTA_EVALUACIONES.EvaluacionNumerica3 WITH lnTotalDimPrp / 10, ;
						NTA_EVALUACIONES.EvaluacionNumerica4 WITH lnTotalDimCom / 10, ;
						NTA_EVALUACIONES.EvaluacionNumerica5 WITH lnTotalDimPrc / 10, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica1 WITH NotaAlfabetica(lnTotalDimCog / 10, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionAlfabetica2 WITH NotaAlfabetica(lnTotalDimArg / 10, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionAlfabetica3 WITH NotaAlfabetica(lnTotalDimPrp / 10, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionAlfabetica4 WITH NotaAlfabetica(lnTotalDimCom / 10, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionAlfabetica5 WITH NotaAlfabetica(lnTotalDimPrc / 10, lnNivelAcademico), ;
						NTA_EVALUACIONES.DefinitivaNumerica WITH lnDefinitivaNumerica, ;
						NTA_EVALUACIONES.DefinitivaAlfabetica WITH NotaAlfabetica(lnDefinitivaNumerica, lnNivelAcademico)
						
			ELSE

				REPLACE NTA_EVALUACIONES.EvaluacionNumerica1 WITH NotaNumerica(NOTAS.Ind1, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica2 WITH NotaNumerica(NOTAS.Ind2, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica3 WITH NotaNumerica(NOTAS.Ind3, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica4 WITH NotaNumerica(NOTAS.Ind4, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica5 WITH NotaNumerica(NOTAS.Ind5, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica6 WITH NotaNumerica(NOTAS.Ind6, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica7 WITH NotaNumerica(NOTAS.Ind7, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica8 WITH NotaNumerica(NOTAS.Ind8, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica9 WITH NotaNumerica(NOTAS.Ind9, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionNumerica10 WITH NotaNumerica(NOTAS.Ind10, lnNivelAcademico), ;
						NTA_EVALUACIONES.EvaluacionAlfabetica1 WITH NOTAS.Ind1, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica2 WITH NOTAS.Ind2, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica3 WITH NOTAS.Ind3, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica4 WITH NOTAS.Ind4, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica5 WITH NOTAS.Ind5, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica6 WITH NOTAS.Ind6, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica7 WITH NOTAS.Ind7, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica8 WITH NOTAS.Ind8, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica9 WITH NOTAS.Ind9, ;
						NTA_EVALUACIONES.EvaluacionAlfabetica10 WITH NOTAS.Ind10, ;
						NTA_EVALUACIONES.DefinitivaNumerica WITH lnDefinitivaNumerica, ;
						NTA_EVALUACIONES.DefinitivaAlfabetica WITH NotaAlfabetica(lnDefinitivaNumerica, lnNivelAcademico)
			
			ENDIF
		
		ELSE

			SELECT NTA_PARCIALES
			LOCATE FOR NTA_PARCIALES.IdPensum = NOTAS.IdPensum AND ;
					NTA_PARCIALES.IdMatricula = NOTAS.IdMatricul AND ;
					NTA_PARCIALES.Periodo = lnPeriodoOriginal
					
			IF	! FOUND()

				APPEND BLANK
				REPLACE NTA_PARCIALES.IdPensum WITH NOTAS.IdPensum, ;
						NTA_PARCIALES.IdMatricula WITH NOTAS.IdMatricul, ;
						NTA_PARCIALES.Periodo WITH lnPeriodoOriginal
						
			ENDIF

			IF	lnTotalInd = 0

				REPLACE NTA_PARCIALES.EvaluacionNumerica1 WITH lnTotalDimCog / 10, ;
						NTA_PARCIALES.EvaluacionNumerica2 WITH lnTotalDimArg / 10, ;
						NTA_PARCIALES.EvaluacionNumerica3 WITH lnTotalDimPrp / 10, ;
						NTA_PARCIALES.EvaluacionNumerica4 WITH lnTotalDimCom / 10, ;
						NTA_PARCIALES.EvaluacionNumerica5 WITH lnTotalDimPrc / 10, ;
						NTA_PARCIALES.EvaluacionAlfabetica1 WITH NotaAlfabetica(lnTotalDimCog / 10, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionAlfabetica2 WITH NotaAlfabetica(lnTotalDimArg / 10, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionAlfabetica3 WITH NotaAlfabetica(lnTotalDimPrp / 10, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionAlfabetica4 WITH NotaAlfabetica(lnTotalDimCom / 10, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionAlfabetica5 WITH NotaAlfabetica(lnTotalDimPrc / 10, lnNivelAcademico), ;
						NTA_PARCIALES.DefinitivaNumerica WITH lnDefinitivaNumerica, ;
						NTA_PARCIALES.DefinitivaAlfabetica WITH NotaAlfabetica(lnDefinitivaNumerica, lnNivelAcademico)
						
			ELSE

				REPLACE NTA_PARCIALES.EvaluacionNumerica1 WITH NotaNumerica(NOTAS.Ind1, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica2 WITH NotaNumerica(NOTAS.Ind2, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica3 WITH NotaNumerica(NOTAS.Ind3, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica4 WITH NotaNumerica(NOTAS.Ind4, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica5 WITH NotaNumerica(NOTAS.Ind5, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica6 WITH NotaNumerica(NOTAS.Ind6, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica7 WITH NotaNumerica(NOTAS.Ind7, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica8 WITH NotaNumerica(NOTAS.Ind8, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica9 WITH NotaNumerica(NOTAS.Ind9, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionNumerica10 WITH NotaNumerica(NOTAS.Ind10, lnNivelAcademico), ;
						NTA_PARCIALES.EvaluacionAlfabetica1 WITH NOTAS.Ind1, ;
						NTA_PARCIALES.EvaluacionAlfabetica2 WITH NOTAS.Ind2, ;
						NTA_PARCIALES.EvaluacionAlfabetica3 WITH NOTAS.Ind3, ;
						NTA_PARCIALES.EvaluacionAlfabetica4 WITH NOTAS.Ind4, ;
						NTA_PARCIALES.EvaluacionAlfabetica5 WITH NOTAS.Ind5, ;
						NTA_PARCIALES.EvaluacionAlfabetica6 WITH NOTAS.Ind6, ;
						NTA_PARCIALES.EvaluacionAlfabetica7 WITH NOTAS.Ind7, ;
						NTA_PARCIALES.EvaluacionAlfabetica8 WITH NOTAS.Ind8, ;
						NTA_PARCIALES.EvaluacionAlfabetica9 WITH NOTAS.Ind9, ;
						NTA_PARCIALES.EvaluacionAlfabetica10 WITH NOTAS.Ind10, ;
						NTA_PARCIALES.DefinitivaNumerica WITH lnDefinitivaNumerica, ;
						NTA_PARCIALES.DefinitivaAlfabetica WITH NotaAlfabetica(lnDefinitivaNumerica, lnNivelAcademico)
			
			ENDIF
			
		ENDIF

		SELECT NOTAS
		
		SET MESSAGE TO 'Procesando: ' + TRANSFORM(RECNO() / RECCOUNT() * 100, '999% ') + REPLICATE('|', RECNO() / RECCOUNT() * 100)
		
	ENDSCAN

	MESSAGEBOX('Notas importadas correctamente.')
	
ELSE

	MESSAGEBOX('Período no válido.')

ENDIF

CLOSE TABLES ALL

RETURN
