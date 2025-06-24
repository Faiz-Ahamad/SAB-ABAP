*&---------------------------------------------------------------------*
*& Report Y_ALV_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_hierseq.

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

DATA : lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA : wa_fieldcat TYPE slis_fieldcat_alv.

DATA : it_output TYPE TABLE OF yalv_str,
       wa_output TYPE yalv_str.

DATA : ls_keyinfo TYPE slis_keyinfo_alv.

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

wa_fieldcat-col_pos = '1'.
wa_fieldcat-fieldname = 'VBELN'.
wa_fieldcat-tabname = 'IT_VBAP'.
wa_fieldcat-seltext_l = 'Sales Document'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '2'.
wa_fieldcat-fieldname = 'POSNR'.
wa_fieldcat-tabname = 'IT_VBAP'.
wa_fieldcat-seltext_l = 'Item number'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '3'.
wa_fieldcat-fieldname = 'MATNR'.
wa_fieldcat-tabname = 'IT_VBAP'.
wa_fieldcat-seltext_l = 'Material number'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.

wa_fieldcat-col_pos = '4'.
wa_fieldcat-fieldname = 'ARKTX'.
wa_fieldcat-tabname = 'IT_VBAP'.
wa_fieldcat-seltext_l = 'Desc'.
APPEND wa_fieldcat TO lt_fieldcat.
CLEAR wa_fieldcat.


ls_keyinfo-header01 = 'VBELN'.
ls_keyinfo-item01 = 'VBELN'.




CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK              = ' '
*   I_CALLBACK_PROGRAM             =
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   IS_LAYOUT        =
    it_fieldcat      = lt_fieldcat
*   IT_EXCLUDING     =
*   IT_SPECIAL_GROUPS              =
*   IT_SORT          =
*   IT_FILTER        =
*   IS_SEL_HIDE      =
*   I_SCREEN_START_COLUMN          = 0
*   I_SCREEN_START_LINE            = 0
*   I_SCREEN_END_COLUMN            = 0
*   I_SCREEN_END_LINE              = 0
*   I_DEFAULT        = 'X'
*   I_SAVE           = ' '
*   IS_VARIANT       =
*   IT_EVENTS        =
*   IT_EVENT_EXIT    =
    i_tabname_header = 'IT_VBAK'
    i_tabname_item   = 'IT_VBAP'
*   I_STRUCTURE_NAME_HEADER        =
*   I_STRUCTURE_NAME_ITEM          =
    is_keyinfo       = ls_keyinfo
*   IS_PRINT         =
*   IS_REPREP_ID     =
*   I_BYPASSING_BUFFER             =
*   I_BUFFER_ACTIVE  =
*   IR_SALV_HIERSEQ_ADAPTER        =
*   IT_EXCEPT_QINFO  =
*   I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER        =
*   ES_EXIT_CAUSED_BY_USER         =
  TABLES
    t_outtab_header  = it_vbak
    t_outtab_item    = it_vbap
 EXCEPTIONS
   PROGRAM_ERROR    = 1
   OTHERS           = 2
  .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
