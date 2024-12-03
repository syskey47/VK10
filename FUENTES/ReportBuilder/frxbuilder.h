*=======================================================
* Report Builder compile constants
*=======================================================

#include foxpro_reporting.h
#include frxbuilder_loc.h
#include _frxcursor.h

*-------------------------------------------------------
* Debug & build :
*  - double-check these before each release build:
*-------------------------------------------------------

#define BUILDER_VERSION		"2325"

#define DEBUG_SUSPEND_ON_ERROR			    .F.		&& Allow suspend on error?

#define DEBUG_WAITMSG_WHILE_EXECUTING	    .F.		&& Show a WAIT WINDOW while processing lengthy Xbase code?

#define DEBUG_RCLICK_AVAILABLE			    .T.		&& rclick on a handlerForm to get advanced menu

#define BUILDER_USES_TABLE_BUFFERING    	.F.		&& No longer necessary, as the Designer itself buffers the FRX cursor

#define DEBUG_ALLOW_DEFAULT_ON_CONTEXT_MENU .F.		&& allow "discard and invoke default action" option on context menu

#define SHOW_HELP_BUTTON_ON_HANDLER_FORMS   .T.		&& Controls the visibility of Help button on handler forms


*-------------------------------------------------------
* Font Override / Large Font support:
*-------------------------------------------------------

#define DEBUG_FORCE_LARGE_FONT_SUPPORT	    .F.		&& Force objects to switch to "MS Shell Dlg" font (large font support)
#define DEBUG_FONT_SIZE_OVERRIDE             8      && Force a specific font size. 8 is default


*-------------------------------------------------------
* File names and locations:
*-------------------------------------------------------

#define THIS_APP_FILENAME		"REPORTBUILDER.APP"

#define BUILDER_CLASSLIB    	"frxBuilder.vcx"
#define FRXUTILS_PRG_CLASSLIB   "frxutils.prg"
#define FRXCOMMON_PRG_CLASSLIB  "frxcommon.prg"
#define HANDLERS_PRG_CLASSLIB   "frxHandlers.prg"
#define HANDLERS_VCX_CLASSLIB   "frxHandlers.vcx"

#define INT_REGISTRY_TABLE		"frxbuilder.dbf"
#define EXT_REGISTRY_TABLE		"reportbuilder.dbf"

*-------------------------------------------------------
* Constants peculiar to the Report Designer internals:
*-------------------------------------------------------

#define REPORTBUILDER_RESOURCE_ID		"9REPORTBDLR"
#define REGEXPLORER_RESOURCE_NAME       "RegistryExplorer"
#define FRXBROWSER_RESOURCE_NAME        "FrxBrowser"
#define BANDVIEWER_RESOURCE_NAME		"BandViewer"
#define MEMO_EDITOR_RESOURCE_NAME       "MemoEditor"
#define RUNTIME_EXT_RESOURCE_NAME		"RuntimeExtensionEditor"
#define DEBUG_HANDLER_RESOURCE_NAME     "DebugHandler"

#define BAND_SEPARATOR_HEIGHT_FRUS	 	2083.333
#define BAND_SEPARATOR_HEIGHT_PIXELS	20
#define PIXEL_HEIGHT_IN_FRUS	        104.167
#define PIXEL_WIDTH_IN_FRUS	            104.167
#define LINE_WIDTH_FRU					104.167

#define FIELDEXPR_DEFAULT_WIDTH_CHARS       15

#define FIELDEXPR_DEFAULT_WIDTH_CHARACTER   14 
#define FIELDEXPR_DEFAULT_WIDTH_DATE        10
#define FIELDEXPR_DEFAULT_WIDTH_DATETIME    20
#define FIELDEXPR_DEFAULT_WIDTH_INTEGER     12
#define FIELDEXPR_DEFAULT_WIDTH_CURRENCY    25
#define FIELDEXPR_DEFAULT_WIDTH_MEMO        70

#define FRX_FONTFACE_DEFAULT            "Courier New"
#define FRX_FONTSIZE_DEFAULT            10

#define GET_OBJECT_START_BAND		.T.
#define GET_OBJECT_END_BAND			.F.

#define GET_OBJECT_IDS				.F.
#define GET_OBJECT_RECNOS			.T.

#define OLEBOUND_DPI_DEFAULT		960

#define XPATH_REPORTDATA_DEFAULT    "/VFPData/reportdata[@type='R']"

*-------------------------------------------------------
* Miscellaneous readability constants:
*-------------------------------------------------------

#define GET_START_BAND .T.
#define GET_END_BAND   .F.

*-------------------------------------------------------
* Return flags:
*-------------------------------------------------------

#define FLAG_HANDLE_EVENT	        0
#define FLAG_NODEFAULT              0
#define FLAG_RELOAD_FRX		        1

#define EVENT_PASSED_TO_VFP			0
#define EVENT_HANDLED_BY_BUILDER	1

#define FRX_DISCARD_CHANGES			0
#define FRX_RELOAD_CHANGES			2

*-------------------------------------------------------
* Handler registry table record types 
*  - see REC_TYPE field:
*-------------------------------------------------------

#define HANDLREG_EXIT		'X'
#define HANDLREG_FILTER		'F'
#define HANDLREG_GETEXPR	'G'
#define HANDLREG_HANDLER	'H'
#define HANDLREG_RTEXTEND   'E'

*-------------------------------------------------------
* Event types passed in from Report Designer:
* (Additional to frx.h)
*-------------------------------------------------------

#define FRX_BLDR_EVENT_RIGHTCLICK    0

*-------------------------------------------------------
* frx OBJTYPE values:
* (Additional to frx.h)
*-------------------------------------------------------

#define FRX_OBJTYPE_MULTISELECT             99

*-------------------------------------------------------
* Event Handling modes (Report Builder options dialog):
*-------------------------------------------------------

#define MODE_HANDLE_CLASS   1
#define MODE_FORCE_DEBUG    2
#define MODE_FORCE_MSBOX    3
#define MODE_FORCE_NATIVE	4

*-------------------------------------------------------
* Object Cursor filter modes: (frxCursor)
*-------------------------------------------------------

#define OBJCSR_ALL_OBJECTS_IGNORE_GROUPS	0
#define OBJCSR_FILTER_ON_SELECTED			1
#define OBJCSR_SHOW_ALL_OBJECTS				2
#define OBJCSR_FILTER_GROUP					3

#define OBJCSR_SORTORDER_TYPE		1
#define OBJCSR_SORTORDER_BAND		2

#define OBJGRP_SELECTED_CHAR		"*"

*-------------------------------------------------------
* Object Position control (option values):
*-------------------------------------------------------

#define OBJECT_POSITION_FLOAT		1
#define OBJECT_POSITION_FIX_TOP		2
#define OBJECT_POSITION_FIX_BOTTOM	3

*-------------------------------------------------------
* Object Stretch control (option values):
*-------------------------------------------------------

#define OBJECT_STRETCH_NO_STRETCH	1
#define OBJECT_STRETCH_TO_TALLEST	2
#define OBJECT_STRETCH_TO_HEIGHT	3

*-------------------------------------------------------
* Text Format/Styles:
* (additional to frx.h)
*-------------------------------------------------------

#define STYLE_CHAR_NORMAL		"N"
#define STYLE_CHAR_BOLD			"B"
#define STYLE_CHAR_ITALIC		"I"
#define STYLE_CHAR_UNDER		"U"
#define STYLE_CHAR_STRIKE		"-"

#define DEFAULT_FORE_COLOR 		0
#define DEFAULT_BACK_COLOR		16777215

*-------------------------------------------------------
* Page Layout:
*-------------------------------------------------------

#define ORIENTATION_PORTRAIT	0
#define ORIENTATION_LANDSCAPE	1

*-------------------------------------------------------
* Help Context IDs:
*-------------------------------------------------------

#define UI_OPTIONS_DLG_HELP_ID                1231155
#define UI_REGEXPLR_DLG_HELP_ID               1231156
#define UI_DEBUGHNDLR_DLG_HELP_ID             1231160
#define UI_METAEDIT_DLG_HELP_ID               1231161
#define UI_FRXBROWS_DLG_HELP_ID               1231157

#define UI_BAND_PROPS_GENERAL_HELP_ID         1231162      	
#define UI_BAND_PROPS_BAND_HELP_ID            1231145
#define UI_BAND_PROPS_PROTECTION_HELP_ID      1231146
#define UI_BAND_PROPS_OTHER_HELP_ID           1231147

#define UI_CONTROL_PROPS_GENERAL_HELP_ID      1231148        	
#define UI_CONTROL_PROPS_STYLE_HELP_ID        1231149
#define UI_CONTROL_PROPS_FORMAT_HELP_ID       1231150
#define UI_CONTROL_PROPS_PRINTWHEN_HELP_ID    1231151
#define UI_CONTROL_PROPS_CALCULATE_HELP_ID    1231152
#define UI_CONTROL_PROPS_PROTECTION_HELP_ID   1231153
#define UI_CONTROL_PROPS_OTHER_HELP_ID        1231154

#define UI_REPORT_PROPS_PAGELAYOUT_HELP_ID    1231138
#define UI_REPORT_PROPS_OPTIONALBANDS_HELP_ID 1231139
#define UI_REPORT_PROPS_DATAGROUP_HELP_ID     1231140
#define UI_REPORT_PROPS_VARIABLES_HELP_ID	  1231141
#define UI_REPORT_PROPS_PROTECTION_HELP_ID    1231142
#define UI_REPORT_PROPS_RULERGRID_HELP_ID     1231143
#define UI_REPORT_PROPS_DATAENV_HELP_ID       1231144

#define UI_MULTI_PROPS_SELECTION_HELP_ID      1231158
#define UI_MULTI_PROPS_PROPERTIES_HELP_ID     1231159

