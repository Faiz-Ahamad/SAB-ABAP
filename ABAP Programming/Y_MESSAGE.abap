*&---------------------------------------------------------------------*
*& Report Y_MESSAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_message.


PARAMETERS p_ino TYPE yde_invno.

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.


SELECT inv_num inv_type inv_date
FROM yinv_hdr
INTO TABLE it_data
WHERE inv_num = p_ino.

IF sy-subrc <> 0.
  MESSAGE i000(yoru) WITH p_ino.
ENDIF.


LOOP AT it_data INTO wa_data.
  WRITE : / wa_data-ino, wa_data-itype ,wa_data-idate.
ENDLOOP.
