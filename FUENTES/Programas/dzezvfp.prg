********************************************************************************
* The code in this module is copyrighted code.                                 *
* Please refer to the DynaZIP 3.0 License Agreement for terms and conditions   *
* regarding its use.                                                           *
*                                                                              *
* Copyright (c) 1996 by Inner Media, Inc                                       *
*                       60 Plain Road                                          *
*                       Hollis, NH 03049                                       *
* All Rights Reserved.                                                         *
********************************************************************************
*       Function: RUN_ZIP(zipfile, itemlist, spandisks)
*       Purpose: create a zip file from a given item list, defaulted to
*                multi-volume option disabled unless otherwise specified.
*       Return: If successful, 0 is return
******************************************************************************
FUNCTION RUN_ZIP

LPARAMETERS tcZipFile, tcItemList, tlSpanDisks

LOCAL lnRegstr_id, lnRetn_code, lnRetn_code1
		
DECLARE INTEGER dZipStart IN c:\dz32\dz_ez32
DECLARE INTEGER SetZipValue IN c:\dz32\dz_ez32 INTEGER id, INTEGER iValue, INTEGER
DECLARE INTEGER GetZipValue IN c:\dz32\dz_ez32 INTEGER id, INTEGER iValue
DECLARE INTEGER SetZipString IN c:\dz32\dz_ez32 INTEGER id, INTEGER, STRING@lpTheString
DECLARE INTEGER GetZipString IN c:\dz32\dz_ez32 INTEGER id, INTEGER, iValue, STRING@lpTheString, INTEGER stringLen
DECLARE INTEGER dZipEasy IN c:\dz32\dz_ez32 INTEGER id
DECLARE INTEGER dZipEnd IN c:\dz32\dz_ez32 INTEGER id

#DEFINE ZIP_ADD      4
#DEFINE MV_USEMULTI  32768

#DEFINE Zip_function 0
#DEFINE Zip_zipfile  1
#DEFINE Zip_itemlist 2
#DEFINE Zip_recurse  4
#DEFINE Zip_quiet    6
#DEFINE Zip_multivol 32


lnRegstr_id = dZipStart()
lnRetn_code = -1

IF	lnRegstr_id <> -1
	lnRetn_code = SetZipValue(lnRegstr_id, Zip_function, ZIP_ADD)
	IF	lnRetn_code <> -1
		IF	tlSpanDisks
			lnRetn_code = SetZipValue(lnRegstr_id, Zip_multivol, MV_USEMULTI)
		ENDIF
	ENDIF
	IF	lnRetn_code <> -1
		lnRetn_code = SetZipValue(lnRegstr_id, Zip_recurse, 1)
	ENDIF
	IF	lnRetn_code <> -1
		lnRetn_code = SetZipString(lnRegstr_id, Zip_zipfile, ALLTRIM(tcZipFile))
	ENDIF
	IF	lnRetn_code <> -1
		lnRetn_code = SetZipString(lnRegstr_id, Zip_itemlist, ALLTRIM(tcItemList))
	ENDIF
	IF	lnRetn_code <> -1
		lnRetn_code = dZipEasy(lnRegstr_id)
	ENDIF
	lnRetn_code1 = dZipEnd(lnRegstr_id)
	IF	lnRetn_code1 = -1
		lnRetn_code = -1
	ENDIF
ENDIF
RETURN(lnRetn_code)

******************************************************************************
*       Function: RUN_UNZIP(zipfile, destination, filespec)
*       Purpose: unzip a zipped file to a given destination
*       Return: If successful, 0 is return
******************************************************************************
FUNCTION RUN_UNZIP
PARAMETERS zipfile, destination, filespec

PRIVATE m.regstr_id, m.retn_code, m.retn_code1

DECLARE INTEGER dunzstart IN c:\dz32\dz_ez32
DECLARE INTEGER setunzvalue IN c:\dz32\dz_ez32 INTEGER id, INTEGER iValue, INTEGER
DECLARE INTEGER getunzvalue IN c:\dz32\dz_ez32 INTEGER id, INTEGER iValue
DECLARE INTEGER setunzstring IN c:\dz32\dz_ez32 INTEGER id, INTEGER, STRING@lpTheString
DECLARE INTEGER getunzstring IN c:\dz32\dz_ez32 INTEGER id, INTEGER, iValue, STRING@lpTheString, INTEGER stringLen
DECLARE INTEGER dunzeasy IN c:\dz32\dz_ez32 INTEGER id
DECLARE INTEGER dunzend IN c:\dz32\dz_ez32 INTEGER id

#DEFINE UNZIP_EXTRACT 8

#DEFINE unz_function    0
#DEFINE unz_zipfile     1
#DEFINE unz_filespec    2
#DEFINE unz_destination 4
#DEFINE unz_overwrite   7

m.regstr_id = dunzstart()
m.retn_code = -1
IF(m.regstr_id <> -1) THEN
  m.retn_code = setunzvalue(m.regstr_id, unz_function, UNZIP_EXTRACT)  
  if(m.retn_code <> -1) THEN
    m.retn_code = setunzstring(m.regstr_id, unz_zipfile, ALLTRIM(zipfile))
  ENDIF
  if(m.retn_code <> -1) THEN
    m.retn_code = setunzstring(m.regstr_id, unz_filespec, ALLTRIM(filespec))
  ENDIF
  if(m.retn_code <> -1) THEN
    m.retn_code = setunzstring(m.regstr_id, unz_destination, ALLTRIM(destination))
  ENDIF
  if(m.retn_code <> -1) THEN
    m.retn_code = setunzvalue(m.regstr_id, unz_overwrite, .F.)
  ENDIF
  if(m.retn_code <> -1) THEN
    m.retn_code = dunzeasy(m.regstr_id)
  ENDIF
  m.retn_code1 = dunzend(m.regstr_id)
  IF(m.retn_code1 = -1) THEN
    m.retn_code = -1
  ENDIF
ENDIF
RETURN(m.retn_code)

* EOF: DZ_EASY.PRG
