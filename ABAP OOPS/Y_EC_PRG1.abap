*&---------------------------------------------------------------------*
*& Report Y_EC_PRG1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_ec_prg1.

DATA : lv_ino TYPE yde_invno,
       lv_type TYPE yde_invtype,
       lv_loc TYPE yde_loc,
       lv_date TYPE yde_invdate.
DATA : lo_expections TYPE REF TO ycx_inv1.
DATA : lv_msg TYPE string.

PARAMETERS : p_ino TYPE yde_invno.

START-OF-SELECTION.
  WRITE : / lv_ino,
          / lv_type,
          / lv_loc,
          / lv_date.

AT SELECTION-SCREEN.
  TRY .
      IF p_ino IS INITIAL.
        RAISE EXCEPTION TYPE ycx_inv1
          EXPORTING
            textid = ycx_inv1=>exp1
*           previous =
*           lv_ino =
          .
      ENDIF.
    CATCH ycx_inv1 INTO lo_expections.
      CALL METHOD lo_expections->if_message~get_text
        RECEIVING
          result = lv_msg.
      MESSAGE lv_msg TYPE 'E'.

  ENDTRY.
  TRY .
      SELECT SINGLE inv_num inv_type loc inv_date
      FROM yinv_hdr
      INTO ( lv_ino , lv_type, lv_loc, lv_date )
      WHERE inv_num = p_ino.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE ycx_inv1
          EXPORTING
            textid = ycx_inv1=>exp2
*           previous =
            lv_ino = p_ino.
      ENDIF.
    CATCH ycx_inv1 INTO lo_expections.
      CALL METHOD lo_expections->if_message~get_text
        RECEIVING
          result = lv_msg.
      MESSAGE lv_msg TYPE 'E'.
  ENDTRY.
