*&---------------------------------------------------------------------*
*& Report Y_ALV_SORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_sort.

DATA : lv_vbeln TYPE vbeln_va.

SELECT-OPTIONS : s_vbeln FOR lv_vbeln.

TYPES : BEGIN OF ity_vbak,
          vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          erzet TYPE erzet,
          ernam TYPE ernam,
        END OF ity_vbak.

DATA : it_vbak TYPE TABLE OF ity_vbak,
       wa_vbak TYPE ity_vbak.

DATA : lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA : wa_fieldcat TYPE slis_fieldcat_alv.

DATA : lt_sort TYPE slis_t_sortinfo_alv,
       wa_sort TYPE slis_sortinfo_alv.

DATA : lt_filter TYPE slis_t_filter_alv,
       wa_filter TYPE slis_filter_alv.

DATA : lt_heading TYPE slis_t_listheader,
       wa_heading TYPE slis_listheader.

SELECT vbeln erdat erzet ernam
FROM vbak
INTO TABLE it_vbak
WHERE vbeln IN s_vbeln.

wa_fieldcat-col_pos = '1'.
wa_fieldcat-fieldname = 'VBELN'.
wa_fieldcat-tabname = 'IT_VBAK'.
wa_fieldcat-seltext_l = 'Sales Document'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '3'.
wa_fieldcat-fieldname = 'ERDAT'.
wa_fieldcat-tabname = 'IT_VBAK'.
wa_fieldcat-seltext_l = 'Creation Date'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '2'.
wa_fieldcat-fieldname = 'ERZET'.
wa_fieldcat-tabname = 'IT_VBAK'.
wa_fieldcat-seltext_l = 'Creation Time'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '4'.
wa_fieldcat-fieldname = 'ERNAM'.
wa_fieldcat-tabname = 'IT_VBAK'.
wa_fieldcat-seltext_l = 'Name of Person'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

*SORTING THE OUTPUT
wa_sort-fieldname = 'VBELN'.
wa_sort-down = 'X'.
APPEND wa_sort TO lt_sort.
CLEAR wa_sort.

*FILTER-ING THE DATA
wa_filter-fieldname = 'ERNAM'.
wa_filter-tabname = 'IT_VBAK'.
wa_filter-sign0 = 'I'.
wa_filter-optio = 'EQ'.
wa_filter-valuf_int = 'CURA'.
APPEND wa_filter TO lt_filter.
CLEAR wa_filter.

*HEADING
wa_heading-typ = 'H'.
wa_heading-info = 'ALV DISPLAY'.
APPEND wa_heading TO lt_heading.
CLEAR wa_heading.

wa_heading-typ = 'S'.
wa_heading-info = 'Orders Created'.
wa_heading-key = 'by person cura'.
APPEND wa_heading TO lt_heading.
CLEAR wa_heading.

wa_heading-typ = 'A'.
wa_heading-info = 'Hello World'.
APPEND wa_heading TO lt_heading.
CLEAR wa_heading.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK        = ' '
*   I_BYPASSING_BUFFER       = ' '
*   I_BUFFER_ACTIVE          = ' '
    i_callback_program       = sy-repid
*    i_callback_pf_status_set = ''
*   I_CALLBACK_USER_COMMAND  = ' '
   i_callback_top_of_page   = 'HEADING'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME         =
*   I_BACKGROUND_ID          = ' '
*   I_GRID_TITLE             =
*   I_GRID_SETTINGS          =
*   IS_LAYOUT                =
    it_fieldcat              = lt_fieldcat
*   IT_EXCLUDING             =
*   IT_SPECIAL_GROUPS        =
   it_sort                  = lt_sort
   it_filter                = lt_filter
*   IS_SEL_HIDE              =
*   I_DEFAULT                = 'X'
*   I_SAVE                   = ' '
*   IS_VARIANT               =
*   IT_EVENTS                =
*   IT_EVENT_EXIT            =
*   IS_PRINT                 =
*   IS_REPREP_ID             =
*   I_SCREEN_START_COLUMN    = 0
*   I_SCREEN_START_LINE      = 0
*   I_SCREEN_END_COLUMN      = 0
*   I_SCREEN_END_LINE        = 0
*   I_HTML_HEIGHT_TOP        = 0
*   I_HTML_HEIGHT_END        = 0
*   IT_ALV_GRAPHICS          =
*   IT_HYPERLINK             =
*   IT_ADD_FIELDCAT          =
*   IT_EXCEPT_QINFO          =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER  =
*   ES_EXIT_CAUSED_BY_USER   =
  TABLES
    t_outtab                 = it_vbak
  EXCEPTIONS
    program_error            = 1
    OTHERS                   = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

FORM heading.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_heading
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
