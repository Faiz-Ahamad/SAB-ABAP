*&---------------------------------------------------------------------*
*& Report YFH_MULTIPLEFILES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfh_multiplefiles.

PARAMETERS : p_dir(20) TYPE c DEFAULT '/tmp'.

DATA : it_data TYPE TABLE OF yinv_hdr,
       wa_data TYPE yinv_hdr.

DATA : it_files TYPE TABLE OF salfldir.
DATA : wa_files TYPE salfldir.
DATA : lv_dir TYPE salfile-longname.
DATA : lv_filename TYPE string.
DATA : lv_string TYPE string.
DATA : lv_ino   TYPE string,
       lv_iloc  TYPE string,
       lv_itype TYPE string,
       lv_idate TYPE string.

START-OF-SELECTION.

  lv_dir = p_dir.
  TRANSLATE lv_dir TO LOWER CASE.

  CALL FUNCTION 'RZL_READ_DIR_LOCAL'
    EXPORTING
      name               = lv_dir
*     FROMLINE           = 0
*     NRLINES            = 1000
    TABLES
      file_tbl           = it_files
    EXCEPTIONS
      argument_error     = 1
      not_found          = 2
      no_admin_authority = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DELETE it_files WHERE name NP 'INV-*'.

  LOOP AT it_files INTO wa_files.
    CONCATENATE lv_dir '/' wa_files-name INTO lv_filename.
    OPEN DATASET lv_filename FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DO.
        READ DATASET lv_filename INTO lv_string.
        IF sy-subrc = 0.
          SPLIT lv_string AT cl_abap_char_utilities=>horizontal_tab INTO lv_ino lv_iloc lv_itype lv_idate.
          wa_data-inv_num   = lv_ino.
          wa_data-loc       = lv_iloc.
          wa_data-inv_type  = lv_itype.
          wa_data-inv_date  = lv_idate.
          APPEND wa_data TO it_data.
          CLEAR wa_data.

        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
      CLOSE DATASET lv_filename.
    ENDIF.
    IF it_data IS NOT INITIAL.
      DELETE it_data INDEX 1.
      INSERT yinv_hdr_temp FROM TABLE it_data.
      IF sy-subrc = 0 .
        WRITE : 'Processed the file sucessfully ' ,lv_filename.
      ELSE.
        WRITE : 'Processing the file failed!!! ', lv_filename.
      ENDIF.
      REFRESH it_data.

    ENDIF.

  ENDLOOP.
