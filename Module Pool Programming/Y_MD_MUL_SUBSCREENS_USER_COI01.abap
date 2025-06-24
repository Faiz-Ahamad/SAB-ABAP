*----------------------------------------------------------------------*
***INCLUDE Y_MD_MUL_SUBSCREENS_USER_COI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm = 'HEADER'.
    lv_screen = 0101.
  ELSEIF sy-ucomm = 'ITEM'.
    lv_screen = 0102.
  ENDIF.

  SELECT inv_num inv_type inv_date
    FROM yinv_hdr
    INTO TABLE it_hdr
    WHERE inv_num = lv_ino.

  READ TABLE it_hdr INTO wa_hdr INDEX 1.
  IF sy-subrc = 0.
    lv_ino = wa_hdr-ino.
    lv_itype = wa_hdr-itype.
    lv_date = wa_hdr-idate.
  ENDIF.

  IF it_hdr IS NOT INITIAL.
    SELECT inv_num inv_itemnum item_cost curr
    FROM yinv_item
    INTO TABLE it_item
    FOR ALL ENTRIES IN it_hdr
    WHERE inv_num = it_hdr-ino.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check INPUT.
    SELECT inv_num inv_type inv_date
    FROM yinv_hdr
    INTO TABLE it_hdr
    WHERE inv_num = lv_ino.

  IF sy-subrc <> 0.
    MESSAGE e001(yoru).
  ENDIF.
ENDMODULE.
