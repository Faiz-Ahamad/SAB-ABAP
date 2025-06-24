*&---------------------------------------------------------------------*
*& Report Y_ALV_BY_SALV_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_by_salv_table.

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

DATA : it_final TYPE TABLE OF ystr_details,
       wa_final TYPE ystr_details.

DATA : lo_alv TYPE REF TO CL_SALV_TABLE.
DATA : lo_functions TYPE REF TO CL_SALV_FUNCTIONS_LIST.
DATA : lo_columns TYPE REF TO CL_SALV_COLUMNS_TABLE.
DATA : lo_column TYPE REF TO CL_SALV_COLUMN.
DATA : lo_sorts TYPE REF TO CL_SALV_SORTS.
DATA : lo_filters TYPE REF TO CL_SALV_FILTERS.

SELECT vbeln erdat erzet ernam
FROM vbak
INTO TABLE it_vbak
WHERE vbeln IN s_vbeln.

IF it_vbak IS NOT INITIAL.

  SELECT vbeln posnr matnr
  FROM vbap
  INTO TABLE it_vbap
  FOR ALL ENTRIES IN it_vbak
  WHERE vbeln = it_vbak-vbeln.

ENDIF.

LOOP AT it_vbak INTO wa_vbak.
  LOOP AT it_vbap INTO wa_vbap.

    wa_final-vbeln = wa_vbak-vbeln.
    wa_final-erdat = wa_vbak-erdat.
    wa_final-erzet = wa_vbak-erzet.
    wa_final-ernam = wa_vbak-ernam.
    wa_final-posnr = wa_vbap-posnr.
    wa_final-matnr = wa_vbap-matnr.

    APPEND wa_final TO it_final.
    CLEAR : wa_final.

  ENDLOOP.

ENDLOOP.

TRY.
CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
  IMPORTING
    r_salv_table   = lo_alv
  CHANGING
    t_table        = it_final
    .
 CATCH cx_salv_msg .
ENDTRY.

CALL METHOD lo_alv->get_functions
  RECEIVING
    value  = lo_functions
    .

CALL METHOD lo_functions->set_all
  EXPORTING
    value  = IF_SALV_C_BOOL_SAP=>TRUE
    .

CALL METHOD lo_alv->get_columns
  RECEIVING
    value  = lo_columns
    .

CALL METHOD lo_columns->set_column_position
  EXPORTING
    columnname = 'ERZET'
    position   = 2
    .

CALL METHOD lo_columns->set_column_position
  EXPORTING
    columnname = 'ERDAT'
    position   = 3
    .

TRY.
CALL METHOD lo_columns->get_column
  EXPORTING
    columnname = 'VBELN'
  receiving
    value      = lo_column
    .
 CATCH cx_salv_not_found .
ENDTRY.

CALL METHOD lo_column->set_long_text
  EXPORTING
    value  = 'Document Number'
    .

CALL METHOD lo_alv->get_sorts
  RECEIVING
    value  = lo_sorts
    .

TRY.
CALL METHOD lo_sorts->add_sort
  EXPORTING
    columnname = 'POSNR'
*    position   =
    sequence   = IF_SALV_C_SORT=>SORT_DOWN
*    subtotal   = IF_SALV_C_BOOL_SAP=>FALSE
*    group      = IF_SALV_C_SORT=>GROUP_NONE
*    obligatory = IF_SALV_C_BOOL_SAP=>FALSE
*  receiving
*    value      =
    .
 CATCH cx_salv_not_found .
 CATCH cx_salv_existing .
 CATCH cx_salv_data_error .
ENDTRY.

CALL METHOD lo_alv->get_filters
  RECEIVING
    value  = lo_filters
    .

TRY.
CALL METHOD lo_filters->add_filter
  EXPORTING
    columnname = 'ERNAM'
    sign       = 'I'
    option     = 'EQ'
    low        = 'CURA'
*    high       =
*  receiving
*    value      =
    .
 CATCH cx_salv_not_found .
 CATCH cx_salv_data_error .
 CATCH cx_salv_existing .
ENDTRY.








CALL METHOD lo_alv->display
    .
