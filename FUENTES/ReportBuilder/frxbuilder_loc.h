*=======================================================
* Report Builder localization constants
*=======================================================
* (For localization - see also: frxcursor.h)

#define c_CR	chr(13)
#define c_LF    chr(10)
#define c_CRLF  chr(13)+chr(10)
#define c_CR2	chr(13)+chr(13)
#define c_TAB	chr(9)

*-------------------------------------------------------
* Event Types
*-------------------------------------------------------

#define EVTYP_RIGHTCLICK_LOC		"(reserved)"
#define EVTYP_PROPERTIES_LOC		"Properties dialog"
#define EVTYP_OBJECT_CREATE_LOC		"Object Create"
#define EVTYP_OBJECT_CHANGE_LOC		"Object Change"
#define EVTYP_OBJECT_REMOVE_LOC		"Object Remove"
#define EVTYP_OBJECT_PASTE_LOC		"Object Paste"
#define EVTYP_REPORT_SAVE_LOC       "Report Save"
#define EVTYP_REPORT_OPEN_LOC		"Report Open"
#define EVTYP_REPORT_CLOSE_LOC		"Report Close"
#define EVTYP_DATAENV_LOC			"Open DataEnvironment"
#define EVTYP_PRINT_PREVIEW_LOC		"Print Preview Mode"
#define EVTYP_OPTIONAL_BANDS_LOC	"Optional Bands dialog"
#define EVTYP_DATA_GROUPING_LOC		"Data Grouping dialog"
#define EVTYP_VARIABLES_LOC			"Variables dialog"
#define EVTYP_EDIT_IN_PLACE_LOC     "Edit Label Text"
#define EVTYP_OBJECT_DROP_LOC       "Object Drop from DE"
#define EVTYP_SET_GRID_SCALE_LOC    "Set Grid Scale"
#define EVTYP_IMPORT_DE_LOC         "Import Data Environment"
#define EVTYP_PRINT_LOC             "Print Report"
#define EVTYP_QUICKREPORT_LOC       "Quick Report"
#define EVTYP_UNKNOWN_LOC			"UNKNOWN EVENT"

*-------------------------------------------------------
* Dialog Captions: 
*-------------------------------------------------------

*#define DLG_TITLE_NEW_PREFIX_LOC		"New "
#define DLG_TITLE_NEW_PREFIX_LOC		""
#define DLG_TITLE_PROPERTIES_LOC		" Properties"
#define DLG_TITLE_BAND_LOC				" Band"
#define DLG_TITLE_READONLY_SUFFIX_LOC	" [Read Only]"

*-------------------------------------------------------
* Dialog context menu prompts:
*-------------------------------------------------------

#define UI_CONTEXT_EVENT_INSPECTOR_LOC	"Event Inspector..."
#define UI_CONTEXT_BROWSE_FRX_LOC		"Browse FRX..."
#define UI_CONTEXT_OPTIONS_DIALOG_LOC  	"Options..."

#define UI_TOOLSMENU_OPTIONS_MESSAGE_LOC "Displays the default report builder Options dialog box"

*-------------------------------------------------------
* Message box strings: 
*-------------------------------------------------------

#define DEFAULT_MBOX_TITLE_LOC          	"Report Builder"
#define RB_INVALID_PARAMETERS_LOC		    "Report Builder has been called with invalid parameters."
#define RB_FILE_NOT_FOUND_LOC			    "The specified report file could not be opened."

#define EVENT_INSPECTOR_TITLE_LOC           "Report Builder Event"

#define RB_GETEXPR_FAILURE_LOC              "The GetExpression handler is not available. INPUTBOX() will be used instead."
#define RB_DEF_GETEXPR_PROMPT_LOC           "Enter expression:"

#define RB_EXCEPTION_HEADER_LOC             "The report builder application has encountered an exception from which it could not recover:"
#define RB_ERROR_NEWOBJECT_LOC              "The report builder application was unable to instantiate the following class:"
#define RB_ERROR_CHECK_REGISTRY_LOC         "Please ensure that the registry table is correctly configured."

#define DEVICEHELPER_ERROR_LOC			    "Unable to read page layout information from report printer environment."+ chr(13) + "Error: "
#define NO_PRINTERS_INSTALLED_LOC		    "There are no printers installed. Page Layout settings may not be available."
#define PRINTER_INSTALLED_OK_LOC		    "Thank you for installing a printer. Page Layout options for this report can now be set."

#define RUNTIME_EXT_XML_HELPER_TXT_LOC	    "Edit the XML directly but be careful to maintain the valid XML format."
#define RUNTIME_EXT_NO_FRX_LOC			    "The FRX cursor is not specified or not available. Report metadata can not be edited."

#define UNABLE_TO_COPY_REGISTRY_LOC         "Unable to create copy of registry table."
#define OVERWRITE_EXISTING_REGISTRY_LOC     "Overwrite existing registry table?"
#define FILE_EXISTS_LOC					    "File Exists:"
#define REGISTRY_TABLE_LOC				    "Registry Table:"

#define FEATURE_IS_PROTECTED_LOC		    "This function is not available in the Report Designer's protected mode."
#define OBJECT_LOCK_LOC             	    "This object may not be moved."
#define DELETE_MBOX_TITLE_LOC			    "Object Delete"
#define DELETE_MBOX_MSG_LOC        		    "{%1} object(s) are protected from delete operations."
#define OBJECT_NO_EDIT_LOC          	    "This object may not be edited."

#define GROUPED_ITEM_PROPERTIES_LOC		    "These items are grouped. To edit the properties of the individual layout elements, you must first un-group them using the Format menu."

#define TEXTLABEL_INVALID_CAPTION_MSG_LOC	"You must enter a Label Caption."
#define FIELDEXPR_INVALID_CAPTION_MSG_LOC   "You must enter a field expression."

#define PICTURE_INVALID_SOURCE_MSG_LOC      "You must enter a picture source."
#define PICTURE_INVALID_FILENAME_MSG_LOC	"Unable to locate the source file. Please select a valid picture source."

#define PROPEDIT_MBOX_TITLE_LOC			    "Unable to save"

#define USE_REG_ERR_MBOX_MSG_LOC		    "Unable to open handler registry table {%1}. The default, internal lookup table will be used."  

#define PRINTER_NAME_SUFFIX_DEFAULT_LOC	    " (Default)"

#define METADATA_DOM_CREATE_FAILED_LOC 	    "Unable to create MSXml.DomDocument instance. Metadata XML may not be available."
#define METADATA_XML_INVALID_LOC		    "The metadata XML for this report element is not valid."
#define METADATA_XML_REPLACE_LOC		    "Do you want to replace the metadata with a valid default XML fragment?"

#define BAND_REMOVE_WARNING_LOC			    "{%1} object(s) exist in the {%2} band(s)."+c_CR+"If they stay in the report, their position in the report layout"+c_CR+"will be unpredictable when these bands are removed."+c_CR2+"Do you wish to delete these objects as well?"+c_CR2+"Yes"+c_TAB+"- to DELETE objects currently in the bands."+c_CR+"No"+c_TAB+"- to leave the objects in the report layout."+c_CR+"Cancel"+c_TAB+"- to return to the dialog without deleting anything."
#define DETAIL_BAND_REMOVE_WARN_LOC		    "{%1} object(s) exist in this detail band."+c_CR+"Are you sure you want to remove this band, along with the layout objects?"
#define GROUP_BAND_REMOVE_WARN_LOC		    "{%1} object(s) exist in this group's header and footer."+c_CR+"Are you sure you want to remove this data grouping, along with the layout objects?"

#define QUERY_SUSPEND_EXECUTION_LOC 	    "Do you want to suspend execution?"

#define EDIT_REPORT_VAR_PROMPT_LOC		    "Variable name:"
#define EDIT_REPORT_VAR_CAPTION_LOC		    "Report Variable"

#define LOAD_DE_CONFIRMATION_LOC			"This will replace existing Data Environment information in this report. Do you want to continue?"
#define LOAD_DE_ERROR_LOC					"An error occurred attempting to read the source report."
#define LOAD_DE_INVALID_CLASS_LOC       	"A class of base class 'DataEnvironment' must be selected."
#define LOAD_DE_ERR_INSTANTIATING_CLASS_LOC	"An error ocurred while attempting to instantiate the DE class and therefore it could not be linked to the report."
#define DE_METHOD_HEADER_COMMENT_LOC		"* THIS METHOD CODE WAS INSERTED BY THE REPORT BUILDER *"

#define LOAD_DE_SUCCESS_LOC					"The data environment for this report will be updated when you click OK to save your changes."

#define OTHER_EDIT_COMMENT_LOC				"Comments are stored in the COMMENTS field of the report(.frx) file and are not used by the report engine."

#define OTHER_EDIT_USER_LOC					"User data is stored in the USER field of the report(.frx) file and is not used by the report engine."

#define OTHER_EDIT_TOOLTIP_LOC				"Tooltips are displayed for layout objects in the Report Designer."

#define OTHER_EDIT_METADATA_LOC 			"Run-time extensions specify code elements visible to ReportListener objects at run time."

#define METADATA_HELPER_TEXT_LOC			"Run-time extensions specify code elements visible to ReportListener objects. Execute when specifies an expression that ReportListener objects can evaluate to determine whether to run the extensions."

#define EDIT_SCRIPT_DLG_CAPTION_LOC			"Edit Runtime Script"
#define EDIT_META_XML_DLG_CAPTION_LOC		"Metadata XML"

#define LABEL_EDIT_CAPTION_LOC              "Label Caption"
#define LABEL_EDIT_COMMENT_LOC				"A label's caption may not exceed 254 characters in length. Additional characters will be ignored."
#define REPORT_VAR_INVALID_NAME_LOC			"Please specify a valid variable name."

#define REPORT_VAR_DUPLICATE_NAME_LOC       "Please specify a unique variable name."

#define OPTIONS_DEFAULT_INTERNAL_LOOKUP_LOC		"internal lookup table"
#define OPTIONS_HANDLER_REGISTRY_PROMPT_LOC		"Handler registry:"
#define OPTIONS_GETFILE_REGISTRY_TITLE_LOC		"Select event handler registry table"
#define OPTIONS_HANDLER_REGISTRY_INVALID_LOC	"The specified table does not exist or is invalid."

#define DTL_HELPER_TEXT_LOC  					"During PROTECTED report designer sessions, design-time captions are displayed in the layout instead of the field expression."

#define OLEBOUND_DPI_HELPERTEXT_LOC				"You can tune the performance of a report with OLEBound objects by adjusting the DPI used to render them."

*-------------------------------------------------------
* Page Layout Preview Control:
*-------------------------------------------------------

#define PAGELAYOUT_FORM_CAPTION_LOC				"Page Layout Details"

#define PAGELAYOUT_INFO_PAGE_WIDTH_LOC			"Page Width = "
#define PAGELAYOUT_INFO_PAGE_HEIGHT_LOC			"Page Height = "
#define PAGELAYOUT_INFO_ORIENTATION_LOC			"Orientation = "
#define PAGELAYOUT_INFO_UNPRINT_TOP_LOC			"Unprintable Top margin = "
#define PAGELAYOUT_INFO_UNPRINT_LEFT_LOC		"Unprintable Left margin = "
#define PAGELAYOUT_INFO_EXTRA_LEFT_LOC			"Additional Left margin = "
#define PAGELAYOUT_INFO_COL_COUNT_LOC			"Column Count = "	
#define PAGELAYOUT_INFO_COL_WIDTH_LOC			"Column Width = "
#define PAGELAYOUT_INFO_COL_SPACE_LOC			"Column Space = "
#define PAGELAYOUT_INFO_HEADER_SIZE_LOC			"Header size = "
#define PAGELAYOUT_INFO_FOOTER_SIZE_LOC			"Footer size = "

*-------------------------------------------------------
* Calculation combo list:
*-------------------------------------------------------

#define CALCULATE_NOTHING_LOC	    "None"
#define CALCULATE_COUNT_LOC		    "Count"
#define CALCULATE_SUM_LOC		    "Sum"
#define CALCULATE_AVERAGE_LOC	    "Average"
#define CALCULATE_LOWEST_LOC	    "Lowest"
#define CALCULATE_HIGHEST_LOC	    "Highest"
#define CALCULATE_STDDEV_LOC	    "Standard deviation"
#define CALCULATE_VARIANCE_LOC	    "Variance"

#define PICTUREMODE_CLIP_LOC                "Clip contents"
#define PICTUREMODE_SCALE_KEEP_SHAPE_LOC    "Scale contents, retain shape"
#define PICTUREMODE_SCALE_STRETCH_LOC       "Scale contents, fill the frame"

*-------------------------------------------------------
* Line/Shape Styles:
*-------------------------------------------------------

#define LINE_STYLE_0_LOC			"None"
#define LINE_STYLE_1_LOC			"Dotted"
#define LINE_STYLE_2_LOC			"Dashes"
#define LINE_STYLE_3_LOC			"Dash-dot"
#define LINE_STYLE_4_LOC			"Dash-dot-dot"
#define LINE_STYLE_5_LOC			"Tiny dots"
#define LINE_STYLE_6_LOC			"Small dots"
#define LINE_STYLE_7_LOC			"Large dots"
#define LINE_STYLE_8_LOC			"Normal"

#define LINE_WIDTH_HAIRLINE_LOC		"Hairline"
#define LINE_WIDTH_1POINT_LOC		"1 point (normal)"
#define LINE_WIDTH_2POINT_LOC		"2 point"
#define LINE_WIDTH_4POINT_LOC		"4 point"
#define LINE_WIDTH_6POINT_LOC		"6 point"

*-------------------------------------------------------
* Measurement units (option/combo values):
*-------------------------------------------------------

#define UNITS_NORULER_LOC	 	"Inches (no ruler)"
#define UNITS_INCHES_LOC	 	"Inches"
#define UNITS_METRIC_LOC	 	"Metric/cm"
#define UNITS_PIXELS_LOC	 	"Pixels"
#define UNITS_NONPAREIL_LOC  	"Nonpariel"
#define UNITS_CHARACTERS_LOC 	"Characters"

*-------------------------------------------------------
* String Trimming Modes (option/combo values):
*-------------------------------------------------------

#define STRINGTRIM_DEFAULT_LOC          "Default trimming"
#define STRINGTRIM_CHAR_LOC             "Trim to nearest character"
#define STRINGTRIM_WORD_LOC             "Trim to nearest word"
#define STRINGTRIM_ELLIPSIS_CHAR_LOC    "Trim to nearest character, append ellipsis"
#define STRINGTRIM_ELLIPSIS_WORD_LOC    "Trim to nearest word, append ellipsis"
#define STRINGTRIM_ELLIPSIS_FILE_LOC    "Filespec: Show inner path as ellipsis"

*-------------------------------------------------------
* UI control captions (not already LOC'd) :
*-------------------------------------------------------

#define USE_LOC_STRINGS_IN_UI				.F.    && Set this .T. to enable these LOC strings in UI controls

*-------------------------------------------------------
* Use code like this in the object's .Init():
*
*#IF USE_LOC_STRINGS_IN_UI
*    THIS.Caption = UI_CMD_OK_LOC
*#ENDIF
*
*-------------------------------------------------------

#define UI_CMD_OK_LOC						"OK"
#define UI_CMD_CANCEL_LOC					"Cancel"
#define UI_CMD_HELP_LOC 					"Help"

#define UI_CMD_FONT_LOC						"Font..."
#define UI_CMD_CLOSE_LOC					"Close"
#define UI_CMD_ADD_RECORD_LOC				"Add Record"

#define UI_CMD_ADD_LOC						"Add"
#define UI_CMD_REMOVE_LOC					"Remove"

*--- Tab Captions:

#define UI_TAB_GENERAL_LOC				"General"	
#define UI_TAB_BAND_LOC					"Band"
#define UI_TAB_STYLE_LOC				"Style"
#define UI_TAB_FORMAT_LOC				"Format"
#define UI_TAB_PRINTWHEN_LOC			"Print when"
#define UI_TAB_CALCULATE_LOC			"Calculate"
#define UI_TAB_OTHER_LOC				"Other"
#define UI_TAB_PAGELAYOUT_LOC			"Page Layout"
#define UI_TAB_OPTIONALBANDS_LOC		"Optional Bands"
#define UI_TAB_DATAGROUP_LOC			"Data Grouping"
#define UI_TAB_VARIABLES_LOC			"Variables"
#define UI_TAB_PROTECTION_LOC			"Protection"
#define UI_TAB_RULERGRID_LOC			"Ruler/Grid"
#define UI_TAB_DATAENV_LOC				"Data Environment"

#define UI_TAB_SELECTION_LOC			"Selection"
#define UI_TAB_PROPERTIES_LOC			"Properties"

*--- Options dialog:

#define UI_OPTIONS_FORM_CAPTION_LOC         "Report Builder Options"

#define UI_OPTIONS_LBL_EVENT_HANDLING_LOC	" Report Designer event handling "
#define UI_OPTIONS_LBL_HANDLE_TEXT_LOC      "When handling Report Designer events, the builder will:"
#define UI_OPTIONS_LBL_HANDLER_TABLE_LOC    " Handler Registry table "
#define UI_OPTIONS_LBL_TABLE_TEXT_LOC       "The Report Builder uses a lookup table to determine which class to use to handle a specific builder event and/or object type."
#define UI_OPTIONS_LBL_COPY_TEXT_LOC        "If you wish to override the default mappings of handler classes to report designer events, you will need to create a customizable copy of the internal handler table."
#define UI_OPTIONS_LBL_EXPLORE_TEXT_LOC     "Registry Explorer provides a way for you to browse the current handler registry table, and make changes if you have appropriate permissions."

#define UI_OPTIONS_CMD_COPY_LOC				"\<Create copy"
#define UI_OPTIONS_CMD_EXPLORE_LOC			"Registry \<Explorer"

#define UI_OPTIONS_OPT_SEARCH_LOC           "Search for a \<handler class in the registry table (see below)"
#define UI_OPTIONS_OPT_DEBUG_LOC            "Use the \<debug handler for all events"
#define UI_OPTIONS_OPT_INSPECT_LOC          "Use the e\<vent inspector for all events"
#define UI_OPTIONS_OPT_IGNORE_LOC           "\<Ignore builder events completely"
#define UI_OPTIONS_OPT_USE_INTERNAL_LOC     "\<Use internal lookup table"
#define UI_OPTIONS_OPT_USE_ALTERNATE_LOC    "U\<se alternative lookup table:"

*--- Registry Explorer dialog:

#define UI_REGEXPLR_FORM_CAPTION_LOC		"Event Handler Registry"
#define UI_REGEXPLR_FORM_INTERNAL_LOC		"(Internal lookup table)"
#define UI_REGEXPLR_COL_TYPE_LOC			"Type"
#define UI_REGEXPLR_COL_CLASS_LOC			"Class"
#define UI_REGEXPLR_COL_LIBRARY_LOC			"Library"
#define UI_REGEXPLR_COL_DESCRIPT_LOC		"Description"
#define UI_REGEXPLR_COL_EVENT_LOC			"Event"
#define UI_REGEXPLR_COL_OBJTYP_LOC			"Objtype"
#define UI_REGEXPLR_COL_OBJCOD_LOC			"Objcode"
#define UI_REGEXPLR_COL_NATIVE_LOC			"Native"
#define UI_REGEXPLR_COL_DEBUG_LOC			"Debug"
#define UI_REGEXPLR_COL_FILTER_LOC			"Filter order"

*--- Metadata Editor dialog:

#define UI_CMD_EDIT_XML_LOC					"Edit XML..."
#define UI_METAEDIT_LBL_RTEXTENSION_LOC		"Run-time extensions:"
#define UI_METAEDIT_LBL_EXECWHEN_LOC		"Execute when:"

*--- FRX Browser dialog:

#define UI_FRXBROWS_FORM_CAPTION_LOC		"FRX Table Browser"

*--- Multiple selection dialog:

#define UI_MULTISEL_APPLY_PROTECTION_LOC	"Apply these protection settings to the selected objects:"
#define UI_MULTISEL_APPLY_PRINTWHEN_LOC		"Apply these conditions to the selected objects upon saving:"

*--- FRX Browse Panel:

#define UI_FRXBROWS_CHK_CURPOS_LOC			"CURPOS=.T. (Object selected in layout)"

*--- Object Position Panel:

#define UI_OBJPOS_LBL_OBJECT_POS_LOC		" Object position "
#define UI_OBJPOS_OPT_FLOAT_LOC				"\<Float"
#define UI_OBJPOS_OPT_FIX_REL_TO_TOP_LOC    "Fix relative to \<top of band"
#define UI_OBJPOS_OPT_FRX_REL_TO_BOTTOM_LOC "Fix relative to \<bottom of band"

*--- Stretch Down Panel:

#define UI_STRETCH_LBL_STRETCH_LOC			" Stretch downwards "
#define UI_STRETCH_OPT_NO_STRETCH_LOC		"\<No stretch"
#define UI_STRETCH_OPT_REL_TO_TALLEST_LOC   "Stretch re\<lative to tallest object in group"
#define UI_STRETCH_OPT_REL_TO_HEIGHT_LOC    "Stretch relative to \<height of band"

*--- Absolute Positioning panel:

#define UI_ABSPOS_LBL_CAPTION_LOC			" Size and position in layout "
#define UI_ABSPOS_LBL_PAGE_TOP_LOC			"From page top:"
#define UI_ABSPOS_LBL_LEFT_LOC				"From left:"
#define UI_ABSPOS_LBL_HEIGHT_LOC			"Height:"
#define UI_ABSPOS_LBL_WIDTH_LOC				"Width:"

*--- Band panel:

#define UI_BAND_LBL_HEIGHT_LOC				"\<Height:"
#define UI_BAND_CHK_CONSTANT_HEIGHT_LOC		"Constant band height"
#define UI_BAND_LBL_RUN_EXPR_LOC			" Run expression "
#define UI_BAND_LBL_ONENTRY_LOC				"On \<entry:"
#define UI_BAND_LBL_ONEXIT_LOC				"On e\<xit:"

*--- Band protection panel:

#define UI_BANDPROT_LBL_CAPTION_LOC			" When in PROTECTED mode "
#define UI_BANDPROT_LBL_HELP_TEXT_LOC		"The following restrictions will apply to this band when the layout is modified in protected mode:"
#define UI_BANDPROT_CHK_NO_RESIZE_LOC		"Band cannot be resized"
#define UI_BANDPROT_CHK_NO_PROPS_LOC		"Properties dialog box is not available"

*--- Calculate panel:

#define UI_CALCULATE_LBL_CAPTION_LOC		" Calculate "
#define UI_CALCULATE_LBL_TYPE_LOC			"Calculation type:"
#define UI_CALCULATE_LBL_RESET_LOC			"Reset based on:"

*--- Comment/User panel:

#define UI_COMMENTUSER_LBL_COMMENT_LOC		"Comment "
#define UI_COMMENTUSER_LBL_USERDATA_LOC		"User data "
#define UI_COMMENTUSER_CMD_EDIT_COMMENT_LOC "Edit comment..."
#define UI_COMMENTUSER_CMD_EDIT_USER_LOC    "Edit user data..."

*--- Load DE panel:

#define UI_LOADDE_LBL_CAPTION_LOC			" Load data environment "
#define UI_LOADDE_OPT_COPY_FROM_FRX_LOC		"Copy from another report file"
#define UI_LOADDE_OPT_LINK_TO_CLASS_LOC		"Link to a DataEnvironment class"
#define UI_LOADDE_CMD_SELECT_LOC			"Select..."
#define UI_LOADDE_LBL_CLASSNAME_LOC			"Class:"
#define UI_LOADDE_LBL_LIBRARY_LOC			"Class Library / Source:"
#define UI_LOADDE_CHK_PRIVATE_SESSION_LOC	"Report uses a private data session"

*--- DesignTime Label panel:

#define UI_DTLABEL_LBL_CAPTION_LOC			"Design-time caption:"

*--- Detail band properties panel:

#define UI_DETAIL_LBL_CAPTION_LOC			" Detail properties "
#define UI_DETAIL_CHK_NEW_COLUMN_LOC		"Start on new \<column"
#define UI_DETAIL_CHK_NEW_PAGE_LOC			"Start on new \<page"
#define UI_DETAIL_CHK_RESET_PAGE_LOC		"Reset page \<number to 1 for each detail set"
#define UI_DETAIL_CHK_HEADERFOOTER_LOC      "Associated \<header and footer bands"
#define UI_DETAIL_CHK_REPRINT_HEADER_LOC	"\<Reprint detail header on each page"
#define UI_DETAIL_LBL_THRESHOLD_LOC			"\<Start detail set on new page when less than:"
#define UI_DETAIL_LBL_TARGET_ALIAS_LOC		"\<Target alias expression:"

*--- Detail bands panel:

#define UI_DETAILBANDS_LBL_CAPTION_LOC		" Detail bands "

*--- Field Expression panel:

#define UI_FIELDEXPR_LBL_CAPTION_LOC		"\<Expression:"

*--- Field Format panel:

#define UI_FORMAT_LBL_CAPTION_LOC			"\<Format expression:"
#define UI_FORMAT_OPT_CHARACTER_LOC			"\<Character"
#define UI_FORMAT_OPT_NUMERIC_LOC			"\<Numeric"
#define UI_FORMAT_OPT_DATE_LOC				"\<Date"
#define UI_FORMAT_LBL_OPTIONS_LOC			" Format options "

#define UI_FORMAT_LBL_TEMPLATE_LOC			"Template characters"
#define UI_FORMAT_OPT_OVERLAY_LOC			"\<Overlay"
#define UI_FORMAT_OPT_INTERLEAVE_LOC		"\<Interleave"
#define UI_FORMAT_LBL_JUSTIFY_LOC			"Alignment"
#define UI_FORMAT_OPT_JUST_LEFT_LOC			"\<Left"
#define UI_FORMAT_OPT_JUST_RIGHT_LOC		"\<Right"
#define UI_FORMAT_OPT_JUST_CENTER_LOC		"Cen\<ter"
#define UI_FORMAT_CHK_UPPERCASE_LOC			"To \<upper case"
#define UI_FORMAT_CHK_SET_DATE_LOC			"\<SET DATE format"
#define UI_FORMAT_CHK_BRITISH_DATE_LOC		"\<British date"

#define UI_FORMAT_CHK_LEFT_JUST_LOC			"\<Left justify"
#define UI_FORMAT_CHK_ZERO_BLANK_LOC		"Blank if \<zero"
#define UI_FORMAT_CHK_NEGATIVE_LOC			"(Ne\<gative)"
#define UI_FORMAT_CHK_CR_POSITIVE_LOC		"C\<R if positive"
#define UI_FORMAT_CHK_DB_NEGATIVE_LOC		"DB if negati\<ve"
#define UI_FORMAT_CHK_LEADING_0_LOC			"Leading z\<eros"
#define UI_FORMAT_CHK_CURRENCY_LOC			"C\<urrency"
#define UI_FORMAT_CHK_SCIENTIFIC_LOC		"Scien\<tific"

#define UI_FORMAT_CHK_BLANK_EMPTY_LOC		"Blank if \<empty"

#define UI_FORMAT_LBL_TRIM_MODE_LOC			"\<Trim mode for character expressions:"

*--- Field Positioning panel:

#define UI_FIELDPOS_CHK_OVERFLOW_LOC		"\<Stretch with overflow"

*--- Group Expression panel:

#define UI_GROUPEXPR_LBL_CAPTION_LOC		"Group \<expression:"

*--- Grouping panel:

#define UI_GROUPING_LBL_NESTING_LOC			"Grouping nesting order:"
#define UI_GROUPING_LBL_GROUP_ON_LOC		"Group on:"
#define UI_GROUPING_LBL_STARTS_ON_LOC		" Group starts on "
#define UI_GROUPING_OPT_NEW_LINE_LOC		"New line"
#define UI_GROUPING_OPT_NEW_COL_LOC			"New \<column"
#define UI_GROUPING_OPT_NEW_PAGE_LOC		"New \<page"
#define UI_GROUPING_OPT_NEW_PAGE1_LOC		"\<New page number 1"
#define UI_GROUPING_CHK_REPRINT_LOC			"\<Reprint group header on each page"
#define UI_GROUPING_LBL_THRESHOLD_LOC		"\<Start group on new page when less than:"

*--- Member data panel:

#define UI_MEMBERDATA_LBL_CAPTION_LOC		"Run-time extensions "
#define UI_MEMBERDATA_CMD_EDIT_LOC			"Edit settings..."

*--- MultiPrint When panel:

#define UI_MULTIPRINTWHEN_LBL_CAPTION_LOC	"\<Print only when expression is true:"

*--- MultiSelect panel:

#define UI_MULTISELECT_LBL_OBJECT_LOC		"\<Object"
#define UI_MULTISELECT_LBL_BAND_LOC			"Location at run-time"
#define UI_MULTISELECT_LBL_SORT_BY_LOC		" Sort by "
#define UI_MULTISELECT_OPT_TYPE_LOC			"\<Type"
#define UI_MULTISELECT_OPT_LOCATION_LOC		"\<Location"
#define UI_MULTISELECT_CMD_REMOVE_LOC		"Remove from list"

*--- Object Protection panel:

#define UI_OBJPROTECT_LBL_CAPTION_LOC		" When in PROTECTED mode "
#define UI_OBJPROTECT_LBL_TEXT_LOC			"The following restrictions will apply to this report control when the layout is modified in protected mode:"
#define UI_OBJPROTECT_CHK_NO_RESIZE_LOC		"Object cannot be \<moved or resized"
#define UI_OBJPROTECT_CHK_NO_PROPS_LOC		"\<Properties dialog box is not available"
#define UI_OBJPROTECT_CHK_NO_DELETE_LOC		"Object cannot be \<deleted"
#define UI_OBJPROTECT_CHK_NO_SELECT_LOC		"Object cannot be \<selected"
#define UI_OBJPROTECT_CHK_NOT_VISIBLE_LOC	"Object is not \<visible in Designer"

*--- Optional Bands panel:

#define UI_OPTBANDS_LBL_TITLE_LOC			" Title "
#define UI_OPTBANDS_CHK_TITLE_LOC			"Report has \<title band"
#define UI_OPTBANDS_CHK_TITLE_NEW_PAGE_LOC	"\<New page after title has printed"
#define UI_OPTBANDS_LBL_SUMMARY_LOC			" Summary "
#define UI_OPTBANDS_CHK_SUMMARY_LOC			"Report has su\<mmary band"
#define UI_OPTBANDS_CHK_SUMM_NEW_PAGE_LOC	"Summary prints as ne\<w page"
#define UI_OPTBANDS_CHK_SUMM_HEADER_LOC		"Include page \<header with summary"
#define UI_OPTBANDS_CHK_SUMM_FOOTER_LOC		"Include page \<footer with summary"

*--- Page Layout panel:

#define UI_PAGELAYOUT_LBL_COLUMNS_LOC		" Columns "
#define UI_PAGELAYOUT_LBL_NUMBER_LOC		"Number:"
#define UI_PAGELAYOUT_LBL_WIDTH_LOC			"Width:"
#define UI_PAGELAYOUT_LBL_SPACING_LOC		"Spacing:"
#define UI_PAGELAYOUT_LBL_MARGIN_LOC		"Left margin:"

#define UI_PAGELAYOUT_LBL_PRINT_AREA_LOC	" Print area "
#define UI_PAGELAYOUT_OPT_PRINTABLE_LOC		"Printable page"
#define UI_PAGELAYOUT_OPT_WHOLE_LOC			"Whole page"

#define UI_PAGELAYOUT_LBL_PRINT_ORDER_LOC	" Column print order "
#define UI_PAGELAYOUT_OPT_TOP_BOTTOM_LOC	"Top to bottom"
#define UI_PAGELAYOUT_OPT_LEFT_RIGHT_LOC	"Left to right"

#define UI_PAGELAYOUT_LBL_DEF_FONT_LOC		" Default font "
#define UI_PAGELAYOUT_CHK_FONTSCRIPT_LOC	"Use font script"

#define UI_PAGELAYOUT_LBL_PRINTER_LOC		" Printer "
#define UI_PAGELAYOUT_CMD_PAGE_SETUP_LOC	"Page Setup..."
#define UI_PAGELAYOUT_CHK_SAVE_ENV_LOC		"Save printer environment"

*--- Picture/Bound panel:

#define UI_PICTBOUND_LBL_CAPTION_LOC		" Control source type "
#define UI_PICTBOUND_OPT_FILE_LOC			"Image file name"
#define UI_PICTBOUND_OPT_GENERAL_LOC		"General field name"
#define UI_PICTBOUND_OPT_EXPRVAR_LOC		"Expression or variable name"
#define UI_PICTBOUND_LBL_SOURCE_LOC			"Control source:"
#define UI_PICTBOUND_LBL_PICTMODE_LOC		"If source and frame are different sizes:"
#define UI_PICTBOUND_CHK_CENTER_LOC			"Center general field horizontally in frame"

*--- Print When panel:

#define UI_PRINTWHEN_LBL_CAPTION_LOC		" Print repeated values "
#define UI_PRINTWHEN_OPT_YES_LOC			"\<Yes"
#define UI_PRINTWHEN_OPT_NO_LOC				"\<No"
#define UI_PRINTWHEN_LBL_ALSO_PRINT_LOC		" Also print "
#define UI_PRINTWHEN_CHK_FIRST_WHOLE_LOC	"In \<first whole band of a new page/column"
#define UI_PRINTWHEN_CHK_EXPR_CHANGE_LOC	"When this data \<group expression changes:"
#define UI_PRINTWHEN_CHK_OVERFLOW_LOC		"When \<band content overflows to new page/column"
#define UI_PRINTWHEN_CHK_REMOVE_BLANK_LOC	"\<Remove line if blank"
#define UI_PRINTWHEN_LBL_PRINT_EXPR_LOC		"\<Print only when expression is true:"

*--- Report Protection panel:

#define UI_REPPROTECT_LBL_CAPTION_LOC		" In PROTECTED mode "
#define UI_REPPROTECT_LBL_TEXT_LOC			"Select the features that will be unavailable when this layout is modified in protected mode:"
#define UI_REPPROTECT_CHK_NO_PRINT_LOC		"Report can not be run or \<printed"
#define UI_REPPROTECT_CHK_NO_PREVIEW_LOC	"Report can not be previe\<wed"
#define UI_REPPROTECT_CHK_NO_DATAENV_LOC	"The Data Environment is not available"
#define UI_REPPROTECT_CHK_NO_PAGELAYOUT_LOC "Page \<Layout is not available"
#define UI_REPPROTECT_CHK_NO_OPTBANDS_LOC	"\<Optional Bands can not be changed"
#define UI_REPPROTECT_CHK_NO_GROUPING_LOC	"Data \<Grouping can not be modified"
#define UI_REPPROTECT_CHK_NO_REPVARS_LOC	"Report \<Variables can not be edited"

*--- Ruler/Grid panel:

#define UI_RULERGRID_LBL_RULER_LOC			" Ruler "
#define UI_RULERGRID_LBL_UNITS_LOC			"Units:"
#define UI_RULERGRID_CHK_SHOW_POSITION_LOC	"Show position in status bar"
#define UI_RULERGRID_LBL_GRID_LOC			" Grid "
#define UI_RULERGRID_CHK_SHOW_GRID_LOC		"Show grid lines"
#define UI_RULERGRID_CHK_SNAP_TO_GRID_LOC	"Snap to grid"
#define UI_RULERGRID_LBL_HORIZONTAL_LOC		"Horizontal spacing:"
#define UI_RULERGRID_LBL_VERTICAL_LOC		"Vertical spacing:"

*--- Report Variables panel:

#define UI_REPVARS_LBL_CAPTION_LOC			"Variables:"
#define UI_REPVARS_LBL_STORE_VALUE_LOC		"Value to store:"
#define UI_REPVARS_LBL_INITIAL_LOC			"Initial value:"
#define UI_REPVARS_LBL_RESET_ON_LOC			"Reset value based on:"
#define UI_REPVARS_LBL_CALC_TYPE_LOC		"Calculation type:"
#define UI_REPVARS_CHK_RELEASE_LOC			"Release after report"

*--- Shape format panel:
*--- Text format panel:

#define UI_SHAPE_LBL_STYLE_LOC				"Style:"
#define UI_SHAPE_LBL_WEIGHT_LOC				"Weight:"
#define UI_SHAPE_LBL_CURVATURE_LOC			"Curvature:"
#define UI_SHAPE_LBL_COLOR_LOC				" Color "

#define UI_TEXTFORMAT_LBL_FONT_LOC			" Font "
#define UI_TEXTFORMAT_CHK_FONTSCRIPT_LOC	"Use font script"
#define UI_TEXTFORMAT_CHK_STRIKETHRU_LOC	"Strikethrough"
#define UI_TEXTFORMAT_CHK_UNDERLINE_LOC		"Underline"

#define UI_FORMAT_CHK_FORECOLOR_LOC			"Use default foreground (pen) color"
#define UI_FORMAT_CHK_BACKCOLOR_LOC			"Use default background (fill) color"
#define UI_FORMAT_LBL_BACKSTYLE_LOC			" Backstyle "
#define UI_FORMAT_OPT_OPAQUE_LOC			"Opaque"
#define UI_FORMAT_OPT_TRANSPARENT_LOC		"Transparent"
#define UI_FORMAT_LBL_SAMPLE_LOC			" Sample "

*--- Text Label panel:

#define UI_TEXTLABEL_LBL_CAPTION_LOC		"Caption:"

*--- Tooltip panel:

#define UI_TOOLTIP_LBL_CAPTION_LOC			"Tooltip "
#define UI_TOOLTIP_CMD_EDIT_LOC				"Edit tooltip..."

