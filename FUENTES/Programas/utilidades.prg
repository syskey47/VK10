FUNCTION MontoEscrito(tnValor)

RETURN STR(tnValor)


PROCEDURE ProcShutDown

CLEAR ALL
CLOSE ALL
QUIT

*-------------------------------------------------------
* Funci�n.....: Selecciona(cAlias,cOrden,cRegistro)
*
* Descripci�n.: Abre o selecciona la tabla pasada como par�metro.
*               Puede adem�s mover el puntero de registro sobre
*               la tabla o encontrar un registro en un �ndice.
*
* Par�metros..: cAlias    - Alias de la tabla
*               cOrden    - Orden 
*               cRegistro - Puede contener alguno de
*                           los siguientes valores:
*                           TOP - Mueve el puntero de registro
*                                 al inicio de tabla
*                           BOTTOM - Fin de tabla
*                           NEXT   - Siguiente registro
*                           PREVIO - Registro anterior
*                           APPEND - A�ade un registro
*                           CLOSE  - Cierra la tabla
*                           Si esta variable no contiene
*                           ninguno de estos valores, se realiza
*                           una b�squeda de esta clave con el
*                           orden pasado como par�metro
*
* Devuelve....: L�gico
*
* Notas.......: 18/04/96 10:57:09 PHM
*-------------------------------------------------------
FUNCTION Selecciona(cAlias,cOrden,cRegistro)

IF EMPTY(cAlias)
   RETURN .F.
ENDIF   

LOCAL camiBase,nParametros,lOperacion,cTabla,cModo
cModo = []
nParametros=PARAMETERS()

cTabla = cAlias+[.DBF]

* Determinamos el uso de un alias espec�fico para la tabla
* La estructura pasada ser� la siguiente:
* cAliasTabla,cTablaDBF
**********************************************************
nPal = OCCURS([,],cAlias)   
IF nPal > 0
   cAlias = AddChar(cAlias,[,])
   cTabla = PAL(1,cAlias,[,])+[.DBF]
   cAlias = PAL(2,cAlias,[,])
   cModo  = [ AGAIN ALIAS ]+cAlias
ENDIF

   
* Abre la base de datos en el camino indicado
*********************************************
IF NOT USED(cAlias)
   SELECT 0
   USE (cTabla) &cModo
ENDIF 
SELECT (cAlias)
cTabla = DBF()
lOperacion=.T.
   
* Selecciona orden se se ha indicado
************************************
IF nParametros>1
   IF NOT EMPTY(cOrden)
      IF cOrden<>'N� Registro'
         SET ORDER TO (cOrden)
         lOperacion=.T.
      ELSE
         SET ORDER TO
      ENDIF      
   ENDIF 
ENDIF 
   

* El tercer par�metro tiene dos utilidades
* 1) Especifica el movimiento de registro (TOP/BOTTOM,ETC)
* 2) Indica a la funci�n que realice una b�squeda
**********************************************************   
IF nParametros>2
   DO CASE

      * Realiza una b�squeda num�rica
      *******************************
      CASE TYPE('cRegistro')='N'			
           SEEK (cRegistro)
           IF FOUND() && SEEK(cRegistro)
              lOperacion=.T.
           ELSE
              lOperacion=.F.
           ENDIF   

      * Primer registro
      *****************
      CASE cRegistro='TOP'
           GO TOP
           lOperacion=.T.

      * Ultimo registro
      *****************
      CASE cRegistro='BOTTOM'

           GO BOTTOM
           lOperacion=.T.

      * Siguiente Registro
      ********************
      CASE cRegistro='NEXT'
           IF EOF()
              GO BOTTOM
           ELSE
              SKIP
              IF EOF()
                 GO BOTTOM
              ENDIF
           ENDIF
           lOperacion=.T.

      * Registro Previo
      *****************
      CASE cRegistro='PREVIO'
           IF BOF()
              GO TOP
           ELSE
              SKIP -1
              IF BOF()
                 GO TOP
              ENDIF
           ENDIF

      * A�adir Registro
      *****************

      CASE cRegistro='APPEND'
           APPEND BLANK

      * Cerrar tabla
      **************
      CASE cRegistro='CLOSE'
           USE


      * En cualquier otro caso
      * Realiza una b�squeda
      ************************
      OTHERWISE
           IF SEEK(cRegistro)
              lOperacion=.T.
           ELSE
              lOperacion=.F.
           ENDIF   
      ENDCASE                         
ENDIF
RETURN lOperacion

ENDFUNC 


*-------------------------------------------------------
* Funci�n.....: aSumarMatriz
*
* Descripci�n.: Devuelve el total de un rango de celdas de 
*               una matriz
* 
* Par�metros..: aMatriz  - Matriz de la cual se van a obtener
*                          los resultados.
*               nFilaInicial - Fila inicial
*               nColInicial  - Columna Inicial
*               nFilas       - N�mero de filas que se van a sumar
*                              desde la fila inicial
*               nColumnas    - N�mero de columnas que se van a sumar
*                              desde la columna inicial
*
* Devuelve....: Num�rico
*
* Notas.......: 23/04/96 11:06:09 PHM
*-------------------------------------------------------
FUNCTION aSumarMatriz(aMatriz,nFilaInicial,nColInicial,nFilas,nColumnas)


* Declaraci�n de variables
**************************
EXTERNAL ARRAY aMatriz
LOCAL nFilasMatriz,nTotal

* Inicializaci�n de variables
*****************************
nTotal = 0

* Dimensiones de la matriz
**************************
IF TYPE("aMatriz") = [C]
   nFilasMatriz = ALEN(&aMatriz,1)
   nColumnasMatriz = ALEN(&aMatriz,2)
ELSE
   nFilasMatriz    = ALEN(aMatriz,1)
   nColumnasMatriz = ALEN(aMatriz,2)
ENDIF   


* Comprobamos el par�metro nFilaInicial
***************************************
IF EMPTY(nFilaInicial)
   nFilaInicial = 1
ENDIF

* Comprobamos el par�metro nColInicial
**************************************
IF EMPTY(nColInicial)
   nColInicial = 1   
ENDIF

* Comprobamos el par�metro nFilas
*********************************
IF EMPTY(nFilas)
   nFilas = nFilasMatriz
ENDIF

* Comprobamos el par�metro nColumnas
************************************
IF EMPTY(nColumnas)
   nColumnas = nColumnasMatriz   
ENDIF

* Averiguamos fila final
************************
nFilaFinal = nFilaInicial + nFilas - 1
IF nFilaFinal > nFilasMatriz
   nFilaFinal = nFilasMatriz
ENDIF

* Averiguamos columna final
***************************
nColumnaFinal = nColInicial + nColumnas - 1
IF nColumnaFinal > nColumnasMatriz
   nColumnaFinal = nColumnasMatriz
ENDIF


FOR nContadorFilas = nFilaInicial TO nFilaFinal

    FOR nContadorColumnas = nColInicial TO nColumnaFinal
        
        IF TYPE("aMatriz") = [C]
           cFila = ALLTRIM(STR(nContadorFilas))
           cColumna = ALLTRIM(STR(nContadorColumnas))
           nTotal = nTotal + EVALUATE(aMatriz+"("+cFila+","+cColumna+")") 
        ELSE
           nTotal = nTotal + aMatriz[nContadorFilas,nContadorColumnas]
        ENDIF   
    NEXT --> nContadorColumnas = nColumnaInicial TO nColumnaFinal
        
NEXT --> nContadorFilas = nFilaInicial TO nFilaFinal


RETURN nTotal
ENDFUNC && aSumarMatriz


*-------------------------------------------------------
* Funci�n.....: Encripta
*
* Descripci�n.: Encripta o desencripta cadenas
*
* Par�metros..: cPar1 Desc par 1
*               cPar2 cPa<r2
*               c c
*
* Devuelve....: L�gico
*
* Notas.......: 04/07/97 15:28:49 PHM
*-------------------------------------------------------
FUNCTION Encripta(cCadena,nLongitud,lEncripta)
LOCAL cCadenaTemporal, cTempEncriptada, cCaracter, nASCIIDesplazamiento, lHecho


IF lEncripta                && Se ha llamado a la funci�n para encriptar
    
   IF !EMPTY(cCadena)
              
      cCadenaTemporal = PADR(UPPER(cCadena),nLongitud)
      STORE '' TO cTempEncriptada, cCaracter
                
      * Genera un n�mero ASCII aleatorio para el caracter de desplazamiento
      *********************************************************************
      nASCIIDesplazamiento = MOD(RAND(-1)*10000,255)+1
        
        
      * Guarda el car�cter correspondiente a nASCIIDesplazamiento
      * como el primer car�cter de la cadena encriptada
      ***********************************************************
      cTempEncriptada = chr(nASCIIDesplazamiento)
        
      * Recorre la cadena pasada como par�metro
      *****************************************
      FOR i=1 TO nLongitud			
          
          cCaracter = SUBSTR(cCadenaTemporal,i,1)											 
        
          * Se encripta el car�cter actual de la 
          * forma siguiente:
          * 1 - Tomamos su valor ASCII
          * 2 - A�adimos este valor a nASCIIDesplazamiento
          * 3 - Averiguamos el resto (MOD) de la divisi�n
          *     entre 255 para asegurar que devuelve un
          *     valor ASCII 
          * 4 - Se convierte de nuevo en un car�cter ASCII
          *************************************************
          cCaracter = CHR(MOD(ASC(cCaracter)+nASCIIDesplazamiento,255)+1)
          cTempEncriptada = cTempEncriptada+cCaracter
        
          * El valor ASCII de el car�cter encriptado se utiliza como 
          * nASCIIDesplazamiento del siguiente car�cter
          * De esta forma, el valor de nASCIIDesplazamiento
          * cambia para cada car�cter, haciendo muy dif�cil
          * la desencriptaci�n de la cadena
          **********************************************************
          nASCIIDesplazamiento = ASC(cCaracter)
        
      ENDFOR
   
   ELSE	       && Se ha pasado una cadena vac�a
                   
      cTempEncriptada = SPACE(nLongitud+1) && Devuelve una cadena de blancos
                   
   ENDIF        					  
                    
ELSE           && Secci�n de desencriptaci�n
    
   IF !EMPTY(cCadena)
        
      STORE '' TO cTempEncriptada, cCaracter
      cCadenaTemporal = SUBSTR(cCadena,2)
      nLongitud = LEN(cCadena)
      lHecho = .F.

      * Averiguar el valor de nASCIIDesplazamiento del primer car�cter
      ****************************************************************
      nASCIIDesplazamiento = ASC(cCadena)
            
      * El primer car�cter no es tratado en el proceso de desencriptaci�n
      * puesto que su �nica funci�n es guardar el valor ASCII asignado
      * a nASCIIDesplazamiento para poder desencriptar la cadena actual
      ******************************************************************
      FOR i=2 TO nLongitud				
        
          cCaracter = SUBSTR(cCadena,i,1)
          
          IF ASC(cCaracter) <= nASCIIDesplazamiento
             cTempEncriptada = cTempEncriptada + CHR(255+ASC(cCaracter)-nASCIIDesplazamiento-1)
          ELSE
             cTempEncriptada = cTempEncriptada + CHR(ASC(cCaracter)-nASCIIDesplazamiento-1)
          ENDIF
        
          nASCIIDesplazamiento = ASC(cCaracter)
        
      ENDFOR

   ELSE
        
      cTempEncriptada = SPACE(nLongitud)        && Se ha pasado una cadena vac�a
        
   ENDIF

ENDIF

RETURN cTempEncriptada



*-------------------------------------------------------
* Funci�n.....: aBorrarMatriz
*
* Descripci�n.: Inicializa con un valor un rango de una matriz
* 
* Par�metros..: aMatriz - Matriz que se va a inicializar. Debe
*                         pasarse por referencia mediante @
*               uValor  - Valor con el que se van a inicializar
*                         los elementos indicados de la matriz
*               nFilaInicial - Fila inicial
*               nColInicial  - Columna Inicial
*               nFilas       - N�mero de filas a inicializar
*                              desde la fila inicial
*               nColumnas    - N�mero de columnas a inicializar
*                              desde la columna inicial
*
* Devuelve....: Modifica la matriz pasada como par�metro y
*               no devuelve ning�n valor
*
* Notas.......: 23/04/96 11:06:09 PHM
*-------------------------------------------------------
FUNCTION aBorrarMatriz(aMatriz,uValor,nFilaInicial,nColInicial,nFilas,nColumnas)

EXTERNAL ARRAY aMatriz
LOCAL nFilasMatriz

* Dimensiones de la matriz
**************************
nFilasMatriz    = ALEN(aMatriz,1)
nColumnasMatriz = ALEN(aMatriz,2)


* Comprobamos el par�metro nFilaInicial
***************************************
IF EMPTY(nFilaInicial)
   nFilaInicial = 1
ENDIF

* Comprobamos el par�metro nColInicial
**************************************
IF EMPTY(nColInicial)
   nColInicial = 1   
ENDIF

* Comprobamos el par�metro nFilas
*********************************
IF EMPTY(nFilas)
   nFilas = nFilasMatriz
ENDIF

* Comprobamos el par�metro nColumnas
************************************
IF EMPTY(nColumnas)
   nColumnas = nColumnasMatriz   
ENDIF

* Averiguamos fila final
************************
nFilaFinal = nFilaInicial + nFilas - 1
IF nFilaFinal > nFilasMatriz
   nFilaFinal = nFilasMatriz
ENDIF

* Averiguamos columna final
***************************
nColumnaFinal = nColInicial + nColumnas - 1
IF nColumnaFinal > nColumnasMatriz
   nColumnaFinal = nColumnasMatriz
ENDIF


FOR nContadorFilas = nFilaInicial TO nFilaFinal

    FOR nContadorColumnas = nColInicial TO nColumnaFinal
        aMatriz[nContadorFilas,nContadorColumnas] = uValor
    NEXT --> nContadorColumnas = nColumnaInicial TO nColumnaFinal
        
NEXT --> nContadorFilas = nFilaInicial TO nFilaFinal


RETURN
ENDFUNC && aBorrarMatriz






*-------------------------------------------------------
* Funci�n.....: PAL
*
* Descripci�n.: Extrae subcadenas de una cadena mayor, 
*               delimitadas por un cierto separador
*
* Par�metros..: nPalabra - N�mero de palabra a devolver
*               cTexto   - Texto a examinar
*               cSeparador - Separador de palabras
*
* Devuelve....: Car�cter
*
* Notas.......: 23/07/96 15:52:04 PHM
*-------------------------------------------------------
FUNCTION PAL(nPalabra,cTexto,cSeparador)

LOCAL nPosFin,nPalAnterior
IF EMPTY(cTexto)
   RETURN []
ENDIF   

nPalAnterior = nPalabra-1
nPalAnterior  = IIF(nPalAnterior<1,1,nPalAnterior)

nPosFin    = AT(cSeparador,cTexto,nPalabra)
nPosInicio = AT(cSeparador,cTexto,nPalAnterior)
nPosInicio = IIF(nPosInicio=nPosFin,1,nPosInicio+1)


RETURN SUBSTR(cTexto,nPosInicio,nPosFin-nPosInicio)

ENDFUNC && PAL



*-------------------------------------------------------
* Funci�n.....: Relaciona
*
* Descripci�n.: Crea una relaci�n entre dos tablas
*
* Par�metros..: cTablaOrigen  - Tabla origen
*               cTablaDestino - Tabla destino
*               cExpresion    - Expresi�n de relaci�n
*               cOrden        - Orden activo en la tabla destino
*               lA�adir       - A�ade la clausula ADDITIVE
*
* Devuelve....: L�gico
*
* Notas.......: 31/07/96 18:51:27 PHM 
*-------------------------------------------------------
FUNCTION Relaciona(cTablaOrigen,cTablaDestino,cExpresion,cOrden,lA�adir)
* Relaciona(cTablaOrigen,cTablaDestino,cExpresion,cOrden,lA�adir)

cA�adir = IIF(lA�adir,[ ADDITIVE ],[ ])
=Selecciona(cTablaDestino,cOrden)
=Selecciona(cTablaOrigen)
SET RELATION TO &cExpresion INTO &cTablaDestino &cA�adir

RETURN
ENDFUNC && Relaciona



*-------------------------------------------------------
* Funci�n.....: Plural
*
* Descripci�n.: Devuelve el plural de una palabra
*               pasada como par�metro
*
* Par�metros..: cPalabra - Palabra en singular
*
* Devuelve....: Car�cter
*
* Notas.......: 05/08/1996 22:26:38 PHM
*-------------------------------------------------------
FUNCTION Plural(cPalabra,nCantidad)

IF TYPE([nCantidad])=[N]
   IF nCantidad <= 1
      RETURN cPalabra
   ENDIF   
ENDIF

cPalabra = ALLTRIM(cPalabra)


DO CASE
   CASE UPPER(RIGHT(cPalabra,2)) = "ES"
        cPalabra = cPalabra + "ES"
   CASE UPPER(RIGHT(cPalabra,1)) = "A"
        cPalabra = cPalabra + "S"             
   CASE UPPER(RIGHT(cPalabra,1)) = "O"
        cPalabra = cPalabra + "S"             
ENDCASE


RETURN UPPER(cPalabra)

ENDFUNC && ValorImpuesto



*-------------------------------------------------------
* Funci�n.....: FormaPago
*
* Descripci�n.: Devuelve la descripci�n de una forma de
*               pago
*
* Par�metros..: cFOCO - Forma de cobro
*                       U - Unico
*                       A - Anual
*                       M - Mensual
*                       B - BiMensual
*                       T - Trimestral
*                       C - Cuatrimestral
*                       S - Semestral
*
* Devuelve....: Car�cter
*
* Notas.......: 09/08/1996 15:39:04 PHM
*-------------------------------------------------------
FUNCTION FormaPago(cFOCO)

DO CASE
   CASE cFOCO =  [U]
        RETURN "�nico"
   CASE cFOCO =  [A]
        RETURN "Anual"
   CASE cFOCO =  [M]
        RETURN "Mensual"
   CASE cFOCO =  [B]
        RETURN "Bimensual"
   CASE cFOCO =  [T]
        RETURN "Trimestral"
   CASE cFOCO =  [C]
        RETURN "Cuatrimestral"
   CASE cFOCO =  [S]
        RETURN "Semestral"
ENDCASE


ENDFUNC && FormaPago



**********************************************************
** FUNCIONES PARA PROTEGER/DESPROTEGER TABLAS DE UNA BD **
**********************************************************


*-------------------------------------------------------
* Funci�n.....: CambiaCabecera(cTablaProt,cProtec,lForzar)
*
* Descripci�n.: Protege una tabla
*
* Par�metros..: cTablaProt  - Nombre de tabla
*               cProtec - Cadena de control. Puede 
*                         contener los siguientes
*                         valores:
*                         PRO - Proteger tabla
*                         --- - Desproteger tabla
*               lForzar - Determina si ha de proteger
*                         la tabla de todos modos
*
* Devuelve....: L�gico
*
* Notas.......: 14/10/96 15:40:34
*               Esta funci�n protege de forma limitada
*               el acceso a una tabla invirtiendo los 
*               128 primeros bytes de la tabla. PHM
*-------------------------------------------------------
FUNCTION CambiaCabecera(cTablaProt,cProtec,lForzar)
LOCAL nTabla,cBufer,cCadena,i,lProtegida

#DEFINE TAMA�O_CABECERA 128
#DEFINE BUFFER_CABECERA SPACE(128)
#DEFINE BYTES_CABECERA  128
lProtegida = EstaProtegida(cTablaProt)

* No ha podido abrir la tabla
* por tanto no es necesario
* cambiar la cabecera
*****************************
IF lProtegida = .NULL.
   RETURN .F.
ENDIF   
   

DO CASE
   CASE lProtegida  .AND. cProtec = [PRO]  .AND. !lForzar
        RETURN .F.
   CASE !lProtegida .AND. cProtec = [---]  .AND. !lForzar
        RETURN .F.
ENDCASE 



cCadena = []
nTabla = FOPEN(cTablaProt,2)


* Comprobar errores de apertura
*******************************
IF FERROR() # 0
   RETURN .F.
ENDIF

* Para decodificar la tabla, es necesario 
* que �sta mida al menos 128 bytes
*****************************************
cBufer = FREAD(nTabla,BYTES_CABECERA)
IF LEN(cBufer) # BYTES_CABECERA
   RETURN .F.
ENDIF

* Tomar los n Bytes de la cabecera
* en invertirlos
**********************************
FOR i = BYTES_CABECERA TO 1 STEP -1
    cCadena = cCadena + SUBSTR(cBufer,i,1)
NEXT
IF LEN(cCadena) # BYTES_CABECERA
   RETURN .F.
ENDIF


* Escribimos los datos invertidos en
* la cabecera de la tabla
************************************
=FSEEK(nTabla,0)   
IF FWRITE(nTabla,cCadena,BYTES_CABECERA) # BYTES_CABECERA
   RETURN .F.
ENDIF


* Escribimos al final de la tabla
* la cadena de control cProtec
*********************************
IF !ISNULL(lProtegida)
   =FSEEK(nTabla,-3,2)
ELSE   
   =FSEEK(nTabla,0,2)
ENDIF

IF FWRITE(nTabla,cProtec,3) # 3
   RETURN .F.
ENDIF


* Cerramos la tabla
*******************
=FCLOSE(nTabla)   

* Realizamos comprobaci�n de autenticidad
*****************************************


RETURN .T.

ENDFUNC



*-------------------------------------------------------
* Funci�n.....: Camino(cFichero)
*
* Descripci�n.: Devuelve la ruta de acceso a un fichero
*
* Par�metros..: cFichero - Cadena conteniendo el nombre
*                          de fichero y la ruta de 
*                          acceso
*
* Devuelve....: Car�cter
*
* Notas.......: Esta funci�n devuelve una cadena con
*               la ruta de acceso al fichero especificado.  PHM
*-------------------------------------------------------
FUNCTION Camino(cFichero)

RETURN SUBSTR(cFichero,1,RAT([\],cFichero))

ENDFUNC




*-------------------------------------------------------
* Funci�n.....: Extension(cFichero)
*
* Descripci�n.: Devuelve la extensi�n de un fichero
*
* Par�metros..: cFichero - Cadena conteniendo el nombre
*                          de fichero y la extensi�n
*
* Devuelve....: Car�cter
*
* Notas.......: Esta funci�n devuelve una cadena con
*               la extensi�n del fichero especificado. PHM
*-------------------------------------------------------
FUNCTION Extension(cFichero)

RETURN SUBSTR(cFichero,RAT([.],cFichero)+1)

ENDFUNC



*-------------------------------------------------------
* Funci�n.....: CompBaseDatos(cBaseDatos)
*
* Descripci�n.: Devuelve el estado de acceso a una 
*               base de datos
*
* Par�metros..: cBaseDatos - Nombre de la base de datos
*
* Devuelve....: Num�rico
*
* Notas.......: Esta funci�n devuelve un n�mero indicando 
*               el estado de acceso a una base de datos en
*               un entorno de red. PHM
*-------------------------------------------------------
FUNCTION CompBaseDatos(cBaseDatos)

#DEFINE SIN_USO            0  && El fichero no est� en uso
#DEFINE LOCAL_EXCLUSIVO    1  && El fichero es local y exclusivo
#DEFINE LOCAL_COMPARTIDO   2  && El fichero es local y compartido
#DEFINE FICHERO_BLOQUEADO  3  && Fichero bloqueado por red
#DEFINE FICHERO_COMPARTIDO 4  && Fichero compartido en red
#DEFINE NO_ENCONTRADO      5  && Fichero no encontrado
#DEFINE LOCAL_REMOTO       6  && Fichero Compartido local y red
#DEFINE SIN_PARAMETROS     9  && Sin par�metros

LOCAL nTablas,nContador,nPorcentaje,cBaseDatos,cRuta,oDBC


* Abre la biblioteca de clases
******************************
* SET CLASSLIB TO PACKDB

* Crea un objeto para manejar la base de datos
**********************************************
oDBC=CREATEOBJECT("Tablas",cBaseDatos,"BaseDatos")

* Cierra todos los ficheros y vuelve a activar
* el fichero de procedimientos
**********************************************
* SET PROCEDURE TO GENERAL

* Abre la biblioteca de clases
******************************
* SET CLASSLIB TO PACKDB


* Comprobamos el estado de bloqueo
**********************************
oDBC.Bloqueo()

RETURN oDBC.nBloqueo



*-------------------------------------------------------
* Funci�n.....: Protege(cTablaProt,lForzar)
*
* Descripci�n.: Protege la cabecera de una tabla
*
* Par�metros..: cTablaProt  - Nombre de la tabla
*               lForzar - Determina si ha de proteger
*                         la tabla de todos modos
*
* Devuelve....: L�gico
*
* Notas.......: Esta funci�n protege una tabla 
*               invirtiendo los 128 primeros bytes.
*               A�ade al final de la tabla un indicador
*               para verificar que la tabla ha sido 
*               protegida. PHM
*-------------------------------------------------------
FUNCTION Protege(cTablaProt,lForzar)
LOCAL cProtec

cProtec = [PRO]
IF CompruebaPatron(_NOPROT,SoloNombre(cTablaProt))
   RETURN .F.
ENDIF   

RETURN CambiaCabecera(cTablaProt,cProtec,lForzar)


ENDFUNC



*-------------------------------------------------------
* Funci�n.....: DesProtege(cTablaProt)
*
* Descripci�n.: Desprotege la cabecera de una tabla
*
* Par�metros..: cTablaProt - Nombre de la tabla
*               lForzar - Determina si ha de proteger
*                         la tabla de todos modos
* Devuelve....: L�gico
*
* Notas.......: Esta funci�n desprotege una tabla 
*               invirtiendo los 128 primeros bytes que
*               se hab�an invertido en la funci�n
*               Protege(). PHM
*-------------------------------------------------------
FUNCTION DesProtege(cTablaProt,lForzar)
LOCAL cProtec

cProtec = [---]
IF CompruebaPatron(_NOPROT,SoloNombre(cTablaProt))
   RETURN .F.
ENDIF   
RETURN CambiaCabecera(cTablaProt,cProtec,lForzar)


ENDFUNC


*-------------------------------------------------------
* Funci�n.....: EstaProtegida(cTablaProt)
*
* Descripci�n.: Indica si una tabla est� protegida
*
* Par�metros..: cTablaProt - Nombre de la tabla
*
* Devuelve....: L�gico
*
* Notas.......: Esta funci�n comprueba la presencia de la
*               cadena de control al final de la tabla. 
*               Si contiene [PRO] indica que la tabla ha
*               sido protegida mediante la funci�n 
*               Protege()
*               Si contiene [---] o algo distinto, indica
*               que la tabla puede utilizarse. PHM
*-------------------------------------------------------
FUNCTION EstaProtegida(cTablaProt)
LOCAL nTabla,cProtec


nTabla = FOPEN(cTablaProt,2)

* Comprobar errores de apertura
*******************************
IF FERROR() # 0
   RETURN .F.
ENDIF

* Comprobamos el final de la tabla
**********************************
=FSEEK(nTabla,-3,2)
cProtec = FREAD(nTabla,3)

* Comprobamos el inicio de la tabla
***********************************
cDBF1=[0a]
cDBF2=[0`]
=FSEEK(nTabla,0)
cIniTabla = FREAD(nTabla,2)
lDBF = IIF(cDBF1 == cIniTabla OR cDBF2 == cINITabla,.T.,.F.)
=FCLOSE(nTabla)



* Comprobamos cada uno de los casos
***********************************
DO CASE
   CASE !lDBF
        RETURN .T.
   CASE cProtec = [---] AND !lDBF
        RETURN .F.
   CASE cProtec = [PRO] AND  lDBF
        RETURN .F.
   CASE cProtec = [PRO] AND !lDBF
        RETURN .T.
   CASE cProtec = [---] AND  lDBF    
        RETURN .F.
   OTHERWISE
        RETURN .NULL.        
ENDCASE

ENDFUNC




*-------------------------------------------------------
* Funci�n.....: ProtegerBD(cBaseDatos,lProteger)
*
* Descripci�n.: Protege/Desprotege todas las tablas
*               definidas en una base de datos, incluyendo
*               la propia base de datos.
*
* Par�metros..: cBaseDatos - Nombre de base de datos
*               lProteger - Indica si ha de proteger o
*                           desproteger las tablas y la
*                           base de datos.
*
* Devuelve....: L�gico
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION _ProtegerBD(cBaseDatos,lProteger)

LOCAL i,lProteger

IF lProteger
	CLOSE DATABASES ALL
ENDIF

IF AT('\',cBaseDatos)=0
	cBaseDatos=PU_DIRBD+cBaseDatos
ENDIF 
cAliasBD = SoloNombre(cBaseDatos)


lProtegida=CompruebaBD(cBaseDatos)

IF ISNULL(lProtegida)
   RETURN
ENDIF   

IF lProteger AND lProtegida 
	RETURN
ENDIF

IF !lProteger AND !lProtegida 
   RETURN .T.
ENDIF

IF EMPTY(cBasedatos)
   RETURN .F.
ENDIF
   
IF lProtegida
   =Desprotege(cBaseDatos)
ENDIF   


OPEN DATA (cBaseDatos)
SET DATA TO (cAliasBD)
nTablas = ADBOBJECTS(aTablas,[TABLE])
cCamino = Camino(DBC())
CLOSE DATABASES 

FOR i=1 TO nTablas
    cTablaProt =cCamino + aTablas[i]+[.DBF]
    IF CompruebaPatron(_NOPROT,SoloNombre(cTablaProt))
       LOOP
    ENDIF   
    IF !lProtegida
       IF !Protege(cTablaProt)
           RETURN .F.
       ENDIF   
    ELSE
       IF !DesProtege(cTablaProt)
          RETURN .F.
       ENDIF   
    ENDIF
NEXT    

IF ISNULL(lProtegida) .OR. !lProtegida
   =Protege(cBaseDatos)
ENDIF   

*IF !lProtegida
*   =Protege(cBaseDatos)
*ENDIF


ENDFUNC





*-------------------------------------------------------
* Funci�n.....: ProtegerBD(cBaseDatos,lProteger)
*
* Descripci�n.: Protege/Desprotege todas las tablas
*               definidas en una base de datos.
*
* Par�metros..: cBaseDatos - Nombre de base de datos
*               lProteger - Indica si ha de proteger o
*                           desproteger las tablas y la
*                           base de datos.
*
* Devuelve....: L�gico
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION ProtegerBD(cBaseDatos,lProteger)

LOCAL i,lProteger

IF lProteger
	CLOSE DATABASES ALL
ENDIF

IF EMPTY(cBasedatos)
   cBaseDatos = GETFILE([DBC])
ENDIF

cAliasBD = SoloNombre(cBaseDatos)

OPEN DATA (cBaseDatos)
SET DATA TO (cAliasBD)
nTablas = ADBOBJECTS(aTablas,[TABLE])
cCamino = Camino(DBC())
CLOSE DATABASES ALL

FOR i=1 TO nTablas
    cTablaProt =cCamino + aTablas[i]+[.DBF]
    IF CompruebaPatron(_NOPROT,SoloNombre(cTablaProt))
       LOOP
    ENDIF   
    IF lProteger
       IF !Protege(cTablaProt)
           LOOP
           * RETURN .F.
       ENDIF   
    ELSE
       IF !DesProtege(cTablaProt)
          LOOP
          * RETURN .F.
       ENDIF   
    ENDIF
NEXT    


ENDFUNC

*-------------------------------------------------------
* Funci�n.....: CompruebaBD(cBaseDatos)
*
* Descripci�n.: Comprueba si la base de datos se est�
*               utilizando por otro usuario
*
* Par�metros..: cBaseDatos - Nombre de base de datos
*
* Devuelve....: L�gico
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION CompruebaBD(cBaseDatos)

#DEFINE SIN_USO            0  && El fichero no est� en uso
#DEFINE LOCAL_EXCLUSIVO    1  && El fichero es local y exclusivo
#DEFINE LOCAL_COMPARTIDO   2  && El fichero es local y compartido
#DEFINE FICHERO_BLOQUEADO  3  && Fichero bloqueado por red
#DEFINE FICHERO_COMPARTIDO 4  && Fichero compartido en red
#DEFINE NO_ENCONTRADO      5  && Fichero no encontrado
#DEFINE LOCAL_REMOTO       6  && Fichero Compartido local y red
#DEFINE SIN_PARAMETROS     9  && Sin par�metros

*********************************************
* Comprueba que la B.D. no est� siendo      *
* optimizada en este momento                *
*********************************************
nEstado = CompBaseDatos(cBaseDatos)
IF !INLIST(nEstado,SIN_USO,LOCAL_EXCLUSIVO,LOCAL_COMPARTIDO)
   RETURN .NULL.
ENDIF   

RETURN EstaProtegida(cBaseDatos)

ENDFUNC



*-------------------------------------------------------
* Funci�n.....: QuitaExtension
*
* Descripci�n.: Elimina la extensi�n del fichero pasado
*               como par�metro
*
* Par�metros..: lcFicheroExt - Nombre de fichero
*
* Devuelve....: Caracter
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION QuitaExtension

parameters lcFicheroExt


******************************************************************************
* Variable         Tipo        Uso               
* ============================================================================
* lcSinExtension   (c)         Valor de retorno
* lcFicheroExt     (c)         Nombre de fichero
******************************************************************************

  if "." $ lcFicheroExt                 && La extensi�n empieza tras
                                        && el �ltimo punto
    lcSinExtension=substr(lcFicheroExt,1,rat(".",lcFicheroExt)-1)
  else
    lcSinExtension=lcFicheroExt
  endif ("." $ lcFicheroExt)
return lcSinExtension

ENDFUNC

*-------------------------------------------------------
* Funci�n.....: QuitaPrefijo
*
* Descripci�n.: Elimina la ruta del fichero pasado
*               como par�metro
*
* Par�metros..: lcNombreFichero - Nombre de fichero
*
* Devuelve....: Caracter
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION QuitaPrefijo

parameters lcNombreFichero


******************************************************************************
* Variable         Tipo        Uso               
* ============================================================================
* lcSinDirectorio  (c)         Valor devuelto
* lcNombreFichero  (c)         Nombre del fichero
******************************************************************************

DO CASE
   CASE "\" $ lcNombreFichero               && El nombre de fichero empieza tras
                                            && la �ltima barra
     
        lcSinDirectorio=SUBSTR(lcNombreFichero,RAT("\",lcNombreFichero)+1)
        *THIS.cRuta = left(lcNombreFichero,RAT("\",lcNombreFichero))
        
   CASE ":" $ lcNombreFichero               && El nombre de fichero empieza tras
                                            && los dos puntos
     
       lcSinDirectorio=SUBSTR(lcNombreFichero,AT(":",lcNombreFichero)+1)
       *THIS.cRuta = left(lcNombreFichero,AT(":",lcNombreFichero))

   OTHERWISE
   
       lcSinDirectorio=lcNombreFichero        && El nombre de fichero no tiene
                                              && directorio
       *THIS.cRuta = ""                                              
ENDCASE
return lcSinDirectorio


*-------------------------------------------------------
* Funci�n.....: SoloNombre(cFichero)
*
* Descripci�n.: Elimina la ruta y extensi�n del fichero 
*               pasado como par�metro
*
* Par�metros..: cFichero - Nombre de fichero
*
* Devuelve....: Caracter
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION SoloNombre(cFichero)

RETURN QuitaPrefijo( QuitaExtension( cFichero ) )

ENDFUNC


*-------------------------------------------------------
* Funci�n.....: CompruebaPatron(cPatron,cFichero)
*
* Descripci�n.: Compara el nombre de fichero con un criterio
*               o patr�n de ficheros. 
*
* Par�metros..: cPatron - Esta cadena contiene los criterios
*                         de selecci�n
*               cFichero - Contiene el nombre de fichero
*
* Devuelve....: L�gico
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION CompruebaPatron(cPatron,cFichero)

LOCAL i,lIgual

* Conversi�n a may�sculas
*************************
cPatron = UPPER(cPatron)
cFichero = UPPER(cFichero)

* Contamos el n�mero de palabras definidas 
* en la cadena cPatr�n
******************************************
nPalabras = OCCURS([@],cPatron)

FOR i = 1 TO nPalabras
    cPal = PAL(i,cPatron,[@])
    IF LIKE(cPal,cFichero)
       RETURN .T.
    ENDIF
NEXT

RETURN .F.    

ENDFUNC



                  
*-------------------------------------------------------
* Funci�n.....: DesProtegeEntorno(oEntorno)
*
* Descripci�n.: Desprotege las tablas definidas en el
*               entorno de datos pasado como par�metro
*
* Par�metros..: oEntorno - Objeto entorno de datos
*
* Devuelve....: Nada
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION DesProtegeEntorno(oEntorno)
LOCAL nObjetos,cBaseDatos,cCamino,cOrigen,cClase

nObjetos = AMEMBERS(aCursores,oEntorno,2)


FOR i = 1 TO nObjetos
    cObjeto    = [oEntorno.]+aCursores[i]
    cClase     = &cObjeto..BaseClass
    IF UPPER(cClase) # [CURSOR]
       LOOP
    ENDIF   
    * cBaseDatos = &cObjeto..DataBase
    * cCamino    = Camino(cBaseDatos)
    cCamino    = PU_DIRBD
    cOrigen    = &cObjeto..CursorSource
    cTablaProt     = AddBs(cCamino)+cOrigen+[.DBF]
    IF !DesProtege(cTablaProt)
       LOOP
    ENDIF   
NEXT



ENDFUNC     


*-------------------------------------------------------
* Funci�n.....: ProtegeEntorno(oEntorno)
*
* Descripci�n.: Protege las tablas definidas en el
*               entorno de datos pasado como par�metro
*
* Par�metros..: oEntorno - Objeto entorno de datos
*
* Devuelve....: Nada
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION ProtegeEntorno(oEntorno)
LOCAL nObjetos,cBaseDatos,cCamino,cOrigen,cTablaProt
LOCAL ARRAY aCursores[1]

nObjetos = AMEMBERS(aCursores,oEntorno,2)

FOR i = 1 TO nObjetos
    cObjeto    = [oEntorno.]+aCursores[i]
    cClase     = &cObjeto..BaseClass
    IF UPPER(cClase) # [CURSOR]
       LOOP
    ENDIF   
    cBaseDatos = &cObjeto..DataBase
    cCamino    = Camino(cBaseDatos)
    cOrigen    = &cObjeto..CursorSource
    cTablaProt     = AddBs(cCamino)+cOrigen+[.DBF]
    IF !Protege(cTablaProt)
       LOOP
    ENDIF   
NEXT

ENDFUNC     

                  
                  
*-------------------------------------------------------
* Funci�n.....: AddBs(cCamino)
*
* Descripci�n.: A�ade una barra de directorio al final
*               de la ruta pasada como par�metro si �sta 
*               no la ten�a
*
* Par�metros..: cCamino - Ruta
*
* Devuelve....: Caracter
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION addbs(cCamino)
LOCAL cSeparador
cSeparador = IIF(_MAC,":","\")
cCamino = ALLTRIM(UPPER(cCamino))
IF !(RIGHT(cCamino,1) $ '\:') AND !EMPTY(cCamino)
   cCamino = cCamino + cSeparador
ENDIF
RETURN cCamino
                  
ENDFUNC


*-------------------------------------------------------
* Funci�n.....: AddChar(cCadena,cCaracter)
*
* Descripci�n.: A�ade el caracter especificado al final
*               de la cadena pasada como par�metro si �sta 
*               no lo ten�a
*
* Par�metros..: cCadena - Cadena a comprobar
*               cCaracter - Caracter a a�adir
*
* Devuelve....: Caracter
*
* Notas.......: PHM
*-------------------------------------------------------
FUNCTION addChar(cCadena,cCaracter)
cCadena = ALLTRIM(UPPER(cCadena))
IF !(RIGHT(cCadena,1) $ cCaracter) AND !EMPTY(cCadena)
   cCadena = cCadena + cCaracter
ENDIF
RETURN cCadena
                  
ENDFUNC





* Ejemplo de justificaci�n de texto
***********************************
*CLEAR
*cTexto = 'Permite la edici�n de archivos de texto y programas. '+;
*         'Si ha seleccionado "Modificar el archivo seleccionado" en la ficha Proyectos '+;
*         'del cuadro de di�logo Opciones, la ventana de edici�n se abre '+;
*         'cuando haga doble clic sobre un archivo de texto o de programa en el administrador '+;
*         'de proyectos. '+CHR(13)+;
*         ' En la ventana de edici�n puede: '+;
*         ' Trasladar texto hacia la ventana Comandos o hacia otras ventanas de edici�n.'+;
*         ' Seleccione el texto a trasladar y arr�strelo al lugar de destino. '+;
*         ' Para establecer las preferencias de edici�n, vea la ficha Editar del cuadro'+;
*         ' de di�logo Opciones. '+;
*         ' Copiar texto a la ventana Comandos o a otras ventanas de edici�n. '+;
*         ' Seleccione el texto a copiar, mantenga presionada la tecla CTRL y arr�strelo'+;
*         ' al lugar de destino. '+;
*         ' Cambiar la fuente, el interlineado y el sangrado, seleccionando el comando '+;
*         ' apropiado en el men� Formato. Esto es todo. No hay nada m�s que decir. '+;
*         ' Fin de las pruebas de justificaci�n. ' 
*nAncho = 70
*
*? JustificarTexto(cTexto,nAncho) FUNCTION [V120]


*-------------------------------------------------------
* Funci�n.....: JustificarTexto(cTexto,nAncho)
*
* Descripci�n.: Devuelve una cadena justificada a ambos
*               margenes
*
* Par�metros..: cTexto		- Variable o campo memo a 
*                             justificar
*               nAncho		- Ancho de l�nea
*
* Devuelve....: Caracter
*
* Notas.......: 16/01/1997 17:16:29 Pedro Hern�ndez
*-------------------------------------------------------
FUNCTION JustificarTexto(cTexto,nAncho)

* Declaraci�n de variables
**************************
LOCAL nLinea, cLinea, nPalabras,i,cPalabra,cResultado

* Inicializaci�n de variables
*****************************
nLinea = 0
STORE [] TO cLinea,cResultado


* Apertura de librerias
***********************
SET LIBRARY TO FOXTOOLS

* Contamos el n�mero de palabras
* Se asumen como separadores de palabras
* los espacios y el tabulador
****************************************
nPalabras = Words(cTexto)

* Bucle de composici�n
**********************
FOR i = 1 TO nPalabras
    cPalabra = WordNum(cTexto,i)
    
    * Comprobamos que la longitud
    * de la palabra actual mas la longitud
    * acumulada de la linea no sobrepase
    * el ancho de linea determinado por
    * el par�metro nLinea
    **************************************
    IF LEN(cLinea)+LEN(cPalabra) > nAncho ;
       OR cPalabra = CHR(13)
       cLinea = JustificarLinea(cLinea,nAncho)
       cResultado = cResultado + cLinea + iif(cPalabra=chr(13),[],chr(13))
       cLinea = []
    ENDIF

   cLinea = cLinea + cPalabra + [ ]

NEXT

cLinea = JustificarLinea(cLinea,nAncho)
cResultado = cResultado + cLinea + chr(13)

RETURN cResultado



*-------------------------------------------------------
* Funci�n.....: JustificarLinea(cTexto,nAncho)
*
* Descripci�n.: Devuelve una cadena justificada a ambos
*               margenes. Se llama a esta funci�n desde
*               JustificarTexto, para ajustar cada una
*               de las l�neas que va procesando
*
* Par�metros..: cTexto		- Variable o campo memo a 
*                             justificar
*               nAncho		- Ancho de l�nea
*
* Devuelve....: Caracter
*
* Notas.......: 16/01/1997 17:16:29 Pedro Hern�ndez
*-------------------------------------------------------
FUNCTION JustificarLinea(cTexto,nAncho)

* Declaraci�n de variables
**************************
LOCAL nPalabras, nCaracteres, nEspacios, nA�adir, nIntEspacios, nModEspacios,i

* Inicializaci�n de variables
*****************************
nPalabras    = Words(cTexto)
cTexto       = ALLTRIM(cTexto)
nCaracteres  = LEN(cTexto)
nEspacios    = OCCURS([ ],cTexto)
nA�adir      = nAncho - nCaracteres
nIntEspacios = INT( nA�adir / nEspacios )
nModEspacios = IIF(nEspacios = 0,0,MOD( nA�adir , nEspacios ))
cEspacios    = SPACE(nIntEspacios+1)
* cEspacios    = replicate([�],nIntEspacios+1)
cFinal       = RIGHT(cTexto,1)

IF cFinal = [.] OR cFinal = CHR(13)
   RETURN cTexto
ENDIF   


* Reemplaza todos los espacios por 
* los espacios de justificaci�n
**********************************
cTexto = STRTRAN(cTexto, [ ], cEspacios)
* cTexto = cTexto+replicate([-],nAncho-LEN(cTexto))

* Si han sobrado espacios
* se pueden a�adir entre palabras
*********************************

FOR i = 1 TO nModEspacios 
    
    * Averiguamos la posici�n de la palabra
    ***************************************
    nDif = nPalabras + 1 - i
    cPalabra = WordNum(cTexto,nDif)
    nPos = RAT([ ]+cPalabra,cTexto)
    
    * Insertamos un espacio m�s
    ***************************
    cTexto = STUFF(cTexto,nPos,0,[ ])
       
NEXT

RETURN cTexto



*-------------------------------------------------------
* Funci�n.....: NombreFichero(cFichero)
*
* Descripci�n.: Devuelve el nombre de fichero, incluyendo
*               la extensi�n
*
* Par�metros..: cFichero	- Nombre de fichero incluyendo
*                             la extensi�n y la ruta
*
* Devuelve....: Caracter
*
* Notas.......: 27/01/1997 10:35:02 Pedro Hern�ndez
*-------------------------------------------------------
FUNCTION NombreFichero(cFichero)

IF RAT('\',cFichero) > 0
   cFichero = SUBSTR(cFichero,RAT('\',cFichero)+1,255)
ENDIF
IF AT(':',cFichero) > 0
   cFichero = SUBSTR(cFichero,AT(':',cFichero)+1,255)
ENDIF
RETURN ALLTRIM(UPPER(cFichero))



*-------------------------------------------------------
* Funci�n.....: ForzarExtension(cFichero,cExtension)
*
* Descripci�n.: Devuelve un nombre de fichero con una 
*               extensi�n definida como par�metro, ignorando
*               la extensi�n que tuviera
*
* Par�metros..: cFichero	- Nombre de fichero incluyendo
*                             la extensi�n y la ruta
*               cExtension  - Extensi�n que va a sustituir
*                             a la existente
*
* Devuelve....: Caracter
*
* Notas.......: 27/01/1997 10:38:28 Pedro Hern�ndez
*-------------------------------------------------------

FUNCTION ForzarExtension(cFichero,cExtension)

LOCAL cCamino


IF SUBSTR(cExtension,1,1) = "."
   cExtension = SUBSTR(cExtension,2,3)
ENDIF

cCamino = SoloCamino(cFichero)
cFichero = SoloNombre(UPPER(ALLTRIM(cFichero)))
IF AT('.',cFichero) > 0
   cFichero = SUBSTR(cFichero,1,AT('.',cFichero)-1) + '.' + cExtension
ELSE
   cFichero = cFichero + '.' + cExtension
ENDIF
RETURN ADDBS(cCamino) + cFichero



*-------------------------------------------------------
* Funci�n.....: SoloCamino(cFichero)
*
* Descripci�n.: Devuelve la ruta de acceso al fichero
*               pasado como par�metro
*
* Par�metros..: cFichero	- Nombre de fichero incluyendo
*                             la extensi�n y la ruta
*
* Devuelve....: Caracter
*
* Notas.......: 27/01/1997 10:38:28 Pedro Hern�ndez
*-------------------------------------------------------
FUNCTION SoloCamino(cFichero)
cFichero = ALLTRIM(UPPER(cFichero))
IF '\' $ cFichero
   cFichero = SUBSTRC(cFichero,1,RAT('\',cFichero))
   IF RIGHT(cFichero,1) = '\' AND LEN(cFichero) > 1 ;
         AND SUBSTRC(cFichero,LEN(cFichero)-1,1) <> ':'
      cFichero = SUBSTRC(cFichero,1,LEN(cFichero)-1)
   ENDIF
   RETURN cFichero
ELSE
   RETURN ''
ENDIF



*-------------------------------------------------------
* Funci�n.....: SumaFecha(dFecha,nValor,cTipo)
*
* Descripci�n.: Aumenta en la unidad pasada como par�metro
*               la fecha indicada. 
*
* Par�metros..: dFecha	- Fecha
*               nValor  - Unidades a aumentar
*               cTipo   - Tipo de unidad a aumentar. 
*                         Siendo:
*                         A - A�os
*                         M - Meses
*                         D - D�as
*
* Devuelve....: Caracter
*
* Notas.......: 27/01/1997 10:38:28 Pedro Hern�ndez
*-------------------------------------------------------
FUNCTION SumaFecha(dFecha,nValor,cTipo)

* Declaraci�n de variables
**************************
LOCAL nDia, nMes, nA�o, cDia, cMes, cA�o

* Inicializaci�n de variables
*****************************
nDia = DAY(dFecha)
nMes = MONTH(dFecha)
nA�o = YEAR(dFecha)

DO CASE 
   CASE cTipo = 'D'
        nDia = nDia + nValor

   CASE cTipo = 'M'
        IF nMes + nValor > 12
           IF nValor > 12
              nRMes = MOD(nValor,12)
              nSMes = INT(nValor/12)
              IF nMes + nRMES > 12
                 * nSMes = nSMes + 1
                 * nMes = nMes + MOD(nRMes,12)
                 nMes = nMes + nRMes - 12
              ELSE 
                 nMes = nMes + nRMes
              ENDIF   
              nA�o = nA�o + nSMes
           ELSE
              nA�o = nA�o + 1
              nMes = nMes + nValor - 12
           ENDIF
        ELSE 
           nMes = nMes + nValor 
        ENDIF
   CASE cTipo = 'A'
        nA�o = nA�o + nValor
ENDCASE 

cDia = ALLTRIM(STR(nDia))
cMes = ALLTRIM(STR(nMes))
cA�o = ALLTRIM(STR(nA�o))

RETURN CTOD(cDia+'-'+cMes+'-'+cA�o)

FUNCTION MyChrTran
	LPARAMETERS tcSearchedExpression, tcSearchExpression, tcReplacementExpression
	LOCAL lcRet, lcReplace, lnSub
	IF	EMPTY(tcSearchedExpression)
		tcSearchedExpression = ''
	ENDIF
	IF	EMPTY(tcSearchExpression)
		tcSearchExpression = ''
	ENDIF
	IF	EMPTY(tcReplacementExpression)
		tcReplacementExpression = ''
	ENDIF
	lcRet = tcSearchedExpression
	FOR	lnSub = 1 TO LEN(tcSearchExpression)
		lcRet = STRTRAN(lcRet, SUBSTR(tcSearchExpression, lnSub, 1) , ;
				SUBSTR(tcReplacementExpression, lnSub, 1))
	ENDFOR
	RETURN lcRet
ENDFUNC

FUNCTION MyFullPath
	LPARAMETERS tcFileName1, lnMSDOSPath
	LOCAL lcRet, lcOldPath
	IF	EMPTY(tcFileName1)
		tcFileName1 = ''
	ENDIF
	lcOldPath = SET('PATH')
	IF	TYPE('lnMSDOSPath') = 'N'
		SET PATH TO (GETENV('PATH'))
	ENDIF
	lcRet = SYS(2014, tcFileName1, 'a:\')
	SET PATH TO (lcOldPath)
	RETURN lcRet
ENDFUNC

FUNCTION Clave
LPARAMETERS cTexto, lEncripta
LOCAL nCount, cBase, cClave
cBase = REPLICATE('rphpg137', INT(LEN(cTexto) / 8) + 1)
cClave = ''
IF	lEncripta
	FOR nCount = 1 TO LEN(cTexto)
		IF	ASC(SUBSTR(cTexto, nCount, 1)) + ASC(SUBSTR(cBase, nCount, 1)) > 255
			cClave = cClave + CHR(ASC(SUBSTR(cTexto, nCount, 1)) + ;
						ASC(SUBSTR(cBase, nCount, 1)) - 224)
		ELSE
			cClave = cClave + CHR(ASC(SUBSTR(cTexto, nCount, 1)) + ;
						ASC(SUBSTR(cBase, nCount, 1)))
		ENDIF
	ENDFOR
ELSE
	FOR nCount = 1 TO LEN(cTexto)
		IF	ASC(SUBSTR(cTexto, nCount, 1)) - ASC(SUBSTR(cBase, nCount, 1)) < 32
			cClave = cClave + CHR(ASC(SUBSTR(cTexto,i,1)) - ;
						ASC(SUBSTR(cBase,i,1)) + 224)
		ELSE
			cClave = cClave + CHR(ASC(SUBSTR(cTexto,i,1)) - ;
						ASC(SUBSTR(cBase,i,1)))
		ENDIF
	ENDFOR
ENDIF
RETURN cClave
	
PROCEDURE WinCascade

LOCAL 	loForm, lnNumForm, lnFormIndex, loLastForm

WITH oAplicacion.oForms

	IF .IsEmpty()
		RETURN .T.
	ENDIF

	loLastForm = .NULL.
	lnNumForm = .GetObjectCount()
	FOR lnFormIndex =  1 TO lnNumForm
		*-- Get the form reference
		loForm = .GET(lnFormIndex)
		IF TYPE("loForm") == "O" AND !ISNULL(loForm)
			IF loForm.VISIBLE
				*!* Make sure it is not minimized.
				loForm.WINDOWSTATE = 0
				*-- Move the form
				IF ISNULL(loLastForm)
					loForm.MOVE(0, 0)
				ELSE
					loForm.MOVE( ;
						MIN(SYSMETRIC(SM_SCREENWIDTH) - 50, ;
						loLastForm.LEFT + MIN(23, loLastForm.WIDTH)), ;
						MIN(SYSMETRIC(SM_SCREENHEIGHT) - 150, ;
						loLastForm.TOP + MIN(23, loLastForm.HEIGHT)) ;
						)
				ENDIF
				loForm.SHOW()
				loLastForm = loForm
			ENDIF
		ELSE
			*-- This should never be processed. It is just a safety catch.
			MESSAGEBOX("goApp.oForms corrupted. (utility.prg)")
			RETURN
		ENDIF
	ENDFOR
ENDWITH
ENDPROC



PROCEDURE FermeTout

LOCAL loForm,  loActiveForm;
	lnNumForm, ;
	lnFormIndex ,;
	lcLastFormName

*!* BUG 970918120524 - EF
*!* Check the ActiveForm exists
IF TYPE('_SCREEN.ACTIVEFORM') == 'U'
	*!* No active window
	*!* We could clean goApp.oForms
	*!* We could clean goApp.oToolbars
	RETURN .T.
ELSE
	*!* Get reference to the active form
	*!* Delete it at the end to avoid problem with grids on active forms.
	loActiveForm = _SCREEN.ACTIVEFORM

	*-- Work on goApp
	WITH goApp.oForms
		*-- Release the forms starting from the end (faster).
		*-- The collection array is always resized after deletion, so
		*-- 'lnFormIndex' always points at the last one in the FOR loop.
		lnNumForm = .GetObjectCount()
		FOR lnFormIndex = lnNumForm TO 1 STEP -1
			*-- Get the form reference
			loForm = .GET(lnFormIndex)
			IF TYPE("loForm") == "O" AND !ISNULL(loForm)
				IF loForm.NAME == loActiveForm.NAME
					*!* BUG 970807141255 - EF
					*!* Skip the active form for now
					LOOP
				ENDIF
				*!* Release the form
				RELEASE WINDOW (loForm.NAME)
			ELSE
				*-- This should never be processed. It is just a safety catch.
				MESSAGEBOX("The form collection is corrupted. (mainproc.prg)")
				RETURN .F.
			ENDIF
		ENDFOR
	ENDWITH

	*!* BUG 970807141255 - EF
	*!* Delete active form
	lcLastFormName = loActiveForm.NAME
	RELEASE WINDOW (loActiveForm.NAME)
ENDIF

*!* BUG 971010145818 - EF *!* BUG 980212093758 - EF
*!* Here is a SMART check for an active window. Work around to some foxpro bugs ...
IF TYPE('_SCREEN.ACTIVEFORM.cFunctionId') == 'U'
	*!* There is no active form, everything went fine.
	RETURN .T.
ELSE
	*!* So a form is still active hu ?
	IF ISNULL(loActiveForm)
		*!* The last form was released ...
		IF lcLastFormName = _SCREEN.ACTIVEFORM.NAME
			*!* ... but the active form still refers to it ! Ignore it.
			RETURN .T.
		ENDIF
	ENDIF
	*!* The active form is 'really' active
	RETURN .F.
ENDIF

ENDPROC
