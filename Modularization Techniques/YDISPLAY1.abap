*&---------------------------------------------------------------------*
*& Report Y_DISPLAY1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Y_DISPLAY1.

DATA :lv_ino TYPE yde_invno.

select-OPTIONS : s_ino FOR lv_ino.

DATA : it_output TYPE ytabstr_dis,
       wa_output TYPE ystr_dis.

CALL FUNCTION 'YDISPLAY1'
  EXPORTING
    sino           = s_ino[]
 IMPORTING
   LT_FINAL       = it_output
          .


LOOP AT it_output INTO wa_output.
  WRITE : / wa_output-ino ,
            wa_output-itype,
            wa_output-idate,
            wa_output-itmno,
            wa_output-icost,
            wa_output-curr.
ENDLOOP.
