*&---------------------------------------------------------------------*
*& Report Y_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_display.

PARAMETERS:  lv_ino TYPE yde_invno.
DATA : it_output TYPE ytabstr_dis,
       wa_output TYPE ystr_dis.

CALL FUNCTION 'YDISPLAY'
  EXPORTING
    p_ino    = lv_ino
  IMPORTING
    lt_final = it_output.

LOOP AT it_output INTO wa_output.
  WRITE : / wa_output-ino ,
            wa_output-itype,
            wa_output-idate,
            wa_output-itmno,
            wa_output-icost,
            wa_output-curr.
ENDLOOP.
