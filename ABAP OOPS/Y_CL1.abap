*&---------------------------------------------------------------------*
*& Report Y_CL1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_cl1.

DATA : lv_object TYPE REF TO y_cl1.


PARAMETERS : p_vbeln TYPE vbeln_va.

DATA : lt_final TYPE ytstr_details,
       wa_final TYPE ystr_details.


CREATE OBJECT lv_object.

CALL METHOD lv_object->get_data
  EXPORTING
    pvbeln    = p_vbeln
  IMPORTING
    lt_output = lt_final.



LOOP AT lt_final INTO wa_final.
  WRITE : / wa_final-vbeln, wa_final-erdat, wa_final-erzet,
            wa_final-ernam, wa_final-posnr, wa_final-matnr.

ENDLOOP.
