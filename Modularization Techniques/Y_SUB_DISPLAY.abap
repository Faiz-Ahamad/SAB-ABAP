*&---------------------------------------------------------------------*
*& Report Y_SUB_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_sub_display.

PARAMETERS p_ino TYPE yde_invno.


TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

TYPES : BEGIN OF ity_data1,
          ino   TYPE yde_invno,
          iitno TYPE yde_invitemnum,
          icost TYPE yde_cost,
          curr  TYPE yde_curr,
        END OF ity_data1.

DATA : it_data1 TYPE TABLE OF ity_data1,
       wa_data1 TYPE ity_data1.

DATA : it_final TYPE YTABSTR_DIS,
       wa_final TYPE ystr_dis.

PERFORM get_hdr USING p_ino CHANGING it_data.


IF it_data IS NOT INITIAL.
  PERFORM get_itm USING it_data CHANGING it_data1.
ENDIF.

PERFORM data_dis USING it_data it_data1 CHANGING it_final.

LOOP at it_final INTO wa_final.
  WRITE : / wa_final-ino , wa_final-itype, wa_final-idate,
            wa_final-itmno, wa_final-icost, wa_final-curr.
ENDLOOP.

INCLUDE y_sub_display_get_hdrf01.
