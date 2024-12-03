*:******************************************************************************
*:
*: Procedure File PS2PDF.PRG
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   PS2PDF
*:   clnpsfiles
*:   runme
*:   long2str
*:   str2long
*:   getStartupInfo
*:   num2dword
*:   num2word
*:   buf2dword
*:   Decl
PARAMETERS m_ifilename   && checking this has to be a ps file.
IF	m_ifilename =="" OR NOT FILE(m_ifilename)
	RETURN
ENDIF
DO clnpsfiles
m_safety  = SET("safety")
SET SAFETY OFF
IF NOT DIRECTORY("psfiles")
	MKDIR psfiles
ENDIF
IF NOT DIRECTORY("pdffiles")
	MKDIR pdffiles
ENDIF
m_psfile= "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
IF FILE(m_psfile)
	ERASE (m_psfile)
ENDIF
IF JUSTEXT(m_ifilename) == ""
	m_ifilename = JUSTSTEM(m_ifilename)+".TXT"
	m_psfile=JUSTSTEM(m_ifilename)+".ps"
	IF FILE(m_psfile)
		ERASE (m_psfile)
	ENDIF
	RENAME (m_ifilename) TO "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
	m_ifilename = "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
ENDIF
IF JUSTEXT(m_ifilename)="TXT"
	RENAME (m_ifilename) TO "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
	m_ifilename = "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
ENDIF
IF JUSTEXT(m_ifilename)="ps" OR JUSTEXT(m_ifilename)="PS"
	RENAME (m_ifilename) TO "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
	m_ifilename = "psfiles\"+JUSTSTEM(m_ifilename)+".ps"
ENDIF
gs = FILETOSTR("LocationOfgs.ini")
m_outfile = "pdffiles\"+JUSTSTEM(m_ifilename) +".pdf"
m_cmd = [ -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE#pdfwrite -sOutputFile#]+m_outfile +[ -dnodisplay -dCompatibilityLevel#1.2 -c .setpdfwrite -f ] +m_ifilename
m_cmd = (gs)+ m_cmd +CHR(0)
** this is the actual ps2pdf command sent to ghostscript
DO runme WITH m_cmd
SET SAFETY &m_safety

*!******************************************************************************
*!
*! Procedure CLNPSFILES
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
PROCEDURE clnpsfiles
** proceedure for clearing out the last ps file to be converted.
** general housekeeping
m_num = ADIR(m_files,"psfiles\*.ps")
IF m_num  > 0
	m_dir = "psfiles\"
	FOR i=1 TO m_num
		m_filetoerase =(m_dir)+m_files[i,1]
		ERASE (m_filetoerase)
	NEXT i
ENDIF
ENDPROC



*!******************************************************************************
*!
*! Procedure RUNME
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
PROC runme
PARA m_cmd
#DEFINE NORMAL_PRIORITY_CLASS 32
#DEFINE IDLE_PRIORITY_CLASS 64
#DEFINE HIGH_PRIORITY_CLASS 128
#DEFINE REALTIME_PRIORITY_CLASS 1600

* Return code from WaitForSingleObject() if
* it timed out.
#DEFINE WAIT_TIMEOUT 0x00000102

* This controls how long, in milli secconds, WaitForSingleObject()
* waits before it times out. Change this to suit your preferences.
#DEFINE WAIT_INTERVAL 200

DECLARE INTEGER CreateProcess IN kernel32.DLL ;
	INTEGER lpApplicationName, ;
	STRING lpCommandLine, ;
	INTEGER lpProcessAttributes, ;
	INTEGER lpThreadAttributes, ;
	INTEGER bInheritHandles, ;
	INTEGER dwCreationFlags, ;
	INTEGER lpEnvironment, ;
	INTEGER lpCurrentDirectory, ;
	STRING @lpStartupInfo, ;
	STRING @lpProcessInformation

DECLARE INTEGER WaitForSingleObject IN kernel32.DLL ;
	INTEGER hHandle, INTEGER dwMilliseconds

DECLARE INTEGER CloseHandle IN kernel32.DLL ;
	INTEGER hObject

DECLARE INTEGER GetLastError IN kernel32.DLL

* STARTUPINFO is 68 bytes, of which we need to
* initially populate the 'cb' or Count of Bytes member
* with the overall length of the structure.
* The remainder should be 0-filled
START = long2str(68) + REPLICATE(CHR(0), 64)

* PROCESS_INFORMATION structure is 4 longs,
* or 4*4 bytes = 16 bytes, which we'll fill with nulls.
process_info = REPLICATE(CHR(0), 16)
* Start a copy of gs (EXE name must be null-terminated)
File2Run = m_cmd

* Call CreateProcess, obtain a process handle. Treat the
* application to run as the 'command line' argument, accept
* all other defaults. Important to pass the start and
* process_info by reference.
lcStartupInfo = getStartupInfo()
** the older startup
* I didn't want ghostscript to show, so I changed the startup
* of create process to run without a visual element.
* to have GS start visually, change @lcStartupInfo, below to be @start
RetCode = CreateProcess(0, File2Run, 0, 0, 1, ;
	NORMAL_PRIORITY_CLASS , 0, 0, @lcStartupInfo, @process_info)

* Unable to run, exit now.
IF RetCode = 0
	=MESSAGEBOX("Error occurred. Error code: ", GetLastError())
	RETURN
ENDIF

* Extract the process handle from the
* PROCESS_INFORMATION structure.
hProcess = str2long(SUBSTR(process_info, 1, 4))

DO WHILE .T.
* Use timeout of TIMEOUT_INTERVAL msec so the display
* will be updated. Otherwise, the VFP window never repaints until
* the loop is exited.
	IF WaitForSingleObject(hProcess, WAIT_INTERVAL) != WAIT_TIMEOUT
		EXIT
	ELSE
		DOEVENTS
	ENDIF
ENDDO

* Show a message box when we're done.
*This was removed to enable it run without user intervention.
* ie. a web web server
*      =MESSAGEBOX ("Process completed")
* Close the process handle afterwards.
RetCode = CloseHandle(hProcess)
RETURN


********************
*!******************************************************************************
*!
*! Procedure LONG2STR
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
FUNCTION long2str
********************
* Passed : 32-bit non-negative numeric value (m.longval)
* Returns : ASCII character representation of passed
*           value in low-high format (m.retstr)
* Example :
*    m.long = 999999
*    m.longstr = long2str(m.long)

PARAMETERS m.longval

PRIVATE i, m.retstr

m.retstr = ""
FOR i = 24 TO 0 STEP -8
	m.retstr = CHR(INT(m.longval/(2^i))) + m.retstr
	m.longval = MOD(m.longval, (2^i))
NEXT
RETURN m.retstr


*******************
*!******************************************************************************
*!
*! Procedure STR2LONG
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
FUNCTION str2long
*******************
* Passed:  4-byte character string (m.longstr)
*   in low-high ASCII format
* returns:  long integer value
* example:
*   m.longstr = "1111"
*   m.longval = str2long(m.longstr)

PARAMETERS m.longstr

PRIVATE i, m.retval

m.retval = 0
FOR i = 0 TO 24 STEP 8
	m.retval = m.retval + (ASC(m.longstr) * (2^i))
	m.longstr = RIGHT(m.longstr, LEN(m.longstr) - 1)
NEXT
RETURN m.retval

ENDPRO


*!******************************************************************************
*!
*! Procedure GETSTARTUPINFO
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
PROCEDURE  getStartupInfo
* creates the STARTUP structure to specify main window
* properties if a new window is created for a new process

*| typedef struct _STARTUPINFO {
*|     DWORD   cb;                4
*|     LPTSTR  lpReserved;        4
*|     LPTSTR  lpDesktop;         4
*|     LPTSTR  lpTitle;           4
*|     DWORD   dwX;               4
*|     DWORD   dwY;               4
*|     DWORD   dwXSize;           4
*|     DWORD   dwYSize;           4
*|     DWORD   dwXCountChars;     4
*|     DWORD   dwYCountChars;     4
*|     DWORD   dwFillAttribute;   4
*|     DWORD   dwFlags;           4
*|     WORD    wShowWindow;       4
*|     WORD    cbReserved2;       2
*|     LPBYTE  lpReserved2;       4
*|     HANDLE  hStdInput;         4
*|     HANDLE  hStdOutput;        4
*|     HANDLE  hStdError;         4
*| } STARTUPINFO, *LPSTARTUPINFO; total: 68 bytes

#DEFINE STARTF_USESHOWWINDOW   1
#DEFINE SW_SHOWMAXIMIZED       2

RETURN  num2dword(68) +;
	num2dword(0) + num2dword(0) + num2dword(0) +;
	num2dword(0) + num2dword(0) + num2dword(0) + num2dword(0) +;
	num2dword(0) + num2dword(0) + num2dword(0) +;
	num2dword(STARTF_USESHOWWINDOW) +;
	num2word(SW_SHOWMAXIMIZED) +;
	num2word(0) + num2dword(0) +;
	num2dword(0) + num2dword(0) + num2dword(0)

*!******************************************************************************
*!
*! Procedure NUM2DWORD
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
FUNCTION  num2dword (lnValue)
#DEFINE m0       256
#DEFINE m1     65536
#DEFINE m2  16777216
LOCAL b0, b1, b2, b3
b3 = INT(lnValue/m2)
b2 = INT((lnValue - b3 * m2)/m1)
b1 = INT((lnValue - b3*m2 - b2*m1)/m0)
b0 = MOD(lnValue, m0)
RETURN CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)

*!******************************************************************************
*!
*! Procedure NUM2WORD
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
FUNCTION  num2word (lnValue)
RETURN CHR(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))

*!******************************************************************************
*!
*! Procedure BUF2DWORD
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
FUNCTION  buf2dword (lcBuffer)
RETURN ASC(SUBSTR(lcBuffer, 1,1)) + ;
	ASC(SUBSTR(lcBuffer, 2,1)) * 256 +;
	ASC(SUBSTR(lcBuffer, 3,1)) * 65536 +;
	ASC(SUBSTR(lcBuffer, 4,1)) * 16777216

*!******************************************************************************
*!
*! Procedure DECL
*!
*!  Calls
*!      clnpsfiles
*!      runme
*!
*!******************************************************************************
PROCEDURE  DECL
DECLARE INTEGER GetLastError IN kernel32

DECLARE INTEGER CreateProcess IN kernel32;
	STRING lpApplicationName, STRING lpCommandLine,;
	INTEGER lpProcessAttributes,;
	INTEGER lpThreadAttributes,;
	INTEGER bInheritHandles, INTEGER dwCreationFlags,;
	INTEGER @ lpEnvironment, STRING lpCurrentDirectory,;
	STRING lpStartupInfo, STRING @ lpProcessInformation

DECLARE INTEGER GetModuleHandle IN kernel32 INTEGER lpModuleName
DECLARE INTEGER GetCurrentProcessId IN kernel32
DECLARE INTEGER GetCurrentThreadId IN kernel32
DECLARE INTEGER GetCurrentProcess IN kernel32
DECLARE INTEGER GetCurrentThread IN kernel32

DECLARE INTEGER TerminateProcess IN kernel32;
	INTEGER hProcess, INTEGER uExitCode
ENDPRO
