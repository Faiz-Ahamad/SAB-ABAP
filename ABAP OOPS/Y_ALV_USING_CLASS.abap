*&---------------------------------------------------------------------*
*& Report Y_ALV_USING_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_alv_using_class.

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

DATA : lt_fieldcat TYPE lvc_t_fcat.

DATA : lo_cont TYPE REF TO cl_gui_custom_container.
DATA : lo_grid TYPE REF TO cl_gui_alv_grid.

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

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
*   I_BUFFER_ACTIVE        =
    i_structure_name       = 'YSTR_DETAILS'
*   I_CLIENT_NEVER_DISPLAY = 'X'
*   I_BYPASSING_BUFFER     =
*   I_INTERNAL_TABNAME     =
  CHANGING
    ct_fieldcat            = lt_fieldcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CREATE OBJECT lo_cont EXPORTING container_name = 'C1'.

CREATE OBJECT lo_grid EXPORTING i_parent = lo_cont.

CALL METHOD lo_grid->set_table_for_first_display
*  EXPORTING
*    i_buffer_active               =
*    i_bypassing_buffer            =
*    i_consistency_check           =
*    i_structure_name              =
*    is_variant                    =
*    i_save                        =
*    i_default                     = 'X'
*    is_layout                     =
*    is_print                      =
*    it_special_groups             =
*    it_toolbar_excluding          =
*    it_hyperlink                  =
*    it_alv_graphics               =
*    it_except_qinfo               =
*    ir_salv_adapter               =
  CHANGING
    it_outtab                     = it_final
    it_fieldcatalog               = lt_fieldcat
*    it_sort                       =
*    it_filter                     =
  EXCEPTIONS
    invalid_parameter_combination = 1
    program_error                 = 2
    too_many_lines                = 3
    others                        = 4
        .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL SCREEN '100'.
