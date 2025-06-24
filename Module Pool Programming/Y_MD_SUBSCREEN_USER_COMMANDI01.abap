*----------------------------------------------------------------------*
***INCLUDE Y_MD_SUBSCREEN_USER_COMMANDI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.



  select inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_hdr
  WHERE inv_num = yinv_hdr-inv_num.

  READ TABLE it_hdr INTO wa_hdr INDEX 1.
  IF SY-SUBRC = 0.
    yinv_hdr-inv_num = wa_hdr-ino.
    yinv_hdr-inv_type = wa_hdr-itype.
    yinv_hdr-inv_date = wa_hdr-idate.
  ENDIF.


ENDMODULE.
