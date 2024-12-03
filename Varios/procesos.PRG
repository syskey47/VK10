*--------------------------------------------------
FUNCTION _Actualizable(tcAlias)
*--------------------------------------------------
* Hace actualizable un cursor
* USO: _Actualizable("MiCursor")
* PARAMETRO:
*    tcAlias = Alias del cursor
*--------------------------------------------------
	LOCAL lcAliasTmp, lcAliasAnt
	lcAliasAnt = ALIAS()
	IF EMPTY(tcAlias) OR NOT USED(tcAlias)
	   WAIT WINDOW NOWAIT " No existe el alias "
	   RETURN
	ENDIF
	lcAliasTmp = SYS(2015)
	USE DBF(tcAlias) IN 0 SHARE AGAIN ALIAS (lcAliasTmp)
	USE DBF(lcAliasTmp) IN (tcAlias) SHARE AGAIN ALIAS (tcAlias)
	USE IN (lcAliasTmp)
	IF NOT EMPTY(lcAliasAnt)
	   SELECT (lcAliasAnt)
	ENDIF
	RETURN
ENDFUNC


**********************************************************************
*
* Función: hazmodificable 
*
* Hace modificable un cursor creado con SELECT SQL
*
* Sintaxis: 
*
* =goCSApp.hazmodificable(cursor)
*
* Parametros:
*
* cursor
*
* Ejemplos:
*
* = hazmodificable(ALIAS())
* = hazmodificable("query1")
*
* Retorno:
*
* nada
*
* Nota: No debe haber ningun alias xxTemp abierto
* **********************************************************************
FUNCTION hazmodificable
LPARAMETERS tcalias
USE DBF(tcalias) IN 0 AGAIN alias xxTemp
USE DBF("xxTemp") IN (tcalias) AGAIN ALIAS (tcalias)
USE IN xxTemp
ENDFUNC

Muestra el porcentaje de ejecución de un comando SELECT o USE VIEW




*----------------------------------------
* EJEMPLO DE USO
*----------------------------------------

LOCAL loBar
loBar = CREATEOBJECT("SQLBar")
SELECT * ;
  FROM MiTabla ;
  INTO CURSOR MiCursor ;
  WHERE MiCampo = "ALGO"
RELEASE loBar

*----------------------------------------
* Comienzo la definición de la calse
*----------------------------------------
DEFINE CLASS SQLBar AS CUSTOM
  PROTECTED lSetTalk, lWindows
  lSetTalk = ""
  lWindow = ""
  NAME = "SQLBar"

  PROCEDURE INIT
    THIS.lSetTalk = SET("TALK")
    THIS.lWindow = SYS(2015)
    DEFINE WINDOW (THIS.lWindow) FROM 0,0 TO 1,1
    SET TALK WINDOW (THIS.lWindow)
    SET TALK ON
  ENDPROC

  PROCEDURE DESTROY
    LOCAL lThisSetTalk
    lThisSetTalk = THIS.lSetTalk
    SET TALK &lThisSetTalk
    RELEASE WINDOW (THIS.lWindow)
  ENDPROC
ENDEFINE

*----------------------------------------
* Final la definición de la clase



TERMOMETRO EN PROCESOS
*----------------------------------------
* EJEMPLO DE USO
*----------------------------------------

LOCAL loBar, lnI
loBar = CREATEOBJECT("ThermoStatusBar")
FOR lnI = 1 TO 100
  loBar.Grafica(lnI)
  INKEY(.01)
ENDFOR
RELEASE loBar

*----------------------------------------
* Comienzo la definición de la calse
*----------------------------------------
DEFINE CLASS ThermoStatusBar AS CUSTOM
  PROTECTED lcSetStatusBar
  lcSetStatusBar=""
  Name = "ThermoStatusBar"

  PROCEDURE INIT
    THIS.lcSetStatusBar = SET("STATUS BAR")
    SET STATUS BAR ON
    SET MESSAGE TO
    RETURN ""
  ENDPROC

  PROCEDURE DESTROY
    LOCAL lcStatusBar
    lcStatusBar = THIS.lcSetStatusBar
    SET MESSAGE TO
    SET STATUS BAR &lcStatusBar
    RETURN ""
  ENDPROC

  PROCEDURE Grafica(lnPorcentaje)
    IF EMPTY(lnPorcentaje)
      lnPorcentaje = 0
    ENDIF
    IF lnPorcentaje > 100
      lnPorcentaje = 100
    ENDIF
    SET MESSAGE TO REPLICATE(""", 160*lnPorcentaje/100) ;
      + STR(INT(lnPorcentaje),4) + "%"
    RETURN ""
  ENDPROC
ENDDEFINE


Mensaje Wait en barra de procesps



*----------------------------------------
* Ejemplo de uso
*----------------------------------------
LOCAL loBar, lcTexto

lcTexto = " Este texto aparece en la BARRA !!! "
loBar = CREATEOBJECT("WaitStatusBar", lcTexto)
=INKEY(0)

lcTexto = " Ahora aparece este !!! "
loBar.SetWaitText(lcTexto)
=INKEY(0)

RELEASE loBar

*----------------------------------------
* Comienzo la definición de la calse
*----------------------------------------
DEFINE CLASS WaitStatusBar AS CUSTOM
 PROTECTED lcSetStatusBar
 lcSetStatusBar=""
 NAME = "WaitStatusBar"

 PROCEDURE INIT(lcTexto)
  IF EMPTY(lcTexto)
   lcTexto = "..."
  ENDIF
  THIS.lcSetStatusBar = SET("STATUS BAR")
  SET STATUS BAR ON
  SET MESSAGE TO lcTexto
  RETURN ""
 ENDPROC

 PROCEDURE DESTROY
  LOCAL lcStatusBar
  lcStatusBar = THIS.lcSetStatusBar
  SET MESSAGE TO
  SET STATUS BAR &lcStatusBar
  RETURN ""
 ENDPROC

 PROCEDURE SetWaitText(lcTexto)
  IF EMPTY(lcTexto)
   lcTexto = "..."
  ENDIF
  SET MESSAGE TO lcTexto
  RETURN ""
 ENDPROC

ENDDEFINE
*----------------------------------------
* Final la definición de la clase
 


Con la clase Login podemos tener facilmente un control de acceso a nuestras aplicaciones.

Ejemplo

IF _Login(1)
   *-- Usuario autenticado OK.
ELSE
   *-- Usuario no válido
   RETURN
ENDIF






* ----------------------------------------
* Function _Login( lnNivel, lnNivelSup)
* ----------------------------------------
* Funcion que muestra el form de LOGIN
* Parámetros:
*     lnNivel [opc] - Nivel autorizado.
*     si se omite permite cualquier 
*     usuario registrado
* ----------------------------------------
FUNCTION _Login( lnNivel, lnNivelSup)
  LOCAL llRet
  IF PARAMETERS() < 1
    lnNivel = 0
  ENDIF
  IF PARAMETERS() < 2
    lnNivelSup = 10
  ENDIF

  loForm = CREATEOBJECT("Login", lnNivel, lnNivelSup)
  loForm.SHOW()
  llRet = loForm.lRetorno
  RELE loForm

  IF llRet
    RETURN .T.
  ELSE
    RETURN .F.
  ENDI
ENDFUNC

* ----------------------------------------
*-- Class:        Login
*-- Ingreso de password
* ----------------------------------------
DEFINE CLASS Login AS FORM
  HEIGHT = 110
  WIDTH = 220
  DOCREATE = .T.
  AUTOCENTER = .T.
  BORDERSTYLE = 2
  CAPTION = "Ingrese usuario y contraseña"
  CONTROLBOX = .F.
  CLOSABLE = .F.
  MAXBUTTON = .F.
  MINBUTTON = .F.
  WINDOWTYPE = 1
  *-- Nivel inferior de acceso
  nNivelInf = -1
  *-- Nivel superior de acceso
  nNivelSup = -1
  *-- Numero de intentos de validacion
  nIntentos = -1
  NAME = "Login"
  *-- retorna .T. si el usuario y contraseña son correctos
  lRetorno = .F.
  ADD OBJECT cmdaceptar AS COMMANDBUTTON WITH ;
    TOP = 72, ;
    LEFT = 48, ;
    HEIGHT = 25, ;
    WIDTH = 72, ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    CAPTION = "Aceptar", ;
    DEFAULT = .T., ;
    TABINDEX = 5, ;
    NAME = "cmdAceptar"
  ADD OBJECT cmdcancelar AS COMMANDBUTTON WITH ;
    TOP = 72, ;
    LEFT = 133, ;
    HEIGHT = 25, ;
    WIDTH = 72, ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    CANCEL = .T., ;
    CAPTION = "Cancelar", ;
    TABINDEX = 6, ;
    NAME = "cmdCancelar"
  ADD OBJECT lblusuario AS LABEL WITH ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    ALIGNMENT = 1, ;
    BACKSTYLE = 0, ;
    CAPTION = "Usuario", ;
    HEIGHT = 15, ;
    LEFT = 12, ;
    TOP = 16, ;
    WIDTH = 60, ;
    TABINDEX = 2, ;
    NAME = "lblUsuario"
  ADD OBJECT lblcontrasena AS LABEL WITH ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    ALIGNMENT = 1, ;
    BACKSTYLE = 0, ;
    CAPTION = "Contraseña", ;
    HEIGHT = 15, ;
    LEFT = 12, ;
    TOP = 40, ;
    WIDTH = 60, ;
    TABINDEX = 4, ;
    NAME = "lblContrasena"
  ADD OBJECT txtusuario AS TEXTBOX WITH ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    FORMAT = "k", ;
    HEIGHT = 21, ;
    LEFT = 85, ;
    MAXLENGTH = 15, ;
    TABINDEX = 1, ;
    TOP = 12, ;
    WIDTH = 120, ;
    NAME = "txtUsuario"
  ADD OBJECT txtcontrasena AS TEXTBOX WITH ;
    FONTNAME = "MS Sans Serif", ;
    FONTSIZE = 8, ;
    FORMAT = "k", ;
    HEIGHT = 21, ;
    LEFT = 85, ;
    MAXLENGTH = 15, ;
    TABINDEX = 3, ;
    TOP = 36, ;
    WIDTH = 120, ;
    PASSWORDCHAR = "*", ;
    NAME = "txtContrasena"

  PROCEDURE validausuario
    LPARAMETERS tcUsuario, tcContrasena, tnNivelInf, tnNivelSup
    LOCAL lcUser, lcPass, lnNivel
    *--- pasa usuario a mayuscula
    tcUsuario = ALLTRIM(UPPER(tcUsuario))
    tcContrasena = ALLTRIM(tcContrasena)

    *-----------------------------
    *--- Aqui busco los datos del usuario
    *--- en la tabla de Usuarios
    *-----------------------------
    lcUser = "LUIS"
    lcPass = "siul"
    lnNivel = 5
    *-----------------------------

    *--- valido usuario y contraseña
    IF NOT (tcUsuario == lcUser ;
        AND tcContrasena == lcPass)
      *--- No existe usuario o Contraseña no válida
      =MESSAGEBOX('Usuario o contraseña inválida',48,'Advertencia')
      RETURN .F.
    ENDI
    IF NOT BETWEEN(lnNivel, tnNivelInf, tnNivelSup)
      *--- Nivel no autorizado
      =MESSAGEBOX('Usuario no autorizado para este módulo',48,'Advertencia')
      RETURN .F.
    ENDI
    *--- Todo correcto
    RETURN .T.
  ENDPROC

  PROCEDURE UNLOAD
    RETURN THISFORM.lRetorno
  ENDPROC

  PROCEDURE INIT
    LPARAMETERS tnNivelInf, tnNivelSup
    IF PARAMETERS() < 0
      tnNivelInf = 0
    ENDIF
    IF PARAMETERS() < 1
      tnNivelSup = 10
    ENDIF
    THISFORM.nIntentos = 0
    THISFORM.nNivelInf = tnNivelInf
    THISFORM.nNivelSup = tnNivelSup
    THISFORM.txtUsuario.SETFOCUS
    THISFORM.cmdAceptar.DEFAULT = .T.   && porque lo pierde en el SetFocus
  ENDPROC

  PROCEDURE cmdaceptar.CLICK
    THISFORM.nIntentos=THISFORM.nIntentos+1
    THISFORM.lRetorno=THISFORM.ValidaUsuario( ;
      THISFORM.txtUsuario.VALUE, ;
      THISFORM.txtContrasena.VALUE, ;
      THISFORM.nNivelInf, THISFORM.nNivelSup)
    IF THISFORM.lRetorno
      THISFORM.HIDE
    ELSE
      IF THISFORM.nIntentos<3
        IF EMPTY(THISFORM.txtUsuario.VALUE)
          THISFORM.txtUsuario.SETFOCUS
        ELSE
          THISFORM.txtContrasena.SETFOCUS
        ENDI
      ELSE
        =MESSAGEBOX('Acceso denegado',16,'Advertencia')
        THISFORM.HIDE
      ENDI
    ENDI
  ENDPROC

  PROCEDURE cmdcancelar.CLICK
    THISFORM.lRetorno=.F.
    THISFORM.HIDE
  ENDPROC

ENDDEFINE
* ----------------------------------------
*-- EndDefine: Login
* ----------------------------------------

 

Ejecutar un archivo .AVI desde VFP mediante API 




Declare Long mciSendString in "winmm.dll";
   String lpstrCommand,;
   String lpstrReturnString,;
   Long uReturnLength,;
   Long hwndCallback 

*** Ventana normal
 = mciSendString("play C:MiAvi.avi", 0, 0, 0) 

*** Pantalla completa
= mciSendString("play C:MiAvi.avi fullscreen", 0, 0, 0)

 

Ejecutar un archivo .AVI desde VFP mediante API 




Declare Long mciSendString in "winmm.dll";
   String lpstrCommand,;
   String lpstrReturnString,;
   Long uReturnLength,;
   Long hwndCallback 

*** Ventana normal
 = mciSendString("play C:MiAvi.avi", 0, 0, 0) 

*** Pantalla completa
= mciSendString("play C:MiAvi.avi fullscreen", 0, 0, 0)

 

Desconectamos la unidad de red "anteriormente conectada".






DECLARE INTEGER WNetDisconnectDialog ;
  IN WIN32API ;
  INTEGER HWND, ;
  INTEGER nResourceType

DECLARE INTEGER GetActiveWindow IN WIN32API

ValTip = 3 && Abre el cuadro de dialogo Finalizar Captura 
ValTip = 2 && Abre el cuadro de dialogo desconectar puerto de impresora
ValTip = 1 && Abre el cuadro de dialogo desconectar unidad de red

IF WNetDisconnectDialog(GetActiveWindow(), ValTip) = 0
  MESSAGEBOX("Si se desconectó", 64, "Aviso")
ELSE
  MESSAGEBOX("No se desconectó", 16, "Aviso")
ENDIF



¿Como mostrar la ventana de "Conectar a unidad de red"?






Podemos mostrar la ventana de "Conectar a unidad de red" y conectarnos a un recurso compartido desde VFP con el siguiente código:

DECLARE INTEGER WNetConnectionDialog ;
  IN WIN32API ;
  INTEGER HWND, ;
  INTEGER nResourceType
DECLARE INTEGER GetActiveWindow IN WIN32API
IF WNetConnectionDialog(GetActiveWindow(),1) = 0
  MESSAGEBOX("Si se conectó", 64, "Aviso")
ELSE
  MESSAGEBOX("No se conectó", 16, "Aviso")
ENDIF


¿Cómo vaciar la papelera de reciclaje?






Con esta función podemos vaciar la papelera de reciclaje desde VFP mediante la API.

Podemos enviar dos parámetros: El primero es la Unidad donde se encuentra la "papelera", y el segundo es una bandera para que aparezca la ventana de confirmación de vaciado

FUNCTION VaciarPapelera(tcUnidad, tlNoPregunta)
  IF EMPTY(tcUnidad)
    tcUnidad = "C:" + CHR(0)
  ENDIF
  DECLARE INTEGER SHEmptyRecycleBin IN Shell32 ;
    INTEGER HWND, ;
    STRING @lpszRootPath, ;
    INTEGER dwFlags
  #DEFINE SHERB_NOCONFIRMATION 0x00000001
  #DEFINE SHERB_NOPROGRESSUI 0x00000002
  #DEFINE SHERB_NOSOUND 0x00000004
  SHEmptyRecycleBin(0, tcUnidad, tlNoPregunta)
  RETURN
ENDFUNC

Conectandose a la red desde Visual FoxPro
En el número de FoxPress de abril del 2000, se hizo mención a las funciones de la API de Windows para conectarse, desconectarse e interrogar sobre una conexión de red, y poder utilizarlas desde Visual FoxPro. Estas funciones son:

Interroga sobre una conexión de red...: WNetGetConnection 
Añade una nueva conexión de red......: WNetAddConnection 
Cancela una conexión de red.............: WNetCancelConnection 
Ahora podemos usar directamente funciones definidas por el usuario para una fácil implementación en nuestras aplicaciones de Visual FoxPro. Estas tres funciones se describen a continuación:

*----------------------------------------
* FUNCTION GetConnection(lcDrive)
*----------------------------------------
* Retorna el nombre de la PC y recurso
* compartido de una conexión de red
* PARAMETROS: lcDrive
* USO: ? GetConnection("K:")
*----------------------------------------
FUNCTION GetConnection(lcDrive)
DECLARE INTEGER WNetGetConnection IN WIN32API ;
STRING lpLocalName, ;
STRING @lpRemoteName, ;
INTEGER @lpnLength
LOCAL cRemoteName, nLength, lcRet, llRet
cRemoteName=SPACE(100)
nLength = 100
llRet = WNetGetConnection(lcDrive,@cRemoteName,@nLength)
lcRet = LEFT(cRemoteName,AT(CHR(0),cRemoteName)-1)
RETURN lcRet
ENDFUNC

*----------------------------------------
* FUNCTION AddConnection(tcDrive,tcResource,tcPassword)
*----------------------------------------
* Conecta un recurso compartido a la unidad tcDrive
* USO: ? AddConnection("Z:","PC_REMOTARECURSO")
*----------------------------------------
FUNCTION AddConnection(tcDrive,tcResource,tcPassword)
LOCAL lnRet
DECLARE INTEGER WNetAddConnection IN WIN32API;
STRING @lpzRemoteName, ;
STRING @lpzPassword,;
STRING @lpzLocalName
IF PARAMETERS() < 3
lnRet = WNetAddConnection(@tcResource,0,@tcDrive)
ELSE
lnRet = WNetAddConnection(@tcResource,@tcPassword, @tcDrive)
ENDIF
IF lnRet # 0
RETURN "Error " + ALLT(STR(lnRet)) + ;
" al conectar el drive " + tcDrive
ENDIF
RETURN ""
ENDFUNC

*----------------------------------------
* FUNCTION CancelConnection(tcDrive)
*----------------------------------------
* Desconecta una unidad de red
* USO: ? CancelConnection("Z:")
*----------------------------------------
FUNCTION CancelConnection(tcDrive)
LOCAL lnRet
DECLARE INTEGER WNetCancelConnection IN WIN32API;
STRING @lpzLocalName, ;
INTEGER nForce
lnRet = WNetCancelConnection( @tcDrive, 0)
IF lnRet # 0
RETURN "Error " + ALLT(STR(lnRet)) + ;
" al desconectar el drive " + tcDrive
ENDIF
RETURN ""
ENDFUNC

*----------------------------------------
Algunos directorios importantes

Muchas veces queremos que nuestras aplicaciones lean o escriban archivos en los directorios que estan por defecto en todas las computadoras que tienen instalado Windows. Por ejemplo el directorio "C:WINDOSW"

La ruta y el nombre de estos directorios, lo podemos conocer con las siguientes funciones de la API de Windows:

Directorio de Windows................: GetWindowsDirectory 
Directorio System de Windows.....: GetSystemDirectory 
Directorio Temporal de Windows...: GetTempPath 
Estas funciones de la API las declaramos directamente en las siguientes funciones definidas por el usuario, para invocarlas facilmente desde Visual FoxPro. Las funciones son las siguientes:

*----------------------------------------
* FUNCTION WinDir()
*----------------------------------------
* Retorna el directorio de Windows
* USO: ? WinDir() -> "C:WINNT"
*----------------------------------------
FUNCTION WinDir()
LOCAL lcPath, lnSize
lcPath = SPACE(255)
lnsize = 255
DECLARE INTEGER GetWindowsDirectory IN Win32API ;
STRING @pszSysPath,;
INTEGER cchSysPath
lnSize = GetWindowsDirectory(@lcPath, lnSize)
IF lnSize <= 0
lcPath = ""
ELSE
lcPath = ADDBS(SUBSTR(lcPath, 1, lnSize))
ENDIF
RETURN lcPath
ENDFUNC

*----------------------------------------
* FUNCTION SystemDir()
*----------------------------------------
* Retorna el directorio SYSTEM de Windows
* USO: ? SystemDir() -> "C:WINNTSYSTEM32"
*----------------------------------------
FUNCTION SystemDir()
LOCAL lcPath, lnSize
lcPath = SPACE(255)
lnsize = 255
DECLARE INTEGER GetSystemDirectory IN Win32API ;
STRING @pszSysPath,;
INTEGER cchSysPath
lnSize = GetSystemDirectory(@lcPath, lnSize)
IF lnSize <= 0
lcPath = ""
ELSE
lcPath = ADDBS(SUBSTR(lcPath, 1, lnSize))
ENDIF
RETURN lcPath
ENDFUNC

*----------------------------------------
* FUNCTION TempDir()
*----------------------------------------
* Retorna la ruta de los archivos temporales
* USO: ? TempDir() -> "C:WINNTTEMP"
*----------------------------------------
FUNCTION TempDir()
LOCAL lcPath, lnRet
lcPath = SPACE(255)
lnSize = 255
DECLARE INTEGER GetTempPath IN WIN32API ;
INTEGER nBufSize, ;
STRING @cPathName
lnRet = GetTempPath(lnSize, @lcPath)
IF lnRet <= 0
lcPath = ""
ELSE
lcPath = ADDBS(SUBSTR(lcPath, 1, lnRet))
ENDIF
RETURN lcPath
ENDFUNC

*----------------------------------------
Nombre de usuario y computadora

Cuando queremos saber el nombre de usuario o el nombre de la computadora, podemos usar directamente desde FoxPro el comando SYS(0), que nos devuelve información sobre el equipo de red cuando se utiliza Visual FoxPro en un entorno de red. Pero también existen las siguientes funciones de la API de Windows que nos devuelven esta información:

Retorna el nombre del usuario.............: GetUserName 
Retorna el nombre de la computadora...: GetComputerName 
Las funciones escritas en código de Visual FoxPro y de fácil uso son las siguientes:

*----------------------------------------
* FUNCTION UserName()
*----------------------------------------
* Retorna el nombre del usuario
* USO: ? UserName() -> "LUISG"
*----------------------------------------
FUNCTION UserName()
LOCAL lcUser, lnSize
lcUser = SPACE(80)
lnSize = 80
DECLARE INTEGER GetUserName IN WIN32API ;
STRING @cUserName, ;
INTEGER @nSize
=GetUserName(@lcUser, @lnSize)
IF lnSize < 2
lcUser = ""
ELSE
lcUser = SUBSTR(lcUser, 1, lnSize-1)
ENDIF
RETURN lcUser
ENDFUNC

*----------------------------------------
* FUNCTION ComputerName()
*----------------------------------------
* Retorna el nombre de la computadora
* USO: ? ComputerName() -> "PC_DESARROLLO"
*----------------------------------------
FUNCTION ComputerName()
LOCAL lcComputer, lnSize
lcComputer = SPACE(80)
lnSize = 80
DECLARE INTEGER GetComputerName IN WIN32API ;
STRING @cComputerName, ;
INTEGER @nSize
=GetComputername(@lcComputer, @lnSize)
IF lnSize < 2
lcComputer = ""
ELSE
lcComputer = SUBSTR(lcComputer, 1, lnSize)
ENDIF
RETURN lcComputer
ENDFUNC

*----------------------------------------
Sonidos y espera

Mediante la API de Windows, podemos ejecutar los sonidos del sistema o cualquier archivo de extensión .wav. También podemos detener la ejecución del programa durante "n" milisegundos. Las funciones son las siguientes:

Ejecuta el sonido predeterminado del sistema...: MessageBeep 
Ejecuta el sonido de un archivo wav...............: PlaySound 
Detiene la ejecución de un programa...............: Sleep 
Para ejecutar estas funciones desde Visual FoxPro usamos lo siguiente:

*----------------------------------------
* FUNCTION Beep(tnSound)
*----------------------------------------
* Ejecuta el sonido predeterminado del sistema
* USO: ? Beep(0)
*----------------------------------------
FUNCTION Beep(tnSound)
tnSound = IIF(VARTYPE(tnSound) = "N", tnSound, 1)
DECLARE INTEGER MessageBeep IN WIN32API ;
INTEGER nSound
RETURN IIF(MessageBeep(tnSound) = 1, .T., .F.)
ENDFUNC

*----------------------------------------
* FUNCTION PlayWav(lcWaveFile, lnPlayType)
*----------------------------------------
* Ejecuta un archivo .WAV
* USO: PlayWave( [,])
* Archivo_Wav = Ruta completa del archivo .Wav
* Ejecucion = 1 - Ejecución en background (default)
* 0 - La aplicación espera la ejecución
* 2 - Si el archivo no existe, no ejecuta el default
* 4 - Apaga el sonido que se está ejecutando
* 8 - Continuado
*----------------------------------------
FUNCTION PlayWav(lcWaveFile, lnPlayType)
lnPlayType = IIF(VARTYPE(lnPlayType) = "N", lnPlayType, 1)
DECLARE INTEGER PlaySound IN WINMM.DLL ;
STRING cWave, ;
INTEGER nModule, ;
INTEGER nType
RETURN IIF(PlaySound(lcWaveFile,0,lnPlayType) = 1, .T., .F.)
ENDFUNC

*----------------------------------------
* FUNCTION Sleep(lnMiliSeg)
*----------------------------------------
* Función que detiene la ejecución de un programa
* durante "n" milisegundos sin interfase con el teclado.
* USO: ? Sleep(1500)
*----------------------------------------
FUNCTION Sleep(lnMiliSeg)
lnMiliSeg = IIF(VARTYPE(lnMiliSeg) = "N", lnMiliSeg, 1000)
DECLARE Sleep IN WIN32API ;
INTEGER nMillisecs
RETURN IIF(Sleep(lnMiliSeg) = 1, .T., .F.)
ENDFUNC

*----------------------------------------
Posición del cursor

Algunas funciones de la API de Windows son muy curiosas, como esta que nos permite configurar la posición del cursor en nuestra pantalla:

Posiciona el cursor en la pantalla......: SetCursorPos 
Esta función en código de Visual FoxPro es:

*----------------------------------------
* FUNCTION SetCurPos(lnX, lnY)
*----------------------------------------
* Coloca el cursor en la posición especificada
* USO: ? SetCurPos(50,200)
*----------------------------------------
FUNCTION SetCurPos(lnX, lnY)
lnX = IIF(EMPTY(lnX),0,lnX)
lnY = IIF(EMPTY(lnY),0,lnY)
DECLARE INTEGER SetCursorPos IN WIN32API ;
INTEGER lnX, ;
INTEGER lnY
RETURN IIF(SetCursorPos(lnX, lnY) = 1, .T., .F.)
ENDFUNC

*----------------------------------------
Verificar si la aplicación está activa

Podemos saber si una aplicación está activa, para ello tenemos la función de la API:

Busca la ventana activa......: FindWindows 
A esta función se le debe pasar como parámetro, el título (caption) de la aplicación. Este parámetro debe ser exactamente igual al título de la ventana de la aplicación que queremos verificar:

*----------------------------------------
* FUNCTION IsActive(tcCaption)
*----------------------------------------
* Verifica si una aplicación ya está activa
* USO: ? IsActive("Calculadora")
*----------------------------------------
FUNCTION IsActive(tcCaption)
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName
RETURN FindWindow(0, tcCaption) # 0
ENDFUNC
*----------------------------------------
Con esta función podemos comprobar si nuestra aplicación de Visual FoxPro ya ha sido iniciada en una PC y así no iniciarla nuevamente. Para lograrlo escribiremos una función que se invoca en el inicio de nuestra aplicación, luego de haber colocado el título a nuestra ventana principal. 

*----------------------------------------
* FUNCTION YaActiva()
*----------------------------------------
* Comprueba que la aplicación no se esta ejecutando
* Invoca a IsActive() descripta anteriormente
*----------------------------------------
FUNCTION YaActiva()
LOCAL llRet, lcCaption
llRet = .F.
lcCaption = _SCREEN.Caption
*--- Renombra temporariamente el caption de la app
_SCREEN.Caption = "_" + lcCaption
IF IsActive(lcCaption)
*--- Si ya esta activo
MESSAGEBOX("Este sistema ya está activo",16,"Aviso")
llRet = .T.
ENDIF
_SCREEN.Caption = lcCaption
RETURN llRet
ENDFUNC

*----------------------------------------
Si la función YaActiva() retorna .T., entonces ya hay una instancia de la aplicación activa, y debemos cancelar la nueva ejecución. 

Mas funciones

Muchas funciones de la API de Windows ya fueron tratadas en este Portal y existen muchas funciones mas, de la que podemos sacar provecho, y darle un toque mas profesional a nuestras aplicaciones.




Si quieres saber la aplicación, o la ruta de la aplicación que abre un archivo determinado, puedes utilizar un programa como el mostrado o convertir éste en una función.





Por ejemplo:
Queremos saber la aplicación que nos abre un archivo tipo INI.
Se utiliza como ejemplo el archivo win.ini del directorio c:windows

el programa da como resultado:
c:windowsnotepad.exe


DECLARE LONG FindExecutable IN SHELL32.DLL ;
	STRING lpfile, ;
STRING lpdirectory, ;
STRING lpresult 
sFile = "C:windowswin.ini"
IF NOT FILE(SFILE)
	WAIT WINDOWS "El archivo no existe"
	RETURN
ENDIF
S2=SPACE(260)
I=0
i = FindExecutable(sFile,"",@S2)
IF i > 32
	NL=AT(CHR(0),S2)-1
	? SUBSTR(S2,1,NL)
ELSE
	WAIT WINDOWS "No hay Aplicación asociada"
ENDIF
RETURN



Reproduce Archivos de sonido multimedia

*-- Class: sonidos --*






**************************************
*-- Class: sonidos (c:fuentescesaclasescesa.vcx)
*-- ParentClass: custom
*-- BaseClass: custom
*-- Forma de uso:
*-- MyMedia = CreateObject("Sonidos")
*-- MyMedia.Abresonido("C:MultimediaMusicaShopin.wav")
*-- MyMedia.Play()
*-- Para detener el sonido en cualquier momento utiliza MyMedia.ClosePlay()
*-- Para hacer una pausa utiliza Mymedia.Pause()
*-- Divierte.-- recuerda que todo es posible en Foxpro
**************************************
DEFINE CLASS sonidos AS CUSTOM

  mcierror = 0
  mcierrorstring = "Objeto no localizado"
  NAME = "sonidos"
  openplay = .F.

  *----------
  * PROCEDURE AbreSonido
  *----------
  PROCEDURE AbreSonido
    PARAMETERS cFileName
    cFileName=ALLTRIM(cFileName)
    *!* Revisamos el estado del archivo de sonidos
    cCmd = ("STATUS FoxMedia READY")
    IF THIS.doMCI(cCmd) = "true" THEN
      *!* If one is, close it
      cCMD = ("CLOSE FoxMedia WAIT")
      THIS.doMCI(cCmd)
      *!* And use the custom Disable method of the form to disable
      *!* all appropriate controls
      THISFORM.ctrlMedia1.DISABLE(.T.)
    ENDIF

    *!* Prompt the user for the media file to open
    IF !EMPTY(cFileName)
      IF !FILE(cFileName)
        cFileName = GETFILE("avi|mov|wav|mid|cda","Archivo a ejecutar")
      ENDIF
    ELSE
      cFileName = GETFILE("avi|mov|wav|mid|cda","Archivo a ejecutar")
    ENDIF
    IF !EMPTY(cFileName) THEN

      _SCREEN.MOUSEPOINTER = 11

      *!* Need to use window handle functions in FoxTools
      *	SET LIBRARY TO HOME() + ".FOXTOOLS.FLL"
      SET LIBRARY TO FOXTOOLS.FLL
      EXTERNAL PROCEDURE MainHWND
      EXTERNAL PROCEDURE _WhToHwnd
      EXTERNAL PROCEDURE _WOnTop

      * Returns Handle of Main VFP Window
      Main_hWnd = MainHWND()

      * Get Handle of the form with FOXTOOLS.FLL
      cur_window = _WhToHwnd(_WOnTop())

      NullPointer = 0

      *!* Set up open MCI command into string variable
      cCmd = ('OPEN "' + cFileName + '" alias FoxMedia' + ;
        ' style child parent ' + ALLTRIM(STR(cur_window)) + ' WAIT')

      *!* Execute the MCI command
      THIS.doMCI(cCmd)

      *!* Check to see if MCI command succeeded
      IF THIS.MCIerror > 0 THEN
        *!* If not, it might be a non-visual media
        *!* We'll try to open it without setting the window parent
        cCmd = ('OPEN "' + cFileName + '" alias FoxMedia WAIT')
        THIS.doMCI(cCmd)
        IF THIS.MCIerror > 0 THEN
          *!* Nope, still won't open.  Some other error.
          *!* Let's show the user the MCI error and get out
          MESSAGEBOX(THIS.MCIerrorString)
          _SCREEN.MOUSEPOINTER = 0
          RETURN
        ELSE
          *!* It's not a visual media, so let's show a label
          *!* to let the user know the media has been loaded
          *			THIS.lblNonVisual.visible = .T.
        ENDIF
      ELSE
        *!* It does have visual media, so we need to set up the window
        *!* it will play in.

        *!* Get the window handle of the window playing the video
        cCmd = "status FoxMedia window handle wait"
        hWin = INT(VAL(THIS.doMCI(cCmd)))

        *!* Once we have the window handle, we need to position
        *!* the video window to be the same position and size
        *!* as our player rectangle on the form
        x1Pos = THISFORM.player.LEFT
        y1Pos = THISFORM.player.TOP
        x2Pos = THISFORM.player.WIDTH
        y2pos = THISFORM.player.HEIGHT

        *!* Use the SetWindowPos Windows function to set position and size
        setWindowPos(hWin,0,x1Pos,y1Pos,x2Pos,y2Pos,0)

        *!* Everything's done, let's show the video
        cCmd = ("WINDOW FoxMedia state show")
        THIS.doMCI(cCmd)

      ENDIF

      *!* Set the device to use milliseconds when setting/getting position
      THIS.doMCI("SET FoxMedia time format milliseconds")

      *!* Enable all appropriate controls
      THISFORM.CtrlMedia1.DISABLE(.F.)

      *THISFORM.lblLoading.visible = .F.
      _SCREEN.MOUSEPOINTER = 0
    ENDIF
  ENDPROC

  *----------
  * PROCEDURE PLAY
  *----------
  PROCEDURE PLAY

    *!* First need to see if the media is at the end
    *!* by comparing the total length with the current position
    nMediaLength = VAL(THIS.doMCI("STATUS FoxMedia length"))
    nMediaPosition = VAL(THIS.doMCI("STATUS FoxMedia position"))

    IF nMediaPosition >= nMediaLength THEN
      *!* The media is at the end, so we need to seek back to the start
      *!* of the clip before playing
      THIS.doMCI("SEEK FoxMedia to start WAIT")
    ENDIF

    *!* Now we can play the media
    THIS.doMCI("PLAY FoxMedia")
    IF THIS.MCIerror > 0 THEN
      THIS.showMCIerror
    ELSE
      THISFORM.CtrlMedia1.timer1.INTERVAL = 360
    ENDIF
  ENDPROC

  *----------
  * PROCEDURE closeplay
  *----------
  PROCEDURE closeplay
    cCmd = "CLOSE FoxMedia"
    THIS.doMCI(cCmd)
    IF THIS.MCIerror > 0 THEN
      THIS.showMCIerror
    ENDIF

    THISFORM.CtrlMedia1.timer1.INTERVAL = 0
    THISFORM.CtrlMedia1.DISABLE(.T.)
  ENDPROC

  *----------
  * PROCEDURE showmcierror
  *----------
  PROCEDURE showmcierror
    *!* This method shows the last MCI error string that occured.
    MESSAGEBOX(THIS.MCIerrorString + " (" + STR(THIS.MciError) + ")")
  ENDPROC

  *----------
  * PROCEDURE getmcierror
  *----------
  PROCEDURE getmcierror
    LPARAMETERS cError
    LOCAL lcErrorString,nError

    *!* This method is called from the doMCI to retrieve the last
    *!* MCI error string.
    *!* This function also saves the last error number and string
    *!* into properties associated with the form.

    nError=0
    IF TYPE("cError")="C"
      IF LEFT(cError,7)="*ERROR*"
        nError=VAL(SUBSTR(cError,8))
      ENDIF
    ENDIF

    IF TYPE("cError")="N"
      nError=cError
    ENDIF

    cErrorString=SPACE(256)
    =mciGetErrorString(nError,@cErrorString,LEN(cErrorString))

    THIS.MciError = nError
    THIS.MCIerrorString = cErrorString

    RETURN TRIM(CHRTRAN(cErrorString,CHR(0),""))
  ENDPROC

  *----------
  * PROCEDURE domci
  *----------
  PROCEDURE domci
    LPARAMETERS cMCIcmd

    *!* This method takes a MCI command string and executes it using
    *!* the Windows API function mciSendString

    *!* If the function executes successfully, the result is returned.
    *!* Otherwise, the error string is returned.
    cRetString = SPACE(80)
    nRetValue = mciSendString(cMCIcmd,@cRetString,LEN(cRetString),0)

    cErr = THIS.getMCIerror(nRetValue)
    IF nRetValue > 0
      RETURN CeRR
    ENDIF

    RETURN TRIM(STRTRAN(cRetString,CHR(0),""))
  ENDPROC

  *----------
  * PROCEDURE pausa
  *----------
  PROCEDURE pausa

    *!* Check to see if there is media acutally playing
    IF THIS.doMCI("STATUS FoxMedia mode") = "playing" THEN

      *!* Yes there is, so execute the PAUSE MCI command
      THIS.doMCI("PAUSE FoxMedia")
      IF THIS.MCIerror > 0 THEN
        THIS.showMCIerror
      ELSE
        THISFORM.CtrlMedia1.timer1.INTERVAL = 0
      ENDIF
    ELSE
      THIS.PLAY()
    ENDIF
  ENDPROC

  *----------
  * PROCEDURE INIT
  *----------
  PROCEDURE INIT
    *!* This is the primary Windows API function that is used to
    *!* send MCI commands
    DECLARE INTEGER mciSendString ;
      IN WinMM.DLL ;
      STRING cMCIString,;
      STRING @cRetString,;
      INTEGER nRetLength,;
      INTEGER hInstance

    *!* This function allows us to retrieve the last MCI error that occured
    DECLARE INTEGER mciGetErrorString ;
      IN WINMM.DLL ;
      INTEGER nErrorno, ;
      STRING @cBuffer, ;
      INTEGER nBufSize

    *!* When MCI plays a video, it creates its own Window.  By using
    *!* this Windows API function we can position this Window to be
    *!* in the same position as our Player rectangle on the form
    DECLARE INTEGER SetWindowPos ;
      IN User32 ;
      INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER
  ENDPROC


ENDDEFINE
*
*-- EndDefine: sonidos
**************************************

 

Como borrar un acceso directo mediante API. Enviado por Carlos Tarello, Puebla (Mexico) 




***************************************************************************
***************************************************************************
*
* Función       :  BorrarAccesoDirecto
* Proposito     :  Borra un acceso directo 
* Parametros    :  1.- Path del acceso directo
*                  2.- El texto que aparece como rotulo del acceso 
* Nota          :  Esta Función utiliza un DLL llamado "STKIT432.DLL" el cual puede ser bajado de: 
*                  ftp://ftp.vbi.org/runtimes/vb4.0/stkit432.zip
*                  ftp://us.vbi.org/pub/runtimes/vb4.0/stkit432.zip
* Regresa       :  1 = Se borro el acceso directo con exito
*                  0 = No se pudo borrar el acceso directo
* Ejemplo       :  a) Borra un acceso directo en el escritorio
*                  BorrarAccesoDirecto('....Escritorio', 'Bloc de notas')
*
*                  b) Borra un acceso directo en "Programas" del "Menú Inicio" (Dos ejemplos de lo mismo)
*                  BorrarAccesoDirecto('....Menú InicioProgramas', 'Bloc de notas')
*                  BorrarAccesoDirecto('', 'Bloc de notas')
*
*                  c) Borra un acceso directo al menu "Inicio" de "Programas"
*                  BorrarAccesoDirecto('Inicio', 'Bloc de notas')
***************************************************************************
***************************************************************************
FUNCTION BorrarAccesoDirecto(c_Ruta,c_Rotulo)
LOCAL n_Resultado
 
DECLARE INTEGER fRemoveShellLink IN STKIT432.DLL ;
 STRING lpstrFolderName,  ;
 STRING lpstrLinkName
 
 *--- ejecuta el comando para borrar el acceso directo
 n_Resultado = fRemoveShellLink(c_Ruta,c_Rotulo)
 
RETURN n_Resultado
 
***************************************************************************

 

Como crear un acceso directo mediante API. Enviado por Carlos Tarello, Puebla (Mexico)




***************************************************************************
***************************************************************************
*
* Función       :  CrearAccesoDirecto
* Proposito     :  Crea un acceso directo 
* Parametros    :  1.- Donde crear el acceso directo
*                  2.- El texto que aparecera como rotulo del acceso 
*                  3.- El path y nombre del archivo al cual se hace el acceso directo
*                  4.- Los argumentos para el archivo
* Nota          :  Debe existir la carpeta donde se va a crear el acceso directo
*                  Esta Función utiliza un DLL llamado "STKIT432.DLL" el cual puede ser bajado de:
*                  ftp://ftp.vbi.org/runtimes/vb4.0/stkit432.zip
*                  ftp://us.vbi.org/pub/runtimes/vb4.0/stkit432.zip
* Regresa       : 1 = Se creo el acceso directo con exito
*                 0 = No se pudo crear el acceso directo
* Ejemplo       : a) Crea un acceso directo en el escritorio
*                 CrearAccesoDirecto('....Escritorio', 'Bloc de notas', 'c:windows
otepad.exe', '')
*
*                 b) Crea un acceso directo en "Programas" del "Menú Inicio" (Dos ejemplos de lo mismo)
*                 CrearAccesoDirecto('....Menú InicioProgramas', 'Bloc de notas', 'c:windows
otepad.exe', '')
*                 CrearAccesoDirecto('', 'Bloc de notas', 'c:windows
otepad.exe', '')
*
*                 c) Crea un acceso directo al menu "Inicio" de "Programas"
*                 CrearAccesoDirecto('Inicio', 'Bloc de notas', 'c:windows
otepad.exe', '')
***************************************************************************
***************************************************************************
FUNCTION CrearAccesoDirecto(c_Ruta,c_Rotulo,c_Archivo,c_Argumentos)
LOCAL n_Resultado
 
DECLARE INTEGER fCreateShellLink IN STKIT432.DLL ;
 STRING lpstrFolderName,  ;
 STRING lpstrLinkName,  ; 
 STRING lpstrLinkPath,  ;
 STRING lpstrLinkArgs
 
*--- ejecuta el comando para crear el acceso directo
n_Resultado = fCreateShellLink(c_Ruta,c_Rotulo,c_Archivo,c_Argumentos)
 
RETURN n_Resultado

Con esta simple funcion se puede abrir el explorador y mostrar una pagina. me fue de mucha utilidad. Saludos. 




Function gotoUrl
	*- ir a una direccion url con el explorador predeterminado de esta maquina.
	***  Function: Starts associated Web
	***               Browser
	***            and goes to the specified
	***                          URL.
	***            If Browser is already open
	***            it reloads the page.
	***    Assume: Works only on Win95 and NT
	***                          4.0
	***      Pass: tcUrl  - The URL of the site
	***                   or HTML page to bring
	***                  up in the Browser
	***   Return:2 - Bad Association (invalid
	***               URL)
	***          31 - No application
	***               association
	***          29 - Failure to load
	***               application
	***          30 - Application is busy
	***
	***            Values over 32 indicate
	***                          success and return an
	***                          instance handle for
	***            the application started (the
	***                          browser)
	*******************************************

	Lparameters tcUrl
	cWinTemp = getenv("windir")+"TEMP"
	If !file(cWinTemp+"nul")
		Return -1
	Endif

	tcUrl=IIF(type("tcUrl")="C",tcUrl, "http://www.midireccion.com/")

	Declare INTEGER ShellExecute IN SHELL32.dll ;
		INTEGER nWinHandle,;
		STRING cOperation,;
		STRING cFileName,;
		STRING cParameters,;
		STRING cDirectory,;
		INTEGER nShowWindow

	Declare INTEGER FindWindow ;
		IN WIN32API ;
		STRING cNull,STRING cWinName

	Return ShellExecute(FindWindow(0,_SCREEN.caption), "Open",tcUrl, "",cWinTemp,0)
Endfunc

Función API para poner la Ventana Principal de VFP en el primer plano fijo, situa nuestra aplicación por encima de cualquier otra que se encuentre abierta en Windows. Enviada por Carlos Tarello (Puebla, Mexico) 




***************************************************************************
***************************************************************************
*
*   Función    : VentanaTopMost
*   Proposito  : Pasar la ventana Principal de VFP al primer plano fijo
*                Situar nuestra aplicación siempre encima de todas las 
*                demas ventanas de windows
*   Parametros : 1 - Pasar la ventana Principal de VFP al primer plano fijo
*                0 - Quitar la ventana Principal de VFP del primer plano fijo
*   Regresa    : Nada
*   Ejemplo    : =VentanaTopMost(1)
*     
***************************************************************************
***************************************************************************
FUNCTION VentanaTopMost(n_Estado)
DECLARE Integer SetWindowPos IN WIN32API ;
      Integer  nWnd, ;
      Integer  nWndInsertAfter, ;
      Integer  nTop, ;
      Integer  nLeft, ;
      Integer  nHeight, ;
      Integer  nWidth, ;
      Integer  nFlags
 
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName
      
#define SWP_NOSIZE          1
#define SWP_NOMOVE          2
#define HWND_TOPMOST       -1
#define HWND_NOTOPMOST     -2
 
*--- se obtiene el manejador de la ventana principal
n_FoxHwnd = FindWindow( 0, _SCREEN.Caption )
 
*--- si el parametro es 1
IF n_Estado = 1
 
   *--- pasar a primer plano fijo
   =SetWindowPos(n_FoxHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
 
ENDIF
 
*--- si el parametro es 0
IF n_Estado = 0
 
   *--- la quita del primer plano fijo
   =SetWindowPos(n_FoxHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
 
ENDIF
 

ENDFUNC
 
***************************************************************************


Función API para ocultar la aplicación de la lista de tareas (TaskBar), para que no pueda ser "Tronada" con las teclas Ctrl-Alt-Del, enviada por Carlos Tarello.




***************************************************************************
***************************************************************************
*
*   Función    : OcultaDelTaskBar
*   Proposito  : Oculta la aplicación del TaskBar, para que no pueda
*                ser "Tronada" con las teclas Ctrl-Alt-Del
*   Parametros : .T. = Quita de la lista del TaskBar la aplicación
*                .F. = Registra en la lista del TaskBar la aplicación
*   Nota       : Esta función no funciona con Windows NT
*   Ejemplo    :  OcultaDelTaskBar(.T.)
*
***************************************************************************
***************************************************************************
FUNCTION OcultaDelTaskBar(b_Accion)
LOCAL n_CurrProc
 
 DECLARE LONG RegisterServiceProcess IN KERNEL32.DLL  ;
   LONG ProcessID,   ;
   LONG ServiceFlags
 
 DECLARE LONG GetCurrentProcessId IN KERNEL32.DLL  ;
 
 *--- obtiene el identificador de proceso
 n_CurrProc = GetCurrentProcessId()
 
IF b_Accion = .T.
 
 *--- remueve la bandera de servicio
 RegisterServiceProcess(n_CurrProc, 1)
 
ELSE
 
 *--- crea la bandera de servicio de la aplicación
 RegisterServiceProcess(n_CurrProc, 0)
 
ENDIF
 
ENDFUNC

***************************************************************************


Función API para cambiar la imagen de fondo (Wallpaper) del escritorio de Windows, envíada por Carlos Tarello. 




***************************************************************************
***************************************************************************
*
*   Función     :  CambiarWallPaperWindows
*   Proposito   :  Cambiar la Imagen del WallPaper del Escritorio de Windows
*   Parametros  :  Cadena con el Path y el Archivo de Imagen
*   Regresa     :  1 = Se realizo el cambio con Exito
*                  0 = No se pudo hacer el cambio
*   Ejemplo     :  CambiarWallPaperWindows('C:WINDOWSFondo_60.BMP')
*                  CambiarWallPaperWindows('')
*     
***************************************************************************
***************************************************************************
FUNCTION CambiarWallPaperWindows(c_Archivo)
 
DECLARE INTEGER SystemParametersInfo IN USER32.DLL  ;
LONG uAction,   ;
LONG uParam,   ;
STRING lpvParam,  ;
LONG fuWinIni
    
uAction  = 20
uParam   = 0
lpvParam = ALLTRIM(c_Archivo) 
fuWinIni = 0
 
*--- realiza el cambio 
n_Resultado = SystemParametersInfo(@uAction,@uParam,@lpvParam,@fuWinIni)
 
RETURN n_Resultado

***************************************************************************


Función API para deshabilitar las teclas Ctrl-Alt-Del,Alt-Tab,Ctrl-Esc y Tecla "Windows", enviada por Carlos Tarello (Kevin Mitnick)




***************************************************************************
***************************************************************************
*
*   Función     : DesactivarTeclasWindows
*   Proposito   : Desactiva las combinaciones de Teclas de Windows:
*                 Ctrl-Alt-Del
*                 Alt-Tab
*                 Ctrl-Esc
*                 Tecla "Windows"
*   Parametros  : .T. = Deshabilita las teclas
*                 .F. = Habilita las teclas
*   Nota        : Esta función Hace creer al Windows que esta activado el ScreenSaver
*   Regresa     : 1 = Se realizo con Exito
*                 0 = No se pudo hacer el cambio
*   Ejemplo     : a) Deshabilita las teclas:
*                 n_Resultado = DesactivarTeclasWindows(.T.)
*
*                 b) Habilita las teclas:
*                 n_Resultado = DesactivarTeclasWindows(.F.)
 
***************************************************************************
***************************************************************************
FUNCTION DesactivarTeclasWindows(b_Estado)
 
DECLARE INTEGER SystemParametersInfo IN USER32.DLL  ;
LONG uAction,   ;
LONG uParam,   ;
STRING lpvParam,  ;
LONG fuWinIni
 
uAction  = 97
lpvParam = '0'
fuWinIni = 0
 
If b_Estado = .T. 
   *--- deshabilita las teclas
   uParam   = 1
   n_Resultado = SystemParametersInfo(@uAction,@uParam,lpvParam,@fuWinIni)
Else
   *--- habilita las teclas
   uParam   = 0
   n_Resultado = SystemParametersInfo(@uAction,@uParam,lpvParam,@fuWinIni)    
EndIf
 
RETURN n_Resultado
 
ENDFUNC

***************************************************************************


Una manera de conseguir la dirección IP local con Winsock.




************************************************************
*
* Clase: GET_IPADDRESS
*
* Devuelve la dirección IP local
*
* Parametros:
*
*		ninguno
*
* Ejemplos:
*
*	ipdir=get_ipaddress()
*
* Retorno
*
*	dirección IP o cadena vacia si no está instalado el WinSock
*
* Nota
*
*  Adaptado de John Harvey
*
* Fecha de Creación  : 29/01/2001 Pablo Roca
* Ultima Modificacion: 29/01/2001 Pablo Roca
*
************************************************************
LOCAL lcret
IPSocket = CreateObject("MSWinsock.Winsock")
IF TYPE('IPSocket')='O'
	lcret = IPSocket.LocalIP
ELSE
	MESSAGEBOX("Winsock no está instalado!")
	lcret = ""
ENDIF
RETURN lcret



*!* Cambia la resolución de la pantalla
*!* Sintaxis: ChangeRes(tnWidth, tnHeight)
*!* Valor devuelto: llRetVal
*!* Argumentos: tnWidth, tnHeight
*!* tnWidth especifica la nueva anchura de la pantalla en pixels
*!* tnHeight especifica la nueva altura de la pantalla en pixels

FUNCTION ChangeRes
    LPARAMETERS tnWidth, tnHeight
    LOCAL lnWidth, lnHeight, lnModeNum, lcDevMode
    *!* Valores
    lnModeNum  = 0
    lcDevMode  = REPLICATE(CHR(0), 156)
    lnWidth    = IIF(EMPTY(tnWidth), 800, tnWidth)
    lnHeight   = IIF(EMPTY(tnHeight), 600, tnHeight)
    *!* Instrucciones DECLARE DLL para cambiar resolución
    DECLARE INTEGER EnumDisplaySettings   IN Win32API STRING lpszDeviceName,;
	INTEGER iModeNum, STRING @lpDevMode
    DECLARE INTEGER ChangeDisplaySettings IN Win32API STRING @lpDevMode ,;
	INTEGER dwFlags
    *!* Bucle para obtener todos los modos disponibles
    DO WHILE EnumDisplaySettings(NULL, lnModeNum, @lcDevMode) <> 0
        lnModeNum = lnModeNum +1
    ENDDO
    *!* Configurar la structura DevMode
    lcDevMode = STUFF(lcDevMode,  41, 4, LongToStr(1572864))
    lcDevMode = STUFF(lcDevMode, 109, 4, LongToStr(tnWidth))  && Ancho
    lcDevMode = STUFF(lcDevMode, 113, 4, LongToStr(tnHeight))  && Alto
    *!* Cambiar resolucion
    ChangeDisplaySettings(@lcDevMode, 1)
ENDFUNC

*!* Convierte un long integer a un 4-byte character string
*!* Sintaxis: LongToStr(lnLongVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: lnLongVal
*!* lnLongVal especifica el long integer a convertir
FUNCTION LongToStr
    LPARAMETERS lnLongVal
    LOCAL lnCnt, lcRetStr
    lcRetStr = ''
    FOR lnCnt = 24 TO 0 STEP -8
        lcRetStr = CHR(INT(lnLongVal/(2^lnCnt))) + lcRetStr
        lnLongVal = MOD(lnLongVal, (2^lnCnt))
    NEXT
    RETURN lcRetStr
ENDFUNC


*!* Muestra la barra de tareas de windows
*!* Sintaxis: ShowTaskBar()
*!* Valor devuelto:
*!* Argumentos:FUNCTION ShowTaskBar
*!* Constantes para ocultar o mostrar la barra de tareas de windows
* Sgte linea notificada por Hugo Ranea 20/06/2001
    #DEFINE TOGGLE_UNHIDEWINDOW    64
    LOCAL lnHwnd
    *!* Valores
    lnHwnd = 0
    *!* Instrucciones DECLARE DLL para manipular la barra de tareas
    DECLARE INTEGER FindWindowA IN Win32API STRING lpClassName,STRING lpWindowName
    DECLARE INTEGER SetWindowPos IN Win32API INTEGER hwnd,;
    INTEGER hwndInsertAfter, INTEGER x, INTEGER y, INTEGER cx,;
    INTEGER cy, INTEGER wFlags
    *!* Valores
    lnHwnd = FindWindowA('Shell_traywnd', '')
    *!* Mostrar la barra de tareas
    IF lnHwnd <> 0
        SetWindowPos(lnHwnd, 0, 0, 0, 0, 0, TOGGLE_UNHIDEWINDOW)
    ENDIF
ENDFUNC


*!* Oculta la barra de tareas de windows
*!* Sintaxis: HideTaskBar()
*!* Valor devuelto:
*!* Argumentos:
FUNCTION HideTaskBar

*!* Constantes para ocultar o mostrar la barra de tareas de windows
* Sgte linea notificada por Hugo Ranea 20/06/2001
    #DEFINE TOGGLE_HIDEWINDOW    128
    LOCAL lnHwnd
    *!* Valores
    lnHwnd = 0
    *!* Instrucciones DECLARE DLL para manipular la barra de tareas
    DECLARE INTEGER FindWindowA IN Win32API STRING lpClassName,;
    STRING lpWindowName
    DECLARE INTEGER SetWindowPos IN Win32API INTEGER hwnd,;
    INTEGER hwndInsertAfter, INTEGER x, INTEGER y, INTEGER cx,;
    INTEGER cy, INTEGER wFlags
    *!* Valores
    lnHwnd = FindWindowA('Shell_traywnd', '')
    *!* Ocultar la barra de tareas
    IF lnHwnd <> 0
        SetWindowPos(lnHwnd, 0, 0, 0, 0, 0, TOGGLE_HIDEWINDOW)
    ENDIF
ENDFUNC



Funciona en cualquier versión de Windows. 




Dimension aKnownDrives[1]
lnDrives = GetDriveStrings(@aKnownDrives)
If lnDrives > 0
    Dimension aDriveInfo[3]
    For ix = 1 to lnDrives
        =GetVolInfo( aKnownDrives[ix], @aDriveInfo )
        ? "Drive : [" ;
            + aKnownDrives[ix] ;
            + "] Type : [" ;
            + cDriveType(aKnownDrives[ix]) ;
            + "]  Volume Name : [" ;
            + aDriveInfo[1] ;
            + "]  Sytem : [" ;
            + aDriveInfo[2] ;
            + "]  Serial No : [" ;
            + aDriveInfo[3] +"]"
    Endfor
Endif

Function cDriveType
    Lparameters tcRoot && Root of drive ie: "c:"
    Local array aDrvTypes[7]
    aDrvTypes[1]="CANNOT_DETERMINE"
    aDrvTypes[2]="INVALID_DRIVE"
    aDrvTypes[3]="DRIVE_REMOVABLE"
    aDrvTypes[4]="DRIVE_FIXED"
    aDrvTypes[5]="DRIVE_REMOTE"
    aDrvTypes[6]="DRIVE_CDROM"
    aDrvTypes[7]="DRIVE_RAMDISK"
    Return aDrvTypes[nDriveType(tcRoot)+1]

Function nDriveType
    Lparameters tcRoot && Root of drive ie: "c:"
    Declare integer GetDriveType in WIN32API string @cDrvLetter
    Return GetDriveType(@tcRoot)

Function GetVolInfo
    Lparameters lcRoot, taInfo && Root of drive ie: "c:", InfoArray passed by ref
    Declare SHORT GetVolumeInformation IN Win32API;
        STRING @lpRootPathName, STRING @lpVolumeNameBuffer,;
        INTEGER nVolumeNameSize, INTEGER @lpVolumeSerialNumber,;
        INTEGER @lpMaximumComponentLength, INTEGER @lpFileSystemFlags,;
        STRING @lpFileSystemNameBuffer, INTEGER nFileSystemNameSize
    Store 0 TO lnserialno, lncomplen, lnsysflags
    Store SPACE(260) TO lcvolname, lcsysname
    Store LEN(lcvolname) TO lnvolsize, lnnamesize
    If (GetVolumeInformation(@lcRoot, @lcvolname,;
            lnvolsize, @lnserialno, @lncomplen, @lnsysflags,;
            @lcsysname, lnnamesize) # 0)
        Dimension taInfo[3]
        taInfo[1] = substr(lcvolname, 1, at(chr(0),lcvolname)-1) && Volume name
        taInfo[2] = substr(lcsysname, 1, at(chr(0),lcsysname)-1) && System
        taInfo[3] = dec2hex(lnserialno) && Serial in hex format
    Else
        taInfo = ""
    Endif
    Return

Function GetDriveStrings
    Parameters aDriveStrings && Array passed by ref
    Local lpBuffer, nBufferLength, lnBuflen, lnDriveCount, ix
    Declare integer GetLogicalDriveStrings in Win32API ;
        integer  nBufferLength,	string @ lpBuffer
    lpBuffer = space(26*128)
    nBufferLength = 26*128
    lnBuflen = GetLogicalDriveStrings(nBufferLength, @lpBuffer)
    If lnBuflen # 0 && Succeeded
        lpBuffer = left(lpBuffer,lnBuflen)
        lnDriveCount = occurs(chr(0),lpBuffer)
        Dimension aDriveStrings[lnDriveCount]
        For ix = 1 to lnDriveCount
            aDriveStrings[ix] = ;
                substr(lpBuffer, ;
                iif( ix=1,1,at(chr(0),lpBuffer,ix-1)+1 ), ;
                at(chr(0),lpBuffer,ix) ;
                - iif( ix=1,0,at(chr(0),lpBuffer,ix-1)) - 1)
        Endfor
    Else
        lnDriveCount = 0
    Endif
    Return lnDriveCount

Function dec2hex
    Parameter nDecimal, nDigits
    **  Converts from base 10 to base 16.  Returns Hex notation in a string whose length
    **  is always a multiple of 2, unless the nDigits parameter is specified to pad the
    **  string with zeroes.
    cHex = ""
    Do WHILE nDecimal >= 16
        cHex = hexdigit(nDecimal % 16) + cHex
        nDecimal = int(nDecimal/16)
    Enddo
    cHex = hexdigit(nDecimal) + cHex
    Return PADL(cHex, ;
        iif( PARAMETERS() < 2, ;
        ceiling(len(cHex)/2)*2, nDigits ), "0")

Function hexdigit
    Parameters nDecimal
    Return iif(nDecimal>9,chr(asc("A")+nDecimal%10),str(nDecimal,1))

 

SHFD_CAPACITY_DEFAULT = 0 &&' capacidad del drive por default
SHFD_CAPACITY_360 = 3 &&' 360KB, para 5.25"  :-)
SHFD_CAPACITY_720 = 5 &&' 720KB, para 3.5"  : -(
SHFD_FORMAT_QUICK = 0 &&' formato rápido
SHFD_FORMAT_FULL = 1 &&' formato completo
SHFD_FORMAT_SYSONLY = 2 &&' copia solamente los archivos del sistema (Solo Win95)

DECLARE INTEGER SHFormatDrive IN "SHELL32.DLL" INTEGER, INTEGER, INTEGER, INTEGER

hWnd = GetHwndForm(THISFORM)
iDrive = 0
IF hWnd <> 0 THEN
   Resultado = SHFormatDrive(hWnd, iDrive,SHFD_CAPACITY_DEFAULT, SHFD_FORMAT_QUICK)
ENDIF


*==========================================================
* Esta función recibe una referencia hacia el formulario y devuelve el HWND
* (window handle) de esta ventana o formulario.
*==========================================================

Function GetHwndForm
LParameter toForm

Local lcCaption
lcCaption = toForm.Caption
toForm.Caption = Sys(3)

If not "FOXTOOLS" $ Upper( Set("Library") )
 Set Library to (Home()+"FoxTools.Fll") Additive
Endif

Local lnHWND
lnHWND = _WhToHwnd( _WFindTitl(toForm.Caption) )
toForm.Caption = m.lcCaption

Return m.lnHWND



De los siguientes sitios:

1. La fuente mas completa de información es a traves de una subscripcion a MSD
(Microsoft Developer Network). En uno de los numerosos discos que ofrece, encontraras
un gran archivo de ayuda (sobre unos 20 Mb), que contiene no solo todas las funciones,
sino tambien articulos y ejemplos de codigo. Solo comentar que este tipo de subscripcion
puede resultar caro y puede no ser una opcion viable.

2. VFP 3.0 venia con un archivo llamado Win32api.hlp. Si tienes acceso a esta version,
busca este archivo, desafortunadamente no aparece en VFP 5.0 ni en VFP 6.0

3. El Web site de Inprise tiene un fichero de ayuda, que se puede descargar, la URL es:

	http://www.inprise.com/devsupport/delphi/downloads/

4. El Web de Microsoft Site puede ofrecer información actualizada.
	Ver: http://www.microsoft.com/win32dev/

5. La web de Allapi, en: http://www.allapi.net (añadido por Pablo Roca)

Notas: No hice las URLS de arriba funcionales, ya que pueden cambiar

Ayuda bastante una experiencia real de C++. Las declaraciones estan realizadas habitualmente
en dicho lenguaje, y conociendolo te podras imaginar que tipos de datos son los que
necesita cada funcion, y si se deben pasar por referencia o valor.

Finalmente, deseo agradecer (en ningun orden particular) a: Paul Vlad Tatavu, Erik Moore,
Bob Archer, David Frankenbach, Jerry Ritcey, Donald Orphanidys, John Koziol, y a
Roxanne Seibert por su ayuda participando y ofreciendo informacion..
 


Para poder determinar el numero de colores disponibles, son necesarias tres llamadas a la API de windows: GetDC(), GetDeviceCaps(), and ReleaseDC().



A continuación se muestran las funciones capaces de devolver este valor. Nota: En la version de FoxPro de Windows se debe cargar FOXTOOLS.FLL antes de llamar a la función. 
FUNCTION NumColors
* version de 32 bit para uso con
* VFP bajo Win 95 y superiores,
* y Windows NT 3.51 y superiores

DECLARE INTEGER GetDC IN Win32API;
  INTEGER hWnd
DECLARE INTEGER GetDeviceCaps IN Win32API;
  INTEGER hDC, INTEGER nIndex
DECLARE INTEGER ReleaseDC IN Win32API;
  INTEGER hWnd, INTEGER hDC
LOCAL lnresult, lnhDC, lnplanes, lnpixels
lnresult = 0
lnhDC = GetDC(0)
IF lnhDC > 0
  * Get the number of color planes
  lnplanes = GetDeviceCaps(lnhDC, 14)
  * Get the number of bits per pixel
  lnpixels = GetDeviceCaps(lnhDC, 12)
  * Calculate the return value
  lnresult = 2 ^ (lnplanes * lnpixels)
  = ReleaseDC(0, lnhDC)
ENDIF
RETURN lnresult



FUNCTION NumColors
* Para usar con FPW 2.5 y superiores
* y VFP bajo Windows 3.1

PRIVATE m.result, m.getdc, m.getdevcaps,;
  m.releasedc, m.hdc, m.planes, m.pixels
m.result = 0
m.getdc = RegFN('GetDC', 'I', 'I')
m.getdevcaps = RegFN('GetDeviceCaps', 'II', 'I')
m.releasedc = RegFN('ReleaseDC', 'II', 'I')
m.hdc = CallFN(m.getdc, 0)
IF m.hdc > 0
  * Get the number of color planes
  m.planes = CallFN(m.getdevcaps, m.hdc, 14)
  * Get the number of bits per pixel
  m.pixels = CallFN(m.getdevcaps, m.hdc, 12)
  * Calculate the return value
  m.result = 2 ^ (m.planes * m.pixels)
  = CallFN(m.releasedc, 0, m.hdc)
ENDIF
RETURN m.result


La misma función que hemos visto en el caso anterior puede ser
usada para evitar que un programa externo se cargue mós de una vez.
Un ejemplo sencillo es el de la calculadora de Windows.

Imaginemos que en nuestra aplicación demos la posibilidad de utilizar
la calculadora. Pondríamos una línea come esta:

RUN /N CALC.EXE

Pero si esta línea la ejecutamos más de una vez, se cargarás la
calcuadora una y otra vez.

* Antes de activar la calculadora:
IF NOT F_ActivaWin("Calculadora")
    * La calculadora no está cargada:
    RUN /N CALC.EXE
ENDIF

* Y ESTA ES LA FUNCION QUE LO HACE TODO:
*-----------------------------
FUNCTION F_ActivaWin(cCaption)
*-----------------------------
LOCAL nHWD
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName

DECLARE SetForegroundWindow IN WIN32API ;
INTEGER nHandle

DECLARE SetActiveWindow IN WIN32API ;
INTEGER nHandle

DECLARE ShowWindow IN WIN32API ;
INTEGER nHandle, ;
INTEGER nState

nHWD = FindWindow(0, cCaption)
IF nHWD > 0
    * VENTANA YA ACTIVA
    * LA "LLAMAMOS":
    ShowWindow(nHWD,9)

    * LA PONEMOS ENCIMA
    SetForegroundWindow(nHWD)

    * LA ACTIVAMOS
    SetActiveWindow(nHWD)
    RETURN .T.
ELSE
    * VENTANA NO ACTIVA
    RETURN .F.
ENDIF



En muchos casos es importante que nuestras aplicaciones puedan estar cargadas
una sola vez. Los motivos pueden ser muchos: un programa VFP ocupa muchos
recursos del sistema, en algunos casos puedo necesitar abrir los archivos
en modo exclusivo, etc.

Utilizando las APIs que Windows pone a disposición, se puede controlar si
existe una ventana con un nombre determinado. Si nosotros controlamos esto
antes de asignar el título a la ventana de nuestro programa, podemos saber
nuestra aplicación ya estaba cargada desde antes.

Lo úmico que necesitamos hacer es lo siguiente:

En nuestras primeras líneas de programa ponemos estas líneas de código:

* Antes de ponerle el título a nuestra ventana:
IF F_ActivaWin("Mi programa")
    * El programa ya estaba activo:
    RETURN && Termina el programa
ENDIF

* Empezamos a definir las características de la ventana principal
* siempre y cuando sea necesario visualizarla.
WITH _SCREEN
    * PREPARO LA VENTANA PRINCIPAL
    * .WIDTH = ...
    * .HEIGHT = ...
    * ETC, ETC
    * 
    *
    .CAPTION = "Mi programa"    && Título de la ventana
    .VISIBLE = .T.
ENDWITH

* Y ESTA ES LA FUNCION QUE LO HACE TODO:
*-----------------------------
FUNCTION F_ActivaWin(cCaption)
*-----------------------------
LOCAL nHWD
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName

DECLARE SetForegroundWindow IN WIN32API ;
INTEGER nHandle

DECLARE SetActiveWindow IN WIN32API ;
INTEGER nHandle

DECLARE ShowWindow IN WIN32API ;
INTEGER nHandle, ;
INTEGER nState

nHWD = FindWindow(0, cCaption)
IF nHWD > 0
    * VENTANA YA ACTIVA
    * LA "LLAMAMOS":
    ShowWindow(nHWD,9)

    * LA PONEMOS ENCIMA
    SetForegroundWindow(nHWD)

    * LA ACTIVAMOS
    SetActiveWindow(nHWD)
    RETURN .T.
ELSE
    * VENTANA NO ACTIVA
    RETURN .F.
ENDIF


*------------------------------------------------------
FUNCTION _MapDrive( tcDrive, tcResource, tcPassword)
*------------------------------------------------------
* Conecta un recurso compartido al drive tcDrive
* USO: ? _MapDrive("Z:","PC_RemotaRecurso")
*------------------------------------------------------
 LOCAL lnRet

 DECLARE INTEGER WNetAddConnection IN WIN32API;
  STRING @lpzRemoteName, STRING @lpzPassword,;
  STRING @lpzLocalName

 IF PARAMETERS() < 3
  lnRet = WNetAddConnection( @tcResource, 0, @tcDrive)
 ELSE
  lnRet = WNetAddConnection( @tcResource, @tcPassword, @tcDrive)
 ENDIF

 IF lnRet   RETURN "Error "+ALLT(STR(lnRet))+" al conectar el drive "+tcDrive
 ENDIF
 RETURN ""
ENDFUNC



*------------------------------------------------
FUNCTION _Sleep(lnMiliSeg)
*------------------------------------------------
* Función que "para" la ejecución de un programa
* durante "n" milisegundos
* Mejor que INKEY() ya que no tiene interfase con el teclado.
* USO: _Sleep()
*------------------------------------------------
lnMiliSeg = IIF(TYPE("lnMiliSeg") = "N", lnMiliSeg, 1000)
DECLARE Sleep ;
  IN WIN32API ;
  INTEGER nMillisecs
RETURN Sleep(lnMiliSeg)
ENDFUNC


*-----------------------------------------------
FUNCTION GetVol(lpRoot)
*-----------------------------------------------
* Nuestra información del volumen
* USO: GetVol("C:")
* PARAMETRO: lpRoot = LetraDrive + ":"
*-----------------------------------------------
LOCAL lnRet, lcString, lpVolName, ;
  nVolSize, lpVolNumber, ;
  lpMaxComp, lpFlags, ;
  lpFSName, nFSSize

IF EMPTY(lpRoot)
  lpRoot = "d:"
ENDIF
lpVolName = SPACE(256)
nVolSize = 256
lpVolNumber = 0
lpMaxComp = 256
lpFlags = 0
lpFSName = SPACE(256)
nFSSize = 256

DECLARE INTEGER GetVolumeInformation IN Win32API AS GetVolInfo ;
  STRING  @lpRoot, ;
  STRING  @lpVolName, ;
  INTEGER nVolSize, ;
  INTEGER @lpVolNumber, ;
  INTEGER @lpMaxComp, ;
  INTEGER @lpFlags, ;
  STRING  @lpFSName, ;
  INTEGER nFSSize

lnRet=GetVolInfo(@lpRoot, @lpVolName, ;
  nVolSize, @lpVolNumber, ;
  @lpMaxComp, @lpFlags, ;
  @lpFSName, nFSSize)

IF lnRet > 0
  lcString = "Drive name: " + ;
    ALLT(lpRoot)+CHR(13)+ ;
    "Vol name: " + ;
    LEFT(ALLT(lpVolName),LEN(ALLT(lpVolName))-1)+CHR(13)+ ;
    "Max     ALLT(STR(nVolSize))+CHR(13)+ ;
    "Vol Serial     ALLT(STR(lpVolNumber))+CHR(13)+ ;
    "Max     ALLT(STR(lpMaxComp))+CHR(13)+ ;
    "File Sys Flags: " + ;
    ALLT(STR(lpFlags))+CHR(13)+ ;
    "File Sys type: " + ;
    LEFT(ALLT(lpFSName),LEN(ALLT(lpFSName))-1)+CHR(13)+ ;
    "File Sys Name Size: " + ;
    ALLT(STR(nFSSize))
ELSE
  lcString = "No se pudo ver información"
ENDIF
=MESSAGEBOX(lcString, "Información del volumen")
RETURN ""
ENDFUNC



*------------------------------------------------------
FUNCTION _MapDrive( tcDrive, tcResource, tcPassword)
*------------------------------------------------------
* Conecta un recurso compartido al drive tcDrive
* USO: ? _MapDrive("Z:","PC_RemotaRecurso")
*------------------------------------------------------
 LOCAL lnRet

 DECLARE INTEGER WNetAddConnection IN WIN32API;
  STRING @lpzRemoteName, STRING @lpzPassword,;
  STRING @lpzLocalName

 IF PARAMETERS() < 3
  lnRet = WNetAddConnection( @tcResource, 0, @tcDrive)
 ELSE
  lnRet = WNetAddConnection( @tcResource, @tcPassword, @tcDrive)
 ENDIF

 IF lnRet   RETURN "Error "+ALLT(STR(lnRet))+" al conectar el drive "+tcDrive
 ENDIF
 RETURN ""
ENDFUNC



*------------------------------------------------
FUNCTION _PlayWave(lcWaveFile,lnPlayType)
*------------------------------------------------
* Ejecuta un archivo .WAV
* USO: _PlayWave( [,])
*     Arch_WAV = Ruta completa del archivo .WAV
*     Tipo_Ejecucion = 1 - Ejecución en background (default)
*                      0 - La aplicación espera la ejecución
*                      2 - Si el archivo no existe, no ejecuta el default
*                      4 - Apaga el sonido que se está ejecutando 
*                      8 - Continuado  
* RETORNA: .T. Si el sonido fue ejecutado
*------------------------------------------------
lnPlayType = IIF(TYPE("lnPlayType")="N",lnPlayType,1)
DECLARE INTEGER PlaySound ;
   IN WINMM.dll  ;
   STRING cWave, ;
   INTEGER nModule, ;
   INTEGER nType
RETURN IIF(PlaySound(lcWaveFile,0,lnPlayType) = 1, .T., .F.)
ENDFUNC



Podemos escribir y leer valores de un archivo .INI mediante la API de Windows.




*----------------------------------------------------
FUNCTION WriteFileIni(tcFileName,tcSection,tcEntry,tcValue)
*----------------------------------------------------
* Escribe un valor de un archivo INI.
* Si no existe el archivo, la sección o la entrada, la crea.
* Retorna .T. si tuvo éxito
* PARAMETROS:
*  tcFileName = Nombre y ruta completa del archivo.INI
*  tcSection = Sección del archivo.INI
*  tcEntry = Entrada del archivo.INI
*  tcValue = Valor de la entrada
* USO: WriteFileIni("C:MiArchivo.ini","Default","Port","2")
* RETORNO: Logico
*----------------------------------------------------
DECLARE INTEGER WritePrivateProfileString ;
	IN WIN32API ;
	STRING cSection,STRING cEntry,STRING cEntry,;
	STRING cFileName

RETURN IIF(WritePrivateProfileString(tcSection,tcEntry,tcValue,tcFileName)=1, .T., .F.)
ENDFUNC

*----------------------------------------------------
FUNCTION ReadFileIni(tcFileName,tcSection,tcEntry)
*----------------------------------------------------
* Lee un valor de un archivo INI.
* Si no existe el archivo, la sección o la entrada, retorna .NULL.
* PARAMETROS:
*  tcFileName = Nombre y ruta completa del archivo.INI
*  tcSection = Sección del archivo.INI
*  tcEntry = Entrada del archivo.INI
* USO: ReadFileIni("C:MiArchivo.ini","Default","Port")
* RETORNO: Caracter
*----------------------------------------------------
LOCAL lcIniValue, lnResult, lnBufferSize
DECLARE INTEGER GetPrivateProfileString ;
   IN WIN32API ;
   STRING cSection,;
   STRING cEntry,;
   STRING cDefault,;
   STRING @cRetVal,;
   INTEGER nSize,;
   STRING cFileName
lnBufferSize = 255
lcIniValue = spac(lnBufferSize)
lnResult=GetPrivateProfileString(tcSection,tcEntry,"*NULL*",;
   @lcIniValue,lnBufferSize,tcFileName)
lcIniValue=SUBSTR(lcIniValue,1,lnResult)
IF lcIniValue="*NULL*"
   lcIniValue=.NULL.
ENDIF
RETURN lcIniValue
ENDFUNC



*--------------------------------------------
FUNCTION _ComputerName
*--------------------------------------------
* Retorna el nombre de la computadora
*--------------------------------------------
LOCAL lcComputer, lnSize
lcComputer = SPACE(80)
lnSize = 80
DECLARE INTEGER GetComputerName IN WIN32API ;
   STRING @cComputerName, ;
   INTEGER @nSize
=GetComputername(@lcComputer, @lnSize)
IF lnSize < 2
   lcComputer = ""
ELSE
   lcComputer = SUBSTR(lcComputer, 1, lnSize)
ENDIF
RETURN lcComputer
ENDFUNC



*-----------------------------------------
FUNCTION _GetConnec(lcDrive)
*-----------------------------------------
* Retorna el nombre de la PC y recurso compartido
* de una coneccion de red
* PARAMETROS: lcDrive 
* USO: _GetConnec("K:")
*-----------------------------------------
 DECLARE INTEGER WNetGetConnection IN WIN32API ;
  STRING lpLocalName, ;
  STRING @lpRemoteName, ;
  INTEGER @lpnLength

 LOCAL cRemoteName, nLength, lcRet, llRet
	
 cRemoteName=SPACE(100)
 nLength=100
 llRet = WNetGetConnection(lcDrive,@cRemoteName,@nLength)
 lcRet = LEFT(cRemoteName,AT(CHR(0),cRemoteName)-1)
 RETURN lcRet
ENDFUNC



*------------------------------------------------
FUNCTION _CopyFile( lcOrigen, lcDestino, lnFlag)
*------------------------------------------------
* Copia un archivo mediante API
* USO: _CopyFile(,  [,])
* RETORNA: .T. Si lo pudo copiar
*------------------------------------------------
lnFlag = IIF(TYPE("lnFlag") = "N", lnFlag, 0)
DECLARE INTEGER CopyFile ;
   IN WIN32API ;
   STRING @cSource,;
   STRING @cTarget,;
   INTEGER nFlag
RETURN IIF(CopyFile(@lcOrigen,@lcDestino,lnFlag) = 0, .F., .T.)
ENDFUNC



Con estas funciones, podemos cambiar la hora de la PC desde VFP.

Para LEER la fecha-hora del sistema

   ? ReadLocalTime()

Para ESCRIBIR la fecha-hora del sistema

   ? WriteLocalTime({07/10/1998 18:00:00})

NOTA: Deben estar juntas las cuatro funciones
          ReadLocalTime()
          WriteLocalTime()
          _256to10()
          _10to256()





*========================
FUNCTION ReadLocalTime()
*========================
* Lee mediante API el GetLocalTime
* Retorno: DATETIME o .NULL. si existe error
* Autor: LMG - 1998.09.14
*========================
LOCAL lcAuxi, ltDateTime, ;
   lcSetDate, lcSetHours, lcSetCentury, ;
   lcSetSysformats, lcSetMark

lcSetSysformats = SET("SYSFORMATS")
lcSetCentury = SET("CENTURY")
lcSetDate = SET("DATE")
lcSetHours = SET("HOURS")
lcSetMark = SET("MARK")

SET SYSFORMATS OFF
SET CENTURY ON
SET DATE YMD
SET HOURS TO 24
SET MARK TO "/"

DECLARE GetLocalTime IN win32api ;
   STRING @lcAuxi

lcAuxi=SPAC(32)

IF GetLocalTime(@lcAuxi)
   ltDateTime = CTOT( _256to10(SUBS(lcAuxi,1,2), 4) + "/" + ;
      _256to10(SUBS(lcAuxi,3,2), 2) + "/" + ;
      _256to10(SUBS(lcAuxi,7,2), 2) + " " + ;
      _256to10(SUBS(lcAuxi,9,2), 2) +  ":" + ;
      _256to10(SUBS(lcAuxi,11,2), 2) + ":" + ;
      _256to10(SUBS(lcAuxi,13,2), 2) )
ELSE
  ltDateTime = .NULL.
ENDIF

SET MARK TO &lcSetMark
SET HOURS TO &lcSetHours
SET DATE &lcSetDate
SET CENTURY &lcSetCentury
SET SYSFORMATS &lcSetSysformats

RETURN ltDateTime
ENDFUNC

*========================
FUNCTION WriteLocalTime(ltDateTime)
*========================
* Escribe mediante API el GetLocalTime
* Parametro: Debe pasarse una variable del tipo DateTime
* Retorno: .T. si pudo cambiar fecha y hora
*          .F. envio un parámetro no válido o error
* Autor: LMG - 1998.09.14
*========================
IF TYPE("ltDateTime")
   RETURN .F.
ENDIF

LOCAL lcCadena

lcCadena = _10to256(YEAR(ltDateTime),2) + ;
   _10to256(MONTH(ltDateTime),2) + ;
   _10to256(DOW(ltDateTime),2) + ;
   _10to256(DAY(ltDateTime),2) + ;
   _10to256(HOUR(ltDateTime),2) + ;
   _10to256(MINUTE(ltDateTime),2) + ;
   _10to256(SEC(ltDateTime),2) + ;
   _10to256(000,2) + SPAC(24)

DECLARE SetLocalTime IN win32api ;
   STRING lcCadena

RETURN SetLocalTime(lcCadena)
ENDFUNC

*========================
FUNCTION _256to10(lcPar, lnCant)
*========================
* Toma un par de caracteres en base 256 y lo
* convierte en "lnCant" caracteres en base 10
* Usada por: ReadLocalTime()
* Autor: LMG - 1998.09.14
*========================
RETURN PADL(ALLTRIM(STR(ASC(SUBSTR(lcPar,2)) * 256 + ;
   ASC(SUBSTR(lcPar,1)))), lnCant, "0")
ENDFUNC

*========================
FUNCTION _10to256(lnNumero, lnCant)
*========================
* Toma número en base 10 y lo convierte 
* en "lnCant" caracteres en base 256
* Usada por: WriteLocalTime()
* Autor: LMG - 1998.09.14
*========================
LOCAL lcRetorno, lnAscii

lcRetorno=''
DO WHILE lnNumero >= 256
   lnAscii=MOD(lnNumero,256)
   lcRetorno=lcRetorno + CHR(lnAscii)
   lnNumero=INT(lnNumero / 256)
ENDDO
lnAscii=lnNumero
lcRetorno=lcRetorno + CHR(lnAscii)
RETURN PADR(lcRetorno, lnCant, CHR(0))
ENDFUNC
*========================


*--------------------------------------------
FUNCTION _TempPath
*--------------------------------------------
* Retorna la ruta de los archivos temporales
* con "" al final ("C:TEMP")
*--------------------------------------------
LOCAL lcPath, lnRet
lcPath = SPACE(255)
lnSize = 255
DECLARE INTEGER GetTempPath IN WIN32API ;
   INTEGER nBufSize, ;
   STRING @cPathName
lnRet = GetTempPath(lnSize, @lcPath)
IF lnRet <= 0
   lcPath = ""
ELSE
   lcPath = SUBSTR(lcPath, 1, lnRet)
ENDIF
RETURN lcPath
ENDFUNC



*-----------------------------------------------
FUNCTION SetCurPos(lnX, lnY)
*-----------------------------------------------
* Posiciona el cursor en la posición especificada
* PARAMETROS: lnX = Posición de X
*             lnY = Posición de Y
*-----------------------------------------------
IF EMPTY(lnX)
  lnX = 0
ENDIF
IF EMPTY(lnY)
  lnY = 0
ENDIF
DECLARE INTEGER SetCursorPos IN WIN32API ;
  INTEGER, ;
  INTEGER
=SetCursorPos(lnX, lnY)
RETURN ""
ENDFUNC


? _EstaActiva('Calculadora')

* NOTA: Como parámetro debo enviar el caption de la aplicación
* que quiero verificar si está activa.

*-----------------------------------------------
Function _EstaActiva(tcCaption)
*-----------------------------------------------
* Verifica si una aplicación ya está activa
* USO: _EstaActiva()
* RETORNA: .T. Si la aplicación está activa
*-----------------------------------------------
DECLARE INTEGER FindWindow in WIN32API ;
  STRING cNULL, ;
  STRING cWinName

return FindWindow(0, tcCaption) EndFunc


*--------------------------------------------
FUNCTION _SystemDir
*--------------------------------------------
* Retorna el directorio SYSTEM de Windows
* sin "" al final ("C:WINNTSYSTEM32")
*--------------------------------------------
LOCAL lcPath, lnSize
lcPath = SPACE(255)
lnsize = 255
DECLARE INTEGER GetSystemDirectory IN Win32API ;
   STRING  @pszSysPath,;
   INTEGER cchSysPath
lnSize = GetSystemDirectory(@lcPath, lnSize)
IF lnSize <= 0
   lcPath = ""
ELSE
   lcPath =  SUBSTR(lcPath, 1, lnSize)
ENDIF
RETURN lcPath
ENDFUNC



*--------------------------------------------
FUNCTION ListApp
*--------------------------------------------
* Nuestra información de las aplicaciones que
* estan corriendo en Windows
* USO: ListApp()
*-----------------------------------------------
LOCAL laApp, lnHandle, lnCount, lcTitle, lnI, lnHFox
DIMENSION laApp[1]
lnHFox=0
DECLARE INTEGER FindWindow ;
  IN win32api ;
  INTEGER nullpointer, ;
  STRING cwindow_name
DECLARE INTEGER GetWindow ;
  IN win32api ;
  INTEGER ncurr_window_handle, ;
  INTEGER ndirection
DECLARE INTEGER GetWindowText ;
  IN win32api ;
  INTEGER n_win_handle, ;
  STRING @ cwindow_title, ;
  INTEGER ntitle_length
lnHFox = FindWindow(0,_SCREEN.CAPTION)
lnHandle = lnHFox && GetWindow(lnHFox,0)
lnCount = 0
DO WHILE lnHandle > 0
  lcTitle=SPACE(255)
  lnI=GetWindowText(lnHandle, @lcTitle,LEN(lcTitle))
  IF lnI>0
    lcTitle=STRTRAN(TRIM(lcTitle),CHR(0),"")
  ELSE
    lcTitle=""
  ENDIF
  IF lnHandle > 0 .AND. !EMPTY(lcTitle)
    lnCount=lnCount+1
    DIMENSION laApp(lnCount)
    laApp[lnCount]=lcTitle
  ENDIF
  lnHandle = GetWindow(lnHandle,2)
ENDDO

IF ALEN(laApp,1)>0
  lcString = "Las siguientes aplicaciones estan ejecutandose:" + CHR(13) + CHR(13)
  FOR i=1 TO ALEN(laApp,1)
    lcString = lcString + laApp[i]+CHR(13)
  NEXT
ELSE
  lcString = "No hay aplicaciones ejecutandose"
ENDIF
=MESSAGEBOX(lcString, "Lista de aplicaciones")
RETURN ""
ENDFUNC



* ------------------------------------------------------
FUNCTION _UnmapDrive( tcDrive)
* ------------------------------------------------------
* Desconecta un drive de red
* USO: ? _UnmapDrive("Z:")
* ------------------------------------------------------
 LOCAL lnRet

 DECLARE INTEGER WNetCancelConnection IN WIN32API;
  STRING @lpzLocalName, INTEGER nForce

 lnRet = WNetCancelConnection( @tcDrive, 0)

 IF lnRet   RETURN "Error "+ALLT(STR(lnRet))+" al desconectar el drive "+tcDrive
 ENDIF
 RETURN ""
ENDFUNC


Hay veces que incluso despues de un ZAP, se puede recuperar los registros, solo
funciona si no se han escrito datos encima de esos registros.

FUNCTION UNZAP
PARAMETER Y
IF Y>0 .AND. USED() 
   IF RECCOUNT()=0
      FILENAME=DBF()
      USE
      HANDLE=FOPEN(FILENAME,2)
      IF HANDLE>0
         BYTE=FREAD(HANDLE,32)
         BKUP_BYTE=BYTE
         FIELD_SIZE=ASC(SUBSTR(BYTE,11,1))+(ASC(SUBSTR(BYTE,12,1))*256)
         FILE_SIZE=FSEEK(HANDLE,0,2)
         BYTE8=CHR(INT(Y/(256*256*256)))
         BYTE7=CHR(INT(Y/(256*256)))
         BYTE6=CHR(INT(Y/256))
         BYTE5=CHR(MOD(Y,256))
         BYTE=SUBSTR(BYTE,1,4)+BYTE5+BYTE6+BYTE7+BYTE8+SUBSTR(BYTE,9)
         =FSEEK(HANDLE,0)
         =FWRITE(HANDLE,BYTE)
         =FCHSIZE(HANDLE,FILE_SIZE+(FIELD_SIZE*Y))
         =FCLOSE(HANDLE)
      ENDIF
      USE &FILENAME
   ENDIF
ENDIF


Uso:

ZAP
=UNZAP(47)   && recupera 47 registros

Esta funcion UNZAP, puede recuperar mas registros de los debidos, por tanto despues
de un UNZAP, debe hacer un browse para comprobar que todo esta bien, en caso que se
hayan recuperado mas registos de los posibles, debe hacer un ZAP y un UNZAP con menos
registros.

En las vistas con modo de almacenamiento en bufer a tabla (es decir 4 o 5), no se
les puede crear un indice, y por tanto no se puede hacer SEEK o INDEXSEEK en ellas.

Para resolver esto se ha reealizado la sisuiente rutina:

************************************************************
*
* Funcion: INDEXVISTA
*
* Indexa cualquier tipo de vista
*
* Parametros:
*
*	tcvista - Nombre de la vista
*	tcexpr  - expresion completa para indexar
*	tctag   - nombre del indice (tag)
*
* Ejemplos:
*
*	ret=indexview("lv_alelin","allart+STR(mov,3)","allart")
*
* Retorno
*
*	devuelve verdadero/falso si se pudo crear el indice
*
* Nota
*
*   La vista debe estar abierta
*
* Ultima Modificacion: 05/04/2000 Pablo Roca
* Creacion           : 05/04/2000 Pablo Roca
*
************************************************************
FUNCTION indexvista (tcvista, tcexpr, tctag)
LOCAL lcOldBufering, llret, lcalias
IF PCOUNT()=3
   lcalias = ALIAS()	
   SELECT (tcvista)
   lcOldBufering=CURSORGETPROP("Buffering")
   llret=CURSORSETPROP("Buffering",3)
   IF llret
      INDEX ON &tcexpr TAG (tctag)
      SET ORDER TO
      llret=CURSORSETPROP("Buffering",lcOldBufering)
   ENDIF
   IF !EMPTY(lcalias)
      SELECT (lcalias)
   ELSE
      SELECT 0
   ENDIF   
ELSE
   llret = .F.
ENDIF
RETURN llret
ENDFUNC

Ejemplo de uso:

ret=indexvista("lv_alelin","allart+STR(mov,3)","allart")

Con esto podremos realizar cualquier SEEK (mejor SEEK() ) o INDEXSEEK sobre la vista
 



*--------------------------------------------------
FUNCTION _Actualizable(tcAlias)
*--------------------------------------------------
* Hace actualizable un cursor
* USO: _Actualizable("MiCursor")
* PARAMETRO:
*    tcAlias = Alias del cursor
*--------------------------------------------------
	LOCAL lcAliasTmp, lcAliasAnt
	lcAliasAnt = ALIAS()
	IF EMPTY(tcAlias) OR NOT USED(tcAlias)
	   WAIT WINDOW NOWAIT " No existe el alias "
	   RETURN
	ENDIF
	lcAliasTmp = SYS(2015)
	USE DBF(tcAlias) IN 0 SHARE AGAIN ALIAS (lcAliasTmp)
	USE DBF(lcAliasTmp) IN (tcAlias) SHARE AGAIN ALIAS (tcAlias)
	USE IN (lcAliasTmp)
	IF NOT EMPTY(lcAliasAnt)
	   SELECT (lcAliasAnt)
	ENDIF
	RETURN
ENDFUNC


*--------------------------------------------------
FUNCTION _Exclusivo(tcTabla)
*--------------------------------------------------
* Verifica si una tabla esta abierta en  EXCLUSIVO
* USO: _Exclusivo("C:VFPMiTabla.DBF")
* PARAMETRO:
*    tcTabla = Ruta completa del archivo .DBF
* RETORNO: .T. si se puede abrir en exclusivo
*--------------------------------------------------
LOCAL lnHandle, llRet
lnHandle = FOPEN(tcTabla)
IF lnHandle = -1
   llRet = .F.
ELSE
   llRet = .T.
   =FCLOSE(lnHandle)
ENDIF
RETURN llRet
ENDFUNC



**********************************************************************
*
* Función: hazmodificable 
*
* Hace modificable un cursor creado con SELECT SQL
*
* Sintaxis: 
*
* =goCSApp.hazmodificable(cursor)
*
* Parametros:
*
* cursor
*
* Ejemplos:
*
* = hazmodificable(ALIAS())
* = hazmodificable("query1")
*
* Retorno:
*
* nada
*
* Nota: No debe haber ningun alias xxTemp abierto
* **********************************************************************
FUNCTION hazmodificable
LPARAMETERS tcalias
USE DBF(tcalias) IN 0 AGAIN alias xxTemp
USE DBF("xxTemp") IN (tcalias) AGAIN ALIAS (tcalias)
USE IN xxTemp
ENDFUNC



*--------------------------------------------------------
* FUNCTION FindField(lcCampo, lcAlias)
*--------------------------------------------------------
* Busca un nombre de campo en una tabla y retorna .T. si tuvo exito.
* USO: ? FindField("MiCampo", "MiAlias")
*      ? FindField("MiCampo") && Busca en el alias corriente
*--------------------------------------------------------
FUNCTION FindField(lcCampo, lcAlias)
  LOCAL ln
  IF EMPTY(lcAlias)
    lcAlias = ALIAS()
  ENDIF
  IF USED(lcAlias)
    ln = AFIELDS(MiArray, lcAlias)
    IF ln > 0
      ln = ASCAN(MiArray, UPPER(lcCampo))
    ENDIF
  ELSE
    ln = 0
    MESSAGEBOX("El alias no existe.",16)
  ENDIF
  RETURN ln ENDFUNC



Como limitar la entrada de un campo memo a X lineas. De Ken Weber.



Simplemente hay que poner en el keypress lo siguiente: 
LPARAMETERS nKeyCode, nShiftAltCtrl
IF nkeycode = 13
   IF OCCURS(chr(13),this.value) >=5
      NODEFAULT
   ENDIF
ENDIF

En este ejemplo se limita a 6 lineas.




Enviado por Alex Wieder al grupo de noticias




Se puede pasar al formulario secundario un puntero hacia el primero como parámetro:

Do segundoFormulario with ThisForm

Luego en el segundo formulario se agrega una propiedad llamada FormaMadre y en el Init:

lParameters oFormaMadre
ThisForm.FormaMadre = oFormaMadre

Después se puede acceder cualquier propiedad del primer formulario (madre) así:

ThisForm.FormaMadre.Caption = "Hola mamita!"




Normalmente en los texbox para introducir los datos, se hace poniendole
en la propiedad format el simbolo !, esto no funciona en los editbox, por
lo que se propone aqui dos posibles soluciones para conseguir esto.

Vamos a aprovechar la propiedad format y por tanto solo se pondrá en
mayusculas, si hemos puesto el simbolo ! en el format, para así hacerlo
igual que en los texbox.

Solución 1

Poner en el metodo Keypress del editbox:

LPARAMETERS nKeyCode, nShiftAltCtrl
*Brett Hobs & John Koziol
* convierte de a..z, y la ñ
IF '!' $ THIS.FORMAT AND (BETWEEN(nKeyCode,97,122) OR nKeyCode=241)
	nKeyCode=nKeyCode-32
	NODEFAULT
	KEYBOARD CHR(nKeyCode)
ENDIF

Solución 2

Poner en el método InteractiveChange del editbox:

* Mike Helland
local lnSelStart
IF '!' $ THIS.FORMAT
	lnSelStart = this.SelStart
	this.value = UPPER(this.value)
	this.SelStart = lnSelStart
ENDIF




Para cambiar las propiedades de un objeto (textbox, label, ...) cuando se pasa el
ratón por encima de él, se puede realizaren el evento mousemove.

Por ejemplo vamos a poner en rojo un label cuando pasamos por encima de él:

1. En el evento mousemove del label

LPARAMETERS nButton, nShift, nXCoord, nYCoord
*{ se pone en rojo
this.forecolor = RGB(255,0,0)
dodefault(nButton, nShift, nXCoord, nYCoord)

2. En el evento mousemove del formulario (para restaurar el color cuando nos
salimos del label)

LPARAMETERS nButton, nShift, nXCoord, nYCoord
*{ se pone en negro otra vez
thisform.label1.forecolor = RGB(0,0,0)
dodefault(nButton, nShift, nXCoord, nYCoord)




*-----------------------------------------------------------
* FUNCTION SCX2PRG(tcForm, tcFile)
*-----------------------------------------------------------
* Pasa todos los métodos de un formulario y sus controles a
* un archivo de procedimientos.
* PARAMETROS:
*    tcForm: Ruta y nombre del formulario (.SCX)
*    tcFile: Ruta y nombre del archivo a generar (.PRG)
* AUTOR: LMG
* USO: SCX2PRG("C:FORMSFORM1.SCX", "C:PRGSMETODOS.PRG")
*-----------------------------------------------------------
FUNCTION SCX2PRG(tcForm, tcFile)
  tcForm = FORCEEXT(tcForm, "SCX")
  IF NOT FILE(tcForm)
        MESSAGEBOX("El archivo" + CR + tcForm ;
      + CR + "no existe.", 16, "Aviso")
    RETURN .F.
  ENDIF
  IF EMPTY(tcFile)
    *--- Por defecto genera un PRG  con el
    *--- mismo nombre que el formulario
    tcFile = tcForm
  ENDIF
  tcFile = FORCEEXT(tcFile, "PRG")
  SET TEXTMERGE TO (tcFile) NOSHOW
  SET TEXTMERGE ON
  USE (tcForm) ALIAS MiScx
  ************************************************************
  *** METODOS DEL FORMULARIO
  *** <<UPPER(tcForm)>>
  ************************************************************
  SCAN ALL
    IF NOT EMPTY(MiScx.methods)
      *---------------------------------------------------
      *-- <<MiScx.objname>> -- (<<MiScx.Baseclass>>)
      *---------------------------------------------------
      <>
    ENDIF
  ENDSCAN
  USE IN MiScx
  ************************************************************
  *** FINAL DEL ARCHIVO
  ************************************************************
  SET TEXTMERGE OFF
  SET TEXTMERGE TO
  RETURN .T.
ENDFUNC




Uso:

Formulario:

DECLARE INTEGER GetFocus IN WIN32API
SaveWindowAsBitmap(GetFocus(), "FORMULARIO" + ".BMP")


Escritorio:

SaveWindowAsBitmap(MainhWnd(), "ESCRITORIO" + ".BMP")


************************************************************
*
* Funcion: SAVEWINDOWASBITMAP
*
* Guarda un formulario como bitmap
*
* Parametros:
*
*		tnHWnd		    Handle a la ventana (Window handle)
*		tcDefaultName	Nombre archivo (bitmap a guardar)
*
* Ejemplos:
*
*   SaveWindowAsBitMap(GetFocus(), "MIVENTANA")
*
* Retorno 
*
*	nada
*
* Nota
*
* Creación           : 29/10/1999
* Ultima Modificacion: 29/10/1999
* Original de Steven Rauhl (sruhl@fastrans.net)
*
************************************************************
FUNCTION SaveWindowAsBitMap
LPARAMETERS tnHWnd, tcDefaultName

LOCAL lnHBitmap 	&& Handle to bitmap
LOCAL lcFileName	&& Nombre del archivo

LOCAL lnRetVal 		&& valor de retorno de la API

DECLARE INTEGER CopyWindowToDIB IN DibAPI32 INTEGER hWnd, INTEGER fPrintArea
DECLARE INTEGER SaveDIB IN DibAPI32 INTEGER hBitmap, STRING @ cFileName

#DEFINE PW_WINDOW 1
#DEFINE PW_CLIENT 2

lcFileName = PUTFILE("Guardar como Bitmap", tcDefaultName, "BMP")
IF EMPTY(lcFileName)		&& El usuario pulso escape en PUTFILE
	RETURN					&& evitamos la captura
ENDIF

lnHBitmap = CopyWindowToDIB(tnHWnd, PW_WINDOW)
IF EMPTY(lnHBitmap)
	= MESSAGEBOX("Imposible crear bitmap de la ventana", ;
				MB_ICON_EXCLAMATION + MB_OK, ;
				"ERROR MESSAGE TITLE" )
	RETURN
ENDIF

lnRetVal = SaveDIB(lnHBitmap, @lcFileName)
IF lnRetVal != 0
	= MESSAGEBOX("Imposible guardar el bitmap como: " + lcFileName + CRLF + ;
					"PrintDIB returno " + STR(lnRetVal), ;
				MB_ICONEXCLAMATION + MB_OK, ;
				"ERROR MESSAGE TITLE")
ENDIF
ENDFUNC




Necesita el DIBAPI, que está en la sección de archivos.

Uso:

Formulario:

DECLARE INTEGER GetFocus IN WIN32API
PrintWindow(GetFocus(), "Imprimiendo el formulario")

Escritorio:

PrintWindow(MainhWnd(), "Imprimiendo Escritorio")


************************************************************
*
* Funcion: PRINTWINDOW
*
* Imprime una ventana
*
* Parametros:
*
*		tnHWnd		Handle a la ventana (Window handle)
*		tcJobName	Nombre del Job de Impresion
*
* Ejemplos:
*
*   PrintWindow(GetFocus(), "Imprimiendo el formulario")
*
* Nota
*
* Creación           : 29/10/1999
* Ultima Modificacion: 29/10/1999
* Original de Steven Rauhl (sruhl@fastrans.net)
*
************************************************************
FUNCTION PRINWINDOW
LPARAMETERS tnHWnd, tcJobName

LOCAL lcJobName		&& Nombre de la tarea de impresion
LOCAL lnRetVal		&& Valor de retorno de las funciones del API

DECLARE INTEGER PrintWindow IN DibApi32 ;
	INTEGER HWnd, ;
	INTEGER fPrintArea, ;
	INTEGER fPrintOpt, ;
	INTEGER wxScale, ;
	INTEGER wyScale, ;
	STRING @ szJobName
	
*!* Imprimir la ventana entera o el area cliente

*!* Como ajustar la imagen
*!* PW_BESTFIT se ajusta al papel pero se mantienen las proporciones
*!* PW_STRETCHTOPAGE se ajusta para cubrir totalmente el papel pero distorsiona las proporciones
*!* PR_SCALE escala el tamaño de impresion

*!* Si no se incluye el FoxPro.H descomente estas lineas
*!*	*!*	
lcJobName = tcJobName + CHR(0)
lnRetVal = PrintWindow( tnHWnd, PW_WINDOW, PW_STRETCHTOPAGE, 0, 0, @lcJobName)
IF lnRetVal != 0
	IF lnRetVal != 6	&& 6 = El usuario cancelo la impresión
		= MESSAGEBOX("Imposible Imprimir la ventana" + CRLF + ;
						"PrintWindow API retorno " + STR(lnRetVal), ;
					MB_ICONEXCLAMATION + MB_OK, ;
					"ERROR")
	ENDIF
ENDIF
RETURN
ENDFUNC



Hay veces que se necesita que un control se posicione en el formulario
respecto a otro control (en vez de hacerlo en la posicion absoluta respecto
al formulario. Este caso es normal cuando tenemos por ejemplo un textbox
con longitud variable en funcion de .... lo que sea y deseamos un segundo
texbox separado del primero siempre por el mismo numero de pixeles.

En la clase redefinida del texbox (si no la hay debe hacerse una), crear
las siguientes propiedades:

link_control  - indica a que control esta vinculado el actual (inicializado por defecto a ="")
link_top      - desplazamiento vertical sobre el control vinculado (inicializado por defecto a 0)
link_sep      - separacion en pixels entre ambos controles (inicializado por defecto a 0)

En el metodo Init del segundo texbox, poner:

DODEFAULT()		&& esto ya es por costumbre
IF !EMPTY(this.link_control)
	LOCAL olinkcontrol
	olinkcontrol = EVALUATE(this.link_control)
	this.top  = olinkcontrol.top + this.link_top
	this.left = olinkcontrol.left + olinkcontrol.width + this.link_sep
ENDIF

Es imprescindible poner en orden los controles, es decir, si tenemos un control que depende
de otro para posicionarse, ese otro debe ejecutar antes el Init




Trabajando con los textbox puede surgir la necesidad de ponerle un formato
especial en función de que su valor (por ejemplo ponerlos en rojo, cuando
su valor sea negativo).

Surge la duda de en que metodos poner el codigo para colorearlos, Valid, Refresh,
... ¿se me quedo alguno? ¿Como lo hago todo mas sencillo? ¿Tengo que repetir todo
esto es cada texbox?

Bueno, lo primero pensar que deberiamos tener redefinida la clase estandard texbox
(o aun mejor todas las clases visuales), y nuestros texbox hacerlos que dependieran
de nuestras nuevas clases redefinidas, de tal manera que cuando hagamos un cambio
en la clase cs_textbox (mi ejemplo), este se realice en todos los que usemos.

Trabajando con VFP6+SP3, se podria estar tentado en utilizar el metodo value_assign
, que es ejecutado cada vex que el valor de un textbox cambia, pero el metodo assign
todavia tiene diversos bugs y problemas, como mas gordo citar que si se pone codigo
en un value_assign (a nivel de clase), cualquier textbox de esa clase que usemos nos
va a decir que se han realizado cambios en el (GETFLDSTATE), por tanto descartado
el assign.

Los metodos a modificar son los siguientes:

InteractiveChange - Se modifica el valor con el raton
ProgrammaticChange - Se modifica el valor por codigo
Refresh  - Se actualiza un textbox vinculado a datos (p.ejemplo con un SKIP)

En el ejemplo que estamos tratando, tambien creo un metodo a nivel de la clase texbox
, por ejemplo llamado AnyChange y desde los tres metodos anteriores llamo a este
AnyChange.

El codigo del AnyChange es:

IF VARTYPE(this.value)="N"
	this.forecolor = IIF(this.value<0,RGB(255,0,0),0)
	this.disabledforecolor = IIF(this.value<0,RGB(255,0,0),0)
ENDIF

Es decir si el valor es numerico y negativo lo pone en rojo.
 



Cuando realizamos operaciones con los datos de un grid, como cambiarle el recordsource
y vincularlo a otro origen de datos (tabla/cursor/vista), hay veces en las que se estropea
el grid (se pierden los anchos de las columnas, ...), incluso sucede cuando realizamos
diversas operaciones con dichos datos:

Para solucionar esto se debe hacer de la siguiente manera:

LOCAL lcRecordSource

lcRecordSource = ALLTRIM(This.RecordSource)
This.RecordSource = ""

** ejecutar el codigo que se desee para la tabla/vista o cursor
** SCAN's, REPLACE's ...

This.RecordSource = lcRecordSource

Si queremos vincularlo a otro cursor o datos, pues simplemente hay que hacer:

thisform.cs_grdresal1.recordsource='lv_diariote'

Es valido si se mantienen los mismos nombres de campos y orden, yo tambien por asegurarme
que todo va bien, siempre restauro los controlsources de las columnas:

thisform.cs_grdresal1.column1.controlsource='lv_diariote.diafapun'
thisform.cs_grdresal1.column3.controlsource='lv_diariote.dianasi'
thisform.cs_grdresal1.column4.controlsource='lv_diariote.diacuenta'
thisform.cs_grdresal1.column6.controlsource='lv_diariote.diaconcep'
thisform.cs_grdresal1.column7.controlsource='lv_diariote.diadebe'
thisform.cs_grdresal1.column8.controlsource='lv_diariote.diahaber'
thisform.cs_grdresal1.column9.controlsource='lv_diariote.diadivcod'
 



Para que cuando entremos en un textox, esté seleccionado todo el
texto, hay que  definir la siguiente propiedad:

format = "K"

Esto funcionará con las teclas, si queremos que tambien se seleccione
cuando hacemos click en él, hay que poner lo siguiente en el evento Click,
pero hay que tener en cuenta que en este caso se pierde la posibilidad
de selección parcial de un texto del textbox con el raton.

this.SelStart=0
this.SelLength=LENC(this.value)


NOTA: gracias a JavierPl por la corrección del format.
 

Los formularios almacenan el path de las tablas definidas en el Entorno de Datos.
Por desgracia cuando se distribuye la aplicación, estos formularios pueden apuntar
al directorio donde se desarrollaron. Estos paths deben ser reseteados en tiempo
de ejecución para asegurarnos que apuntan a las tablas correctas.

* en el programa principal o en la de conexion determinar el directorio actual
* almacenarlo en variables globalos o del objeto aplicación.
gcAppPath = sys(2003)
gcDBPath = alltrim(gcAppPath)+"datos"
gcDBName = "mibasededatos.dbc"

Poner en el entorno de datos la propiedad AutoOpenTables = .F.

modificar la clase base del formulario (o cambialo en cada formulario) en el Metodo Load:

* apuntar todas las tablas al directorio y base de datos correcto
thisform.SetAll("Database",gcDbPath+gcDbname,"Cursor")
* abrir las tablas
thisform.dataenvironment.opentables()


*NOTA: esto funciona con tablas de una base de datos, este codigo debe ser modificado si
se usan tablas libres.


En modo ejecucion, con la función SetAll:

thisform.grid1.setall ('Width', 40, 'Columns')


En modo diseño, selecciona el grid, y poner en la ventana de comandos:

ASELOBJ( lagrid )
lagrid[1].setall( 'width', 40, 'column' )
RELE laGrid



Parametros del MESSAGEBOX no documentados
Enviado el Miércoles, abril 05 @ 00:00:00 CEST by pablorocaContributed by: George Tasker 
 

...




Existen dos parametros no documentados de la funcion MESSAGEBOX(), estos son:


Añadiendo estos valores a los otros que controlan el icono y estilo de botones,
afectaran al modo modal y al ambito del dialogo. Mientras que MB_SYSTEMMODAL
muy poco efecto visible sobre el dialogo (sin embargo, hay diferencias internas),
MB_TASKMODAL provocara que el dialogo aparezca no solo encima de las ventanas de
la aplicacion activa, sino que tambien sobre cualquier ventana de cualquier
aplicacion.
 


Parametros del MESSAGEBOX no documentados
Enviado el Miércoles, abril 05 @ 00:00:00 CEST by pablorocaContributed by: George Tasker 
 

...




Existen dos parametros no documentados de la funcion MESSAGEBOX(), estos son:


Añadiendo estos valores a los otros que controlan el icono y estilo de botones,
afectaran al modo modal y al ambito del dialogo. Mientras que MB_SYSTEMMODAL
muy poco efecto visible sobre el dialogo (sin embargo, hay diferencias internas),
MB_TASKMODAL provocara que el dialogo aparezca no solo encima de las ventanas de
la aplicacion activa, sino que tambien sobre cualquier ventana de cualquier
aplicacion.
 


En modo ejecucion, con la función SetAll:

thisform.grid1.setall ('Width', 40, 'Columns')


En modo diseño, selecciona el grid, y poner en la ventana de comandos:

ASELOBJ( lagrid )
lagrid[1].setall( 'width', 40, 'column' )
RELE laGrid

 

En modo ejecucion, con la función SetAll:

thisform.grid1.setall ('Width', 40, 'Columns')


En modo diseño, selecciona el grid, y poner en la ventana de comandos:

ASELOBJ( lagrid )
lagrid[1].setall( 'width', 40, 'column' )
RELE laGrid

 

En modo ejecucion, con la función SetAll:

thisform.grid1.setall ('Width', 40, 'Columns')


En modo diseño, selecciona el grid, y poner en la ventana de comandos:

ASELOBJ( lagrid )
lagrid[1].setall( 'width', 40, 'column' )
RELE laGrid



Existen dos parametros no documentados de la funcion MESSAGEBOX(), estos son:


Añadiendo estos valores a los otros que controlan el icono y estilo de botones,
afectaran al modo modal y al ambito del dialogo. Mientras que MB_SYSTEMMODAL
muy poco efecto visible sobre el dialogo (sin embargo, hay diferencias internas),
MB_TASKMODAL provocara que el dialogo aparezca no solo encima de las ventanas de
la aplicacion activa, sino que tambien sobre cualquier ventana de cualquier
aplicacion.




A veces necesitamos realizar pequeños programas que no requieren
la visualización de la pantalla principal de Visual FoxPro (_SCREEN).
Pero vemos que ésta se carga cada vez que cargamos VFP o un EXE hecho
en VFP.

Para realizar un EXE que visualice solo un formulario, sin cargar la
pantalla principal de VFP, tendremos que hacer lo siguiente:

Preparamos nuestro formulario con la siguiente característica:

1.Propiedad ShowWindow = "2 - As top-level form"

2.En el evento Destroy pondremos el comando CLEAR EVENTS

Después prepararemos un CONFIG.FPW con la siguiente línea:

SCREEN = OFF

De esta forma _SCREEN no será visualizado hasta que no demos la orden
_SCREEN.VISIBLE = .T. en nuestro programa, que por supuesto no pondremos.

Lo único que nos falta es activar nuestro formulario en el código
principal de nuestro programa:

DO FORM MiForm
READ EVENTS        && MUY IMPORTANTE

Finalmente compilamos para preparar el EXE.


Cambiar el icono de la ventana principal de VFP
Enviado el Miércoles, marzo 08 @ 00:00:00 CET by pablorocaContributed by: Luis Maria Guayán 
 

...




* Por ejemplo si queremos cambiar el ícono de la ventana principal por
* archivo "MiIcono.ICO" que esta en C:ICONS ejecutamos:

_Screen.Icon = "C:ICONSMiIcono.ICO"

 
* Por ejemplo si queremos poner como fondo de la pantalla principal el
* archivo "MiImagen.BMP" que esta en C:BITMAPS ejecutamos:

_Screen.Picture = "C:BITMAPSMiImagen.BMP"

 

*-------------------------------------------
* Retorna la resolucion del monitor 
* Ejemplo: ? _Resolucion() -> "800x600"
*-------------------------------------------
FUNCTION _Resolucion()
 RETURN TRANSFORM(SYSMETRIC(1))+"x"+TRANSFORM(SYSMETRIC(2))
ENDFUNC


¿Cuantas veces nos hemos encontrado que nuestros usuarios se van a tomar un
cafe o marchan a comer con la aplicación abierta?

La verdad, es que a mi esto me há dado bastantes problemas, ya que
realizo las copias de seguridad al mediodia. Y día si, día también hay
usuarios que dejan la aplicación abierta, con el problema de que la copia
no se realiza ya que los usuarios dejan archivos abiertos.

La solución es la siguiente:

crear un timer (p.ejemplo) programado para 15-20 minutos, y el el evento
timer programar los pasos necesarios para cerrar la aplicación.

para que el timer no se dispare cuando los usuarios estan trabajando hago
lo siguiente:

En el evento mouse move del formulario y en el keypress de cada objeto,
hago:

IF VARTYPE(gotimer_inactividad)="O"
	* la cuenta atras de tiempo se inicia otra vez
    gotimer_inactividad.interval = gocsapp.tiempo_espera
ENDIF

En mi caso la parte del formulario la hago solo una vez, ya que todos mis
formularios son hijos de uno maestro definido como una clase base.

¿Que codigo se pone para cerrar la aplicación? Depende de lo que desees
hacer, es decir puedes no querer cerrar a un usuario si esta en el medio
de una grabación,... yo en mi caso les cierro la aplicación descartando
cualquier cambio que hayan realizado.

¿Drastico? Si, pero despues de que los usuarios pierden su trabajo dos
veces, debido a su negligencia, os aseguro que no volveran a dejar el
ordenador indebidamente encendido.
Para realizar la compresión de archivos las herramientas más utilizadas son: Winzip, Dynazip, Xceed, y Eclipse Cabinet, aqui tenemos otra alternativa shareware mucho mas barata que las demas (excepto el Eclipse Cabinet que es freeware) ...



Las addZIP Compression Libraries se componen de dlls y activex para comprimir en formato zip, son de littlebigware (http://www.littlebigware.com), shareware y solo cuestan 55 dolares, que es la mitad de las anteriores mencionadas.

La libreria se puede descargar de: addzip

Y en la sección de archivos estan los siguientes:

addzipvfp1.zip (ejemplo muy sencillo con las dlls)
addzipvfp2.zip (ejemplo mas completo)
 

   Enlaces Relacionados  
 
Más de Utilidades
Noticias de pabloroca


--------------------------------------------------------------------------------

Noticia más leída de Utilidades:
Como actualizar la fecha y la hora del pc cliente con la del servidor



Ultimas Noticias de Utilidades:



    

 

 **********************************************************************
* ACTUALIZA LA HORA Y LA FECHA DE ACUERDO AL SERVIDOR CENTRAL
**********************************************************************
pc_serv="Servidor"

run NET TIME &pc_serv /SET /YES


Norvey Arredondo M.
aredondo@email.com

(Nota de Pablo Roca) 
Normalmente (Windows) en:
pc_serv="Servidor" habria que poner:

pc_serv="**Servidor" (cambiar los asteriscos por barras invertidas,
 ya que no se como ponerlas aqui en la web)

y si ponemos asi:

run /n7 NET TIME &pc_serv /SET /YES

No saldrá la ventana de DOS



Como saben tenemos la funcion del RAND() para obtener un resultado entre zero y uno, pero que pasa con aquellas personas que desean generar un numero aleatorio entre dos numeros dados?

Aquí tienen una pequeña muestra de como generar un numero aleatorio partiendo de dos numeros dados y usando la funcion RAND()

Ejemplo:

? damenumaleatorio(10,99)






*---------------------------
FUNCTION damenumaleatorio
   PARAMETERS primero, segundo
   RAND(-1)
   RETURN INT((segundo - primero + 1) ;
      * RAND() + primero)
ENDFUNC
*---------------------------



Child and Parent Form Print Function -- by Mauricio Atanache

====================================
Child and Parent Form Print Function
====================================
*Use this procedure as PrintForm( Thisform ) or PrintForm( _Screen )
* Child and Parent Form Print function
*******************
* Author : Mauricio Atanache G.
* Date : December 10/97
* Parameters : oObjeto is an object FORM, for example THISFORM,
* ACTIVEFORM, _SCREEN
****************************************************************
Procedure PrintForm
******************
lParameters oObjeto
LOCAL cAlias, lUsado
* Save current alias
IF USED(ALIAS())
	cAlias=ALIAS()
	lUsado=.T.
ELSE
	lUsado=.F.
ENDIF
* Put image in clipboard
If !TomaFoto( oObjeto )
	Return
Endif
* Create a cursor for store the image, uses a general field
CREATE CURSOR Foto_Pantalla (SCREEN G)
APPEND BLANK
IF lUsado
	SELECT(cAlias)
ENDIF
* Copy the image from the clipboard to the general field
DEFINE WINDOW Ventana FROM 1,1 TO 4,4
MODIFY GENERAL Foto_Pantalla.SCREEN NOWAIT WINDOW Ventana
KEYBOARD "{CTRL+V}{CTRL+W}" CLEAR
RELEASE WIND Ventana
DOEVENTS
* Must create a report named prtform with an olecontrol and SCREEN as
* Source
IF !EMPTY(Foto_Pantalla.SCREEN)
	SELECT Foto_Pantalla
	REPORT FORM prtform.frx TO PRINTER NOCONSOLE
ELSE
	WAIT WINDOW "Sorry, Can't print"
ENDIF
* Close the cursor
USE IN Foto_Pantalla
* Restore current alias
IF lUsado
	SELECT(cAlias)
ENDIF
Return
***************************************************************

* Author : Mauricio Atanache G.
* Date : December 10/97
* This function puts the image of the form in the clipboard, you can use
* it to send form images to other aplications as Word etc.
* Also you can modify this function to print or copy any object on
* screen.
* Parameters : oForm is an object FORM, for example THISFORM,
ACTIVEFORM, _SCREEN
**************************************************************************
Function TomaFoto
******************
lParameters oForm
Local nHwnd, tnHwnd, hDC, hDC_Mem, hBitMap, hPrevBmp
* Must use the Foxtools library, somewhere.
Declare integer FindWindow in Win32Api String cClassName, String cWindName
Declare integer GetDC in Win32Api integer nhwnd
Declare integer CreateCompatibleDC in Win32Api integer nhcd
Declare Integer BitBlt in Win32Api Integer hDestDC, Integer x, Integer y, ;
Integer nWidth, Integer nHeight, Integer hScrDC, ;
Integer xsrc, Integer ysrc, Integer dwRop
Declare Integer SelectObject in Win32Api Integer hDC, Integer hObject
Declare Integer CreateCompatibleBitmap in Win32Api Integer hDC, Integer nWidth, ;
Integer nHeight
Declare Integer SetClipboardData in Win32Api Integer nFormat, Integer hObject
Declare Integer DeleteDC in Win32Api Integer hDC
Declare Integer ReleaseDC in Win32Api Integer nwnd, Integer hdc
Declare Integer DeleteObject in Win32Api Integer hDC
lnwhandle = _WFindTitl(oForm.Caption)
nHwnd = _WhToHWnd(lnwhandle)
hDC = GetDC( nHwnd )
hDC_Mem = CreateCompatibleDC( hDC )
hBitMap = CreateCompatibleBitMap( hDC, oForm.Width, oForm.Height )
If hBitMap#0
	hPrevBmp = SelectObject( hDC_Mem, hBitMap )
	BitBlt( hDC_Mem, 0, 0, oForm.Width, oForm.Height, hDC, 0, 0, 13369376 )
	If OpenClip( nHwnd )
		EmptyClip()
		SetClipboardData( 2, hBitMap )
		CloseClip()
	Else
		MessageBox( 'Error opening the clipboard', 48, 'Message' )
	Endif
Else
	MessageBox( 'Error creating bitmap', 48, 'Menssage' )
Endif
DeleteDC( hDC_Mem )
ReleaseDC( nHwnd, hDC )
Return .t.
*******************************************
e-mail : dsmauricio@Hotmail.com
Address : Crr 19 No. 75 – 20 of 401, Bogotá – Colombia
Telephone : 3460746 - 3460673

Title: Selecting duplicate records from a table 


SELECT * ;
FROM table A ;
WHERE EXISTS ;
	( SELECT * ;
	FROM table B ;
	WHERE B.key = A.key;
	GROUP BY key ;
	HAVING COUNT(*) > 1 ) ;
ORDER BY fieldlist

or 

SELECT * ;
FROM table ;
WHERE key IN ;
	( SELECT key ;
	FROM table ;
	GROUP BY key  ;
	HAVING count(*) > 1) ;
ORDER BY fieldlist

A New entry in The Universal Download by Max Chen (China) is the basis of an excellent tool for preventing copying of you distributed applications (www.universalthread.com). It is a dll that interrogates your hard disk serial number with a simple function call. Look under recent entries in the VFP download section for
"A dll tell your the hard disk Serial No You can get some physical characteristics of the hard disk.It's useful for you to protect your copyright. 

I'm sorry the I am a chinese, with a poor level english,
so i can't write too much introduction. But, it realy works." 

The example prg file in the zip file can be expanded slightly to remove the trailing spaces and then remove the chr(0) that is appended to the end of the serial number as follows. 

If the program, or the modified program don't work, remember to set your path by adding a line to the top as in set path to C:\(where to find the dll that you unzipped)

Modified prg file
Declare integer GetSerialNumber in diskSerial.dll Integer nDrivelpBuffer,String
aa=space(40)
GetserialNumber(0,@aa)
aa = alltrim(aa) && trim off all the trailing spaces
aa = substr(aa,1,len(aa) -1) && strip the chr(0) from the end
? aa

I'll leave it to your imagination for the copy protection bit, but it would go something along the lines of generating a software serial number based on the original initial hard disk info....

