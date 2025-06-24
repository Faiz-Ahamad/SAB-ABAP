*&---------------------------------------------------------------------*
*& Report YFH_PRG3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfh_prg3.

DATA : lv_ino TYPE yde_invno.

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          loc   TYPE yde_loc,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

DATA : lv_filepath TYPE string VALUE '/tmp/invoice.txt'.
DATA : lv_string TYPE string.




* WRITING A FILE ON APPLICATION LAYER.

*SELECT-OPTIONS : s_ino FOR lv_ino.

*SELECT inv_num loc inv_type inv_date
*FROM yinv_hdr
*INTO TABLE it_data
*WHERE inv_num IN s_ino.
*OPEN DATASET lv_filepath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
*IF sy-subrc = 0.
*  LOOP AT it_data INTO wa_data.
*    CONCATENATE wa_data-ino wa_data-loc wa_data-itype wa_data-idate INTO lv_string SEPARATED BY '--'.
*    TRANSFER lv_string TO lv_filepath.
*  ENDLOOP.
*ENDIF.
*CLOSE DATASET lv_filepath.


* READING A FILE FROM APPLICATION LAYER.
OPEN DATASET lv_filepath FOR INPUT IN TEXT MODE ENCODING DEFAULT.
IF sy-subrc = 0.
  DO.
    READ DATASET lv_filepath INTO lv_string.
    IF sy-subrc = 0.
      SPLIT lv_string AT '--' INTO wa_data-ino wa_data-loc wa_data-itype wa_data-idate.
      APPEND wa_data TO it_data.
      CLEAR wa_data.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
  CLOSE DATASET lv_filepath.
ENDIF.

LOOP AT it_data INTO wa_data.
  WRITE : / wa_data-ino, wa_data-loc, wa_data-itype, wa_data-idate.
ENDLOOP.
