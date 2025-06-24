*----------------------------------------------------------------------*
***INCLUDE Y_MD_SEL_TABCTRL_F4HELPI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  F4HELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4help INPUT.
  TYPES : BEGIN OF ity_data,
            ino TYPE yde_invno,
          END OF ity_data.

  DATA : it_data TYPE TABLE OF ity_data.

  SELECT inv_num
  FROM yinv_hdr
  INTO TABLE it_data.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'inv_num'
*     PVALKEY         = ' '
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'YINV_HDR-INV_NUM'
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
*    IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = it_data
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



ENDMODULE.
