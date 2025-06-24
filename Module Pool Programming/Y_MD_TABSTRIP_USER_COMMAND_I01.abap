*----------------------------------------------------------------------*
***INCLUDE Y_MD_TABSTRIP_USER_COMMAND_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_hdr
  WHERE inv_num = yinv_hdr-inv_num.

  IF it_hdr IS NOT INITIAL.
    SELECT inv_num inv_itemnum item_cost curr
    FROM yinv_item
    INTO TABLE it_item
    FOR ALL ENTRIES IN it_hdr
    WHERE inv_num = it_hdr-ino.
  ENDIF.

  READ TABLE it_hdr INTO wa_hdr INDEX 1.
  IF sy-subrc = 0.
    yinv_hdr-inv_num = wa_hdr-ino.
    yinv_hdr-inv_type = wa_hdr-itype.
    yinv_hdr-inv_date = wa_hdr-idate.
  ENDIF.


ENDMODULE.
