*&---------------------------------------------------------------------*
*& Report Y_CLASSICAL_EVENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_classical_events LINE-COUNT 10(2).

DATA : lv_ino   TYPE yde_invno,
       lv_itype TYPE yde_invtype,
       lv_idate TYPE yde_invdate.

SELECT-OPTIONS : s_ino FOR lv_ino,
                 s_itype FOR lv_itype NO INTERVALS MODIF ID typ,
                 s_idate FOR lv_idate NO-EXTENSION.

PARAMETERS p_chk TYPE c AS CHECKBOX USER-COMMAND select.

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.

TYPES : BEGIN OF ity_type,
          type TYPE yde_invtype,
          desc TYPE desc40,
        END OF ity_type.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.
DATA : it_tydata TYPE TABLE OF ity_type,
       wa_tydata TYPE ity_type.
DATA lt_links TYPE TABLE OF TLINE.

INITIALIZATION.
  s_idate-sign = 'I'.
  s_idate-option = 'EQ'.
  s_idate-low = sy-datum - 100.
  s_idate-high = sy-datum.
  APPEND s_idate.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_itype-low.

  wa_tydata-type = 'CRE'.
  wa_tydata-desc = 'Credit Memo Type'.
  APPEND wa_tydata TO it_tydata.
  CLEAR wa_tydata.

  wa_tydata-type = 'DEB'.
  wa_tydata-desc = 'Debit Memo Type'.
  APPEND wa_tydata TO it_tydata.
  CLEAR wa_tydata.

  wa_tydata-type = 'INV'.
  wa_tydata-desc = 'Invoice Type'.
  APPEND wa_tydata TO it_tydata.
  CLEAR wa_tydata.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'type'
*     PVALKEY         = ' '
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 's_itype-low '
*     STEPL           = 0
*     WINDOW_TITLE    =
*     VALUE           = ' '
      value_org       = 'S'
*     MULTIPLE_CHOICE = ' '
*     DISPLAY         = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM   = ' '
*     CALLBACK_METHOD =
*     MARK_TAB        =
*  IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = it_tydata
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

AT SELECTION-SCREEN ON HELP-REQUEST FOR p_chk.

  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                            = 'TX'
*     DOKLANGU                            = SY-LANGU
      dokname                             = 'YDOC'
*     DOKTITLE                            = ' '
*     CALLED_BY_PROGRAM                   = ' '
*     CALLED_BY_DYNP                      = ' '
*     CALLED_FOR_TAB                      = ' '
*     CALLED_FOR_FIELD                    = ' '
*     CALLED_FOR_TAB_FLD_BTCH_INPUT       = ' '
*     MSG_VAR_1                           = ' '
*     MSG_VAR_2                           = ' '
*     MSG_VAR_3                           = ' '
*     MSG_VAR_4                           = ' '
*     CALLED_BY_CUAPROG                   = ' '
*     CALLED_BY_CUASTAT                   =
*     SHORT_TEXT                          = ' '
*     CLASSIC_SAPSCRIPT                   = ' '
    TABLES
      links                               = lt_links
   EXCEPTIONS
     OBJECT_NOT_FOUND                    = 1
     SAPSCRIPT_ERROR                     = 2
     OTHERS                              = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



AT SELECTION-SCREEN OUTPUT.

  IF p_chk IS INITIAL.
    LOOP AT SCREEN.
      IF screen-group1 = 'TYP'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF p_chk IS NOT INITIAL.
    LOOP AT SCREEN.
      IF screen-group1 = 'TYP'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN.
  IF s_itype-low IS NOT INITIAL.
    IF s_itype-low <> 'CRE' AND s_itype-low <> 'DEB' AND s_itype-low <> 'INV'.
      MESSAGE e002(yoru).
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_data
  WHERE inv_num IN s_ino
  AND inv_type IN s_itype
  AND inv_date IN s_idate.


  LOOP AT it_data INTO wa_data.
    WRITE : / wa_data-ino UNDER TEXT-003,wa_data-itype UNDER TEXT-004,wa_data-idate UNDER TEXT-005.
  ENDLOOP.


END-OF-SELECTION.
  WRITE / TEXT-001.


TOP-OF-PAGE.
  WRITE : / TEXT-002, sy-pagno.
  WRITE : / TEXT-003, 20 TEXT-004, 37 TEXT-005.


END-OF-PAGE.
  WRITE : / TEXT-006.
