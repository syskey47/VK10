*******************************************************************
**
**                     P R I N T 2 P D F
**
*******************************************************************
PROCEDURE Print2PDF
parameters pcFileName, pcReport

*******************************************************************************
* Print2PDF.PRG  Version 1.3
*
* Parms: 	pcReport 				= Name of VFP report to run
*			pcOutputFile 			= Name of finished PDF file to create.
*
* Author:	Paul James (Life-Cycle Technologies, Inc.) mailto:paulj@lifecyc.com
* "Standing on the shoulders of giants", I incorporated the hard work of many
* talented individuals into one program (with my own additions, enhancements, etc.).
* This file is free for anyone to use and distribute.  
* If you plan any commercial distribution, please contact the appropriate people.
*
*
****** MANY THANKS:
* This program is based off the public domain work of:
* Sergey Berezniker		mailto:sergeyb@isgcom.com					(Automating Ghostscript DLLs)
* Bob Lee 				WWW.1amsoftware.com 		(pdfMaker)		(Original version of this program)
* Ed Rauh 				mailto:edrauh@earthlink.net (clsheap.prg)	(Variables for DLLs, etc.)
*
*
****** PURPOSE:
* This program will run a VFP report and output it to a postscript file (temporary filename, temp folder).
* This part of the code uses the Adobe postscript printer driver.
* (It will automatically select the appropriate Postscript printer driver.)
* It will then turn that postscript file into a PDF file (named whatever you want in whatever folder you want).
* This part of the code calls the Ghostscript DLL to turn the postscript file into a PDF.
*
*
****** REQUIREMENTS/SETUP:
*	The "Zip" file this file was included in, contains everything you need to start creating PDF's.
*	Just run the "Demo" program (P2Demo.prg) and it will automatically walk you through installing
*	Ghostscript and the Adobe Postscript driver.  It will then "print" a demo VFP report to a PDF!
*
*
****** COLOR PRINTING:
*	If you want to have "color" in your PDF's, you will need an additional file.
*	 The "Zip" file includes this file.  It is a "Generic Color PostScript" PPD from Adobe.

*	When you are installing the Adobe PostScript driver:
*		In the install dialogue, choose Local Printer.
*		Choose an output port of FILE.
*		When prompted to "Select Printer Model", click the "Browse" button, 
*		locate the file (included with this program) named DEFPSCOL.PPD,
*		Choose the "Generic Color Printer" from the printer list.
*
*	The following web page has excellent additional documentation: 
*		http://www.ep.ph.bham.ac.uk/general/printing/winsetup.html
*
*
****** NOTES:
*	If an Error ocurrs, a .False. return code will be returned, but you should check the .lError property.
*	If .lError is .True., then the .cError property will have text explaining the error.
*
*	Because this is a class, you can either call the Main() method to execute all logic,
*	or you can set the properties yourself and call individual methods as needed (sweet).
*
*
****** EXAMPLE CALLS:
*	1.	*A one line call (nice and neat)
*		loPDF = createobject("Print2PDF", lcMyPDFName, lcMyVFPReport, .t.)
*
*	2.	*This is probably the most typical example.
*		set procedure to Print2PDF.prg additive
*		loPDF = createobject("Print2PDF")
*		if isnull(loPDF)
*			=messagebox("Could not setup PDF class!",48,"Error")
*			return .f.
*		endif
*
*		with loPDF
*			.cINIFile 		= gcCommonPath+"\Print2PDF.ini"
*			.cOutputFile 	= "C:\Output\myfile.pdf"
*			.cReport		= "C:\Myapp\Reports\MyVFPReport.frx"
*			llResult 		= .Main()
*		endwith
*
*		if !llResult or loPDF.lError
*			=messagebox("This error ocurred creating the PDF:"+chr(13)+;
*						alltrim(loPDF.cError),48,"Error Message")
*		endif
*
*	3.	*This example shows manually setting some properties.
*		loPDF = createobject("Print2PDF")
*		loPDF.cReport = "C:\MyApp\Reports\MyVfpReport.frx"
*		loPDF.cOutputFile = "C:\Output\myfile.pdf"
*		loPDF.cPSPrinter = "My PS Printer Name"
*		llResult = loPDF.Main()
*
*	4.	*This example assumes you have created the (.ps) Postscript file yourself and just want to create the PDF.
*		loPDF = createobject("Print2PDF")
*		loPDF.ReadIni()
*		loPDF.cOutputFile = "C:\Output\myfile.pdf"
*		loPDF.cPSFile = "C:\temp\myfile.ps"
*		llResult = loPDF.MakePDF()
*
*
****** OTHER LINKS:
*	If you want to make sure you have a recent copy of the Adobe Generic Postscript printer driver:
*		http://www.adobe.com/support/downloads/detail.jsp?ftpID=1500
*		This link changes periodically, so you might also just try:
*		http://www.adobe.com/support/downloads/product.jsp?product=44&platform=Windows
*
*	Main Ghostscript Web Site:	http://www.ghostscript.com/doc/AFPL/index.htm
*	Licensing Page: http://www.ghostscript.com/doc/cvs/New-user.htm#Find_Ghostscript
*
*
****** GHOSTSCRIPT:
*	Ghostscript does NOT register it's DLL file with Windows, so this code has a function called GSFind()
*	that will try to find the Ghostscript DLL.  Here is what it does:
*	1. See if it is in the VFP Path.
*	2. Grab the location out of the Print2PDF.INI file (if it exists)
*	3. Look in the default installation folder of C:\GS\
*	If the program uses option #3 (my preference) then it will automatically detect the
*	subfolder used to contain the DLL.  Since I am running version 7.04, my
*	folder is "C:\gs\gs7.04\bin\".  The program looks for "C:\GS\GSxxxxx\bin\"
*
*	GhostScript's job (in this class) is to take a "postscript file" (.ps) and turn
*	it into a PDF file (compatible with Adobe 3.x and above).  A "postscript file"
*	is basically a file that contains all of the "printer commands" necessary to
*	print the document, including fonts, pictures, etc.  You could go to a DOS prompt
*	and "copy" a postscript file to your printer port, and it should print the document
*	(providing your printer was Postscript Level 2 capable).  Ghostscript has many other
*	abilities, including converting a PDF back into a postscript file.
*
*	Ghostscript ONLY "prints" what is in the postscript file.  What gets into the
*	postscript file is determined by the "Postscript Printer Driver" that you are
*	using.  If you want COLOR for example, you must use a driver that supports color.
*	Also, because it is setup in Windows like any other 'printer', you can use the
*	Printer Control Panel to change the settings of the driver (cool).
*
*	The "Aladdin Free Public License" (AFPL) version of Ghostscript is "free" as long as
*	it is not a commercial package.
*	The Ghostscript web site has the most recent "publicly released" version.  Also,
*	you can download the actual Source Code for Ghostscript (written in C), and you
*	also get the developer's documentation which describes all parameters, etc.  The
*	parms used here are pretty generally acceptable, but if you need higher resolution,
*	debug messages, printer specific stuff, etc. it's good to have.
*
*	Once you install Ghostscript (usually C:\gs\), you can run it (gswin32.exe)
*	It's main interface is a "command prompt" where you can interactively enter GS commands.
*	You can also enter "devicenames ==" at the GS command prompt to get a current list
*	of all "output devices" currently supported (DEVICE=pdfwrite, DEVICE=laserject, etc.)
*
*	The calls to the Ghostscript DLL interfaces use Ed Rauh's "clsheap.prg" program.  
*	It must be in your VFP path.  It is included in the ZIP file with this code 
*	(thanks Ed), or you can get it from the Universal Thread...
*		http://www.universalthread.com/wconnect/wc.dll?FournierTransformation~2,2,9482
*
*
****** REVISION HISTORY:
*	Version 1.2
*	---------------------------------------------------------------------------------
*	Turned this "thing" into a Class.
*	Added Flags and logic to allow the user to install Postscript on-the-fly.
*	Added Flags and logic to allow the user to install Ghostscript on-the-fly.
*	Added Flags and logic to allow the user to install Adobe Acrobat on-the-fly.
*	Added the ability to read most setting from the .INI file.
*
*	Version 1.3
*	---------------------------------------------------------------------------------
*	Corrected some logic bugs, and bugs in the .ini processing.
*	Changed .ini setting names to be the same as the variable names for clarity**.
*	Added all new properties to .ini file.
*	Added "cStartFolder" property to hold the folder the program is running from.
*	Added "cTempPath" property to hold the folder for storing temporary files.
*	Added support for printing "color" in pdf.
*		Added "lUseColor" to determine color printer use.
*		Added "cColorPrinter" property (and .ini setting) to hold color printer driver.
*	Added "cPrintResolution" so you can change printer resolution on-the-fly.
*	Added the ability to use "dynamic" or "variable" paths in the Install Paths (including this.cStartFolder)
*	Made this file callable as a "procedure".
*	Included Demo program, dbf, report.
*	Included Ghostscript and Postscript installs.
******************************************************************************************************************


*************************************************************************************************
*** The following code allows you to call the Print2PDF class as a Function/Procedure,
*** just pass in the Output Filename and the Report Filename like:
***		Do Print2PDF with "MyPdfFile" "MyVfpReport"
*** If you use Print2PDF as a class, this code NEVER gets hit!
*************************************************************************************************
if vartype(pcFileName) <> "C" or vartype(pcReport) <> "C" or empty(pcFileName) or empty(pcReport)
	=messagebox("No Parms passed to Print2PDF",48,"Error")
	return .f.
endif

local loPDF
loPDF = .NULL.

loPDF = createobject("Print2PDF")

if isnull(loPDF)
	=messagebox("Could not setup PDF class!",48,"Error")
	return .f.
endif

with loPDF
	.cOutputFile 	= pcFileName
	.cReport		= pcReport
	llResult 		= .Main()
endwith

if !llResult or loPDF.lError
	=messagebox("This error ocurred creating the PDF:"+chr(13)+alltrim(loPDF.cError),48,"Error Message")
endif

loPDF = .NULL.
release loPDF

return .t.



**************************************************************************************
** Class Definition :: Print2PDF
**************************************************************************************
define class Print2PDF as relation
	**Please note that any of these properties can be set by you in your code.
	**You can also set most of them by using the .ini file.

	**Set these properties (required)
	cReport			= space(0)	&&Name of VFP report to Run
	cOutputFile		= space(0)	&&Name of finished PDF file to create.

	**User-Definable properties (most of these can be set in the .ini file)
	cStartFolder	= justpath(sys(16))+iif(right(justpath(sys(16)),1)="\","","\")	&&Folder this program started from.
	cTempPath		= space(0)	&&Folder for Temporary Files (default = VFP temp path)
	cExtraRptClauses= space(0)	&&Any extra reporting clauses for the "report form" command
	lReadINI		= .t.		&&Do you want to pull settings out of Print2PDF.ini file?
	cINIFile		= this.cStartFolder+"Print2PDF.ini"	&&Name of INI file to use.  If not in current folder or VFP path, specify full path.
	lFoundPrinter	= .f.		&&Was the PS printer found?
	lFoundGS		= .f.		&&Was Ghostscript found?
	cPSPrinter		= space(0)	&&Name of the Windows Printer that is the Postscript Printer (default = "GENERIC POSTSCRIPT PRINTER")
	cPSColorPrinter	= space(0)	&&Name of the Windows Printer that is the Postscript Printer (default = "GENERIC COLOR POSTSCRIPT")
	lUseColor		= .f.		&&Use "color" printer driver?
	cPrintResolution= space(0)	&&Printer resolution string (300, 600x600, etc.) (default = "300")
	cPSFile			= space(0)	&&Path/Filename for Postscript file (auto-created if not passed)
	lErasePSFile	= .t.		&&Erase the .ps file after conversion?
	cPDFFile		= space(0)	&&Path/Filename for PDF file		(auto-created if not passed)
	cGSFolder		= space(0)	&&Path where Ghostscript DLLs exist	(auto-populated if not passed)


	**Internal properties
	lError			= .f.		&&Indicates that this class had an error.
	cError			= ""		&&Error message generated by this class
	cOrigSafety		= space(0)	&&Original "set safety" settting
	cOrigPrinter	= space(0)	&&Original "Set printer" setting


	**AutoInstall properties	&&See the ReadINI method for more details
	iInstallCount	= 1			&&Number of programs setup for AutoInstallation

	dimension aInstall[1, 7]

	aInstall[1,1] = space(0)	&&Program Identifier (used to find program in array)
	aInstall[1,2] = .t.			&&Can we install this product
	aInstall[1,3] = space(0)	&&Product Name (for user)
	aInstall[1,4] = space(0)	&&Description of product for user
	aInstall[1,5] = space(0)	&&Folder where install files are stored
	aInstall[1,6] = space(0)	&&Setup Executable name
	aInstall[1,7] = space(0)	&&Notes to show user before installing


	**************************************************************************************
	** Class Methods
	**************************************************************************************
	**********************
	** Init Method
	**********************
	function init(pcFileName, pcReport, plRunNow)
		with this
			.cOrigSafety = set("safety")
			.cOrigPrinter = set("Printer", 3)
			
			.cStartFolder = FULLPATH(".")                       && VES Jul 25, 2012
			.cINIFile = ADDBS(.cStartFolder) + "PRINT2PDF.INI"  && VES Jul 25, 2012

			.lError = .f.
			.cError = ""

			if type("pcFileName") = "C" and !empty(pcFileName)
				.cOutputFile = alltrim(pcFileName)
			endif

			if type("pcReport") = "C" and !empty(pcReport)
				.cReport = alltrim(pcReport)
			endif
		endwith

		set safety off

		**Did User pass in parm to autostart the Main method?
		if type("plRunNow") = "L" and plRunNow = .t.
			return this.main()
		endif
	endfunc


	**********************************************************************
	** Cleanup Method
	** 	Make sure all objects are released, etc.
	**********************************************************************
	function CleanUp
		local lcOrigPrinter, lcOrigSafety

		with this
			lcOrigSafety = .cOrigSafety
			lcOrigPrinter = .cOrigPrinter
		endwith

		if !empty(lcOrigSafety)
			set safety &lcOrigSafety
		endif

		if !empty(lcOrigPrinter)
			set printer to
			set printer to name "&lcOrigPrinter"
		endif

		return
	endfunc


	**********************************************************************
	** ResetError Method
	** 	Call this method on each subsequent call to SendFax or CheckLog
	**********************************************************************
	function ResetError
		with this
			.lError = .f.
			.iError = 0
			.cError = ""
		endwith
		return .t.
	endfunc



	**************************************************************************************
	* Main Method - Main code
	*	If you wanted to run each piece seperately, you can make your own calls
	*	to each of the methods called below from within your program and not
	*	call this method at all.  That way, you could execute only the methods you want.
	*	For example, if your postscript file already existed, you could simply set
	*	the properties for the file location, then skip the calls that create the PS file
	*	and go straight to the MakePDF() method.
	**************************************************************************************
	function main(pcFileName, pcReport)
		local x
		store 0 to x
	 	with this
			if type("pcFileName") = "C" and !empty(pcFileName)
				.cOutputFile = alltrim(pcFileName)
			endif

			if type("pcReport") = "C" and !empty(pcReport)
				.cReport = alltrim(pcReport)
			endif

			if empty(.cReport) or empty(.cOutputFile)
				.lError = .t.
				.cError(".cReport and/or .cOutputFile empty",48,"Error")
				return .f.
			endif

			**Get values from Print2Pdf.ini file
			**Also sets default values even if .ini is not used.
			if !.lError
				=.ReadINI()
			endif

			**Set printer to PostScript
			if !.lError
				=.SetPrinter()
			endif

			**Create the Postscript file
			if !.lError
				=.MakePS()
			endif

			**Make sure Ghostscript DLLs can be found
			if !.lError
				=.GSFind()
			endif

			**Turn Postscript into PDF
			if !.lError
				=.MakePDF()
			endif

			**Install PDF Reader
			if !.lError
				=.InstPDFReader()
			endif

			.CleanUp()
		endwith

		return !this.lError
	endfunc



	**************************************************************************************
	* ReadIni()	-	Function to open/read contents of Print2PDF.INI file.
	*			-	If the .ReadINI property is .False., this method will not run
	*			-	This method examines each property, it will not overwrite a property
	*				with a value from the .INI that you have already populated via code.
	**************************************************************************************
	function ReadINI()
		local lcTmp
		store "" to lcTmp

		**If we're not supposed to read the INI, make sure default values are set
		if this.lReadINI = .t.
			**Win API declaration
			declare integer GetPrivateProfileString ;
				in WIN32API ;
				string cSection,;
				string cEntry,;
				string cDefault,;
				string @cRetVal,;
				integer nSize,;
				string cFileName

			**Read INI settings
			with this
				**General Properties
				**Postscript Printer Driver Name
				if empty(.cPSPrinter)
					.cPSPrinter = .ReadIniSetting("PostScript", "cPSPrinter")
				endif

				**Color Postscript Printer Driver Name
				if empty(.cPSColorPrinter)
					.cPSColorPrinter = .ReadIniSetting("PostScript", "cPSColorPrinter")
				endif
		
				**Name of PostScript file
				if empty(.cPSFile)
					.cPSFile = .ReadIniSetting("PostScript", "cPSFile")
				endif

				**Name of folder to hold Temporary postscript files
				if empty(.cTempPath)
					.cTempPath = .ReadIniSetting("PostScript", "cTempPath")
				endif

				**Name of PDF file
				if empty(.cPDFFile)
					.cPDFFile = .ReadIniSetting("GhostScript", "cPDFFile")
				endif

				**Name of Ghostscript folder (where installed to)
				if empty(.cGSFolder)
					.cGSFolder = .ReadIniSetting("GhostScript", "cGSFolder")
				endif

				**Resolution for PDF files
				if empty(.cPrintResolution)
					.cPrintResolution = .ReadIniSetting("PostScript", "cPrintResolution")
				endif

				**Installation Packages
				**# of packages to store settings for
				lcTmp = .ReadIniSetting("Install", "iInstallCount")
				if !empty(lcTmp)
					.iInstallCount = val(lcTmp)

					if .iInstallCount > 1
						dimension .aInstall[.iInstallCount, 7]
					endif

					for x = 1 to .iInstallCount
						**What is the "programmatic" ID for this package
						.aInstall[x,1] = upper(.ReadIniSetting("Install", "cInstID"+transform(x)))

						**Can we install this package?
						lcTmp = upper(.ReadIniSetting("Install", "lAllowInst"+transform(x)))
						.aInstall[x,2] = iif("T" $ lcTmp or "Y" $ lcTmp, .t., .f.)

						**Product Name
						.aInstall[x,3] = .ReadIniSetting("Install", "cInstProduct"+transform(x))

						**Description of Product to show user
						.aInstall[x,4] = .ReadIniSetting("Install", "cInstUserDescr"+transform(x))

						**Folder where installation files exist
						.aInstall[x,5] = .ReadIniSetting("Install", "cInstFolder"+transform(x))

						**Executable file to start installation
						.aInstall[x,6] = .ReadIniSetting("Install", "cInstExe"+transform(x))
						
						**Instructions to User
						.aInstall[x,7] = .ReadIniSetting("Install", "cInstInstr"+transform(x))
					endfor
				endif
			ENDWITH
		ENDIF
		
		**Make sure these basic settings are not blank
		if empty(.cPSPrinter)
			.cPSPrinter	= "GENERIC POSTSCRIPT PRINTER"
		endif
		if empty(.cPSColorPrinter)
			.cPSColorPrinter = "GENERIC COLOR POSTSCRIPT"
		ENDIF
		if empty(.cTempPath)
			.cTempPath = sys(2023) + iif(right(sys(2023),1)="\","","\")
		endif
		if empty(.cPrintResolution)
			.cPrintResolution= "300"
		endif
		return .t.
	endfunc



	**************************************************************************************
	* ReadIniSetting() - Returns the value of a "setting" from an "INI" file (text file)
	*				 	 (returns "" if string is not found)
	*	Parms:	pcSection	= The "section" in the INI file to look in...	[Section Name]
	*			pcSetting	= The "setting" to return the value of			Setting="MySetting"
	**************************************************************************************
	function ReadIniSetting(pcSection, pcSetting)
		local lcRetValue, lnNumRet, lcFile
		
		lcFile = alltrim(this.cIniFile)

		lcRetValue = space(8196)

		**API call to get string
		lnNumRet = GetPrivateProfileString(pcSection, pcSetting, "[MISSING]", @lcRetValue, 8196, lcFile)

		
		lcRetValue = alltrim(substr(lcRetValue, 1, lnNumRet))
		
		if lcRetValue == "[MISSING]"
			lcRetValue = ""
		endif
		
		return lcRetValue
	endfunc



	**************************************************************************************
	* SetPrinter() - Set the printer to the PostScript Printer
	**************************************************************************************
	function SetPrinter()
		local x, lcPrinter
		x = 0
		lcPrinter = ""
		
		with this
			if empty(.cPSPrinter)
				.cPSPrinter = "GENERIC POSTSCRIPT PRINTER"
			endif
			if empty(.cPSColorPrinter)
				.cPSColorPrinter = "GENERIC COLOR POSTSCRIPT"
			endif

			if .lUseColor = .t.
				lcPrinter = .cPSColorPrinter
			else
				lcPrinter = .cPSPrinter
			ENDIF
			lcPrinter = UPPER(lcPrinter) && VES Jul 25, 2012
			
			.lFoundPrinter = .f.

			***Make sure a Postscript printer exists on this PC
			if aprinters(laPrinters) > 0
				for x = 1 to alen(laPrinters)
					if alltrim(upper(laPrinters[x])) == lcPrinter
						.lFoundPrinter = .t.
					endif
				endfor

				if !.lFoundPrinter
					.cError = lcPrinter+" is not installed!!"
					.lError = .t.
				endif
			else
				.cError = "NO printer drivers are installed!!"
				.lError = .t.
			endif

			if .lFoundPrinter
				*** Set the printer to Generic Postscript Printer
				lcEval = "SET PRINTER TO NAME '" +lcPrinter+"'"
				&lcEval

				if alltrim(upper(set("PRINTER",3))) == alltrim(upper(lcPrinter))
				else
					.cError = "Could not set printer to: "+alltrim(lcPrinter)
					.lError = .t.
					.lFoundPrinter = .f.
				endif
			endif

			**Auto-Install, If no PS printer was found.
			if !.lFoundPrinter
				if this.Install("POSTSCRIPT")	&&Install PS driver
					return this.SetPrinter()	&&Call this function again
				endif
			endif
		endwith

		return .lFoundPrinter
	endfunc



	**************************************************************************************
	* MakePS() - Run the VFP report to a PostScript file
	**************************************************************************************
	function MakePS()
		local lcReport, lcExtra, lcPSFile

		set safety off

		with this
			**If no PS printer was found yet, find it
			if !.lFoundPrinter
				if !.SetPrinter()
					return .f.
				endif
			endif

			lcReport	= .cReport
			lcExtra		= .cExtraRptClauses

			if empty(lcReport)
				.cError = "No Report File was specified."
				.lError = .t.
				return .f.
			endif

			if empty(.cPSFile)
				*** We'll create a Postscript Output File (use VFP temporary path and temp filename)
				.cPSFile = .cTempPath + sys(2015) + ".ps"
			endif

			lcPSFile = .cPSFile

			*** Make sure we erase existing file first
			erase (lcPSFile)

			report form (lcReport) &lcExtra noconsole to file &lcPSFile

			if !file(lcPSFile)
				.cError = "Could create PDF file"
				.lError = .t.
				return .f.
			endif
		endwith

		return .t.
	endfunc



	**************************************************************************************
	* GSFind() - Finds the Ghostscript DLL path and adds it to the VFP path
	**************************************************************************************
	function GSFind()
		local x, lcPath
		store "" to lcPath
		store 0 to x

		with this
			.lFoundGS = .f.

			**Look for Ghostscript DLL files.  If not in the VFP path, then GSFind().
			if file("gsdll32.dll")
				.lFoundGS = .t.
				return .t.
			endif

			**Try location specified in INI file
			if !empty(.cGSFolder)
				lcTmp = .cGSFolder + "gsdll32.dll"			&&Make sure the DLL file can be found
				if !file(lcTmp)
					.cGSFolder = ""
				endif
			endif

			*Look for them to exist in C:\gs\gsX.XX\bin\
			if empty(.cGSFolder)
				if !directory("C:\gs")
					return .f.
				endif

				liGS = adir(laGSFolders, "C:\gs\*.*","D")
				if liGS < 1
					return .f.
				endif

				for x = 1 to alen(laGSFolders,1)
					lcTmp = alltrim(upper(laGSFolders[x,1]))
					if "GS" = left(lcTmp,2) and "D" $ laGSFolders[x,5]
						.cGSFolder = lcTmp
						exit
					endif
				endfor

				if empty(.cGSFolder)
					return .f.
				endif

				.cGSFolder = "c:\gs\"+alltrim(.cGSFolder)+"\bin\"
			endif

			if !empty(.cGSFolder)
				lcTmp = .cGSFolder + "gsdll32.dll"			&&Make sure the DLL file can be found
				if !file(lcTmp)
					.cGSFolder = ""
				endif
			endif

			if empty(.cGSFolder)
				return .f.
			else
				.lFoundGS = .t.
			endif
		endwith

		lcPath = alltrim(set("Path"))
		set path to lcPath + ";" + .cGSFolder

		return .t.
	endfunc




	**************************************************************************************
	* MakePDF() - Run Ghostscript to create PDF file from the Postscript file
	**************************************************************************************
	function MakePDF()
		local lcPDFFile, lcOutputFile, lcPSFile

		set safety off

		with this
			**Make sure Ghostscript DLLs have been found (or install them)
			if !.lFoundGS
				if !.GSFind()

					**Auto-Install, Ghostscript
					if .Install("GHOSTSCRIPT")
						if !.GSFind()	&&Call function again
							.cError = "Could not Install Ghostscript!"
							.lError = .t.
							return .f.
						endif
					endif
				endif
			endif

			lcOutputFile	= .cOutputFile
			lcPSFile		= .cPSFile

			if empty(.cPDFFile)
				.cPDFFile = juststem(lcPSFile) + ".pdf"
			endif

			lcPDFFile = .cPDFFile
			erase (lcPDFFile)

			if !.GSConvertFile(lcPSFile, lcPDFFile)
				.cError = "Could not create: "+lcPDFFile
				.lError = .t.
			endif

			if !file(lcPDFFile)
				.cError = "Could not create: "+lcPDFFile
				.lError = .t.
			endif

			**Get rid of .ps file
			if .lErasePSFile
				erase (lcPSFile)
			endif

			**Make sure output file does not exist already
			erase (lcOutputFile)

			*** Move the temp file to the actual file name by renaming
			rename (lcPDFFile) to (lcOutputFile)

			if !file(lcOutputFile)
				.cError = "Could not rename file to "+lcOutputFile
				.lError = .t.
			endif
		endwith
		return !this.lError
	endfunc



	**************************************************************************************
	* GSConvert() - Sets up arguments that will be passed to Ghostscript DLL, calls GSCall
	**************************************************************************************
	function GSConvertFile(tcFileIn, tcFileOut)
		local lnGSInstanceHandle, lnCallerHandle, loHeap, lnElementCount, lcPtrArgs, lnCounter, lnReturn
		dimension  laArgs[11]

		store 0 to lnGSInstanceHandle, lnCallerHandle, lnElementCount, lnCounter, lnReturn
		store null to loHeap
		store "" to lcPtrArgs

		set safety off
		loHeap = createobject('Heap')

		**Declare Ghostscript DLLs
		
		** VES Jul 25 2012
		** Se comento este codigo porque en VFP6 el CLEAR DLLS no acepta
		** parametros adicionales, causando que se eliminaran todas las
		** declaraciones API existentes
		**
		**clear dlls "gsapi_new_instance", "gsapi_delete_instance", "gsapi_init_with_args", "gsapi_exit"

		declare long gsapi_new_instance in gsdll32.dll ;
			long @lngGSInstance, long lngCallerHandle
		declare long gsapi_delete_instance in gsdll32.dll ;
			long lngGSInstance
		declare long gsapi_init_with_args in gsdll32.dll ;
			long lngGSInstance, long lngArgumentCount, ;
			long lngArguments
		declare long gsapi_exit in gsdll32.dll ;
			long lngGSInstance

		laArgs[1] = "dummy" 			&&You could specify a text file here with commands in it (NOT USED)
		laArgs[2] = "-dNOPAUSE"			&&Disables Prompt and Pause after each page
		laArgs[3] = "-dBATCH"			&&Causes GS to exit after processing file(s)
		laArgs[4] = "-dSAFER"			&&Disables the ability to deletefile and renamefile externally
		laArgs[5] = "-r"+this.cPrintResolution	&&Printer Resolution (300x300, 360x180, 600x600, etc.)
		laArgs[6] = "-sDEVICE=pdfwrite"	&&Specifies which "Device" (output type) to use.  "pdfwrite" means PDF file.
		laArgs[7] = "-sOutputFile=" + tcFileOut	&&Name of the output file
		laArgs[8] = "-c"				&&Interprets arguments as PostScript code up to the next argument that begins with "-" followed by a non-digit, or with "@". For example, if the file quit.ps contains just the word "quit", then -c quit on the command line is equivalent to quit.ps there. Each argument must be exactly one token, as defined by the token operator
		laArgs[9] = ".setpdfwrite"		&&If this file exists, it uses it as command-line input?
		laArgs[10] = "-f"				&&(ends the -c argument started in laArgs[8])
		laArgs[11] = tcFileIn			&&Input File name (.ps file)

		* Load Ghostscript and get the instance handle
		lnReturn = gsapi_new_instance(@lnGSInstanceHandle, @lnCallerHandle)
		if (lnReturn < 0)
			loHeap = null
			RELEASE loHeap
			this.lError = .t.
			this.cError = "Could not start Ghostscript."
			return .f.
		endif

		* Convert the strings to null terminated ANSI byte arrays
		* then get pointers to the byte arrays.
		lnElementCount = alen(laArgs)
		lcPtrArgs = ""
		for lnCounter = 1 to lnElementCount
			lcPtrArgs = lcPtrArgs + NumToLONG(loHeap.AllocString(laArgs[lnCounter]))
		endfor
		lnPtr = loHeap.AllocBlob(lcPtrArgs)

		lnReturn = gsapi_init_with_args(lnGSInstanceHandle, lnElementCount, lnPtr)
		if (lnReturn < 0)
			loHeap = null
			RELEASE loHeap
			this.lError = .t.
			this.cError = "Could not Initilize Ghostscript."
			return .f.
		endif

		* Stop the Ghostscript interpreter
		lnReturn=gsapi_exit(lnGSInstanceHandle)
		if (lnReturn < 0)
			loHeap = null
			RELEASE loHeap
			this.lError = .t.
			this.cError = "Could not Exit Ghostscript."
			return .f.
		endif


		* release the Ghostscript instance handle'
		=gsapi_delete_instance(lnGSInstanceHandle)

		loHeap = null
		RELEASE loHeap

		if !file(tcFileOut)
			this.lError = .t.
			this.cError = "Ghostscript could not create the PDF."
			return .f.
		endif

		return .t.
	endfunc



	**************************************************************************************
	* InstPDFReader Method - Installs the PDFReader if needed
	**************************************************************************************
	function InstPDFReader()
		**Make sure the PDF file has been created
		if !file(.cOutputFile)
			return .f.
		endif

		**Ask Windows which EXE is associated with this file (extension)
		lcExe = .AssocExe(.cOutputFile)

		if empty(lcExe)
			**Install the PDF Reader
			return .Install("PDFREADER")
		else
			return .t.
		endif
	endfunc


	**************************************************************************************
	* AssocExe Method - Returns the Executable File associated with a file
	**************************************************************************************
	function AssocExe(pcFile)
		local lcExeFile
		store "" to lcExeFile

		declare integer FindExecutable in shell32;
			string   lpFile,;
			string   lpDirectory,;
			string @ lpResult

		lcExeFile = space(250)

		if FindExecutable(pcFile, "", @lcExeFile) > 32
			lcExeFile = left(lcExeFile, at(chr(0), lcExeFile) -1)
		else
			lcExeFile = ""
		endif

		return lcExeFile
	endfunc


	**************************************************************************************
	* Install Method - Installs software on the PC
	**************************************************************************************
	function Install(pcID)
		local llFound, x, lcEval, lcProduct, lcDesc, lcTmp, ;
				lcFolder, lcInstEXE, lcInstruct, llDynaPath
		store "" to lcEval, lcProduct, lcAbbr, lcDesc, lcTmp, lcFolder, lcInstEXE, lcInstruct
		store .f. to llFound, llDynaPath

		with this
			pcID = alltrim(upper(pcID))

			**See if this Installation ID is in our array
			for x = 1 to alen(.aInstall,1)
				if alltrim(upper(.aInstall[x,1])) == pcID
					llFound = .t.
					exit
				endif
			endfor

			if !llFound
				.lError = .t.
				.cError = "Installation parms do not exist for ID: "+pcID
				return .f.
			endif

			**Copy array contents to variables
			llDoInst	= .aInstall[x,2]
			lcProduct	= .aInstall[x,3]
			lcDesc		= .aInstall[x,4]
			lcFolder	= .aInstall[x,5]
			lcInstEXE	= .aInstall[x,6]
			if !empty(.aInstall[x,7])
				lcInstruct	= ALLTRIM(.aInstall[x,7])
				if "+" $ lcInstruct
					lcInstruct = &lcInstruct
				endif
			else
				lcInstruct	= "Please accept the 'Default Values'"+chr(13)+"during the installation."
			endif

			**See if the path is "dynamically" generated based on variables
			if "+" $ lcFolder
				llDynaPath = .t.
			else
				llDynaPath = .f.
			endif
			
			**Are we allowed to install this product?
			if llDoInst = .t.
				**Make sure we have the Folder and Executable to install from?
				if !empty(lcFolder) and !empty(lcInstEXE)
					if llDynaPath
						lcFolder = alltrim(lcFolder)
						lcEval = &lcFolder
						lcEval = lcEval+alltrim(lcInstEXE)	&&command string
					else
						if right(lcFolder,1) <> "\"				&&Make sure the final backslash exists
							lcFolder = lcFolder + "\"
						endif
				
						lcEval = alltrim(lcFolder)+alltrim(lcInstEXE)	&&command string
					endif

					**Make sure install .exe exists in the path given
					if !llDynaPath and !file(lcEval)
						.cError = "Could not find installer for "+lcProduct+" in:"+chr(13)+alltrim(lcEval)
						.lError = .t.
					else
						if 7=messagebox(lcProduct+" needs to be installed on your computer."+chr(13)+;
								lcDesc+chr(13)+;
								"Is it OK to install now?",36,"Confirmation")
							.lError = .t.
							.cError = "User cancelled "+lcProduct+" Installation."
							return .f.
						endif

						=messagebox(lcInstruct,64,"Instructions")

						**Do the Installation
						.aInstall[x,2] = .f.		&&Do not allow ourselves to get into a loop
						lcEval = "run /n "+lcEval
						&lcEval

						=messagebox("When the Installation has finished"+chr(13)+;
							"COMPLETELY, please click OK...",64,"Waiting for Installation...")

						**Did it work?
						if 7=messagebox("Was the installation successfull?"+chr(13)+chr(13)+;
								"If no errors ocurred during the Installation"+chr(13)+;
								"and everything went OK, please click 'Yes'...",36,"Everything OK?")
							.lError = .t.
							.cError = "Errors ocurred during "+lcProduct+" Installation."
							return .f.
						else
							.lError = .f.
							.cError = ""
							return .t.
						endif
					endif
				endif
			endif
		endwith
		return .f.
	endfunc

enddefine

*** End of Class Print2PDF ***




**************************************************
*-- Class:        heap 
*-- ParentClass:  custom
*-- BaseClass:    custom
*
*  Another in the family of relatively undocumented sample classes I've inflicted on others
*  Warning - there's no error handling in here, so be careful to check for null returns and
*  invalid pointers.  Unless you get frisky, or you're resource-tight, it should work well.
*
*	Please read the code and comments carefully.  I've tried not to assume much knowledge about
*	just how pointers work, or how memory allocation works, and have tried to explain some of the
*	basic concepts behing memory allocation in the Win32 environment, without having gone into
*	any real details on x86 memory management or the Win32 memory model.  If you want to explore
*	these things (and you should), start by reading Jeff Richter's _Advanced Windows_, especially
*	Chapters 4-6, which deal with the Win32 memory model and virtual memory -really- well.
*
*	Another good source iss Walter Oney's _Systems Programming for Windows 95_.  Be warned that 
*	both of these books are targeted at the C programmer;  to someone who has only worked with
*	languages like VFP or VB, it's tough going the first couple of dozen reads.
*
*	Online resources - http://www.x86.org is the Intel Secrets Homepage.  Lots of deep, dark
*	stuff about the x86 architecture.  Not for the faint of heart.  Lots of pointers to articles
*	from DDJ (Doctor Dobbs Journal, one of the oldest and best magazines on microcomputing.)
*
*   You also might want to take a look at the transcripts from my "Pointers on Pointers" chat
*   sessions, which are available in the WednesdayNightLectureSeries topic on the Fox Wiki,
*   http://fox.wikis.com - the Wiki is a great Web site;  it provides a vast store of information
*   on VFP and related topics, and is probably the best tool available now to develop topics in
*   a collaborative environment.  Well worth checking out - it's a very different mechanism for
*   ongoing discussion of a subject.  It's an on-line message base or chat;  I find
*   myself hitting it when I have a question to see if an answer already exists.  It's
*   much like using a FAQ, except that most things on the Wiki are editable...
*
*	Post-DevCon 2000 revisions:
*
*	After some bizarre errors at DevCon, I reworked some of the methods to
*	consistently return a NULL whenever a bad pointer/inactive pointer in the
*	iaAllocs member array was encountered.  I also implemented NumToLong
*	using RtlMoveMemory(), relying on a BITOR() to recast what would otherwise
*	be a value with the high-order bit set.  The result is it's faster, and
*  an anomaly reported with values between 0xFFFFFFF1-0xFFFFFFFF goes away,
*	at the expense of representing these as negative numbers.  Pointer math
*	still works.
*
*****
*	How HEAP works:
*
*	Overwhelming guilt hit early this morning;  maybe I should explain the 
*	concept of the Heap class	and give an example of how to use it, in 
*	conjunction with the add-on functions that follow in this proc library.
*
*	Windows allocates memory from several places;  it also provides a 
*	way to define your own small corner of the universe where you can 
*	allocate and deallocate blocks of memory for your own purposes.  These
*	public or private memory areas are referred to commonly as heaps.
*
*	VFP is great in most cases;  it provides flexible allocation and 
*	alteration of variables on the fly in a program.  You don't need to 
*	know much about how things are represented internally. This makes 
*	most programming tasks easy.  However, in exchange for VFP's flexibility 
*	in memory variable allocation, we give up several things, the most 
*	annoying of which are not knowing the exact location of a VFP 
*	variable in memory, and not knowing exactly how things are constructed 
*	inside a variable, both of which make it hard to define new kinds of 
*	memory structures within VFP to manipulate as a C-style structure.
*
*	Enter Heap.  Heap creates a growable, private heap, from which you 
*	can allocate blocks of memory that have a known location and size 
*	in your memory address space.  It also provides a way of transferring
*	data to and from these allocated blocks.  You build structures in VFP 
*	strings, and parse the content of what is returned in those blocks by 
*	extracting substrings from VFP strings.
*
*	Heap does its work using a number of Win32 API functions;  HeapCreate(), 
*	which sets up a private heap and assigns it a handle, is invoked in 
*	the Init method.  This sets up the 'heap', where block allocations
*	for the object will be constructed.  I set up the heap to use a base 
*	allocation size of twice the size of a swap file 'page' in the x86 
*	world (8K), and made the heap able to grow;  it adds 8K chunks of memory
*	to itself as it grows.  There's no fixed limit (other than available 
*	-virtual- memory) on the size of the heap constructed;  just realize 
*	that huge allocations are likely to bump heads with VFP's own desire
*	for mondo RAM.
*
*	Once the Heap is established, we can allocate blocks of any size we 
*	want in Heap, outside of VFP's memory, but within the virtual 
*	address space owned by VFP.  Blocks are allocated by HeapAlloc(), and a
*	pointer to the block is returned as an integer.  
*
*	KEEP THE POINTER RETURNED BY ANY Alloc method, it's the key to 
*	doing things with the block in the future.  In addition to being a
*	valid pinter, it's the key to finding allocations tracked in iaAllocs[]
*
*	Periodically, we need to load things into the block we've created.  
*	Thanks to work done by Christof Lange, George Tasker and others, 
*	we found a Win32API call that will do transfers between memory 
*	locations, called RtlMoveMemory().  RtlMoveMemory() acts like the 
*	Win32API MoveMemory() call;  it takes two pointers (destination 
*	and source) and a length.  In order to make life easy, at times 
*	we DECLARE the pointers as INTEGER (we pass a number, which is 
*	treated as a DWORD (32 bit unsigned integer) whose content is the
*	address to use), and at other times as STRING @, which passes the 
*	physical address of a VFP string variable's contents, allowing 
*	RtlMoveMemory() to read and write VFP strings without knowing how 
*	to manipulate VFP's internal variable structures.  RtlMoveMemory() 
*	is used by both the CopyFrom and CopyTo methods, and the enhanced
*	Alloc methods.
*
*	At some point, we're finished with a block of memory.  We can free up 
*	that memory via HeapFree(), which releases a previously-allocated 
*	block on the heap.  It does not compact or rearrange the heap allocations
*	but simply makes the memory allocated no longer valid, and the 
*	address could be reused by another Alloc operation.  We track the 
*	active state of allocations in a member array iaAllocs[] which has 
*	3 members per row;  the pointer, which is used as a key, the actual 
*	size of the allocation (sometimes HeapAlloc() gives you a larger block 
*	than requested;  we can see it here.  This is the property returned 
*	by the SizeOfBlock method) and whether or not it's active and available.
*
*	When we're done with a Heap, we need to release the allocations and 
*	the heap itself.  HeapDestroy() releases the entire heap back to the 
*	Windows memory pool.  This is invoked in the Destroy method of the 
*	class to ensure that it gets explcitly released, since it remains alive 
*	until it is explicitly released or the owning process is released.  I 
*	put this in the Destroy method to ensure that the heap went away when 
*	the Heap object went out of scope.
*
*	The original class methods are:
*
*		Init					Creates the heap for use
*		Alloc(nSize)		Allocates a block of nSize bytes, returns an nPtr 
*								to it.  nPtr is NULL if fail
*		DeAlloc(nPtr)		Releases the block whose base address is nPtr.  
*								Returns .T./.F.
*		CopyTo(nPtr,cSrc)	Copies the Content of cSrc to the buffer at nPtr, 
*								up to the smaller of LEN(cSrc) or the length of 
*								the block (we look in the iaAllocs[] array).  
*								Returns .T./.F.
*		CopyFrom(nPtr)		Copies the content of the block at nPtr (size is 
*								from iaAllocs[]) and returns it as a VFP string.  
*								Returns a string, or NULL if fail
*		SizeOfBlock(nPtr)	Returns the actual allocated size of the block 
*								pointed to by nPtr.  Returns NULL if fail 
*		Destroy()			DeAllocs anything still active, and then frees 
*								the heap.
*****
*  New methods added 2/12/99 EMR -	Attack of the Creeping Feature Creature, 
*												part I
*
*	There are too many times when you know what you want to put in 
*	a buffer when you allocate it, so why not pass what you want in 
*	the buffer when you allocate it?  And we may as well add an option to
*	init the memory to a known value easily, too:
*
*		AllocBLOB(cSrc)	Allocate a block of SizeOf(cSrc) bytes and 
*								copy cSrc content to it
*		AllocString(cSrc)	Allocate a block of SizeOf(cSrc) + 1 bytes and 
*								copy cSrc content to it, adding a null (CHR(0)) 
*								to the end to make it a standard C-style string
*		AllocInitAs(nSize,nVal)
*								Allocate a block of nSize bytes, preinitialized 
*								with CHR(nVal).  If no nVal is passed, or nVal 
*								is illegal (not a number 0-255), init with nulls
*
*****
*	Property changes 9/29/2000
*
*	iaAllocs[] is now protected
*
*****
*	Method modifications 9/29/2000:
*
*	All lookups in iaAllocs[] are now done using the new FindAllocID()
*	method, which returns a NULL for the ID if not found active in the
*	iaAllocs[] entries.  Result is less code and more consistent error
*	handling, based on checking ISNULL() for pointers.
*
*****
*	The ancillary goodies in the procedure library are there to make life 
*	easier for people working with structures; they are not optimal 
*	and infinitely complete, but they do the things that are commonly 
*	needed when dealing with stuff in structures.  The functions are of 
*	two types;  converters, which convert standard C structures to an
*	equivalent VFP numeric, or make a string whose value is equivalent 
*	to a C data type from a number, so that you can embed integers, 
*	pointers, etc. in the strings used to assemble a structure which you 
*	load up with CopyTo, or pull out pointers and integers that come back 
*	embedded in a structure you've grabbed with CopyFrom.
*
*	The second type of functions provided are memory copiers.  The 
*	CopyFrom and CopyTo methods are set up to work with our heap, 
*	and nPtrs must take on the values of block addresses grabbed 
*	from our heap.  There will be lots of times where you need to 
*	get the content of memory not necessarily on our heap, so 
*	SetMem, GetMem and GetMemString go to work for us here.  SetMem 
*	copies the content of a string into the absolute memory block
*	at nPtr, for the length of the string, using RtlMoveMemory(). 
*	BE AWARE THAT MISUSE CAN (and most likely will) RESULT IN 
*	0xC0000005 ERRORS, memory access violations, or similar OPERATING 
*	SYSTEM level errors that will smash VFP like an empty beer can in 
*	a trash compactor.
*
*	There are two functions to copy things from a known address back 
*	to the VFP world.  If you know the size of the block to grab, 
*	GetMem(nPtr,nSize) will copy nSize bytes from the address nPtr 
*	and return it as a VFP string.  See the caveat above.  
*	GetMemString(nPtr) uses a different API call, lstrcpyn(), to 
*	copy a null terminated string from the address specified by nPtr. 
*	You can hurt yourself with this one, too.
*
*	Functions in the procedure library not a part of the class:
*
*	GetMem(nPtr,nSize)	Copy nSize bytes at address nPtr into a VFP string
*	SetMem(nPtr,cSource)	Copy the string in cSource to the block beginning 
*								at nPtr
*	GetMemString(nPtr)	Get the null-terminated string (up to 512 bytes) 
*								from the address at nPtr
*
*	DWORDToNum(cString)	Convert the first 4 bytes of cString as a DWORD 
*								to a VFP numeric (0 to 2^32)
*	SHORTToNum(cString)	Convert the first 2 bytes of cString as a SHORT 
*								to a VFP numeric (-32768 to 32767)
*	WORDToNum(cString)	Convert the first 2 bytes of cString as a WORD 
*								to a VFP numeric  (0 to 65535)
*	NumToDWORD(nInteger)	Converts nInteger into a string equivalent to a 
*								C DWORD (4 byte unsigned)
*	NumToWORD(nInteger)	Converts nInteger into a string equivalent to a 
*								C WORD (2 byte unsigned)
*	NumToSHORT(nInteger)	Converts nInteger into a string equivalent to a 
*								C SHORT ( 2 byte signed)
*
******
*	New external functions added 2/13/99
*
*	I see a need to handle NetAPIBuffers, which are used to transfer 
*	structures for some of the Net family of API calls;  their memory 
*	isn't on a user-controlled heap, but is mapped into the current 
*	application address space in a special way.  I've added two 
*	functions to manage them, but you're responsible for releasing 
*	them yourself.  I could implement a class, but in many cases, a 
*	call to the API actually performs the allocation for you.  The 
*	two new calls are:
*
*	AllocNetAPIBuffer(nSize)	Allocates a NetAPIBuffer of at least 
*										nBytes, and returns a pointer
*										to it as an integer.  A NULL is returned 
*										if allocation fails.
*	DeAllocNetAPIBuffer(nPtr)	Frees the NetAPIBuffer allocated at the 
*										address specified by nPtr.  It returns 
*										.T./.F. for success and failure
*
*	These functions are only available under NT, and will return 
*	NULL or .F. under Win9x
*
*****
*	Function changes 9/29/2000
*
*	NumToDWORD(tnNum)		Redirected to NumToLONG()
*	NumToLONG(tnNum)		Generates a 32 bit LONG from the VFP number, recast
*								using BITOR() as needed
*	LONGToNum(tcLong)		Extracts a signed VFP INTEGER from a 4 byte string
*
*****
*	That's it for the docs to date;  more stuff to come.  The code below 
*	is copyright Ed Rauh, 1999;  you may use it without royalties in 
*	your own code as you see fit, as long as the code is attributed to me.
*
*	This is provided as-is, with no implied warranty.  Be aware that you 
*	can hurt yourself with this code, most *	easily when using the 
*	SetMem(), GetMem() and GetMemString() functions.  I will continue to 
*	add features and functions to this periodically.  If you find a bug, 
*	please notify me.  It does no good to tell me that "It doesn't work 
*	the way I think it should..WAAAAH!"  I need to know exactly how things 
*	fail to work with the code I supplied.  A small code snippet that can 
*	be used to test the failure would be most helpful in trying
*	to track down miscues.  I'm not going to run through hundreds or 
*	thousands of lines of code to try to track down where exactly 
*	something broke.  
*
*	Please post questions regarding this code on Universal Thread;  I go out 
*	there regularly and will generally respond to questions posed in the
*	message base promptly (not the Chat).  http://www.universalthread.com
*	In addition to me, there are other API experts who frequent UT, and 
*	they may well be able to help, in many cases better than I could.  
*	Posting questions on UT helps not only with getting support
*	from the VFP community at large, it also makes the information about 
*	the problem and its solution available to others who might have the 
*	same or similar problems.
*
*	Other than by UT, especially if you have to send files to help 
*	diagnose the problem, send them to me at edrauh@earthlink.net or 
*	erauh@snet.net, preferably the earthlink.net account.
*
*	If you have questions about this code, you can ask.  If you have 
*	questions about using it with API calls and the like, you can ask.  
*	If you have enhancements that you'd like to see added to the code, 
*	you can ask, but you have the source, and ought to add them yourself.
*	Flames will be ignored.  I'll try to answer promptly, but realize 
*	that support and enhancements for this are done in my own spare time.  
*	If you need specific support that goes beyond what I feel is 
*	reasonable, I'll tell you.
*
*	Do not call me at home or work for support.  Period. 
*	<Mumble><something about ripping out internal organs><Grr>
*
*	Feel free to modify this code to fit your specific needs.  Since 
*	I'm not providing any warranty with this in any case, if you change 
*	it and it breaks, you own both pieces.
*
DEFINE CLASS heap AS custom


	PROTECTED inHandle, inNumAllocsActive,iaAllocs[1,3]
	inHandle = NULL
	inNumAllocsActive = 0
	iaAllocs = NULL
	Name = "heap"

	PROCEDURE Alloc
		*  Allocate a block, returning a pointer to it
		LPARAMETER nSize
		DECLARE INTEGER HeapAlloc IN WIN32API AS HAlloc;
			INTEGER hHeap, ;
			INTEGER dwFlags, ;
			INTEGER dwBytes
		DECLARE INTEGER HeapSize IN WIN32API AS HSize ;
			INTEGER hHeap, ;
			INTEGER dwFlags, ;
			INTEGER lpcMem
		LOCAL nPtr
		WITH this
			nPtr = HAlloc(.inHandle, 0, @nSize)
			IF nPtr # 0
				*  Bump the allocation array
				.inNumAllocsActive = .inNumAllocsActive + 1
				DIMENSION .iaAllocs[.inNumAllocsActive,3]
				*  Pointer
				.iaAllocs[.inNumAllocsActive,1] = nPtr
				*  Size actually allocated - get with HeapSize()
				.iaAllocs[.inNumAllocsActive,2] = HSize(.inHandle, 0, nPtr)
				*  It's alive...alive I tell you!
				.iaAllocs[.inNumAllocsActive,3] = .T.
			ELSE
				*  HeapAlloc() failed - return a NULL for the pointer
				nPtr = NULL
			ENDIF
		ENDWITH
		RETURN nPtr
	ENDPROC

*	new methods added 2/11-2/12;  pretty simple, actually, but they make 
*	coding using the heap object much cleaner.  In case it isn't clear, 
*	what I refer to as a BString is just the normal view of a VFP string 
*	variable;  it's any array of char with an explicit length, as opposed 
*	to the normal CString view of the world, which has an explicit
*	terminator (the null char at the end.)

	FUNCTION AllocBLOB
		*	Allocate a block of memory the size of the BString passed.  The 
		*	allocation will be at least LEN(cBStringToCopy) off the heap.
		LPARAMETER cBStringToCopy
		LOCAL nAllocPtr
		WITH this
			nAllocPtr = .Alloc(LEN(cBStringToCopy))
			IF ! ISNULL(nAllocPtr)
				.CopyTo(nAllocPtr,cBStringToCopy)
			ENDIF
		ENDWITH
		RETURN nAllocPtr
	ENDFUNC
	
	FUNCTION AllocString
		*	Allocate a block of memory to fill with a null-terminated string
		*	make a null-terminated string by appending CHR(0) to the end
		*	Note - I don't check if a null character precedes the end of the
		*	inbound string, so if there's an embedded null and whatever is
		*	using the block works with CStrings, it might bite you.
		LPARAMETER cString
		RETURN this.AllocBLOB(cString + CHR(0))
	ENDFUNC
	
	FUNCTION AllocInitAs
		*  Allocate a block of memory preinitialized to CHR(nByteValue)
		LPARAMETER nSizeOfBuffer, nByteValue
		IF TYPE('nByteValue') # 'N' OR ! BETWEEN(nByteValue,0,255)
			*	Default to initialize with nulls
			nByteValue = 0
		ENDIF
		RETURN this.AllocBLOB(REPLICATE(CHR(nByteValue),nSizeOfBuffer))
	ENDFUNC

*	This is the end of the new methods added 2/12/99

	PROCEDURE DeAlloc
		*  Discard a previous Allocated block
		LPARAMETER nPtr
		DECLARE INTEGER HeapFree IN WIN32API AS HFree ;
			INTEGER hHeap, ;
			INTEGER dwFlags, ;
			INTEGER lpMem
		LOCAL nCtr
		* Change to use .FindAllocID() and return !ISNULL() 9/29/2000 EMR
		nCtr = NULL
		WITH this
			nCtr = .FindAllocID(nPtr)
			IF ! ISNULL(nCtr)
				=HFree(.inHandle, 0, nPtr)
				.iaAllocs[nCtr,3] = .F.
			ENDIF
		ENDWITH
		RETURN ! ISNULL(nCtr)
	ENDPROC


	PROCEDURE CopyTo
		*  Copy a VFP string into a block
		LPARAMETER nPtr, cSource
		*  ReDECLARE RtlMoveMemory to make copy parameters easy
		DECLARE RtlMoveMemory IN WIN32API AS RtlCopy ;
			INTEGER nDestBuffer, ;
			STRING @pVoidSource, ;
			INTEGER nLength
		LOCAL nCtr
		nCtr = NULL
		* Change to use .FindAllocID() and return ! ISNULL() 9/29/2000 EMR
		IF TYPE('nPtr') = 'N' AND TYPE('cSource') $ 'CM' ;
		   AND ! (ISNULL(nPtr) OR ISNULL(cSource))
			WITH this
				*  Find the Allocation pointed to by nPtr
				nCtr = .FindAllocID(nPtr)
				IF ! ISNULL(nCtr)
					*  Copy the smaller of the buffer size or the source string
					=RtlCopy((.iaAllocs[nCtr,1]), ;
							cSource, ;
							MIN(LEN(cSource),.iaAllocs[nCtr,2]))
				ENDIF
			ENDWITH
		ENDIF
		RETURN ! ISNULL(nCtr)
	ENDPROC


	PROCEDURE CopyFrom
		*  Copy the content of a buffer back to the VFP world
		LPARAMETER nPtr
		*  Note that we reDECLARE RtlMoveMemory to make passing things easier
		DECLARE RtlMoveMemory IN WIN32API AS RtlCopy ;
			STRING @DestBuffer, ;
			INTEGER pVoidSource, ;
			INTEGER nLength
		LOCAL nCtr, uBuffer
		uBuffer = NULL
		nCtr = NULL
		* Change to use .FindAllocID() and return NULL 9/29/2000 EMR
		IF TYPE('nPtr') = 'N' AND ! ISNULL(nPtr)
			WITH this
				*  Find the allocation whose address is nPtr
				nCtr = .FindAllocID(nPtr)
				IF ! ISNULL(nCtr)
					* Allocate a buffer in VFP big enough to receive the block
					uBuffer = REPL(CHR(0),.iaAllocs[nCtr,2])
					=RtlCopy(@uBuffer, ;
							(.iaAllocs[nCtr,1]), ;
							(.iaAllocs[nCtr,2]))
				ENDIF
			ENDWITH
		ENDIF
		RETURN uBuffer
	ENDPROC
	
	PROTECTED FUNCTION FindAllocID
	 	*   Search for iaAllocs entry matching the pointer
	 	*   passed to the function.  If found, it returns the 
	 	*   element ID;  returns NULL if not found
	 	LPARAMETER nPtr
	 	LOCAL nCtr
	 	WITH this
			FOR nCtr = 1 TO .inNumAllocsActive
				IF .iaAllocs[nCtr,1] = nPtr AND .iaAllocs[nCtr,3]
					EXIT
				ENDIF
			ENDFOR
			RETURN IIF(nCtr <= .inNumAllocsActive,nCtr,NULL)
		ENDWITH
	ENDPROC

	PROCEDURE SizeOfBlock
		*  Retrieve the actual memory size of an allocated block
		LPARAMETERS nPtr
		LOCAL nCtr, nSizeOfBlock
		nSizeOfBlock = NULL
		* Change to use .FindAllocID() and return NULL 9/29/2000 EMR
		WITH this
			*  Find the allocation whose address is nPtr
			nCtr = .FindAllocID(nPtr)
			RETURN IIF(ISNULL(nCtr),NULL,.iaAllocs[nCtr,2])
		ENDWITH
	ENDPROC

	PROCEDURE Destroy
		DECLARE HeapDestroy IN WIN32API AS HDestroy ;
		  INTEGER hHeap

		LOCAL nCtr
		WITH this
			FOR nCtr = 1 TO .inNumAllocsActive
				IF .iaAllocs[nCtr,3]
					.Dealloc(.iaAllocs[nCtr,1])
				ENDIF
			ENDFOR
			HDestroy[.inHandle]
		ENDWITH
		DODEFAULT()
	ENDPROC


	PROCEDURE Init
		DECLARE INTEGER HeapCreate IN WIN32API AS HCreate ;
			INTEGER dwOptions, ;
			INTEGER dwInitialSize, ;
			INTEGER dwMaxSize
		#DEFINE SwapFilePageSize  4096
		#DEFINE BlockAllocSize    2 * SwapFilePageSize
		WITH this
			.inHandle = HCreate(0, BlockAllocSize, 0)
			DIMENSION .iaAllocs[1,3]
			.iaAllocs[1,1] = 0
			.iaAllocs[1,2] = 0
			.iaAllocs[1,3] = .F.
			.inNumAllocsActive = 0
		ENDWITH
		RETURN (this.inHandle # 0)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: heap
**************************************************
*
*  Additional functions for working with structures and pointers and stuff
*
FUNCTION SetMem
LPARAMETERS nPtr, cSource
*  Copy cSource to the memory location specified by nPtr
*  ReDECLARE RtlMoveMemory to make copy parameters easy
*  nPtr is not validated against legal allocations on the heap
DECLARE RtlMoveMemory IN WIN32API AS RtlCopy ;
	INTEGER nDestBuffer, ;
	STRING @pVoidSource, ;
	INTEGER nLength

RtlCopy(nPtr, ;
		cSource, ;
		LEN(cSource))
RETURN .T.

FUNCTION GetMem
LPARAMETERS nPtr, nLen
*  Copy the content of a memory block at nPtr for nLen bytes back to a VFP string
*  Note that we ReDECLARE RtlMoveMemory to make passing things easier
*  nPtr is not validated against legal allocations on the heap
DECLARE RtlMoveMemory IN WIN32API AS RtlCopy ;
	STRING @DestBuffer, ;
	INTEGER pVoidSource, ;
	INTEGER nLength
LOCAL uBuffer
* Allocate a buffer in VFP big enough to receive the block
uBuffer = REPL(CHR(0),nLen)
=RtlCopy(@uBuffer, ;
		 nPtr, ;
		 nLen)
RETURN uBuffer

FUNCTION GetMemString
LPARAMETERS nPtr, nSize
*  Copy the string at location nPtr into a VFP string
*  We're going to use lstrcpyn rather than RtlMoveMemory to copy up to a terminating null
*  nPtr is not validated against legal allocations on the heap
*
*	Change 9/29/2000 - second optional parameter nSize added to allow an override
*	of the string length;  no major expense, but probably an open invitation
*	to cliff-diving, since variant CStrings longer than 511 bytes, or less
*	often, 254 bytes, will generally fall down go Boom!
*
DECLARE INTEGER lstrcpyn IN WIN32API AS StrCpyN ;
	STRING @ lpDestString, ;
	INTEGER lpSource, ;
	INTEGER nMaxLength
LOCAL uBuffer
IF TYPE('nSize') # 'N' OR ISNULL(nSize)
	nSize = 512
ENDIF
*  Allocate a buffer big enough to receive the data
uBuffer = REPL(CHR(0), nSize)
IF StrCpyN(@uBuffer, nPtr, nSize-1) # 0
	uBuffer = LEFT(uBuffer, MAX(0,AT(CHR(0),uBuffer) - 1))
ELSE
	uBuffer = NULL
ENDIF
RETURN uBuffer

FUNCTION SHORTToNum
	* Converts a 16 bit signed integer in a structure to a VFP Numeric
 	LPARAMETER tcInt
	LOCAL b0,b1,nRetVal
	b0=asc(tcInt)
	b1=asc(subs(tcInt,2,1))
	if b1<128
		*
		*  positive - do a straight conversion
		*
		nRetVal=b1 * 256 + b0
	else
		*
		*  negative value - take twos complement and negate
		*
		b1=255-b1
		b0=256-b0
		nRetVal= -( (b1 * 256) + b0)
	endif
	return nRetVal

FUNCTION NumToSHORT
*
*  Creates a C SHORT as a string from a number
*
*  Parameters:
*
*	tnNum			(R)  Number to convert
*
	LPARAMETER tnNum
	*
	*  b0, b1, x hold small ints
	*
	LOCAL b0,b1,x
	IF tnNum>=0
		x=INT(tnNum)
		b1=INT(x/256)
		b0=MOD(x,256)
	ELSE
		x=INT(-tnNum)
		b1=255-INT(x/256)
		b0=256-MOD(x,256)
		IF b0=256
			b0=0
			b1=b1+1
		ENDIF
	ENDIF
	RETURN CHR(b0)+CHR(b1)

FUNCTION DWORDToNum
	* Take a binary DWORD and convert it to a VFP Numeric
	* use this to extract an embedded pointer in a structure in a string to an nPtr
	LPARAMETER tcDWORD
	LOCAL b0,b1,b2,b3
	b0=asc(tcDWORD)
	b1=asc(subs(tcDWORD,2,1))
	b2=asc(subs(tcDWORD,3,1))
	b3=asc(subs(tcDWORD,4,1))
	RETURN ( ( (b3 * 256 + b2) * 256 + b1) * 256 + b0)

*!*	FUNCTION NumToDWORD
*!*	*
*!*	*  Creates a 4 byte binary string equivalent to a C DWORD from a number
*!*	*  use to embed a pointer or other DWORD in a structure
*!*	*  Parameters:
*!*	*
*!*	*	tnNum			(R)  Number to convert
*!*	*
*!*	 	LPARAMETER tnNum
*!*	 	*
*!*	 	*  x,n,i,b[] will hold small ints
*!*	 	*
*!*	 	LOCAL x,n,i,b[4]
*!*		x=INT(tnNum)
*!*		FOR i=3 TO 0 STEP -1
*!*			b[i+1]=INT(x/(256^i))
*!*			x=MOD(x,(256^i))
*!*		ENDFOR
*!*		RETURN CHR(b[1])+CHR(b[2])+CHR(b[3])+CHR(b[4])
*			Redirected to NumToLong() using recasting;  comment out
*			the redirection and uncomment NumToDWORD() if original is needed
FUNCTION NumToDWORD
	LPARAMETER tnNum
	RETURN NumToLong(tnNum)
*			End redirection

FUNCTION WORDToNum
	*	Take a binary WORD (16 bit USHORT) and convert it to a VFP Numeric
	LPARAMETER tcWORD
	RETURN (256 *  ASC(SUBST(tcWORD,2,1)) ) + ASC(tcWORD)

FUNCTION NumToWORD
*
*  Creates a C USHORT (WORD) from a number
*
*  Parameters:
*
*	tnNum			(R)  Number to convert
*
	LPARAMETER tnNum
	*
	*  x holds an int
	*
	LOCAL x
	x=INT(tnNum)
	RETURN CHR(MOD(x,256))+CHR(INT(x/256))
	
FUNCTION NumToLong
*
*  Creates a C LONG (signed 32-bit) 4 byte string from a number
*  NB:  this works faster than the original NumToDWORD(), which could have
*	problems with trunaction of values > 2^31 under some versions of VFP with
*	#DEFINEd or converted constant values in excess of 2^31-1 (0x7FFFFFFF).
*	I've redirected NumToDWORD() and commented it out; NumToLong()
*	expects to work with signed values and uses BITOR() to recast values
*  in the range of -(2^31) to (2^31-1), 0xFFFFFFFF is not the same
*  as -1 when represented in an N-type field.  If you don't need to
*  use constants with the high-order bit set, or are willing to let
*  the UDF cast the value consistently, especially using pointer math 
*	on the system's part of the address space, this and its counterpart 
*	LONGToNum() are the better choice for speed, or to save to an I-field.
*
*  To properly cast a constant/value with the high-order bit set, you
*  can BITOR(nVal,0);  0xFFFFFFFF # -1 but BITOR(0xFFFFFFFF,0) = BITOR(-1,0)
*  is true, and converts the N-type in the range 2^31 - (2^32-1) to a
*  twos-complement negative integer value.  You can disable BITOR() casting
*  in this function by commenting the proper line in this UDF();  this 
*	results in a slight speed increase.
*
*  Parameters:
*
*  tnNum			(R)	Number to convert
*
	LPARAMETER tnNum
	DECLARE RtlMoveMemory IN WIN32API AS RtlCopyLong ;
		STRING @pDestString, ;
		INTEGER @pVoidSource, ;
		INTEGER nLength
	LOCAL cString
	cString = SPACE(4)
*	Function call not using BITOR()
*	=RtlCopyLong(@cString, tnNum, 4)
*  Function call using BITOR() to cast numerics
   =RtlCopyLong(@cString, BITOR(tnNum,0), 4)
	RETURN cString
	
FUNCTION LongToNum
*
*	Converts a 32 bit LONG to a VFP numeric;  it treats the result as a
*	signed value, with a range -2^31 - (2^31-1).  This is faster than
*	DWORDToNum().  There is no one-function call that causes negative
*	values to recast as positive values from 2^31 - (2^32-1) that I've
*	found that doesn't take a speed hit.
*
*  Parameters:
*
*  tcLong			(R)	4 byte string containing the LONG
*
	LPARAMETER tcLong
	DECLARE RtlMoveMemory IN WIN32API AS RtlCopyLong ;
		INTEGER @ DestNum, ;
		STRING @ pVoidSource, ;
		INTEGER nLength
	LOCAL nNum
	nNum = 0
	=RtlCopyLong(@nNum, tcLong, 4)
	RETURN nNum
	
FUNCTION AllocNetAPIBuffer
*
*	Allocates a NetAPIBuffer at least nBtes in Size, and returns a pointer
*	to it as an integer.  A NULL is returned if allocation fails.
*	The API call is not supported under Win9x
*
*	Parameters:
*
*		nSize			(R)	Number of bytes to allocate
*
LPARAMETER nSize
IF TYPE('nSize') # 'N' OR nSize <= 0
	*	Invalid argument passed, so return a null
	RETURN NULL
ENDIF
IF ! 'NT' $ OS()
	*	API call only supported under NT, so return failure
	RETURN NULL
ENDIF
DECLARE INTEGER NetApiBufferAllocate IN NETAPI32.DLL ;
	INTEGER dwByteCount, ;
	INTEGER lpBuffer
LOCAL  nBufferPointer
nBufferPointer = 0
IF NetApiBufferAllocate(INT(nSize), @nBufferPointer) # 0
	*  The call failed, so return a NULL value
	nBufferPointer = NULL
ENDIF
RETURN nBufferPointer

FUNCTION DeAllocNetAPIBuffer
*
*	Frees the NetAPIBuffer allocated at the address specified by nPtr.
*	The API call is not supported under Win9x
*
*	Parameters:
*
*		nPtr			(R) Address of buffer to free
*
*	Returns:			.T./.F.
*
LPARAMETER nPtr
IF TYPE('nPtr') # 'N'
	*	Invalid argument passed, so return failure
	RETURN .F.
ENDIF
IF ! 'NT' $ OS()
	*	API call only supported under NT, so return failure
	RETURN .F.
ENDIF
DECLARE INTEGER NetApiBufferFree IN NETAPI32.DLL ;
	INTEGER lpBuffer
RETURN (NetApiBufferFree(INT(nPtr)) = 0)

Function CopyDoubleToString
LPARAMETER nDoubleToCopy
*  ReDECLARE RtlMoveMemory to make copy parameters easy
DECLARE RtlMoveMemory IN WIN32API AS RtlCopyDbl ;
	STRING @DestString, ;
	DOUBLE @pVoidSource, ;
	INTEGER nLength
LOCAL cString
cString = SPACE(8)
=RtlCopyDbl(@cString, nDoubleToCopy, 8)
RETURN cString

FUNCTION DoubleToNum
LPARAMETER cDoubleInString
DECLARE RtlMoveMemory IN WIN32API AS RtlCopyDbl ;
	DOUBLE @DestNumeric, ;
	STRING @pVoidSource, ;
	INTEGER nLength
LOCAL nNum
*	Christof Lange pointed out that there's a feature of VFP that results
*	in the entry in the NTI retaining its precision after updating the value
*	directly;  force the resulting precision to a large value before moving
*	data into the temp variable
nNum = 0.000000000000000000
=RtlCopyDbl(@nNum, cDoubleInString, 8)
RETURN nNum


*** End of CLSHEAP ***