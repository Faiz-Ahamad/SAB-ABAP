*&---------------------------------------------------------------------*
*& Report YFH_PRG2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfh_prg2.

DATA : lv_ino TYPE yde_invno.

SELECT-OPTIONS : s_ino FOR lv_ino.

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          loc   TYPE yde_loc,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

SELECT inv_num loc inv_type inv_date
FROM yinv_hdr
INTO TABLE it_data
WHERE inv_num IN s_ino.

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
*   BIN_FILESIZE            =
    filename                = '‪‪G:\Invoice.txt'
*   FILETYPE                = 'ASC'
*   APPEND                  = 'X'
    write_field_separator   = 'X'
*   HEADER                  = '00'
*   TRUNC_TRAILING_BLANKS   = ' '
*   WRITE_LF                = 'X'
*   COL_SELECT              = ' '
*   COL_SELECT_MASK         = ' '
*   DAT_MODE                = ' '
*   CONFIRM_OVERWRITE       = ' '
*   NO_AUTH_CHECK           = ' '
*   CODEPAGE                = ' '
*   IGNORE_CERR             = ABAP_TRUE
*   REPLACEMENT             = '#'
*   WRITE_BOM               = ' '
*   TRUNC_TRAILING_BLANKS_EOL       = 'X'
*   WK1_N_FORMAT            = ' '
*   WK1_N_SIZE              = ' '
*   WK1_T_FORMAT            = ' '
*   WK1_T_SIZE              = ' '
*   WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*   SHOW_TRANSFER_STATUS    = ABAP_TRUE
*   VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
* IMPORTING
*   FILELENGTH              =
  TABLES
    data_tab                = it_data
*   FIELDNAMES              =
  EXCEPTIONS
    file_write_error        = 1
    no_batch                = 2
    gui_refuse_filetransfer = 3
    invalid_type            = 4
    no_authority            = 5
    unknown_error           = 6
    header_not_allowed      = 7
    separator_not_allowed   = 8
    filesize_not_allowed    = 9
    header_too_long         = 10
    dp_error_create         = 11
    dp_error_send           = 12
    dp_error_write          = 13
    unknown_dp_error        = 14
    access_denied           = 15
    dp_out_of_memory        = 16
    disk_full               = 17
    dp_timeout              = 18
    file_not_found          = 19
    dataprovider_exception  = 20
    control_flush_error     = 21
    OTHERS                  = 22.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
