*&---------------------------------------------------------------------*
*& Report Y_CL_SELECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_cl_select.


DATA : lv_vbeln TYPE vbeln_va.

SELECT-OPTIONS : s_vbeln FOR lv_vbeln.

DATA : lo_object TYPE REF TO y_cl1.
CREATE OBJECT lo_object.

DATA : lt_final TYPE ytstr_details.

CALL METHOD lo_object->get_data_select
  EXPORTING
    svbeln    = s_vbeln[]
  IMPORTING
    lt_output = lt_final.
