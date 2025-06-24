*&---------------------------------------------------------------------*
*& Report Y_ALV_PF_USER_COMMD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_pf_user_commd.


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

DATA : lt_fieldcat1 TYPE slis_t_fieldcat_alv.
DATA : wa_fieldcat1 TYPE slis_fieldcat_alv.

SELECT vbeln erdat erzet ernam
FROM vbak
INTO TABLE it_vbak
WHERE vbeln IN s_vbeln.

wa_fieldcat-col_pos = '1'.
wa_fieldcat-fieldname = 'VBELN'.
wa_fieldcat-hotspot = 'X'.
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

wa_fieldcat1-col_pos = '1'.
wa_fieldcat1-fieldname = 'VBELN'.
wa_fieldcat1-tabname = 'IT_VBAP'.
wa_fieldcat1-seltext_l = 'Sales Document'.
APPEND wa_fieldcat1 TO lt_fieldcat1.
CLEAR wa_fieldcat1.

wa_fieldcat1-col_pos = '2'.
wa_fieldcat1-fieldname = 'POSNR'.
wa_fieldcat1-tabname = 'IT_VBAP'.
wa_fieldcat1-seltext_l = 'Item number'.
APPEND wa_fieldcat1 TO lt_fieldcat1.
CLEAR wa_fieldcat1.

wa_fieldcat1-col_pos = '3'.
wa_fieldcat1-fieldname = 'MATNR'.
wa_fieldcat1-tabname = 'IT_VBAP'.
wa_fieldcat1-seltext_l = 'Material number'.
APPEND wa_fieldcat1 TO lt_fieldcat1.
CLEAR wa_fieldcat1.

wa_fieldcat1-col_pos = '4'.
wa_fieldcat1-fieldname = 'ARKTX'.
wa_fieldcat1-tabname = 'IT_VBAP'.
wa_fieldcat1-seltext_l = 'Desc'.
APPEND wa_fieldcat1 TO lt_fieldcat1.
CLEAR wa_fieldcat1.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK        = ' '
*   I_BYPASSING_BUFFER       = ' '
*   I_BUFFER_ACTIVE          = ' '
    i_callback_program       = sy-repid
    i_callback_pf_status_set = 'STATUS-1'
    i_callback_user_command  = 'CMD-1'
*   I_CALLBACK_TOP_OF_PAGE   = ' '
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
*   IT_SORT                  =
*   IT_FILTER                =
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
* EXCEPTIONS
*   PROGRAM_ERROR            = 1
*   OTHERS                   = 2
  .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


FORM status-1 USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'SALES1'.
ENDFORM.


FORM cmd-1  USING r_ucomm LIKE sy-ucomm
                                  rs_selfield TYPE slis_selfield.

  IF r_ucomm = 'DISPLAY'.


    READ TABLE it_vbak INTO wa_vbak INDEX rs_selfield-tabindex.

    IF sy-subrc = 0.

      SELECT vbeln posnr matnr arktx
      FROM vbap
      INTO TABLE it_vbap
      WHERE vbeln = wa_vbak-vbeln.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
*         I_INTERFACE_CHECK                 = ' '
*         I_BYPASSING_BUFFER                = ' '
*         I_BUFFER_ACTIVE                   = ' '
*         I_CALLBACK_PROGRAM                = ' '
*         I_CALLBACK_PF_STATUS_SET          = ' '
*         I_CALLBACK_USER_COMMAND           = ' '
*         I_CALLBACK_TOP_OF_PAGE            = ' '
*         I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*         I_CALLBACK_HTML_END_OF_LIST       = ' '
*         I_STRUCTURE_NAME                  =
*         I_BACKGROUND_ID                   = ' '
*         I_GRID_TITLE  =
*         I_GRID_SETTINGS                   =
*         IS_LAYOUT     =
          it_fieldcat   = lt_fieldcat1
*         IT_EXCLUDING  =
*         IT_SPECIAL_GROUPS                 =
*         IT_SORT       =
*         IT_FILTER     =
*         IS_SEL_HIDE   =
*         I_DEFAULT     = 'X'
*         I_SAVE        = ' '
*         IS_VARIANT    =
*         IT_EVENTS     =
*         IT_EVENT_EXIT =
*         IS_PRINT      =
*         IS_REPREP_ID  =
*         I_SCREEN_START_COLUMN             = 0
*         I_SCREEN_START_LINE               = 0
*         I_SCREEN_END_COLUMN               = 0
*         I_SCREEN_END_LINE                 = 0
*         I_HTML_HEIGHT_TOP                 = 0
*         I_HTML_HEIGHT_END                 = 0
*         IT_ALV_GRAPHICS                   =
*         IT_HYPERLINK  =
*         IT_ADD_FIELDCAT                   =
*         IT_EXCEPT_QINFO                   =
*         IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*         E_EXIT_CAUSED_BY_CALLER           =
*         ES_EXIT_CAUSED_BY_USER            =
        TABLES
          t_outtab      = it_vbap
        EXCEPTIONS
          program_error = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.
  ENDIF.

  IF r_ucomm = '&IC1'.
    SET PARAMETER ID 'AUN' FIELD rs_selfield-value.
    CALL TRANSACTION 'VA03'.
  ENDIF.
ENDFORM.
