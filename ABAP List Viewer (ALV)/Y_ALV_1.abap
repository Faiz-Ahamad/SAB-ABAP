*&---------------------------------------------------------------------*
*& Report Y_ALV_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_1.

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

DATA : it_output TYPE TABLE OF yalv_str,
       wa_output TYPE yalv_str.

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

LOOP AT it_vbak INTO wa_vbak.
  LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln.
    wa_output-vbeln = wa_vbak-vbeln.
    wa_output-erdat = wa_vbak-erdat.
    wa_output-erzet = wa_vbak-erzet.
    wa_output-ernam = wa_vbak-ernam.
    wa_output-posnr = wa_vbap-posnr.
    wa_output-matnr = wa_vbap-matnr.
    wa_output-arktx = wa_vbap-arktx.
    APPEND wa_output TO it_output.
  ENDLOOP.
ENDLOOP.

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
*   I_PROGRAM_NAME         =
*   I_INTERNAL_TABNAME     =
    i_structure_name       = 'YALV_STR'
*   I_CLIENT_NEVER_DISPLAY = 'X'
*   I_INCLNAME             =
*   I_BYPASSING_BUFFER     =
*   I_BUFFER_ACTIVE        =
  CHANGING
    ct_fieldcat            = lt_fieldcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK              = ' '
*   I_BYPASSING_BUFFER             =
*   I_BUFFER_ACTIVE                = ' '
*   I_CALLBACK_PROGRAM             = ' '
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   I_STRUCTURE_NAME               =
*   IS_LAYOUT     =
    it_fieldcat   = lt_fieldcat
*   IT_EXCLUDING  =
*   IT_SPECIAL_GROUPS              =
*   IT_SORT       =
*   IT_FILTER     =
*   IS_SEL_HIDE   =
*   I_DEFAULT     = 'X'
*   I_SAVE        = ' '
*   IS_VARIANT    =
*   IT_EVENTS     =
*   IT_EVENT_EXIT =
*   IS_PRINT      =
*   IS_REPREP_ID  =
*   I_SCREEN_START_COLUMN          = 0
*   I_SCREEN_START_LINE            = 0
*   I_SCREEN_END_COLUMN            = 0
*   I_SCREEN_END_LINE              = 0
*   IR_SALV_LIST_ADAPTER           =
*   IT_EXCEPT_QINFO                =
*   I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER        =
*   ES_EXIT_CAUSED_BY_USER         =
  TABLES
    t_outtab      = it_output
  EXCEPTIONS
    program_error = 1
    OTHERS        = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
