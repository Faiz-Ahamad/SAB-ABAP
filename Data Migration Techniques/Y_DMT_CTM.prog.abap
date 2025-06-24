REPORT y_dmt_prg1
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
DATA : it_messtab TYPE TABLE OF bdcmsgcoll,
       wa_messtab TYPE bdcmsgcoll.
DATA : lv_msg TYPE string.

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


* Include bdcrecx1_s:
* The call transaction using is called WITH AUTHORITY-CHECK!
* If you have own auth.-checks you can use include bdcrecx1 instead.
*  INCLUDE bdcrecx1_s.
*
*start-of-selection.
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
                                  '/00'.
    PERFORM bdc_field       USING 'MAKT-MAKTX'
                                  wa_data-maktx.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MARA-MEINS'.
    PERFORM bdc_field       USING 'MARA-MEINS'
                                  wa_data-meins.
    PERFORM bdc_field       USING 'MARA-MTPOS_MARA'
                                  'NORM'.
    PERFORM bdc_dynpro      USING 'SAPLSPO1' '0300'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=YES'.

    CALL TRANSACTION 'MM01' USING it_bdcdata
                            MODE 'E'
                            UPDATE 'S'
                            MESSAGES INTO it_messtab.
    REFRESH it_bdcdata.
*    PERFORM bdc_transaction USING 'MM01'.
*perform close_group.
  ENDLOOP.

  LOOP AT it_messtab INTO wa_messtab.
    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = wa_messtab-msgid
        msgnr               = wa_messtab-msgnr
        msgv1               = wa_messtab-msgv1
        msgv2               = wa_messtab-msgv2
        msgv3               = wa_messtab-msgv3
        msgv4               = wa_messtab-msgv4
      IMPORTING
        message_text_output = lv_msg.
    WRITE : / lv_msg.
  ENDLOOP.

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
