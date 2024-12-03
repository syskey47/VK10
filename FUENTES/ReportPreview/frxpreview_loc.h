*=======================================================
* Report Preview localization constants
*=======================================================

#define c_CR	chr(13)
#define c_LF    chr(10)
#define c_CRLF  chr(13)+chr(10)
#define c_CR2	chr(13)+chr(13)
#define c_TAB	chr(9)

*-------------------------------------------------------
* Dialog Captions: 
*-------------------------------------------------------
#define DEFAULT_MBOX_TITLE_LOC      	"Vista preliminar del informe"
#define REPORT_PREVIEW_CAPTION			"Vista preliminar del informe"
#define REPORT_PREVIEW_PAGE_CAPTION     " - Página "
#define REPORT_PREVIEW_GOTO_PAGE_LOC    "Ir a página número:"
#define TOOLBAR_CAPTION					"Vista preliminar del informe"

*-------------------------------------------------------
* Message box strings: 
*-------------------------------------------------------
#define RP_INVALID_PARAMETERS_LOC		"ReportPreview.app has been called with invalid parameters."
#define RP_INVALID_INITIALIZATION_LOC	"Report Preview has not been initialized correctly. It requires a ReportListener reference."
#define RP_INVALID_PAGE_NUMBER_LOC		"Page number must be in range "
#define RP_NO_OUTPUT_PAGES_LOC          "There are no pages available to preview."
#define RP_OUTPUTPAGE_ERROR_LOC         "An exception ocurred invoking .OutputPage():"

*-------------------------------------------------------
* Zoom Level prompts:
*-------------------------------------------------------
#define ZOOM_LEVEL_PROMPT_10_LOC           "10%"
#define ZOOM_LEVEL_PROMPT_25_LOC           "25%"
#define ZOOM_LEVEL_PROMPT_50_LOC           "50%"
#define ZOOM_LEVEL_PROMPT_75_LOC           "75%"
#define ZOOM_LEVEL_PROMPT_100_LOC          "100%"
#define ZOOM_LEVEL_PROMPT_150_LOC          "150%"
#define ZOOM_LEVEL_PROMPT_200_LOC          "200%"
#define ZOOM_LEVEL_PROMPT_300_LOC          "300%"
#define ZOOM_LEVEL_PROMPT_500_LOC          "500%"
#define ZOOM_LEVEL_PROMPT_WHOLE_PAGE_LOC   "Whole Page"

*-------------------------------------------------------
* Context menu prompts:
*-------------------------------------------------------
#define CONTEXT_MENU_PROMPT_FIRST_PAGE_LOC         "Primera página"
#define CONTEXT_MENU_PROMPT_PREVIOUS_LOC           "Página anterior"
#define CONTEXT_MENU_PROMPT_NEXT_LOC               "Página siguiente"
#define CONTEXT_MENU_PROMPT_LAST_PAGE_LOC          "Última página"
#define CONTEXT_MENU_PROMPT_GO_TO_PAGE_LOC         "Ir a página..."
#define CONTEXT_MENU_PROMPT_ZOOM_LOC               "Zoom"
#define CONTEXT_MENU_PROMPT_PAGES_TO_DISPLAY_LOC   "Páginas a mostrar"
#define CONTEXT_MENU_PROMPT_TOOLBAR_LOC            "Barra de herramientas"
#define CONTEXT_MENU_PROMPT_PRINT_LOC              "Imprimir"
#define CONTEXT_MENU_PROMPT_CLOSE_LOC              "Cerrar"
#define CONTEXT_MENU_PROMPT_INFODEBUG_LOC          "Info...[DEBUG]"
#define CONTEXT_MENU_PROMPT_1PAGE_LOC              "1 página"
#define CONTEXT_MENU_PROMPT_2PAGES_LOC             "2 páginas"
#define CONTEXT_MENU_PROMPT_4PAGES_LOC             "4 páginas"

*-------------------------------------------------------
* UI control captions (not already LOC'd) :
*-------------------------------------------------------
#define USE_LOC_STRINGS_IN_UI				.T.    && Set this .T. to enable these LOC strings in UI controls

#define UI_CMD_OK_LOC						"Aceptar"
#define UI_CMD_CANCEL_LOC					"Cancelar"

#define UI_TOOLBAR_GOTOPAGE_LOC				"Ir a página"
#define UI_TOOLBAR_CLOSE_LOC				"Cerrar"
#define UI_TOOLBAR_PRINT_LOC				"Imprimir"

#define UI_TOOLBAR_TT_FIRST_LOC				"Primera página"
#define UI_TOOLBAR_TT_BACK_LOC				"Página anterior"
#define UI_TOOLBAR_TT_GOTOPAGE_LOC			"Ir a página"
#define UI_TOOLBAR_TT_NEXT_LOC				"Página siguiente"
#define UI_TOOLBAR_TT_LAST_LOC				"Última página"
#define UI_TOOLBAR_TT_ZOOMLEVEL_LOC			"Seleccione aumento de página"
#define UI_TOOLBAR_TT_1PAGE_LOC				"Una página"
#define UI_TOOLBAR_TT_2PAGES_LOC			"Dos páginas"
#define UI_TOOLBAR_TT_4PAGES_LOC			"Cuatro páginas"
#define UI_TOOLBAR_TT_CLOSE_LOC				"Cerrar ventana de vista preliminar"
#define UI_TOOLBAR_TT_PRINT_LOC				"Imprimir informe"
