*&---------------------------------------------------------------------*
*& Report Y_ALV_BY_SALV_TABLE_DC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_by_salv_table_dc.

TABLES : vbak.

SELECT-OPTIONS : s_vbeln FOR vbak-vbeln.

TYPES : BEGIN OF ity_vbak,
          vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          erzet TYPE erzet,
          ernam TYPE ernam,
        END OF ity_vbak.

DATA : it_vbak TYPE TABLE OF ity_vbak,
       wa_vbak TYPE ity_vbak.

TYPES : BEGIN OF ity_vbap,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr,
          matnr TYPE matnr,
        END OF ity_vbap.

DATA : it_vbap TYPE TABLE OF ity_vbap,
       wa_vbap TYPE ity_vbap.

DATA : lo_alv1 TYPE REF TO cl_salv_table.
DATA : lo_alv2 TYPE REF TO cl_salv_table.
DATA : lo_functions TYPE REF TO cl_salv_functions_list.
DATA : lo_events TYPE REF TO cl_salv_events_table.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS handler FOR EVENT double_click OF cl_salv_events_table IMPORTING row.
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD handler.
    READ TABLE it_vbak INTO wa_vbak INDEX row.
    IF sy-subrc = 0.

      SELECT vbeln posnr matnr
      FROM vbap
      INTO TABLE it_vbap
      WHERE vbeln = wa_vbak-vbeln.

    ENDIF.
    TRY.
        CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
          IMPORTING
            r_salv_table = lo_alv2
          CHANGING
            t_table      = it_vbap.
      CATCH cx_salv_msg .
    ENDTRY.
    CALL METHOD lo_alv1->get_functions
      RECEIVING
        value = lo_functions.

    CALL METHOD lo_functions->set_all
      EXPORTING
        value = if_salv_c_bool_sap=>true.

    CALL METHOD lo_alv2->display.
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
  SELECT vbeln erdat erzet ernam
  FROM vbak
  INTO TABLE it_vbak
  WHERE vbeln IN s_vbeln.

  TRY.
      CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
        IMPORTING
          r_salv_table = lo_alv1
        CHANGING
          t_table      = it_vbak.
    CATCH cx_salv_msg .
  ENDTRY.

  CALL METHOD lo_alv1->get_functions
    RECEIVING
      value = lo_functions.

  CALL METHOD lo_functions->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  CALL METHOD lo_alv1->get_event
    RECEIVING
      value = lo_events.

  DATA : lo_object TYPE REF TO class1.
  CREATE OBJECT lo_object.
  SET HANDLER lo_object->handler FOR lo_events.

  CALL METHOD lo_alv1->display.
