*&---------------------------------------------------------------------*
*& Report Y_CL1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_cl2.

DATA : lv_object TYPE REF TO y_cl1.
create OBJECT lv_object.

DATA : lv_vbeln TYPE vbeln_va.

select-OPTIONS : s_vbeln FOR lv_vbeln.

DATA : lt_final TYPE ytstr_details,
       wa_final TYPE ystr_details.

CALL METHOD lv_object->get_data_select
  EXPORTING
    svbeln    = s_vbeln[]
  IMPORTING
    lt_output = lt_final
    .



LOOP AT lt_final INTO wa_final.
  WRITE : / wa_final-vbeln, wa_final-erdat, wa_final-erzet,
            wa_final-ernam, wa_final-posnr, wa_final-matnr.

ENDLOOP.
