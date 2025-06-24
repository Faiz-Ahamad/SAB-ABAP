*&---------------------------------------------------------------------*
*& Report Y_ALV_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_block.

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

TYPES : BEGIN OF ity_vbap,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr,
          matnr TYPE matnr,
          arktx TYPE arktx,
        END OF ity_vbap.

DATA : it_vbap TYPE TABLE OF ity_vbap,
       wa_vbap TYPE ity_vbap.

DATA : lt_fieldcat_vbak TYPE slis_t_fieldcat_alv.
DATA : wa_fieldcat_vbak TYPE slis_fieldcat_alv.

DATA : lt_fieldcat_vbap TYPE slis_t_fieldcat_alv.
DATA : wa_fieldcat_vbap TYPE slis_fieldcat_alv.

DATA : lt_layout_vbak TYPE SLIS_LAYOUT_ALV,
       lt_layout_vbap TYPE SLIS_LAYOUT_ALV,
       lt_events_vbak TYPE SLIS_T_EVENT,
       lt_events_vbap TYPE SLIS_T_EVENT.

SELECT vbeln erdat erzet ernam
FROM vbak
INTO TABLE it_vbak
WHERE vbeln IN s_vbeln.


IF it_vbak IS NOT INITIAL.
  SELECT vbeln posnr matnr arktx
  FROM vbap
  INTO TABLE it_vbap
  FOR ALL ENTRIES IN it_vbak
  WHERE vbeln = it_vbak-vbeln.
ENDIF.

wa_fieldcat_vbak-col_pos = '1'.
wa_fieldcat_vbak-fieldname = 'VBELN'.
wa_fieldcat_vbak-tabname = 'IT_VBAK'.
wa_fieldcat_vbak-seltext_l = 'Sales Document'.
APPEND wa_fieldcat_vbak TO lt_fieldcat_vbak.
CLEAR wa_fieldcat_vbak.

wa_fieldcat_vbak-col_pos = '3'.
wa_fieldcat_vbak-fieldname = 'ERDAT'.
wa_fieldcat_vbak-tabname = 'IT_VBAK'.
wa_fieldcat_vbak-seltext_l = 'Creation Date'.
APPEND wa_fieldcat_vbak TO lt_fieldcat_vbak.
CLEAR wa_fieldcat_vbak.

wa_fieldcat_vbak-col_pos = '2'.
wa_fieldcat_vbak-fieldname = 'ERZET'.
wa_fieldcat_vbak-tabname = 'IT_VBAK'.
wa_fieldcat_vbak-seltext_l = 'Creation Time'.
APPEND wa_fieldcat_vbak TO lt_fieldcat_vbak.
CLEAR wa_fieldcat_vbak.

wa_fieldcat_vbak-col_pos = '4'.
wa_fieldcat_vbak-fieldname = 'ERNAM'.
wa_fieldcat_vbak-tabname = 'IT_VBAK'.
wa_fieldcat_vbak-seltext_l = 'Name of Person'.
APPEND wa_fieldcat_vbak TO lt_fieldcat_vbak.
CLEAR wa_fieldcat_vbak.

wa_fieldcat_vbap-col_pos = '1'.
wa_fieldcat_vbap-fieldname = 'VBELN'.
wa_fieldcat_vbap-tabname = 'IT_VBAP'.
wa_fieldcat_vbap-seltext_l = 'Sales Document'.
APPEND wa_fieldcat_vbap TO lt_fieldcat_vbap.
CLEAR wa_fieldcat_vbap.

wa_fieldcat_vbap-col_pos = '2'.
wa_fieldcat_vbap-fieldname = 'POSNR'.
wa_fieldcat_vbap-tabname = 'IT_VBAP'.
wa_fieldcat_vbap-seltext_l = 'Item number'.
APPEND wa_fieldcat_vbap TO lt_fieldcat_vbap.
CLEAR wa_fieldcat_vbap.

wa_fieldcat_vbap-col_pos = '3'.
wa_fieldcat_vbap-fieldname = 'MATNR'.
wa_fieldcat_vbap-tabname = 'IT_VBAP'.
wa_fieldcat_vbap-seltext_l = 'Material number'.
APPEND wa_fieldcat_vbap TO lt_fieldcat_vbap.
CLEAR wa_fieldcat_vbap.

wa_fieldcat_vbap-col_pos = '4'.
wa_fieldcat_vbap-fieldname = 'ARKTX'.
wa_fieldcat_vbap-tabname = 'IT_VBAP'.
wa_fieldcat_vbap-seltext_l = 'Desc'.
APPEND wa_fieldcat_vbap TO lt_fieldcat_vbap.
CLEAR wa_fieldcat_vbap.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
  EXPORTING
    i_callback_program             = sy-repid
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   IT_EXCLUDING                   =
          .

CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    is_layout                        = lt_layout_vbak
    it_fieldcat                      = lt_fieldcat_vbak
    i_tabname                        = 'IT_VBAK'
    it_events                        = lt_events_vbak
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    t_outtab                         = it_vbak
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    is_layout                        = lt_layout_vbap
    it_fieldcat                      = lt_fieldcat_vbap
    i_tabname                        = 'IT_VBAP'
    it_events                        = lt_events_vbap
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    t_outtab                         = it_vbap
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'
* EXPORTING
*   I_INTERFACE_CHECK             = ' '
*   IS_PRINT                      =
*   I_SCREEN_START_COLUMN         = 0
*   I_SCREEN_START_LINE           = 0
*   I_SCREEN_END_COLUMN           = 0
*   I_SCREEN_END_LINE             = 0
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER       =
*   ES_EXIT_CAUSED_BY_USER        =
 EXCEPTIONS
   PROGRAM_ERROR                 = 1
   OTHERS                        = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
