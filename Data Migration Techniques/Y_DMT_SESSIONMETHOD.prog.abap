REPORT y_dmt_sessionmethod
       NO STANDARD PAGE HEADING LINE-SIZE 255.

PARAMETERS : p_file TYPE localfile.

TYPES : BEGIN OF ity_data,
          matnr TYPE matnr,
          mbrsh TYPE mbrsh,
          mtart TYPE mtart,
          maktx TYPE maktx,
          meins TYPE meins,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.
DATA : lv_file TYPE string.
DATA : it_bdcdata TYPE TABLE OF bdcdata,
       wa_bdcdata TYPE bdcdata.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.


START-OF-SELECTION.
  lv_file = p_file.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_file
*     FILETYPE                = 'ASC'
      has_field_separator     = 'X'
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*   IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = it_data
*   CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      client              = sy-mandt
*     DEST                = FILLER8
      group               = 'FEZ-01'
*     HOLDDATE            = FILLER8
      keep                = 'X'
      user                = sy-uname
*     RECORD              = FILLER1
*     PROG                = SY-CPROG
*     DCPFM               = '%'
*     DATFM               = '%'
*   IMPORTING
*     QID                 =
    EXCEPTIONS
      client_invalid      = 1
      destination_invalid = 2
      group_invalid       = 3
      group_is_locked     = 4
      holddate_invalid    = 5
      internal_error      = 6
      queue_error         = 7
      running             = 8
      system_lock_error   = 9
      user_invalid        = 10
      OTHERS              = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


* Include bdcrecx1_s:
* The call transaction using is called WITH AUTHORITY-CHECK!
* If you have own auth.-checks you can use include bdcrecx1 instead.
*  INCLUDE bdcrecx1_s.

START-OF-SELECTION.
  LOOP AT it_data INTO wa_data.
*perform open_group.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RMMG1-MTART'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'RMMG1-MATNR'
                                  wa_data-matnr.
    PERFORM bdc_field       USING 'RMMG1-MBRSH'
                                  wa_data-mbrsh.
    PERFORM bdc_field       USING 'RMMG1-MTART'
                                  wa_data-mtart.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MSICHTAUSW-DYTXT(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'MAKT-MAKTX'
                                  wa_data-maktx.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MARA-MEINS'.
    PERFORM bdc_field       USING 'MARA-MEINS'
                                  wa_data-meins.
    PERFORM bdc_field       USING 'MARA-MTPOS_MARA'
                                  'NORM'.
    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        tcode            = 'MM01'
*       POST_LOCAL       = NOVBLOCAL
*       PRINTING         = NOPRINT
*       SIMUBATCH        = ' '
*       CTUPARAMS        = ' '
      TABLES
        dynprotab        = it_bdcdata
      EXCEPTIONS
        internal_error   = 1
        not_open         = 2
        queue_error      = 3
        tcode_invalid    = 4
        printing_invalid = 5
        posting_invalid  = 6
        OTHERS           = 7.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    REFRESH it_bdcdata.
*perform bdc_transaction using 'MM01'.
*perform close_group.
  ENDLOOP.

  CALL FUNCTION 'BDC_CLOSE_GROUP'
    EXCEPTIONS
      not_open    = 1
      queue_error = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


FORM bdc_dynpro USING program dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.
