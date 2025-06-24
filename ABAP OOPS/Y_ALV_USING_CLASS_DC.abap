*&---------------------------------------------------------------------*
*& Report Y_ALV_USING_CLASS_DC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_using_class_dc.

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


DATA : it_fldcat_vbak TYPE lvc_t_fcat,
       wa_fldcat_vbak TYPE lvc_s_fcat,
       it_fldcat_vbap TYPE lvc_t_fcat,
       wa_fldcat_vbap TYPE lvc_s_fcat.

DATA : lv_cont1 TYPE REF TO cl_gui_custom_container,
       lv_cont2 TYPE REF TO cl_gui_custom_container.

DATA : lv_grid1 TYPE REF TO cl_gui_alv_grid,
       lv_grid2 TYPE REF TO cl_gui_alv_grid.

DATA : it_rows TYPE lvc_t_row,
       wa_rows TYPE lvc_s_row.

CLASS class1 DEFINITION.
  PUBLIC SECTION.
    METHODS handle FOR EVENT double_click OF cl_gui_alv_grid.
ENDCLASS.

CLASS class1 IMPLEMENTATION.
  METHOD handle.
    CALL METHOD lv_grid1->get_selected_rows
      IMPORTING
        et_index_rows = it_rows.

    READ TABLE it_rows INTO wa_rows INDEX 1.
    IF sy-subrc = 0.

      READ TABLE it_vbak INTO wa_vbak INDEX wa_rows-index.
      IF sy-subrc = 0.

        SELECT vbeln posnr matnr
        FROM vbap
        INTO TABLE it_vbap
        WHERE vbeln = wa_vbak-vbeln.

      ENDIF.

    ENDIF.
    CALL METHOD lv_grid2->set_table_for_first_display
      CHANGING
        it_outtab       = it_vbap
        it_fieldcatalog = it_fldcat_vbap
*       it_sort         =
*       it_filter       =
    EXCEPTIONS
       invalid_parameter_combination = 1
       program_error   = 2
       too_many_lines  = 3
       others          = 4
      .
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.


  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  SELECT vbeln erdat erzet ernam
  FROM vbak
  INTO TABLE it_vbak
  WHERE vbeln IN s_vbeln.

  wa_fldcat_vbak-col_pos = 1.
  wa_fldcat_vbak-fieldname = 'VBELN'.
  wa_fldcat_vbak-tabname = 'IT_VBAK'.
  wa_fldcat_vbak-scrtext_l = 'Document Number'.
  APPEND wa_fldcat_vbak TO it_fldcat_vbak.
  CLEAR : wa_fldcat_vbak.

  wa_fldcat_vbak-col_pos = 2.
  wa_fldcat_vbak-fieldname = 'ERDAT'.
  wa_fldcat_vbak-tabname = 'IT_VBAK'.
  wa_fldcat_vbak-scrtext_l = 'Date'.
  APPEND wa_fldcat_vbak TO it_fldcat_vbak.
  CLEAR : wa_fldcat_vbak.

  wa_fldcat_vbak-col_pos = 3.
  wa_fldcat_vbak-fieldname = 'ERZET'.
  wa_fldcat_vbak-tabname = 'IT_VBAK'.
  wa_fldcat_vbak-scrtext_l = 'Time'.
  APPEND wa_fldcat_vbak TO it_fldcat_vbak.
  CLEAR : wa_fldcat_vbak.

  wa_fldcat_vbak-col_pos = 4.
  wa_fldcat_vbak-fieldname = 'ERNAM'.
  wa_fldcat_vbak-tabname = 'IT_VBAK'.
  wa_fldcat_vbak-scrtext_l = 'Name'.
  APPEND wa_fldcat_vbak TO it_fldcat_vbak.
  CLEAR : wa_fldcat_vbak.



  CREATE OBJECT lv_cont1 EXPORTING container_name = 'CONT1'.
  CREATE OBJECT lv_grid1 EXPORTING i_parent = lv_cont1.
  CALL METHOD lv_grid1->set_table_for_first_display
    CHANGING
      it_outtab                     = it_vbak
      it_fieldcatalog               = it_fldcat_vbak
*     it_sort                       =
*     it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  wa_fldcat_vbap-col_pos = 1.
  wa_fldcat_vbap-fieldname = 'VBELN'.
  wa_fldcat_vbap-tabname = 'IT_VBAP'.
  wa_fldcat_vbap-scrtext_l = 'Document Number'.
  APPEND wa_fldcat_vbap TO it_fldcat_vbap.
  CLEAR : wa_fldcat_vbap.

  wa_fldcat_vbap-col_pos = 2.
  wa_fldcat_vbap-fieldname = 'POSNR'.
  wa_fldcat_vbap-tabname = 'IT_VBAP'.
  wa_fldcat_vbap-scrtext_l = 'Item Number'.
  APPEND wa_fldcat_vbap TO it_fldcat_vbap.
  CLEAR : wa_fldcat_vbap.

  wa_fldcat_vbap-col_pos = 3.
  wa_fldcat_vbap-fieldname = 'MATNR'.
  wa_fldcat_vbap-tabname = 'IT_VBAP'.
  wa_fldcat_vbap-scrtext_l = 'Material Number'.
  APPEND wa_fldcat_vbap TO it_fldcat_vbap.
  CLEAR : wa_fldcat_vbap.



  CREATE OBJECT lv_cont2 EXPORTING container_name = 'CONT2'.
  CREATE OBJECT lv_grid2 EXPORTING i_parent = lv_cont2.
  CALL METHOD lv_grid2->set_table_for_first_display
    CHANGING
      it_outtab       = it_vbap
      it_fieldcatalog = it_fldcat_vbap
*     it_sort         =
*     it_filter       =
*    EXCEPTIONS
*     invalid_parameter_combination = 1
*     program_error   = 2
*     too_many_lines  = 3
*     others          = 4
    .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

  DATA : lv_object TYPE REF TO class1.
  CREATE OBJECT lv_object.
  SET HANDLER lv_object->handle FOR lv_grid1.


  CALL SCREEN '100'.
