*----------------------------------------------------------------------*
***INCLUDE Y_MD_INTEGRATION_USER_COMMAI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  IF r1 = 'X'.
    CALL TRANSACTION 'YMD1'.
  ENDIF.
  IF r2 = 'X'.
    CALL TRANSACTION 'ZTC_2'.
  ENDIF.
  IF r3 = 'X'.
    CALL TRANSACTION 'YMD2'.
  ENDIF.
  IF r4 = 'X'.
    CALL TRANSACTION 'YMD3'.
  ENDIF.
ENDMODULE.
