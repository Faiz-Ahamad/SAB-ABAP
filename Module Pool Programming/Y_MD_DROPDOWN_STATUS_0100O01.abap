*----------------------------------------------------------------------*
***INCLUDE Y_MD_DROPDOWN_STATUS_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

  DATA : lt_values TYPE vrm_values,
         wa_values TYPE vrm_value.

  REFRESH : lt_values.
  LOOP AT it_data INTO wa_data.

    wa_values-text = wa_data-dist.
    APPEND wa_values TO lt_values.
    CLEAR wa_values.
  ENDLOOP.



  IF it_data IS NOT INITIAL.
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id              = 'DIST_FLD'
        values          = lt_values
      EXCEPTIONS
        id_illegal_name = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDMODULE.
