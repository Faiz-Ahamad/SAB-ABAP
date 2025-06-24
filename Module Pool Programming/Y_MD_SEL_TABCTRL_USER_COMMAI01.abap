*----------------------------------------------------------------------*
***INCLUDE Y_MD_SEL_TABCTRL_USER_COMMAI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF sy-ucomm = 'SUBMIT'.
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

*    REFRESH : it_final.

    LOOP AT it_hdr INTO wa_hdr.
      LOOP AT it_item INTO wa_item WHERE ino = wa_hdr-ino.
        wa_final-ino = wa_hdr-ino.
        wa_final-itype = wa_hdr-itype.
        wa_final-idate = wa_hdr-idate.
        wa_final-iitm = wa_item-iitm.
        wa_final-icost = wa_item-icost.
        wa_final-curr = wa_item-curr.
        APPEND wa_final TO it_final.
        CLEAR wa_final.
      ENDLOOP.
    ENDLOOP.


    IF it_final IS NOT INITIAL.

      SELECT inv_num inv_itemnum
      FROM yprcd
      INTO TABLE it_prcd1
      FOR ALL ENTRIES IN it_final
      WHERE inv_num = it_final-ino
      AND inv_itemnum = it_final-iitm.
    ENDIF.


    LOOP AT it_final INTO wa_final.
      lv_index = sy-tabix.
      READ TABLE it_prcd1 INTO wa_prcd1 WITH KEY ino = wa_final-ino
                                               iitm = wa_final-iitm.
      IF sy-subrc = 0.

        DELETE it_final INDEX lv_index.

      ENDIF.

    ENDLOOP.



  ENDIF.

  IF sy-ucomm = 'PROCESSED'.


    LOOP AT it_final INTO wa_final.
      IF wa_final-sel = 'X'.

        wa_prcd-inv_num = wa_final-ino.
        wa_prcd-inv_itemnum = wa_final-iitm.
        wa_prcd-item_cost = wa_final-icost.
        wa_prcd-curr = wa_final-curr.
        APPEND wa_prcd TO it_prcd.
      ENDIF.
    ENDLOOP.
    INSERT yprcd FROM TABLE it_prcd.
    IF sy-subrc = 0.
      MESSAGE i007(yoru).

    ENDIF.

  ENDIF.

ENDMODULE.
