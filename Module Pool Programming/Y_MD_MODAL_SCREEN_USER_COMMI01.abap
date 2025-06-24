*----------------------------------------------------------------------*
***INCLUDE Y_MD_MODAL_SCREEN_USER_COMMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
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

  READ TABLE it_hdr INTO wa_hdr INDEX 1.
  IF sy-subrc = 0.
    yinv_hdr-inv_num = wa_hdr-ino.
    yinv_hdr-inv_type = wa_hdr-itype.
    yinv_hdr-inv_date = wa_hdr-idate.
  ENDIF.

  call  SCREEN '200' STARTING AT 10 20
                     ENDING AT 60 70.
ENDMODULE.
