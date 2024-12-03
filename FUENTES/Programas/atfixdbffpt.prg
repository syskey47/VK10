*****************************************************************************
*!*                                                                       *!*
*!* ATFixDbfFpt 1.3 repairs invalid                                      *!*
*!* dbc, dbf, frx, lbx, mnx, pjx, scx, vcx (or user defined xBase)        *!*
*!* and memo file headers                                                 *!*
*!*                                                                       *!*
*!* FoxBASE, FoxBASE+, dBASE III PLUS, FoxPro, dBaseIV and                *!*
*!* Visual FoxPro  version 3.0 - 7.x type table and memo files supported. *!*
*!*                                                                       *!*
*!* This version can't fix table / memo if table field block is           *!*
*!* corrupted!                                                            *!*
*!*                                                                       *!*
*!* Copyright (C) 2001  Arto Toikka.                                      *!*
*!*                                                                       *!*
*!* This library is free software; you can redistribute it and/or         *!*
*!* modify it under the terms of the GNU Library General Public           *!*
*!* License as published by the Free Software Foundation; either          *!*
*!* version 2 of the License, or any later version.                       *!*
*!*                                                                       *!*
*!* This library is distributed in the hope that it will be useful,       *!*
*!* but WITHOUT ANY WARRANTY; without even the implied warranty of        *!*
*!* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *!*
*!* Library General Public License for more details.                      *!*
*!*                                                                       *!*
*!* You should have received a copy of the GNU Library General Public     *!*
*!* License along with this library; if not, write to the                 *!*
*!* Free Software Foundation, Inc., 59 Temple Place - Suite 330,          *!*
*!* Boston, MA  02111-1307, USA. You can get it also at:                  *!*
*!* http://www.gnu.org/copyleft/library.html#SEC3                         *!*
*!*                                                                       *!*
*!* Even this is under a license of GNU you can always send whatever      *!*
*!* payment for a future development of this and other free tools to me,  *!*
*!* but it's totally up to you.                                           *!*
*!*                                                                       *!*
*!* Arto Toikka                                                           *!*
*!* Eestinkallio 1                                                        *!*
*!* 02280 Espoo                                                           *!*
*!* Finland                                                               *!*
*!* at@mp.utu.net                                                         *!*
*!* tel. +358 400 665566                                                  *!*
*!* fax +358 9 8552367                                                    *!*
*!*                                                                       *!*
*****************************************************************************
*!*
*!* Syntax (Program)
*!*
*!* DO ATFixDbfFpt WITH tWhatDbf, tnRepairMode, tcContainer, tnMemoBlockSice, tlNoInfo, tlNoBackups, tnLang
*!*
*!* Syntax (Function)
*!*
*!* ATFixDbfFpt(tWhatDbf, tnRepairMode, tcContainer, tnContainerBlockSize, tnMemoBlockSice, tlNoInfo, tlNoBackups, tnLang)
*!*
*!* tWhatDbf              Name (with .ext) of the table to repair
*!*                       dbc, dbf, frx, lbx, mnx, pjx, scx, vcx or user defined
*!* tnRepairMode          0 (Default) Only report generated
*!*                       1 table header checked and fixed.
*!*                       2 memo header checked and fixed.
*!*                       3 table and memo header checked and fixed.
*!*                       ** values 4 and greater not supported yet
*!*                       ** values 4 and greater are for greater data-anlysis.
*!*                       4 All scannable data readed per record from old table file
*!*                         and writed to the new table file, new header writed,
*!*                         new field block writed form template file (if exist)
*!*                       5 All scannable data readed per record from old memo file
*!*                         and writed to the new memo file, new header writed,
*!*                         new field block writed form template file (if exist)
*!*                       6 All scannable data readed per record from old table and memo files
*!*                         and writed to the new table and memo files file, new headers writed,
*!*                         new field blocks writed form template files (if exist)
*!* tcContainer           Relative path and name of the container (+ .EXT). Give it if there is
*!*                       a problem with table / container link and you like to refresh it.
*!*                       (Default empty i.e. no container link refreshed)
*!*                       NOTE!!!! If there isn't container block in the file header
*!*                       tcContainer value shoud be logical .F. (all VFP data files have a 263
*!*                       character long container block)
*!* tnMemoBlockSice		  Memo block size (Default 64)
*!* tlNoInfo        	  .T. = do not show info screen (only errors) (Default show info)
*!* tlNoBackups     	  .T. = do not make backups from corrupted? files (Default make backups)
*!* tnLang          	  Language, 1 = finnish, others are english (Default finnish)
*!*                       If you add languages please email your addition to me
*!*
*!*
*!* NOTE:  (Backup)
*!*        If make backup is selected following files are generated
*!*        (to the same directory where table is lovated)
*!*        Table: table name (with .EXT) + nn (nn = 1 to 99)
*!*        Memo:  memo name (with .EXT) + nn (nn = 1 to 99)
*!*
*!*
*!* NOTE:  (RETURN VALUE)
*!*        Look tnRepairMode
*!*        positive value (including zero) - > event succesful
*!*        negative values - > event not succesful
*!'  -10 = Only report generated, not succesful
*!*  -50 = Invalid parameters
*!*
*!* NOTE:  (REPORT)
*!*        ATFixDbfFpt writes info file to the same direcory where table file is located.
*!*        Name of the info file is:
*!*        "ATFix_" + name of the table file (without .EXT) + ".TXT"
*!*
*!*        IF RETURN VALUE <> 0 AND <> 1, report is not generated
*!*
*!* Last modified:
*!* 07/01/2001  Started
*!* 07/03/2001  Version 1.0
*!* 07/04/2001  - possibility to rewrite container block added
*!*             -
*!* 07/10/2001  Sorry 1.1b was VFP7 version, VFP5 - 6 support added
*!* 07/11/2001  Reporting bugs fixed
*!* 07/20/2001  Forgotten SET STEP ON line removed
*!*
*!*
*!* 07/24/2001  All messages (except info) moved to the FixMessage function
*!* 07/24/2001  Parameter tcContainer changed.
*!*             If type of the tcContainer is Character -> container block exist
*!*             (VFP data file)
*!*             - if length of tcContainer is zero, container block isn't overwritten
*!*             - if length of tcContainer is greater than zero,
*!*               container block is overwritten with the value in tcContainer
*!*             If type of the tcContainer is not Character -> container block
*!*             doesn't exist (no VFP data file)
*!* 07/24/2001  tnRepairMode = 1 generated an error, FIXED
*!* 07/24/2001  error when fixing free table without container block, FIXED
*!*             NOTE: in the above case DO NOT GIVE a character value to the tcContainer
*!* 07/24/2001  tnRepairMode = 4 ADDED. If tnRepairMode 1 or 3 (table),
*!*             new fixed header is overwritten to the old data file
*!*             If tnRepairmode = 4 new file is generated first and old data file
*!*             is overwritten with the new one. (this is the next step to the
*!*             next version where user can input field block if it is corrupted.
*!* 07/25/2001  Windir changed to the Temp dir
*!*
*!* Notes:      Please if you have any wishes or improvments (or bugs??), e-mail me.
*!*
*!*
*!****************************************************************************

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function FIXDBF        *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION FIXDBF

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tWhatDbf, tnRepairMode, tcContainer, tnMemoBlockSice, tlNoInfo, tlNoBackups, tnLang

*!* tWhatDbf              Name (with .ext) of the table to repair
*!*                       dbc, dbf, frx, lbx, mnx, pjx, scx, vcx or user defined
*!* tnRepairMode          0 (Default) Only report generated
*!*                       1 table header checked and fixed.
*!*                       2 memo header checked and fixed.
*!*                       3 table and memo header checked and fixed.
*!*                       ** values 4 and greater not supported yet
*!*                       ** values 4 and greater are for greater data-anlysis.
*!*                       4 All scannable data readed per record from old table file
*!*                         and writed to the new table file, new header writed,
*!'                         new field block writed form template file (if exist)
*!*                       5 All scannable data readed per record from old memo file
*!*                         and writed to the new memo file, new header writed,
*!'                         new field block writed form template file (if exist)
*!*                       6 All scannable data readed per record from old table and memo files
*!*                         and writed to the new table and memo files file, new headers writed,
*!*                         new field blocks writed form template files (if exist)
*!* tcContainer           Relative path and name of the container (+ .EXT). Give it if there is
*!*                       a problem with table / container link and you like to refresh it.
*!*                       (Default empty i.e. no container link refreshed)
*!*                       NOTE!!!! If there isn't container block in the file header
*!*                       tcContainer value shoud be logical .F. (all VFP data files have a 263
*!*                       character long container block)
*!* tnMemoBlockSice		  Memo block size (Default 64)
*!* tlNoInfo        	  .T. = do not show info screen (only errors) (Default show info)
*!* tlNoBackups           .T. = do not make backups from corrupted? files (Default make backups)
*!* tnLang          	  Language, 1 = finnish, others are english (Default finnish)
*!* tnLang          	  Language, 1 = finnish, others are english (Default finnish)
*!*                       If you add languages please email your addition to me

*!* i.e.
*!* m.tnRepairMode = 0					&& Only report generated (return -10) if not succesful
*!* INLIST(m.tnRepairMode, 1, 4)		&& Only Table repair
*!* INLIST(m.tnRepairMode, 1, 3, 4, 6)	&& Also Table repair
*!* INLIST(m.tnRepairMode, 2, 5)		&& Only Memo repair
*!* INLIST(m.tnRepairMode, 2, 3, 5, 6)	&& Also Memo repair

IF TYPE("m.tnLang") # "N" OR m.tnLang < 1
	m.tnLang = 1  && FIN
ENDIF

m.tWhatDbf = FULLPATH(m.tWhatDbf)

IF !FILE(m.tWhatDbf)
	FixMessage(100, m.tWhatDbf,,m.tnLang)
	RETURN -50
ENDIF

IF TYPE("m.tnRepairMode") # "N"
	m.tnRepairMode = 0
ELSE
	m.tnRepairMode = ABS(m.tnRepairMode)
* If m.tnRepairMode > 4
*   m.tnRepairMode = 0
* Endif
ENDIF

IF TYPE("m.tcContainer") = "C"
	m.tcContainer = LOWER(ALLTRIM(m.tcContainer))
	IF !EMPTY(m.tcContainer)
		IF !FILE(m.tcContainer)
			FixMessage(101, m.tcContainer,,m.tnLang)
			RETURN -50
		ENDIF
	ENDIF
ELSE
	m.tcContainer = .F.
ENDIF

IF TYPE("m.tnMemoBlockSice") # "N" OR ;
		M.tnMemoBlockSice < 0
	m.tnMemoBlockSice = SET("BLOCKSIZE")
ELSE
	m.tnMemoBlockSice = INT(m.tnMemoBlockSice)
ENDIF

IF TYPE("m.tlNoInfo") # "L"
	m.tlNoInfo = .F.  && Show info
ENDIF

IF TYPE("m.tlNoBackups") # "L"
	m.tlNoBackups = .F.  && make backups
ENDIF

LOCAL ;
	lnSelect, ;
	lcTmpDbf

m.lnSelect = SELECT()
lcTmpDbf = ""

IF m.tnRepairMode > 3 OR VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) < 7
	LOCAL ;
		cMyTEMPDir

	SELECT 0

	m.cMyTEMPDir = ;
		IIF(LEN(GETENV('TEMP'))=0,SYS(5)+CURDIR()+;
		IIF(!RIGHT(CURDIR(),1)=='\','\',''),;
		GETENV('TEMP')+IIF(!RIGHT(GETENV('TEMP'),1)=='\','\',''))

	m.lcTmpDbf = m.cMyTEMPDir + SYS(2015)

	DO WHILE FILE(m.lcTmpDbf+".DBF") OR FILE(m.lcTmpDbf+".FPT")
		m.lcTmpDbf = m.cMyTEMPDir + SYS(2015)
	ENDDO

	CREATE TABLE (m.lcTmpDbf) FREE ;
		(ATFIX M NOCPTRANS)

	APPEND BLANK

ENDIF

*!* FoxPro Advisor - September 1997 pages 42-48 / VFP7 help file 2001
*!*
*!* Header Block
*!*
*!*  Byte	Value
*!*     1	0x02   FoxBASE
*!*         0x03   FoxBASE+/dBASE III PLUS, FoxPro, dBaseIV, no memo
*!*         0x30   Visual FoxPro (with or without memo)
*!*         0x43   dBASE IV SQL table files, no memo
*!*         0x63   dBASE IV SQL system files, no memo
*!*         0x83   FoxBASE+/dBASE III PLUS, with memo
*!*         0x8B   dBASE IV with memo
*!*         0xCB   dBASE IV SQL table files, with memo
*!*         0xF5   FoxPro 2.x (or earlier) with memo
*!*         0xFB   FoxBASE with memo
*!*
*!*   2-4	Date of last update	YYMMDD
*!*
*!*   5-8	Number of records LSB-MSB format (see function UnLSBMSB)
*!*
*!*  9-10	Offset to start of data LSB-MSB format, same as HEADER()
*!*			(+1 is deletion flag 2Ah if deleted and 20h if not deleted
*!*			 +2 is the actuall address where the data begins).
*!*
*!* 11-12	Size of record LSB-MSB format (including deletion flag)
*!*
*!* 13-28	Not used
*!*
*!*    29	Bit flags
*!*			1	Structural compound index	(FoxPro, Visual FoxPro)
*!*			2	Memo fields					(Visual FoxPro)
*!*			3	Database container (DBC)	(Visual FoxPro)
*!*			4
*!*			5
*!*			6
*!*			7
*!*			8
*!*
*!*    30	Code Page
*!*
*!* 31-32	Not used
*!*
*!*
*!* Field Blocks - 32 bytes describe each field in the table.
*!*
*!*  Byte	Value
*!*  1-10	Field name
*!*
*!*    11	OOh
*!*
*!*    12	42h	Double    , B
*!*      	43h	Character , C
*!*      	44h	Date      , D
*!*      	46h	Float     , F
*!*      	47h	General   , G
*!*      	49h	Integer   , I
*!*      	4Ch	Logical   , L
*!*      	4Dh	Memo      , M
*!*      	4Eh	Numeric   , N
*!"         50h Picture   , P
*!*      	54h	DateTime  , T
*!*      	59h	Currency  , Y
*!*
*!* 13-14	Offset of field from beginning of record, LSB-MSB format
*!*         Where the data of this field begins is calculated as:
*!*			ASC(DBFHdrByte9)+ASC(DBFHdrByte10)*256+1+ASC(FldHdrByte13)+;
*!*         ASC(FldHdrByte14)*256 (same as)
*!*
*!* 15-16	Not used
*!*
*!* 17-18	Field length (non-numeric fields), LSB-MSB format
*!*
*!*    17	Field length (numeric fields)
*!*
*!*    18	Field decimals (numeric fields)
*!*
*!*    19	Visual Foxpro Sum of:
*!*			01h	Invisible system column
*!*			02h	Null value support
*!*			04h	Indicate binary data (Character, Memo, Currency, Integer,
*!*			DateTime, Double fields)
*!*			Others not used
*!*
*!* 20-32	Not used
*!*

LOCAL ;
	lnHandler, ;
	lcReason, ;
	lnI, ;
	lcBackFile, ;
	lcInfo, ;
	lcInfoFile

*!* m.lnHandler		handler of the "fopened" file
*!* m.lcReason		reason if it can't be opened
*!* m.lnI			counter
*!* m.lcBackfile	Backup file name

NOTE: no binary VALUE

IF !m.tlNoBackups AND m.tnRepairMode # 0

	m.lcBackFile = m.tWhatDbf + "00"

*!* && DataFixBacked = DFB
	IF FILE(m.lcBackFile)
		FOR m.lnI = 1 TO 99
			m.lcBackFile = m.tWhatDbf + PADL(TRANSFORM(m.lnI),2,"0")

*!* && DataFixBacked = EXTnn, nn = 01-99
			IF !FILE(m.lcBackFile)
				EXIT
			ELSE
				IF m.lnI = 99 AND FILE(m.lcBackFile)
					ERASE (m.lcBackFile)
					EXIT
				ENDIF
			ENDIF
		ENDFOR
	ENDIF

	WAIT CLEAR

	NOTE: WAIT FOR makeing DBF backup
	FixMessage(102, m.tWhatDbf, m.lcBackFile, tnLang)
	COPY FILE (m.tWhatDbf) TO (m.lcBackFile)

	WAIT CLEAR

	NOTE: backup ok
	FixMessage(103, m.lcBackFile,, tnLang)

ENDIF

m.lnHandler = FOPEN(m.tWhatDbf, 12)			&& unbuffered

IF m.lnHandler < 0  				        && Error generated creating file

	FixMessage(104+VAL(SET("POINT")+ALLTRIM(STR(FERROR()))), m.tWhatDbf,, tnLang)
	RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)

ENDIF


*!* No errors so now we are in business

LOCAL ;
	llTableIsAlreadyOK, ;
	lnFileSize, ;
	lnHeaderBlockSize, ;
	lcTableHeader, ;
	lcTableFixedHdr, ;
	lcMemoByte, ;
	lcTableContainer1, ;
	lcTableContainer2, ;
	lcFixedContainer1, ;
	lcFixedContainer2, ;
	lnOneFieldBlockSize, ;
	lcHeaderRecTerminator, ;
	lnContainerBlockSize, ;
	lnDataStart1, ;
	lnRecSize1, ;
	lnRecCount1, ;
	lnDataStart2, ;
	lnRecSize2, ;
	lnRecCount2, ;
	lnDataStart3, ;
	lnRecSize3, ;
	lnRecCount3, ;
	lnFieldCo3, ;
	lnRecSize4, ;
	lnNullFlagLen, ;
	lnAllFieldBlockSize, ;
	llIsMemo1, ;
	llIsMemo2, ;
	llIsMemo3, ;
	lcCodePage, ;
	lcFixError, ;
	lcFieldError, ;
	lcWhatFpt, ;
	lcFieldInfo, ;
	lcAllFieldInfo, ;
	llFieldNameOk, ;
	llFieldTypeOk, ;
	llFieldDecOk, ;
	lnFieldLen, ;
	lnI, ;
	lnK, ;
	lcSafety, ;
	llTableRepaired, ;
	llMemoRepaired, ;
	lnTooSlowToHandle


m.llTableIsAlreadyOK = .F.
m.lnFileSize = 0
m.lcTableHeader = ""
m.lcTableFixedHdr = ""
m.lcMemoByte = ""
m.lcTableContainer1 = "" && Actual container block
m.lcTableContainer2 = "" && File name in the container block
m.lcFixedContainer1 = "" && Actual container block
m.lcFixedContainer2 = "" && File name in the container block
m.lnDataStart1 = 0
m.lnRecSize1 = 0
m.lnRecCount1 = 0
m.lnDataStart2 = 0
m.lnRecSize2 = 0
m.lnRecCount2 = 0
m.lnRecCount3 = 0
m.lnAllFieldBlockSize = 0
m.llIsMemo1 = .F.
m.llIsMemo2 = .F.
m.llIsMemo3 = .F.
m.lcCodePage = CHR(0)
m.lcFixError = ""
m.lcFieldError = ""
m.lcWhatFpt = ""
m.lcFieldInfo = ""
m.lcAllFieldInfo = ""
m.llFieldNameOk = .F.
m.llFieldTypeOk = .F.
m.llFieldDecOk = .F.
m.lnFieldLen = 0
m.lnI = 0
m.lnK = 0
m.llTableRepaired = .F.
m.llMemoRepaired = .F.


*!* m.lcTableHeader		First m.lnHeaderBlockSize bytes of the file
*!* m.lnFileSize		Size of the file
*!* m.lnDataStartN		HEADER()
*!* m.lnRecSizeN		Length of the record + 1 (deleted flag)
*!* m.lnRecCountN		RECCOUNT()
*!* N = 1				values calculated from file size etc.
*!* N = 2				from header block (first m.lnHeaderBlockSize bytes of file)
*!* N = 3				values from data field block
*!* N = 4				Data offset

m.lnNullFlagLen = 0     && _NullFlags hidden field size (normally 4)
*!* 0 if _NullFlags doesn't exist

*!* m.llIsMemo1			Is there physical memo file
*!* m.llIsMemo2			Is there memo, What the header info says
*!* m.llIsMemo3			Is there memo, What the field info says
*!* m.lcFieldInfo       Field block

*!* m.llFieldNameOk		field name is okay
*!* m.llFieldTypeOK		field type is okay
*!* m.llFieldDecOk		field decimals is okay (if any)
*!* m.nFieldLen         field length

m.lnDataStart3 = 0		&& Offset to start of data, calulated
*!* from Field Block
*!* Total record width m.lnRecSize3 and m.lnRecSize3
m.lnRecSize3 = 0		&& This is calculated from the cFieldInfo
*!* FIELD length
m.lnRecSize4 = 0		&& This is evaluated from the offset
*!* of the last data field + length of
*!* that field
m.lnFieldCo3 = 0		&& How many fields there are


*!* Change next value if needed
m.lnHeaderBlockSize = 32
m.lcHeaderRecTerminator = CHR(0x0D)
m.lnOneFieldBlockSize = 32

*!* Depending on your machine speed
*!* fix next variable value (it is used
*!* when m.tnRepairMode value is 4 or 6
m.lnTooSlowToHandle = 3000


m.lcWhatFpt = ADDBS(JUSTPATH(m.tWhatDbf))+JUSTSTEM(m.tWhatDbf)

DO CASE
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "DBC" && "DCT"
	m.lcWhatFpt = m.lcWhatFpt + ".DCT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "DBF"
	m.lcWhatFpt = m.lcWhatFpt + ".FPT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "FRX"
	m.lcWhatFpt = m.lcWhatFpt + ".FRT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "LBX"
	m.lcWhatFpt = m.lcWhatFpt + ".LBT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "MNX"
	m.lcWhatFpt = m.lcWhatFpt + ".MNT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "PJX"
	m.lcWhatFpt = m.lcWhatFpt + ".PJT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "SCX"
	m.lcWhatFpt = m.lcWhatFpt + ".SCT"
CASE UPPER(JUSTEXT(m.tWhatDbf)) = "VCX"
	m.lcWhatFpt = m.lcWhatFpt + ".VCT"
OTHERWISE
*!* User defined add your code here
ENDCASE

m.lcFixError = "00000000"

m.lnFileSize = FSEEK(m.lnHandler, 0, 2)
FSEEK(m.lnHandler, 0, 0)              && go to begining of the file

m.lcTableHeader = FREAD(m.lnHandler, m.lnHeaderBlockSize)	&& first m.lnHeaderBlockSize
*!* bytes of the header

IF FERROR() <> 0
	FixMessage(105, m.tWhatDbf,, tnLang)
	RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
ENDIF

m.llIsMemo1 = FILE(m.lcWhatFpt)

DO CASE
CASE LEFT(m.lcTableHeader, 1) = CHR(0x83) && FoxBase+. dBASE III plus
	m.llIsMemo2 = .T.
	m.tcContainer = .F.
CASE LEFT(m.lcTableHeader, 1) = CHR(0x8B) && dBASE IV
	m.llIsMemo2 = .T.
	m.tcContainer = .F.
CASE LEFT(m.lcTableHeader, 1) = CHR(0xCB) && dBASE IV SQL table files
	m.llIsMemo2 = .T.
	m.tcContainer = .F.
CASE LEFT(m.lcTableHeader, 1) = CHR(0xF5) && FoxPro 2.x (or ealier)
	m.llIsMemo2 = .T.
	m.tcContainer = .F.
CASE LEFT(m.lcTableHeader, 1) = CHR(0x30) OR ; && Visual FoxPro
	LEFT(m.lcTableHeader, 1) = CHR(0x31) OR ; && Visual FoxPro
	LEFT(m.lcTableHeader, 1) = CHR(0x32) && Visual FoxPro
	m.llIsMemo2 = (SUBSTR(DECTOBIN(ASC(SUBSTR(m.lcTableHeader, 29, 1))), 7, 1) = "1")
	IF !TYPE("m.tcContainer") == "C"
		m.tcContainer = ""
	ENDIF
OTHERWISE
	m.llIsMemo2 = .F.
	m.tcContainer = .F.
ENDCASE

*!* Change next value if needed
m.lnContainerBlockSize = IIF(TYPE("m.tcContainer")=="C",263,0)

m.llIsMemo3 = .F.   && This get the real value during the field validation

*!* Define Old code page if possible
m.lcCodePage = ;
	CHR(0x01) + ;
	CHR(0x69) + ;
	CHR(0x6A) + ;
	CHR(0x02) + ;
	CHR(0x64) + ;
	CHR(0x6B) + ;
	CHR(0x67) + ;
	CHR(0x66) + ;
	CHR(0x65) + ;
	CHR(0x68) + ;
	CHR(0xC8) + ;
	CHR(0xC9) + ;
	CHR(0x03) + ;
	CHR(0xCB) + ;
	CHR(0xCA) + ;
	CHR(0x04) + ;
	CHR(0x98) + ;
	CHR(0x96) + ;
	CHR(0x97)

m.lcCodePage = ;
	IIF(SUBSTR(m.lcTableHeader, 30, 1) $ m.lcCodePage, ;
	SUBSTR(m.lcTableHeader, 30, 1), CHR(0))

*!*
*!* Offset to start of data LSB-MSB format, same as HEADER()
*!*	(+1 is deletion flag 2Ah if deleted and 20h if not deleted
*!*	 +2 is the actuall address where the data begins).
*!*
*!* Bytes number 9 and 10 point it! Same as HEADER().
*!*
m.lnDataStart2 = UnLSBMSB(SUBSTR(m.lcTableHeader, 9, 2))

*!*
*!* The record length.
*!*
*!* Bytes 11 and 12 is the length of the record including (deleted flag)
*!*
m.lnRecSize2 = UnLSBMSB(SUBSTR(m.lcTableHeader, 11, 2))

&& 1, Field name doesn't start
&& with A, B, C...Z
&& 2, Field name starts with
&& chr(0) (no name)
&& 3, Other character of the
&& field's name are not valid
&& 4, Field type is not
&& valid BCDFGILMNTY
&& 5, Field decimals size is
&& same or greater than field's length
m.lcFieldError = "00000"

* m.aDBFisGarbage = .F.

FSEEK(m.lnHandler, m.lnHeaderBlockSize, 0) && go to the begining of the Field Block

DO WHILE .T.
*!* If everything is ok, you should
*!* never reach the FEOF
*!* because of exit on m.lcHeaderRecTerminator, except
*!* if recco() = 0 or some fatal error

	m.lcFieldInfo = FREAD(m.lnHandler, m.lnOneFieldBlockSize)

	IF FERROR() <> 0
		FixMessage(105, m.tWhatDbf,, tnLang)
		RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
	ENDIF

	IF !LEFT(m.lcFieldInfo, 1) == m.lcHeaderRecTerminator AND !FEOF(m.lnHandler)

*!* Next is used whe data file is overwritten
		m.lcAllFieldInfo = m.lcAllFieldInfo + m.lcFieldInfo

*!* 0Dh i.e. Header record terminator = Enter

*!* Now we can check also if the field name and type is ok
		m.llFieldNameOk = .T.   && field name is okay checking later
		m.llFieldTypeOk = .T.   && field type is okay checking later
		m.llFieldDecOk = .T.    && field decimals is okay (if any) checking later

		IF LEFT(m.lcFieldInfo, 10) <> "_NullFlags"

			m.lnFieldCo3 = m.lnFieldCo3 + 1  && Counting fields

			m.lnFieldLen = ASC(SUBSTR(m.lcFieldInfo, 17, 1))
			NOTE: Does the FIELD NAME START WITH A, B, C...Z ?
			m.llFieldNameOk = ISALPHA(LEFT(m.lcFieldInfo, 1))
			IF !m.llFieldNameOk
				m.lcFieldError = STUFF(m.lcFieldError, 1, 1, "1")
			ENDIF

			NOTE: REST OF the FIELD NAME, IF shorter than
			NOTE: 10 IS filled WITH CHR(0)
			m.lnI = AT(CHR(0), SUBSTR(m.lcFieldInfo, 1, 10))

			IF m.lnI = 1
				m.lcFieldError = STUFF(m.lcFieldError, 2, 1, "1")
			ENDIF

			m.lnI = IIF(m.lnI = 0, 10, m.lnI - 1)

			NOTE: Are the REST characters OF the NAME alpha, digit OR _ ?
			FOR m.lnK = 2 TO m.lnI
				m.llFieldNameOk = IIF(!(ISALPHA(SUBSTR(m.lcFieldInfo, m.lnK, 1)) OR ;
					ISDIGIT(SUBSTR(m.lcFieldInfo, m.lnK, 1)) OR ;
					SUBSTR(m.lcFieldInfo, m.lnK, 1) = CHR(95) ), .F., m.llFieldNameOk)
			ENDFOR

			IF !m.llFieldNameOk
				m.lcFieldError = STUFF(m.lcFieldError, 3, 1, "1")
			ENDIF

			NOTE: IS the FIELD TYPE ok ?
			IF LEFT(m.lcTableHeader, 1) = "0"  && vfoxpro table
				m.llFieldTypeOk = (SUBSTR(m.lcFieldInfo, 12, 1) $ "BCDFGILMNPTY")
			ELSE
				m.llFieldTypeOk = (SUBSTR(m.lcFieldInfo, 12, 1) $ "CNFDLMG")
			ENDIF

			IF !m.llFieldTypeOk
				m.lcFieldError = STUFF(m.lcFieldError, 4, 1, "1")
			ENDIF

			NOTE: IS the FIELD DECIMALS ok ?
			IF SUBSTR(m.lcFieldInfo, 12, 1) # "B"
				m.llFieldDecOk = (ASC(SUBSTR(m.lcFieldInfo, 18, 1)) < m.lnFieldLen)
			ELSE
*!* Field type is double and decimals can be large than field length
*!* because field length is fixed 8 and decimals can be 18
				m.llFieldDecOk = .T.
			ENDIF

			IF !m.llFieldDecOk
				m.lcFieldError = STUFF(m.lcFieldError, 5, 1, "1")
			ENDIF

*!* Now we have checked if the field name and type is ok

*!* Now we check if the field info says "there is a memo"
			IF m.llFieldTypeOk
				NOTE: There IS no P, PICTURE FIELD)
				m.llIsMemo3 = IIF(SUBSTR(m.lcFieldInfo, 12, 1) $ "GM", .T., m.llIsMemo3)
			ENDIF
			IF AT("1", m.lcFieldError) > 0
				EXIT  && Best repair the DBF manually!!
			ELSE
				m.lnRecSize3 = IIF(m.lnRecSize3 = 0, 1, 0) + m.lnRecSize3 + ;
					UnLSBMSB(SUBSTR(m.lcFieldInfo, 17, 1))
*!* && iif(m.lnRecSize3 = 0, 1, 0) is because otherwise
*!* && it points the byte what is the last byte of
*!* && the last field's name, So + 1 and now it
*!* && points where it should point
			ENDIF

*!* we can use max() function because the offset is cumulative
			m.lnRecSize4 = MAX(m.lnRecSize4, UnLSBMSB(SUBSTR(m.lcFieldInfo, 13, 2)) + ;
				M.lnFieldLen)

		ELSE

			m.lnNullFlagLen = UnLSBMSB(SUBSTR(m.lcFieldInfo, 17, 1))

		ENDIF

	ELSE

		IF !LEFT(m.lcFieldInfo, 1) == m.lcHeaderRecTerminator OR ;
				OCCURS(m.lcHeaderRecTerminator, m.lcFieldInfo) > 1
*!* 0Dh i.e. Header record terminator = Enter
*!* Fatal error situation
*!* There is info about more than one field
*!* but the info about the last field is only partial
*!* Not fixable
			m.lcFixError = STUFF(m.lcFixError, 3, 1, "1")
		ENDIF

		m.lnAllFieldBlockSize = m.lnFieldCo3 * m.lnOneFieldBlockSize
*!* But this is still a "plain" value
*!* Add m.lnHeaderBlockSize for the size of Header Block and
*!* Add m.lnOneFieldBlockSize if _NullFlags "field" exist
*!* Add LEN(m.lcHeaderRecTerminator) for the Header record terminator (0x0D)
*!* Add m.lnContainerBlockSize If Visual FoxPro (there are
*!* m.lnContainerBlockSize bytes reserved after header record terminator
*!* for DBC relative path and name
		EXIT
	ENDIF
ENDDO

*!* Now checking if m.lnAllFieldBlockSize is logic

IF FEOF(m.lnHandler)	&& error because eof reached
*!* before header record terminator
	DO CASE
	CASE m.lnFieldCo3 = 0
*!* Fatal error situation
*!* There is no info for any fields
*!* Not fixable
		m.lcFixError = STUFF(m.lcFixError, 1, 1, "1")
	CASE m.lnAllFieldBlockSize = 0
*!* Fatal error situation
*!* There is some info about first field
*!* but the info is only partial
*!* Not fixable
		m.lcFixError = STUFF(m.lcFixError, 2, 1, "1")
	CASE (m.lnAllFieldBlockSize - 1)%32 <> 0
*!* Fatal error situation
*!* There is info about more than one field
*!* but the info about the last field is only partial
*!* Not fixable
		m.lcFixError = STUFF(m.lcFixError, 3, 1, "1")
	CASE LEFT(m.lcTableHeader, 1) = "0"  && atc("Visual", version())>0
*!* Not fatal error situation
*!* Because m.lnContainerBlockSize bytes is after 0Dh and
*!* normaly you can't reach feof()
*!* Possible to fix, check that between 0Dh and delete flag
*!* are m.lnContainerBlockSize bytes (00h or path and name of DBC)
*!* if not write those.
*!* Not fixed in this version
		m.lcFixError = STUFF(m.lcFixError, 4, 1, "1")
	CASE LEFT(m.lcTableHeader, 1) <> "0"
*!* Non Visual (no m.lnContainerBlockSize bytes added)

*!* NOTE Header record terminator is also in the same block with eof

		IF LEN(m.lcFieldInfo) = 1 && and m.lcFieldInfo = chr(13)
*!* This is normal situation and reccount() = 0
		ELSE
*!* This is normal situation if there is less than
*!* m.lnOneFieldBlockSize bytes of data
*!* otherwise there is a record size / Header inconsistency error
*!* i.e. eof mark can't be in the same block with
*!* the header record terminator if record size > = m.lnOneFieldBlockSize
			IF m.lnRecSize3 >= m.lnOneFieldBlockSize   && not ok if > = m.lnOneFieldBlockSize
*!*
*!*
				m.lcFixError = STUFF(m.lcFixError, 5, 1, "1")
			ENDIF
		ENDIF
	OTHERWISE
*!* Admin notice only in english
		WAIT WINDOW "It should not come ever here. Press a key to debug" TIMEOUT 3
		IF LASTKEY() = 65 OR LASTKEY() = 97 && A or a (press a key... Heh)
			SET STEP ON
		ENDIF
	ENDCASE
ELSE
*!* Normal situation, recco()>0
ENDIF

*!* real m.lnDataStart3 value (header())
m.lnDataStart3 = m.lnHeaderBlockSize + ;
	M.lnAllFieldBlockSize + ;
	SIGN(m.lnNullFlagLen) * m.lnOneFieldBlockSize + ;
	LEN(m.lcHeaderRecTerminator) + ;
	IIF(LEFT(m.lcTableHeader, 1) = "0", m.lnContainerBlockSize, 0)

IF m.lnRecSize4 <> m.lnRecSize3
	m.lcFixError = STUFF(m.lcFixError, 6, 1, "1")
ENDIF

m.lnRecSize3 = m.lnRecSize3 + m.lnNullFlagLen
m.lnRecSize4 = m.lnRecSize4 + m.lnNullFlagLen

*!*
*!* Find out how many record there is.
*!*

*!* First evaluate it from the filesize and record length
m.lnRecCount1 = INT((m.lnFileSize - m.lnDataStart2) / m.lnRecSize2)

*!* Secondly evaluate it from the bytes 5-8 (returned by reccount()
m.lnRecCount2 = UnLSBMSB(SUBSTR(m.lcTableHeader, 5, 4))

*!* Thirdly evaluate it from the actual data
m.lnRecCount3 = INT((m.lnFileSize - m.lnDataStart3) / m.lnRecSize3)
*!* This is the most correct one value

IF m.lnRecCount3 <> m.lnRecCount2 OR m.lnRecCount3 <> m.lnRecCount1 ;
		OR m.lnRecCount2 <> m.lnRecCount1
	m.lcFixError = STUFF(m.lcFixError, 7, 1, "1")
ENDIF

IF INLIST(m.tnRepairMode, 0, 1, 2, 3, 4, 5, 6)
	DO CASE
	CASE (AT("1", m.lcFixError) > 0 AND AT("1", m.lcFixError) < 5) OR ;
			AT("1", m.lcFieldError) > 0

		NOTE: NOT repairable
		FixMessage(106, m.tWhatDbf, "R"+m.lcFixError+" F"+m.lcFieldError, tnLang)

	CASE AT("1", m.lcFixError) > 5 OR ;
			M.lnDataStart2 <> m.lnDataStart3 OR ;
			M.tnRepairMode = 0

&& Report

		m.lcFixedContainer1 = ""

		IF TYPE("m.tcContainer") = "C" AND ;
				!EMPTY(m.tcContainer)
			m.lcFixedContainer1 = PADR(m.tcContainer,m.lnContainerBlockSize,CHR(0x00))
			m.lcFixedContainer2 = STRTRAN(m.lcFixedContainer1, CHR(0x00), "")
		ENDIF

		IF LEFT(m.lcTableHeader, 1) = "0"  && Visual FoxPro

			IF m.llIsMemo3
				m.lcMemoByte = STUFF(DECTOBIN(ASC(SUBS(m.lcTableHeader, 29, 1))), 7, 1, "1")
			ELSE
				m.lcMemoByte = STUFF(DECTOBIN(ASC(SUBS(m.lcTableHeader, 29, 1))), 7, 1, "0")
			ENDIF

			m.lcTableFixedHdr = LEFT(m.lcTableHeader, 1) + ;
				CHR(VAL(RIGHT(STR(YEAR(DATE())), 2))) + ;
				CHR(MONTH(DATE())) + ;
				CHR(DAY(DATE())) + ;
				ToLSBMSB(m.lnRecCount3, 4) + ;
				ToLSBMSB(m.lnDataStart3, 2) + ;
				ToLSBMSB(m.lnRecSize3, 2) + ;
				SUBSTR(m.lcTableHeader, 13, 16) + ;
				CHR(BINTODEC(m.lcMemoByte)) + ;
				M.lcCodePage + ;
				SUBSTR(m.lcTableHeader, 31, 2)

		ELSE

			IF m.llIsMemo3
				DO CASE
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x02) OR ;
						LEFT(m.lcTableHeader, 1) = CHR(0xFB)
*!* FoxBase
					m.lcMemoByte = CHR(0xFB)
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x03)
*!* "FoxBASE+/dBASE III PLUS, FoxPro, dBaseIV, no memo"
					m.lcMemoByte = CHR(0xF5) && FoxPro2x
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x43)
*!* "dBASE IV SQL table files, no memo"
					m.lcMemoByte = CHR(0xCB)
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x83)
*!* "FoxBASE+/dBASE III PLUS, with memo"
					m.lcMemoByte = CHR(0x83)
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x8B)
*!* "dBASE IV with memo"
					m.lcMemoByte = CHR(0x8B)
				CASE LEFT(m.lcTableHeader, 1) = CHR(0xF5)
*!* "FoxPro 2.x (or earlier) with memo"
					m.lcMemoByte = CHR(0xF5)
				CASE LEFT(m.lcTableHeader, 1) = CHR(0x63)
*!* "dBASE IV SQL system files, no memo"
*!* Don't know ??
*!* This is a quess
*!* m.lcMemoByte = Chr(0xEB) ??
					m.lcMemoByte = CHR(0xCB)
				OTHERWISE
*!* "dBASE IV with memo" the newest one
					m.lcMemoByte = CHR(0x8B)
				ENDCASE
			ELSE
				m.lcMemoByte = CHR(0x03)
			ENDIF

			m.lcTableFixedHdr = m.lcMemoByte + ;
				CHR(VAL(RIGHT(STR(YEAR(DATE())), 2))) + ;
				CHR(MONTH(DATE())) + ;
				CHR(DAY(DATE())) + ;
				ToLSBMSB(m.lnRecCount3, 4) + ;
				ToLSBMSB(m.lnDataStart3, 2) + ;
				ToLSBMSB(m.lnRecSize3, 2) + ;
				SUBSTR(m.lcTableHeader, 13, 17) + ;
				M.lcCodePage + ;
				SUBSTR(m.lcTableHeader, 31, 2)

		ENDIF

		IF TYPE("m.tcContainer") = "C"

*!* Go to the right position to read original container block
			FSEEK(m.lnHandler, ;
				M.lnHeaderBlockSize + ;
				M.lnAllFieldBlockSize + ;
				SIGN(m.lnNullFlagLen) * m.lnOneFieldBlockSize + ;
				LEN(m.lcHeaderRecTerminator), 0)

			m.lcTableContainer1 = FREAD(m.lnHandler, ;
				M.lnContainerBlockSize) && Actual container block

			m.lcTableContainer2 = STRTRAN(m.lcTableContainer1, CHR(0x00), "")

			IF FERROR()<>0 AND m.tnRepairMode # 0
				FixMessage(105, m.tWhatDbf,, tnLang)
				RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
			ENDIF

		ENDIF

		DO CASE

		CASE INLIST(m.tnRepairMode, 1, 3)             && Table
			FSEEK(m.lnHandler, 0, 0)                  && go to begining of the file
			FWRITE(m.lnHandler, m.lcTableFixedHdr)    && write new header to the table

			IF FERROR()<>0
				FixMessage(105, m.tWhatDbf,, tnLang)
				RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
			ENDIF

			IF TYPE("m.tcContainer") = "C" AND !EMPTY(m.lcFixedContainer1)
*!* GO to the Header record terminator

*!* Go to the right position to write fixed container block
				FSEEK(m.lnHandler, ;
					M.lnHeaderBlockSize + ;
					M.lnAllFieldBlockSize + ;
					SIGN(m.lnNullFlagLen) * m.lnOneFieldBlockSize, 0)

				FWRITE(m.lnHandler, m.lcHeaderRecTerminator + m.lcFixedContainer1)    && Write new container info

				IF FERROR()<>0
					FixMessage(105, m.tWhatDbf,, tnLang)
					RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
				ENDIF

			ENDIF
			m.llTableRepaired = .T.


		CASE INLIST(m.tnRepairMode, 4, 6) && Whole data file is overwritten

*!* This works but for the next version
*!* add input / template for field block if
*!* it is corrupted

			LOCAL ;
				lcTotalHeader, ;
				lcRecordData, ;
				lnRecCounter, ;
				lnProceed

*!* Save Header info to the memo file
			m.lcTotalHeader = ;
				M.lcTableFixedHdr + ;
				M.lcAllFieldInfo + ;
				M.lcHeaderRecTerminator

			DO CASE
			CASE !EMPTY(m.lcFixedContainer1)
				m.lcTotalHeader = m.lcTotalHeader + m.lcFixedContainer1
			CASE !EMPTY(m.lcTableContainer1)
				m.lcTotalHeader = m.lcTotalHeader + m.lcTableContainer1
			ENDCASE

			REPLACE ATFIX WITH m.lcTotalHeader IN (JUSTSTEM(m.lcTmpDbf))

*!* Fetch all data and append it to the memo file
			FSEEK(m.lnHandler, ;
				M.lnHeaderBlockSize + ;
				M.lnAllFieldBlockSize + ;
				SIGN(m.lnNullFlagLen) * m.lnOneFieldBlockSize + ;
				LEN(m.lcHeaderRecTerminator) + ;
				M.lnContainerBlockSize, 0)

*!* Now the pointer is in the beginning of data


			IF !FEOF(m.lnHandler)

				m.lnRecCounter = 1

				SET ESCAPE ON

				m.lnProceed = 600

				IF m.lnRecCount3 > m.lnTooSlowToHandle
					m.lnProceed = FixMessage(108, m.lnRecCount3, m.tnRepairMode, tnLang) * 100
				ENDIF

				IF m.lnProceed = 600 OR m.lnProceed = -100

					DO WHILE .T.

						m.lcRecordData = FREAD(m.lnHandler, m.lnRecSize3)
						IF FERROR()<>0
							FixMessage(105, m.tWhatDbf,, tnLang)
							RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
						ENDIF

						FixMessage(109, m.lnRecCounter, m.lnRecCount3, tnLang)
						REPLACE ATFIX WITH ATFIX + m.lcRecordData IN (JUSTSTEM(m.lcTmpDbf))

						IF FEOF(m.lnHandler)
							EXIT
						ENDIF

						m.lnRecCounter = m.lnRecCounter  + 1

					ENDDO
				ELSE
					RETURN FixExit(m.lnProceed, m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
				ENDIF
			ENDIF
*!* Now memo file ATFIX contains m.tWhatDbf in binary format
			FCLOSE(m.lnHandler)
			m.lcSafety = SET("SAFETY")
			SET SAFETY OFF
			COPY MEMO ATFIX TO (m.tWhatDbf)
			SET SAFETY &lcSafety
			m.llTableRepaired = .T.

		ENDCASE

	OTHERWISE
		NOTE: DATA FILE IS ok
		m.llTableIsAlreadyOK = .T.
		m.lcTableFixedHdr = m.lcTableHeader
	ENDCASE

ELSE

*!* m.tnRepairMode > 3
*!* Not supported yet

ENDIF

FCLOSE(m.lnHandler)                && Close DBF pointed by m.lnHandler

*!* Now We check the FPT file

IF m.llIsMemo3
	IF !m.llIsMemo1
*!* no fpt file but there is a memo field
*!* Error 41 but in this case Memo file is missing
*!* So create it!!!

		LOCAL ;
			lcTmpTable, ;
			lnTmpSele, ;
			cMyTEMPDir

		m.lnTmpSele = SELECT()

		SELECT 0

		m.cMyTEMPDir = ;
			IIF(LEN(GETENV('TEMP'))=0,SYS(5)+CURDIR()+;
			IIF(!RIGHT(CURDIR(),1)=='\','\',''),;
			GETENV('TEMP')+IIF(!RIGHT(GETENV('TEMP'),1)=='\','\',''))

		m.lcTmpTable = m.cMyTEMPDir + SYS(2015)

		DO WHILE FILE(m.lcTmpTable+".DBF") OR FILE(m.lcTmpTable+".FPT")
			m.lcTmpTable = m.cMyTEMPDir + SYS(2015)
		ENDDO

		SELECT 0
		CREATE TABLE (m.lcTmpTable) (temp M)
		USE

		COPY FILE (m.lcTmpTable+".FPT") TO ;
			(m.lcWhatFpt)

		ERASE (m.cTmpTable+".FPT")
		ERASE (m.cTmpTable+".DBF")

	ELSE

*!* all other cases (memo header coud be corrupted)
*!* or memo indicator in DBF Header Block is invalid
*!* So correct the header and possibly write memo
*!* indicator into the DBF Header Block
*!* note!! DBF header is fixed already

		IF !m.tlNoBackups AND m.tnRepairMode # 0  && data file backed

*!* && DataFixBacked = EXT00
			IF FILE(m.lcBackFile)
				FOR m.lnI = 1 TO 99
					m.lcBackFile = m.lcWhatFpt + PADL(TRANSFORM(m.lnI),2,"0")

*!* && DataFixBacked = EXTnn, nn = 01-99
					IF !FILE(m.lcBackFile)
						EXIT
					ELSE
						IF m.lnI = 99 AND FILE(m.lcBackFile)
							ERASE (m.lcBackFile)
							EXIT
						ENDIF
					ENDIF
				ENDFOR
			ENDIF

			WAIT CLEAR

			NOTE: making FPT backup
			FixMessage(102, m.lcWhatFpt, m.lcBackFile, tnLang)

			COPY FILE (m.lcWhatFpt) TO (m.lcBackFile)

			WAIT CLEAR

			NOTE: FPT backup ok

			NOTE: backup ok
			FixMessage(103, m.lcBackFile,, tnLang)

		ENDIF

		m.lnHandler = FOPEN(m.lcWhatFpt, 12)    && unbuffered

		IF m.lnHandler < 0                    && Error generated creating file
			FixMessage(104+VAL(SET("POINT")+ALLTRIM(STR(FERROR()))),m.lcWhatFpt,, tnLang)
			RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
		ENDIF

		NOTE: NOW the FPT-fix starts

*!* Memo files contain one header record and any number of
*!* block structures. The header record contains a pointer
*!* to the next free block and the size of the block in bytes.
*!* The size is determined by the SET BLOCKSIZE command when
*!* the file is created. The header record starts at file
*!* position zero and occupies 512 bytes. The SET BLOCKSIZE TO 0
*!* command sets the block size width to 1.

*!* Following the header record are the blocks that contain a
*!* block header and the text of the memo. The table file contains
*!* block numbers that are used to reference the memo blocks.
*!* The position of the block in the memo file is determined by
*!* multiplying the block number by the block size (found in the
*!* memo file header record). All memo blocks start at even block
*!* boundary addresses. A memo block can occupy more than one
*!* consecutive block.

*!* Memo Header Record

*!* Byte offset Description
*!* 00 – 03 Location of next free block 1)
*!* 04 – 05 Unused
*!* 06 – 07 Block size (bytes per block) 1)
*!* 08 – 511 Unused

*!* 1) Integers stored with the most significant byte first.

*!* --------------------

*!* Memo Block Header and Memo Text

*!* Byte offset Description
*!* 00 – 03 Block signature (indicates the type of data in the block) 1)
*!* 0 – picture (picture field type)
*!* 1 – text (memo field type)
*!* 04 – 07 Length (n) memo (in bytes) 1)
*!* 08 – n Memo text (n = length)

*!* 1) Integers stored with the most significant byte first.

		LOCAL ;
			lcFptHeader, ;
			lnFptSize, ;
			lnFptBlockSize, ;
			lnFptNFB

*!* m.lcFptHeader    First 8 bytes of the file
*!* m.lnFptSize      Size of the file
*!* m.lnFptNFB       Address of next free memo block

		m.lcFptHeader = FREAD(m.lnHandler, 8)  && first 8 bytes of the header

		IF FERROR()<>0
			FixMessage(105, m.lcWhatFpt,, tnLang)
			RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
		ENDIF

*!* Fpt i.e all memo file types
		m.lnFptSize = FSEEK(m.lnHandler, 0, 2)
		m.lnFptNFB = UnMSBLSB(SUBS(m.lcFptHeader, 1, 4))
		m.lnFptBlockSize = UnMSBLSB(SUBS(m.lcFptHeader, 7, 2))

		NOTE: ask OR CALCULATE BLOCKSIZE (NOT IN THIS VERSION)
		IF m.lnFptNFB <> INT(m.lnFptSize / m.lnFptBlockSize)
*  && Next free address is not the same as calculated
*  && maybe the default blocksize is incorrect ???
*  local lcTmpWin2
*  m.lcTmpWin2 = sys(3)
*  define window m.cTmpWin2 at 5, 3 size 9, 30 ;
*         title " FPT Datayksikön koko ??? " double shadow
*
*  acti window m.lcTmpWin2
*
*  do while .t.
*    note: gimme ok blocksize
*  enddo
			m.lnFptBlockSize = m.tnMemoBlockSice
		ENDIF

		DO CASE
		CASE m.lnFptBlockSize = 0
			m.lnFptBlockSize = 1
		CASE m.lnFptBlockSize = 33
			m.lnFptBlockSize = 512 * m.lnFptBlockSize
		OTHERWISE
			m.lnFptBlockSize = m.lnFptBlockSize
		ENDCASE

*!* This is a same than above
*!* m.nFptGetBSize = IIF(m.nFptGetBSize<33, ;
*!* IIF(m.nFptGetBSize = 0, 1, m.nFptGetBSize*512), m.nFptGetBSize)

		m.lcFptFixedHdr = ToMSBLSB(INT(m.lnFptSize / m.lnFptBlockSize), 4) + ;
			CHR(0) + CHR(0) + ToMSBLSB(m.lnFptBlockSize, 2)

		IF INLIST(m.tnRepairMode, 0, 2, 3, 5, 6) AND ;
				!m.lcFptHeader == m.lcFptFixedHdr

			IF INLIST(m.tnRepairMode, 2, 3, 5, 6) && 0 = Also memo
				FSEEK(m.lnHandler, 0, 0)             && go to begining of the file
				FWRITE(m.lnHandler, m.lcFptFixedHdr)

				IF FERROR()<>0
					FixMessage(105, m.lcWhatFpt,, tnLang)
					RETURN FixExit(IIF(m.tnRepairMode = 0, -10, -1 * m.tnRepairMode), m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)
				ENDIF
			ENDIF
			m.llMemoRepaired = .T.
		ELSE

*!* m.tnRepairMode > 3
*!* Not supported yet

		ENDIF
	ENDIF

	FCLOSE(m.lnHandler)                && Close FPT pointed by m.lnHandler

ENDIF  && Memo field exist m.llIsMemo3 = .T.

*!* Report file generation

LOCAL ;
	lcTmpWin1, ;
	lcFileOrigin, ;
	llChr7Exist, ;
	lcInfo, ;
	lcInfoFile, ;
	lcNot1, ;
	lcNot2, ;
	lcLineFeed

m.lcInfo = ""
m.lcNot1 = ""  && or "not"
m.lcNot2 = ""  && or "not"
m.lcLineFeed = CHR(13) + CHR(10)

DO CASE
CASE LEFT(m.lcTableHeader, 1) = CHR(0x02)
	m.lcFileOrigin = "FoxBASE"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x03)
	m.lcFileOrigin = "FoxBASE+ / dBASE III PLUS, FoxPro, dBaseIV, no memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x30)
	m.lcFileOrigin = "Visual FoxPro"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x31)
	m.lcFileOrigin = "Visual FoxPro"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x32)
	m.lcFileOrigin = "Visual FoxPro"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x43)
	m.lcFileOrigin = "dBASE IV SQL table files, no memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x63)
	m.lcFileOrigin = "dBASE IV SQL system files, no memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x83)
	m.lcFileOrigin = "FoxBASE+ / dBASE III PLUS, with memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0x8B)
	m.lcFileOrigin = "dBASE IV with memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0xCB)
	m.lcFileOrigin = "dBASE IV SQL table files, with memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0xF5)
	m.lcFileOrigin = "FoxPro 2.x (or earlier) with memo"
CASE LEFT(m.lcTableHeader, 1) = CHR(0xFB)
	m.lcFileOrigin = "FoxBASE with memo"
OTHERWISE
	m.lcFileOrigin = ""
ENDCASE

IF !EMPTY(m.lcTableContainer2)
	m.lcInfo = m.lcInfo + m.lcFileOrigin + " file: " + ;
		JUSTFNAME(m.lcTableContainer2) + "!" + JUSTFNAME(m.tWhatDbf)
ELSE
	m.lcInfo = m.lcInfo + m.lcFileOrigin + " file: " + JUSTFNAME(m.tWhatDbf)
ENDIF
IF LEN(m.lcInfo) < 45
	m.lcInfo = m.lcInfo + " | Size "+;
		ALLT(STR(m.lnFileSize, 10, 0)) + " Bytes.   " + m.lcLineFeed + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + m.lcLineFeed + "Size "+;
		ALLT(STR(m.lnFileSize, 10, 0)) + " Bytes.   " + m.lcLineFeed + m.lcLineFeed
ENDIF

m.lcInfo = m.lcInfo + "From          Data Start, Total RecSize,  Reccount, FieldCount" + m.lcLineFeed
m.lcInfo = m.lcInfo + "Filesize" + SPACE(32) + STR(m.lnRecCount1, 10, 0) + m.lcLineFeed
m.lcInfo = m.lcInfo + "Header Block  " + STR(m.lnDataStart2, 10, 0) + ;
	SPACE(5) + STR(m.lnRecSize2, 10, 0) + " " + ;
	STR(m.lnRecCount2, 10, 0) + m.lcLineFeed
m.lcInfo = m.lcInfo + "Data Block    " + STR(m.lnDataStart3, 10, 0) + ;
	SPACE(5) + STR(m.lnRecSize3, 10, 0) + " " + ;
	STR(m.lnRecCount3, 10, 0) + "  " + ;
	STR(m.lnFieldCo3, 10, 0) + m.lcLineFeed
m.lcInfo = m.lcInfo + "Data offset" + SPACE(18) + STR(m.lnRecSize4, 10, 0) + m.lcLineFeed
m.lcInfo = m.lcInfo + m.lcLineFeed
IF SUBSTR(m.lcFixError, 1, 1) = "1"
	m.lcInfo = m.lcInfo + "- There isn't Any Info For Fields" + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + "- Field info Ok" + m.lcLineFeed
ENDIF
IF SUBSTR(m.lcFixError, 2, 1) = "1"
	m.lcInfo = m.lcInfo + "- There is some info about first field" + m.lcLineFeed
	m.lcInfo = m.lcInfo + "  but the info is only partial" + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + "- First field info Ok" + m.lcLineFeed
ENDIF
IF SUBSTR(m.lcFixError, 3, 1) = "1"
	m.lcInfo = m.lcInfo + "- There is info about more than one field but" + m.lcLineFeed
	m.lcInfo = m.lcInfo + "  the info about the last field is only partial" + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + "- There are more than one field and the last field info is Ok" + m.lcLineFeed
ENDIF
IF SUBSTR(m.lcFixError, 4, 1) = "1"
	m.lcInfo = m.lcInfo + "- " + TRANSFORM(m.lnContainerBlockSize) + ;
		" bytes for container info are missing" + m.lcLineFeed
ELSE
	IF LEFT(m.lcTableHeader, 1) = "0"
		m.lcInfo = m.lcInfo + "- Space for DBC info Ok" + m.lcLineFeed
	ELSE
* ?"Reserved for the Visual FoxPro"
	ENDIF
ENDIF
IF SUBSTR(m.lcFixError, 5, 1) = "1"
	m.lcInfo = m.lcInfo + "- Record size from the field info is more than " + ;
		TRANSFORM(m.lnOneFieldBlockSize) + m.lcLineFeed
ELSE
* ?"5 Ok"
ENDIF
IF SUBSTR(m.lcFixError, 6, 1) = "1"
	m.lcInfo = m.lcInfo + "- Record size from the field info and offset differs" + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + "- Record size from the field info and offset are Ok" + m.lcLineFeed
ENDIF
IF SUBSTR(m.lcFixError, 7, 1) = "1"
	m.lcInfo = m.lcInfo + "- Record count differs" + m.lcLineFeed
ELSE
	m.lcInfo = m.lcInfo + "- Record count from file size, header and actual data are same (Ok)" + m.lcLineFeed
ENDIF
IF SUBSTR(m.lcFixError, 8, 1) = "1"
*?"Error 8"
ELSE
*?"8 Ok"
ENDIF
m.lcInfo = m.lcInfo + m.lcLineFeed
m.lcInfo = m.lcInfo + "- First letter of the field's Name, Rest Of the Name, Type, Length" + m.lcLineFeed
m.lcInfo = m.lcInfo + "  Ok?"+SPACE(26)+IIF(SUBS(m.lcFieldError, 1, 1) = "1" OR ;
	SUBS(m.lcFieldError, 2, 1) = "1", " No", "Yes")+;
	SPACE(15)+IIF(SUBS(m.lcFieldError, 3, 1) = "1", " No", "Yes")+;
	SPACE(3)+IIF(SUBS(m.lcFieldError, 4, 1) = "1", " No", "Yes")+;
	SPACE(5)+IIF(SUBS(m.lcFieldError, 5, 1) = "1", " No", "Yes") + m.lcLineFeed

IF AT("1", m.lcFieldError)>0
	m.lcInfo = m.lcInfo + m.lcLineFeed
	m.lcInfo = m.lcInfo + "- Because of the error in field, no automatic fix can be done" + m.lcLineFeed
ENDIF

*!* Next TABLE HEADERS
m.lcInfo = m.lcInfo + m.lcLineFeed
m.lcInfo = m.lcInfo + "Table 0riginal Hdr.....:"

** NOTE NOTE NOTE **
*!* CHR(7) is shown OK with Font "Terminal"
*!* If you trouble with CHR(7), uncomment all **CHR(7)** lines
*!* AND COMMENT ALL && **CHR(7) OK** lines

**CHR(7)** For m.lnI = 1 To Len(m.lcTableHeader)						&& **CHR(7)**
**CHR(7)**   If Substr(m.lcTableHeader,m.lnI,1) = Chr(7)				&& **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + "7"								&& **CHR(7)**
**CHR(7)**     m.llChr7Exist = .T.										&& **CHR(7)**
**CHR(7)**   Else														&& **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + Substr(m.lcTableHeader,m.lnI,1)	&& **CHR(7)**
**CHR(7)**   Endif														&& **CHR(7)**
**CHR(7)** Endfor														&& **CHR(7)**

m.lcInfo = m.lcInfo + m.lcTableHeader									&& **CHR(7) OK**

m.lcInfo = m.lcInfo + m.lcLineFeed

m.lcInfo = m.lcInfo + "Table Fixed Hdr........:"
**CHR(7)** For m.lnI = 1 To Len(m.lcTableFixedHdr)						&& **CHR(7)**
**CHR(7)**   If Substr(m.lcTableFixedHdr,m.lnI,1) = Chr(7)				&& **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + "7"								&& **CHR(7)**
**CHR(7)**     m.llChr7Exist = .T.										&& **CHR(7)**
**CHR(7)**   Else														&& **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + Substr(m.lcTableFixedHdr,m.lnI,1)	&& **CHR(7)**
**CHR(7)**   Endif														&& **CHR(7)**
**CHR(7)** Endfor														&& **CHR(7)**

m.lcInfo = m.lcInfo + m.lcTableFixedHdr									&& **CHR(7) OK**

m.lcInfo = m.lcInfo + m.lcLineFeed

*!* Next Fixed container
IF !EMPTY(m.lcFixedContainer2)

	m.lcInfo = m.lcInfo + "- Original container    "
	FOR m.lnI = 1 TO LEN(m.lcTableContainer2)
		IF SUBSTR(m.lcTableContainer2,m.lnI,1) = CHR(7)
			m.lcInfo = m.lcInfo + "7"
			m.llChr7Exist = .T.
		ELSE
			m.lcInfo = m.lcInfo + SUBSTR(m.lcTableContainer2,m.lnI,1)
		ENDIF
	ENDFOR
	m.lcInfo = m.lcInfo + m.lcLineFeed
	m.lcInfo = m.lcInfo + "- New container         "
	FOR m.lnI = 1 TO LEN(m.lcFixedContainer2)
		IF SUBSTR(m.lcFixedContainer2,m.lnI,1) = CHR(7)
			m.lcInfo = m.lcInfo + "7"
			m.llChr7Exist = .T.
		ELSE
			m.lcInfo = m.lcInfo + SUBSTR(m.lcFixedContainer2,m.lnI,1)
		ENDIF
	ENDFOR
	m.lcInfo = m.lcInfo + m.lcLineFeed

ENDIF

* IF m.llChr7Exist
*   m.lcInfo = m.lcInfo + "Note "
*   m.lcInfo = m.lcInfo + "7"
*   m.lcInfo = m.lcInfo + " is CHR(7)               "
* ENDIF

m.lcInfo = m.lcInfo + m.lcLineFeed

m.lcInfo = m.lcInfo + "- FPT file, Memo flag, Memo field"
IF m.llIsMemo1 OR m.llIsMemo3
	m.lcInfo = m.lcInfo + ", Size (Now), Size (True), Block size" + m.lcLineFeed
ENDIF
m.lcInfo = m.lcInfo + SPACE(7) + IIF(m.llIsMemo1, "Yes", " No") + ;
	SPACE(8) + IIF(m.llIsMemo2, "Yes", " No") + ;
	SPACE(9) + IIF(m.llIsMemo3, "Yes", " No")

IF m.llIsMemo1 OR m.llIsMemo3
	LOCAL ;
		laMemoFileInfo[1], ;
		lnMemoFileSize1, ;
		lnMemoFileSize2

	DO CASE
	CASE m.llIsMemo1 AND m.llIsMemo3
		ADIR(laMemoFileInfo, m.lcWhatFpt)
		m.lnMemoFileSize1 = IIF(TYPE("m.laMemoFileInfo[1,2]") = "N", ;
			M.laMemoFileInfo[1,2], "Undefined")
		m.lnMemoFileSize2 = m.lnFptSize
		m.lcInfo = m.lcInfo + "  "+PADL(TRANSFORM(m.lnMemoFileSize1), 10, " ") + ;
			"   " + PADL(TRANSFORM(m.lnMemoFileSize2), 10, " ")
	CASE m.llIsMemo1 AND !m.llIsMemo3
		ADIR(laMemoFileInfo, m.lcWhatFpt)
		m.lnMemoFileSize1 = IIF(TYPE("m.laMemoFileInfo[1,2]") = "N", m.laMemoFileInfo[1,2], "Undefined")
		m.lnMemoFileSize2 = 0
		m.lcInfo = m.lcInfo + "  "+PADL(TRANSFORM(m.lnMemoFileSize1), 10, " ") + ;
			"   " + PADL(TRANSFORM(m.lnMemoFileSize2), 10, " ")
	CASE !m.llIsMemo1 AND m.llIsMemo3
		m.lnMemoFileSize1 = 0
		m.lnMemoFileSize2 = "Undefined"
		m.lcInfo = m.lcInfo + "  "+PADL(TRANSFORM(m.lnMemoFileSize1), 10, " ") + ;
			"   " + PADL(m.lnMemoFileSize1, 10, " ")
	ENDCASE

	m.lcInfo = m.lcInfo + PADL(TRANSFORM(m.lnFptBlockSize), 12, " ") + m.lcLineFeed

*!* Next MEMO HEADERS
	m.lcInfo = m.lcInfo + m.lcLineFeed
	m.lcInfo = m.lcInfo + "Memo 0riginal Hdr......:"

** NOTE NOTE NOTE **
*!* CHR(7) is shown OK with Font "Terminal"
*!* If you trouble with CHR(7), uncomment all **CHR(7)** lines
*!* AND COMMENT ALL && **CHR(7) OK** lines

**CHR(7)** For m.lnI = 1 To Len(m.lcFptHeader)						 && **CHR(7)**
**CHR(7)**   If Substr(m.lcFptHeader,m.lnI,1) = Chr(7)				 && **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + "7"							 && **CHR(7)**
**CHR(7)**     m.llChr7Exist = .T.									 && **CHR(7)**
**CHR(7)**   Else													 && **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + Substr(m.lcFptHeader,m.lnI,1)	 && **CHR(7)**
**CHR(7)**   Endif													 && **CHR(7)**
**CHR(7)** Endfor													 && **CHR(7)**

	m.lcInfo = m.lcInfo + m.lcFptHeader									 && **CHR(7) OK**

	m.lcInfo = m.lcInfo + m.lcLineFeed

	m.lcInfo = m.lcInfo + "Memo Fixed Hdr.........:"
**CHR(7)** For m.lnI = 1 To Len(m.lcFptFixedHdr)					 && **CHR(7)**
**CHR(7)**   If Substr(m.lcFptFixedHdr,m.lnI,1) = Chr(7)			 && **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + "7"							 && **CHR(7)**
**CHR(7)**     m.llChr7Exist = .T.									 && **CHR(7)**
**CHR(7)**   Else													 && **CHR(7)**
**CHR(7)**     m.lcInfo = m.lcInfo + Substr(m.lcFptFixedHdr,m.lnI,1) && **CHR(7)**
**CHR(7)**   Endif													 && **CHR(7)**
**CHR(7)** Endfor													 && **CHR(7)**

	m.lcInfo = m.lcInfo + m.lcFptFixedHdr								 && **CHR(7) OK**

**CHR(7)** m.lcInfo = m.lcInfo + m.lcLineFeed + m.lcLineFeed		 && **CHR(7)**

**CHR(7)** If m.llChr7Exist											 && **CHR(7)**
**CHR(7)**   m.lcInfo = m.lcInfo + "*) Note "						 && **CHR(7)**
**CHR(7)**   m.lcInfo = m.lcInfo + "7"								 && **CHR(7)**
**CHR(7)**   m.lcInfo = m.lcInfo + " is CHR(7) "					 && **CHR(7)**
**CHR(7)** ENDIF													 && **CHR(7)**

*   m.lcInfo = m.lcInfo + m.lcLineFeed + m.lcLineFeed

* ELSE

* m.lcInfo = m.lcInfo + m.lcLineFeed + m.lcLineFeed

ENDIF

m.lcInfo = m.lcInfo + m.lcLineFeed + m.lcLineFeed

*!* Results
m.lcInfo = m.lcInfo + "RESULTS (Repair mode " + TRANSFORM(m.tnRepairMode) + "):" + m.lcLineFeed

*!* For a table
m.lcInfo = m.lcInfo + "- " + JUSTFNAME(m.tWhatDbf) + " is"

IF SUBSTR(m.lcTableHeader, 5, 25) == SUBSTR(m.lcTableFixedHdr, 5, 25) AND ;
		(m.lcTableContainer1 == m.lcFixedContainer1 OR EMPTY(m.lcFixedContainer1))
	m.lcInfo = m.lcInfo + " not"
ENDIF

m.lcInfo = m.lcInfo + " corrupted and" + ;
	IIF(!m.llTableRepaired, ;
	" NOT", "") + " REPAIRED!"

m.lcInfo = m.lcInfo + m.lcLineFeed

*!* For a memo
IF m.llIsMemo1 OR m.llIsMemo3
	m.lcInfo = m.lcInfo + "- " + JUSTFNAME(m.lcWhatFpt) + " is"
	IF m.lcFptHeader == m.lcFptFixedHdr AND ;
			M.lnMemoFileSize1 == m.lnMemoFileSize2
		m.lcInfo = m.lcInfo + " not"
	ENDIF
	m.lcInfo = m.lcInfo + " corrupted and" + ;
		IIF(!m.llMemoRepaired, ;
		" NOT", "") + " REPAIRED!"
ENDIF

m.lcInfo = m.lcInfo + m.lcLineFeed
m.lcInfo = m.lcInfo + "- " + IIF(!m.tlNoBackups AND m.tnRepairMode = 0,"", "No ") + "Backups done."

m.lcInfo = m.lcInfo + m.lcLineFeed + m.lcLineFeed
m.lcInfo = m.lcInfo + "(c) 2001 Arto Toikka"

m.lcInfoFile = ADDBS(JUSTPATH(m.tWhatDbf)) + "ATFix_" + JUSTSTEM(m.tWhatDbf) + ".TXT"


m.lcSafety = SET("SAFETY")
SET SAFETY OFF

#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
*!* VFP 7
	STRTOFILE(m.lcInfo, m.lcInfoFile, 0)
#ELSE
	REPLACE ATFIX WITH m.lcInfo IN (JUSTSTEM(m.lcTmpDbf))
	COPY MEMO ATFIX TO (m.lcInfoFile)
#ENDIF

SET SAFETY &lcSafety

IF !m.tlNoInfo  && Show info window

	m.lcTmpWin1 = "A"+SYS(3)  && plain sys(3) doesn't work define window

	DEFINE WINDOW (m.lcTmpWin1) AT 1, 3 SIZE 35, 78 ;
		IN DESKTOP FONT "Terminal", 10 TITLE " Statistics for the " + ALLT(m.tWhatDbf) ;
		SYSTEM CLOSE FLOAT GROW MINIMIZE ZOOM

	MODIFY COMMAND (m.lcInfoFile) WINDOW (m.lcTmpWin1)

	RELEASE WIND (m.lcTmpWin1)

ENDIF

*!*!*!* Uncomment next line if report file is not needed
*!*!*!* ERASE (m.lcInfoFile)

RETURN FixExit(m.tnRepairMode, m.lcTmpDbf, m.lnSelect, m.lnHandler, m.tnLang)

*!*
*!* End of function FIXDBF
*!*

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function UnLSBMSB      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION UnLSBMSB

*!**!**!**!**!**!**!**!**!**!*

*!*	Example
*!* m.cSomeBytes = "¦¥ÃÓ"  && ascii characters from 0 to 255
*!*
*!* m.nSolved = ASC(SUBSTR(m.cSomeBytes, 1, 1))+;
*!*           ASC(SUBSTR(m.cSomeBytes, 2, 1))*256+;
*!*           ASC(SUBSTR(m.cSomeBytes, 3, 1))*256*256+;
*!*           ASC(SUBSTR(m.cSomeBytes, 4, 1))*256*256*256;
*!* OR
*!* m.nSolved = ASC("¦")+ASC("¥")*256+;
*!*           ASC("Ã")*256*256+ASC("Ó")*256*256*256;
*!*

LPARAMETERS tcSomeBytes

LOCAL ;
	lnRetVal, ;
	lnI

m.lnRetVal = 0

*!* for m.i = 1 to len(tcSomeBytes)
*!*   m.nSolved = m.nSolved+asc(substr(tcSomeBytes, i, 1))*(256^(i-1))
*!* endfor

*!* OR maybe the quicker one

FOR m.lnI = LEN(tcSomeBytes) TO 1 STEP -1
	m.lnRetVal = m.lnRetVal*256+ASC(SUBSTR(tcSomeBytes, m.lnI, 1))
ENDFOR

RETURN m.lnRetVal

*!*
*!* End of function UnLSBMSB
*!*

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function ToLSBMSB      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION ToLSBMSB

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tnSomeNum, tnCount

LOCAL ;
	lcRetVal, ;
	lnI

m.lcRetVal = ""

IF TYPE("m.tnCount")<>"N"
	m.tnCount = 1
ELSE
	m.tnCount = INT(m.tnCount)
ENDIF

FOR m.lnI = 1 TO m.tnCount
	m.lcRetVal = m.lcRetVal+CHR(MOD(m.tnSomeNum, 256))
	m.tnSomeNum = INT(m.tnSomeNum/256)
ENDFOR

RETURN m.lcRetVal

*!*
*!* End of function ToLSBMSB
*!*


*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function UnMSBLSB      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION UnMSBLSB

*!**!**!**!**!**!**!**!**!**!*

*!*	Example
*!* m.cSomeBytes = "¦¥ÃÓ"  && ascii characters from 0 to 255
*!*
*!* m.nSolved = ASC(SUBSTR(m.cSomeBytes, 4, 1))+;
*!*           ASC(SUBSTR(m.cSomeBytes, 3, 1))*256+;
*!*           ASC(SUBSTR(m.cSomeBytes, 2, 1))*256*256+;
*!*           ASC(SUBSTR(m.cSomeBytes, 1, 1))*256*256*256;
*!* OR
*!* m.nSolved = ASC("¦")+ASC("¥")*256+;
*!*           ASC("Ã")*256*256+ASC("Ó")*256*256*256;
*!*

LPARAMETERS tcSomeBytes

LOCAL ;
	lnRetVal, ;
	lnI

m.lnRetVal = 0

FOR m.lnI = 1 TO LEN(m.tcSomeBytes)
	m.lnRetVal = m.lnRetVal * 256 + ASC(SUBSTR(m.tcSomeBytes, m.lnI, 1))
ENDFOR

RETURN m.lnRetVal

*!*
*!* End of function UnMSBLSB
*!*

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function ToMSBLSB      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION ToMSBLSB

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tnSomeNum, tnCount

LOCAL ;
	lcRetVal, ;
	lnI

m.lcRetVal = ""

IF TYPE("m.tnCount")<>"N"
	m.tnCount = 1
ELSE
	m.tnCount = INT(m.tnCount)
ENDIF

FOR m.lnI = 1 TO m.tnCount
	m.lcRetVal = CHR(MOD(m.tnSomeNum, 256)) + m.lcRetVal
	m.tnSomeNum = INT(m.tnSomeNum / 256)
ENDFOR

RETURN m.lcRetVal

*!*
*!* End of function ToMSBLSB
*!*


*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function dectohex      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION dectohex

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tdn1  && decnum

PRIVATE ;
	lcPrefix, ;
	lnI, ;
	laDntoHex, ;
	lcHexnum, ;
	ldn0

m.lcPrefix = IIF(m.tdn1 < 0, "-", "")
m.tdn1 = ABS(m.tdn1)
m.lnI = 0
IF m.tdn1 > 15
	DO WHILE m.tdn1 > 15
		m.lnI = m.lnI + 1
		DIMENSION laDntoHex(i)
		m.ldn0 = m.tdn1 - INT(m.tdn1/16) * 16
		m.laDntoHex(i) = IIF(m.ldn0 = 10, "A", IIF(m.ldn0 = 11, "B", IIF(m.ldn0 = 12, "C", ;
			IIF(m.ldn0 = 13, "D", IIF(m.ldn0 = 14, "E", IIF(m.ldn0 = 15, "F", STR(m.ldn0, 1)))))))
		m.tdn1 = INT(m.tdn1/16)
	ENDDO
	DIMENSION laDntoHex(m.lnI + 1)
	m.laDntoHex(m.lnI + 1) = IIF(m.tdn1 = 10, "A", IIF(m.tdn1 = 11, "B", IIF(m.tdn1 = 12, "C", ;
		IIF(m.tdn1 = 13, "D", IIF(m.tdn1 = 14, "E", IIF(m.tdn1 = 15, "F", STR(m.ldn1, 1)))))))
	m.lcHexnum = ""
	FOR m.lnI = ALEN(m.laDntoHex) TO 1 STEP -1
		m.lcHexnum = m.lcHexnum + m.laDntoHex(m.lnI)
	ENDFOR
	m.lcHexnum = IIF(MOD(LEN(m.lcHexnum), 2) <> 0, "0" + m.lcHexnum, m.lcHexnum)
ELSE
	m.lcHexnum = IIF(m.tdn1 = 10, "0A", IIF(m.tdn1 = 11, "0B", IIF(m.tdn1 = 12, "0C", ;
		IIF(m.tdn1 = 13, "0D", IIF(m.tdn1 = 14, "0E", IIF(m.tdn1 = 15, "0F", "0" + STR(m.tdn1, 1)))))))
ENDIF
RETURN m.lcHexnum

*!*
*!* End of function dectohex
*!*

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function hextodec      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION hextodec

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS thn1  && hexnum

LOCAL ;
	lcPrefix, ;
	lnI, ;
	lnDecNum, ;
	lcHn0

m.lcPrefix = IIF(LEFT(m.thn1, 1) = "-", "-", "")
m.lnDecNum = 0
m.thn1 = STRTRAN(m.thn1, "-", "")
m.thn1 = UPPER(STRTRAN(m.thn1, " ", ""))
FOR m.lnI = LEN(m.thn1) TO 1 STEP -1
	m.lcHn0 = SUBSTR(m.thn1, i, 1)
	m.lnDecNum = m.lnDecNum + (16^(LEN(m.thn1) - m.lnI)) * ;
		IIF(ASC(m.lcHn0) > 64, ASC(m.lcHn0) - 55, VAL(m.lcHn0))
ENDFOR
RETURN INT(m.lnDecNum)

*!*
*!* End of function hextodec
*!*

*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function dectobin      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION DECTOBIN  && 0-255 needed only here

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tdn1  && decnum

LOCAL ;
	lnI, ;
	lnDecToBin, ;
	lcBinNum

DO CASE
CASE TYPE("m.tDn1")<>"N"
	RETURN "00000000"
CASE m.tdn1 = 0
	RETURN "00000000"
*case tDn1>255
*  tDn1 = 255
ENDCASE

m.lnDecToBin = m.tdn1
m.lcBinNum = ""

* m.lcBinNum = stuff(m.lcBinNum, m.lnI, 1, str(m.lnDecToBin%2, 0))

DO WHILE .T.
	m.lcBinNum = STR(m.lnDecToBin%2, 1, 0) + m.lcBinNum
	m.lnDecToBin = INT(m.lnDecToBin/2)
	IF m.lnDecToBin <=1
		m.lcBinNum = STR(m.lnDecToBin, 1, 0) + m.lcBinNum
		EXIT
	ENDIF
ENDDO

IF LEN(m.lcBinNum)%8 <> 0
	m.lcBinNum = REPL("0", 8 - LEN(m.lcBinNum)%8) + m.lcBinNum
ENDIF

RETURN m.lcBinNum

*!*
*!* End of function dectobin
*!*


*!**!**!**!**!**!**!**!**!**!*
*!*                        *!*
*!* Function bintodec      *!*
*!*                        *!*
*!**!**!**!**!**!**!**!**!**!*

FUNCTION BINTODEC

*!**!**!**!**!**!**!**!**!**!*

LPARAMETERS tBn1  && binnum

LOCAL ;
	lnI, ;
	lnDecNum

m.lnDecNum = 0

IF TYPE("m.tBn1") = "N"
	m.tBn1 = ALLTR(STR(INT(m.tBn1)))
ENDIF

FOR m.lnI = 1 TO LEN(m.tBn1)
	IF !INLIST(SUBSTR(m.tBn1, m.lnI, 1), "0", "1")
		NOTE: no binary VALUE
*!* Note only in english
		FixMessage(107,,, tnLang)
	ENDIF
ENDFOR

FOR m.lnI = LEN(m.tBn1) TO 1 STEP -1
	m.lnDecNum = m.lnDecNum + VAL(SUBSTR(m.tBn1, m.lnI, 1)) * 2^(LEN(m.tBn1) - m.lnI)
ENDFOR

RETURN m.lnDecNum

*!*
*!* End of function bintodec
*!*

FUNCTION FixMessage

LPARAMETERS tnMessage, tcVariable1, tcVariable2, tnLang, tnHandler

LOCAL ;
	lnRetVal

m.lnRetVal = 0

DO CASE

CASE INT(m.tnMessage) = 100
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + CHR(13) + ;
				M.tcVariable1 + " ei löydy!", 16, "ATFixDbfFpt error", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + CHR(13) + ;
				M.tcVariable1 + " ei löydy!", 16, "ATFixDbfFpt error")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Can't find data file: " + CHR(13) + ;
				M.tcVariable1, 16, "ATFixDbfFpt error", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Can't find data file: " + CHR(13) + ;
				M.tcVariable1, 16, "ATFixDbfFpt error")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 101
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + CHR(13) + ;
				M.tcVariable1 + " ei löydy!", 16, "ATFixDbfFpt error", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + CHR(13) + ;
				M.tcVariable1 + " ei löydy!", 16, "ATFixDbfFpt error")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Can't find container " + CHR(13) + ;
				M.tcVariable1, 16, "ATFixDbfFpt error", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Can't find container " + CHR(13) + ;
				M.tcVariable1, 16, "ATFixDbfFpt error")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 102
	DO CASE
	CASE m.tnLang = 1  && FIN
		WAIT WINDOW "Odottele teen varmuuskopioa: " + m.tcVariable2 ;
			AT WROWS()/2, WCOLS()/2-20 NOWAIT
	CASE m.tnLang > 1  && ENG
*!*			WAIT WINDOW "Wait for backing up " + ;
*!*				JUSTFNAME(m.tcVariable1) + " to " + JUSTFNAME(m.tcVariable2) ;
*!*				AT WROWS()/2, WCOLS()/2-30 NOWAIT
	ENDCASE

CASE INT(m.tnMessage) = 103
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Varmuuskopio:" + CHR(13) + ;
				M.tcVariable1 + " valmis!", 64, "ATFixDbfFpt", 1500)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Varmuuskopio:" + CHR(13) + ;
				M.tcVariable1 + " valmis!", 64, "ATFixDbfFpt")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
*!*				m.lnRetVal = MESSAGEBOX("Backup file :" + CHR(13) + ;
*!*					M.tcVariable1 + " is done!", 64, "ATFixDbfFpt", 1500)
		#ELSE
*!*				m.lnRetVal = MESSAGEBOX("Backup file :" + CHR(13) + ;
*!*					M.tcVariable1 + " is done!", 64, "ATFixDbfFpt")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 104

	LOCAL ;
		lcReason

	DO CASE
	CASE m.tnLang = 1  && FIN
		DO CASE                				&& Determine the error
		CASE m.tnMessage - INT(m.tnMessage) = (2/10)
			m.lcReason = "Tiedostoa ei löydy (2)"
		CASE m.tnMessage - INT(m.tnMessage) = (4/10)
			m.lcReason = "Liian monta tiedostoa auki (tiedosto kahvat loppu) (4)"
		CASE m.tnMessage - INT(m.tnMessage) = (5/10)
			m.lcReason = "Tiedostoon pääsy kielletty (5)"
		CASE m.tnMessage - INT(m.tnMessage) = (6/10)
			m.lcReason = "Väärä tiedosto kahva (6)"
		CASE m.tnMessage - INT(m.tnMessage) = (8/10)
			m.lcReason = "Muisti loppu (8)"
		CASE m.tnMessage - INT(m.tnMessage) = (25/100)
			m.lcReason = "Haku ei saa kohdistua paikkaan ennen tiedoston alkua (25)"
		CASE m.tnMessage - INT(m.tnMessage) = (29/100)
			m.lcReason = "Levy täynnä (29)"
		CASE m.tnMessage - INT(m.tnMessage) = (31/100)
			m.lcReason = "Tiedoston avaus ei onnistu (31)"
		OTHERWISE
			m.lcReason = "Virhe (" + ALLT(STR((m.tnMessage - INT(m.tnMessage))*100)) + ")"
		ENDCASE
	CASE m.tnLang > 1  && ENG
		DO CASE                				&& Determine the error
		CASE m.tnMessage - INT(m.tnMessage) = (2/10)
			m.lcReason = "File not found (2)"
		CASE m.tnMessage - INT(m.tnMessage) = (4/10)
			m.lcReason = "Too many files open (out of file handles) (4)"
		CASE m.tnMessage - INT(m.tnMessage) = (5/10)
			m.lcReason = "Access denied (5)"
		CASE m.tnMessage - INT(m.tnMessage) = (6/10)
			m.lcReason = "Invalid file handle given (6)"
		CASE m.tnMessage - INT(m.tnMessage) = (8/10)
			m.lcReason = "Out of memory (8)"
		CASE m.tnMessage - INT(m.tnMessage) = (25/100)
			m.lcReason = "Seek error (can't seek before the start of a file) (25)"
		CASE m.tnMessage - INT(m.tnMessage) = (29/100)
			m.lcReason = "Disk full (29)"
		CASE m.tnMessage - INT(m.tnMessage) = (31/100)
			m.lcReason = "Error opening file (31)"
		OTHERWISE
			m.lcReason = "Error (" + ALLT(STR((m.tnMessage - INT(m.tnMessage))*100)) + ")"
		ENDCASE

	ENDCASE

	NOTE: DBF IS corrupte but cannot FOPEN

	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + m.tcVariable1 + CHR(13) + ;
				"Ei voi avata, koska:" + CHR(13) + ;
				M.lcReason + CHR(13) + ;
				"Ota virhe muistiin.", 16, "ATFixDbfFpt virhe", 0)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + m.tcVariable1 + CHR(13) + ;
				"Ei voi avata, koska:" + CHR(13) + ;
				M.lcReason + CHR(13) + ;
				"Ota virhe muistiin.", 16, "ATFixDbfFpt virhe")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Can't open file " + m.tcVariable1 + CHR(13) + ;
				"because of error:" + CHR(13) + ;
				M.lcReason + CHR(13) + ;
				"Write this error down.", 16, "ATFixDbfFpt error", 0)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Can't open file " + m.tcVariable1 + CHR(13) + ;
				"because of error:" + CHR(13) + ;
				M.lcReason + CHR(13) + ;
				"Write this error down.", 16, "ATFixDbfFpt error")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 105
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + m.tcVariable1 + CHR(13) + ;
				"ei voi avata. Sulje mahdolliset muut" + CHR(13) + ;
				"ohjelmat, jotka käyttävät tätä tiedostoa" + CHR(13) + ;
				"ja yritä uudelleen.", 16, "ATFixDbfFpt error", 5000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Tiedostoa " + m.tcVariable1 + CHR(13) + ;
				"ei voi avata. Sulje mahdolliset muut" + CHR(13) + ;
				"ohjelmat, jotka käyttävät tätä tiedostoa" + CHR(13) + ;
				"ja yritä uudelleen.", 16, "ATFixDbfFpt error")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Can't open file " + m.tcVariable1 + CHR(13) + ;
				"Close other applications using this file" + CHR(13) + ;
				"and try again...", 16, "ATFixDbfFpt error", 5000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Can't open file " + m.tcVariable1 + CHR(13) + ;
				"Close other applications using this file" + CHR(13) + ;
				"and try again...", 16, "ATFixDbfFpt error")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 106
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Virhe: " + m.tcVariable2 + CHR(13) + ;
				"Tiedosto " + m.tcVariable1 + CHR(13) + ;
				"on korjauskelvoton, palauta nauhavarmistuskopio...", 16, "ATFixDbfFpt error", 5000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Virhe: " + m.tcVariable2 + CHR(13) + ;
				"Tiedosto " + m.tcVariable1 + CHR(13) + ;
				"on korjauskelvoton, palauta nauhavarmistuskopio...", 16, "ATFixDbfFpt error")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Fatal error: " + m.tcVariable2 + CHR(13) + ;
				"File " + m.tcVariable1 + CHR(13) + ;
				"is unrepairable, restore tape backup...", 16, "ATFixDbfFpt error", 5000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Fatal error: " + m.tcVariable2 + CHR(13) + ;
				"File " + m.tcVariable1 + CHR(13) + ;
				"is unrepairable, restore tape backup...", 16, "ATFixDbfFpt error")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 107
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Ei binääri arvo", 48, "ATFixDbfFpt", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Ei binääri arvo", 48, "ATFixDbfFpt")
		#ENDIF

	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX("Not a binary value", 48, "ATFixDbfFpt", 3000)
		#ELSE
			m.lnRetVal = MESSAGEBOX("Not a binary value", 48, "ATFixDbfFpt")
		#ENDIF
	ENDCASE

CASE INT(m.tnMessage) = 108
	DO CASE
	CASE m.tnLang = 1  && FIN
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX(ALLTRIM(STR(m.tcVariable1)) + ;
				" tiedostoa löytynyt. Niiden palauttaminen voi kestää kauan." + CHR(13) + ;
				"Haluatko jatkaa?" + CHR(13) + CHR(13) + ;
				"NOTE: tnRepairMode arvo " + ALLTRIM(STR(m.tcVariable2-3)) + ;
				" on paljon nopeampi!", 292, "Hidas prosessi?", 10000)
		#ELSE
			m.lnRetVal = MESSAGEBOX(ALLTRIM(STR(m.tcVariable1)) + ;
				" tiedostoa löytynyt. Niiden palauttaminen voi kestää kauan." + CHR(13) + ;
				"Haluatko jatkaa?" + CHR(13) + CHR(13) + ;
				"NOTE: tnRepairMode arvo " + ALLTRIM(STR(m.tcVariable2-3)) + ;
				" on paljon nopeampi!", 292, "Hidas prosessi?")
		#ENDIF
	CASE m.tnLang > 1  && ENG
		#IF VAL(ALLTRIM(STRTRAN(UPPER(VERSION()),'VISUAL FOXPRO',''))) > 6
			m.lnRetVal = MESSAGEBOX(ALLTRIM(STR(m.tcVariable1)) + ;
				" records found. It could take a while to repair." + CHR(13) + ;
				"Do you want to continue?" + CHR(13) + CHR(13) + ;
				"NOTE: tnRepairMode value " + ALLTRIM(STR(m.tcVariable2-3)) + ;
				" would be much faster!", 292, "Slow process?", 10000)
		#ELSE
			m.lnRetVal = MESSAGEBOX(ALLTRIM(STR(m.tcVariable1)) + ;
				" records found. It could take a while to repair." + CHR(13) + ;
				"Do you wnat to continue?" + CHR(13) + CHR(13) + ;
				"NOTE: tnRepairMode value " + ALLTRIM(STR(m.tcVariable2-3)) + ;
				" would be much faster!", 292, "Slow process?")
		#ENDIF
	ENDCASE


CASE INT(m.tnMessage) = 109
	DO CASE
	CASE m.tnLang = 1  && FIN
		WAIT WINDOW "Tietue  " + ;
			PADR(ALLTRIM(STR(m.tcVariable1)) + "/" + ALLTRIM(STR(m.tcVariable2)),21," ") ;
			AT WROWS()/2, WCOLS()/2-15 NOWAIT
	CASE m.tnLang > 1  && ENG
		WAIT WINDOW "Reading record  " + ;
			PADR(ALLTRIM(STR(m.tcVariable1)) + "/" + ALLTRIM(STR(m.tcVariable2)),21," ") ;
			AT WROWS()/2, WCOLS()/2-15 NOWAIT
	ENDCASE

CASE INT(m.tnMessage) = 200
	DO CASE
	CASE m.tnLang = 1  && FIN
		WAIT WINDOW "ATFixDbfFpt käyttäjän keskeytys. Korjauksia ei suoritettu." ;
			AT WROWS()/2, WCOLS()/2-25 NOWAIT
	CASE m.tnLang > 1  && ENG
		WAIT WINDOW "ATFixDbfFpt cancelled by the user. No fixing done." ;
			AT WROWS()/2, WCOLS()/2-25 NOWAIT
	ENDCASE

CASE INT(m.tnMessage) = 201
	DO CASE
	CASE m.tnLang = 1  && FIN
		WAIT WINDOW "ATFixDbfFpt keskeytetty virheen takia." ;
			AT WROWS()/2, WCOLS()/2-20 NOWAIT
	CASE m.tnLang > 1  && ENG
		WAIT WINDOW "ATFixDbfFpt cancelled because of an error." ;
			AT WROWS()/2, WCOLS()/2-20 NOWAIT
	ENDCASE

ENDCASE

IF TYPE("m.tnHandler") = "N"
	FCLOSE(m.tnHandler)
ENDIF

RETURN m.lnRetVal


FUNCTION FixExit

LPARAMETERS lnRetVal, lcTmpDbf, lnSelect, tnHandler, tnLang

IF TYPE("m.tnHandler") = "N"
	FCLOSE(m.tnHandler)
ENDIF

IF TYPE("m.lcTmpDbf") = "C" AND ;
		!EMPTY(JUSTSTEM(m.lcTmpDbf))

	IF USED(JUSTSTEM(m.lcTmpDbf))
		USE IN (JUSTSTEM(m.lcTmpDbf))
	ENDIF

	ERASE m.lcTmpDbf+".DBF"
	ERASE m.lcTmpDbf+".FPT"
ENDIF

IF TYPE("m.lnSelect") = "N" AND ;
		M.lnSelect > 0
	SELECT (m.lnSelect)
ENDIF

DO CASE
CASE INLIST(m.lnRetVal, 200, 300, 700)
	FixMessage(200,,, tnLang)
CASE m.lnRetVal < 0
	FixMessage(201,,, tnLang)
ENDCASE

RETURN m.lnRetVal
