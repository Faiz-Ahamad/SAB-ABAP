*&---------------------------------------------------------------------*
*& Report Y_DMT_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_dmt_bapi.

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
DATA : wa_headdata TYPE bapimathead.
DATA : wa_clientdata TYPE bapi_mara.
DATA : wa_clientdatax TYPE bapi_marax.
DATA : it_return TYPE TABLE OF bapiret2,
       wa_return TYPE bapiret2.
DATA : it_matdesc TYPE TABLE OF bapi_makt,
       wa_matdesc TYPE bapi_makt.


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

  LOOP AT it_data INTO wa_data.

    wa_headdata-material = wa_data-matnr.
    wa_headdata-ind_sector = wa_data-mbrsh.
    wa_headdata-matl_type = wa_data-mtart.
    wa_headdata-basic_view = 'X'.

    wa_clientdata-base_uom = wa_data-meins.
    wa_clientdatax-base_uom = 'X'.

    wa_matdesc-langu = sy-langu.
    wa_matdesc-matl_desc = wa_data-maktx.
    APPEND wa_matdesc TO it_matdesc.


    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata            = wa_headdata
        clientdata          = wa_clientdata
        clientdatax         = wa_clientdatax
*       PLANTDATA           =
*       PLANTDATAX          =
*       FORECASTPARAMETERS  =
*       FORECASTPARAMETERSX =
*       PLANNINGDATA        =
*       PLANNINGDATAX       =
*       STORAGELOCATIONDATA =
*       STORAGELOCATIONDATAX       =
*       VALUATIONDATA       =
*       VALUATIONDATAX      =
*       WAREHOUSENUMBERDATA =
*       WAREHOUSENUMBERDATAX       =
*       SALESDATA           =
*       SALESDATAX          =
*       STORAGETYPEDATA     =
*       STORAGETYPEDATAX    =
*       FLAG_ONLINE         = ' '
*       FLAG_CAD_CALL       = ' '
*       NO_DEQUEUE          = ' '
*       NO_ROLLBACK_WORK    = ' '
      IMPORTING
        return              = wa_return
      TABLES
        materialdescription = it_matdesc
*       UNITSOFMEASURE      =
*       UNITSOFMEASUREX     =
*       INTERNATIONALARTNOS =
*       MATERIALLONGTEXT    =
*       TAXCLASSIFICATIONS  =
*       RETURNMESSAGES      =
*       PRTDATA             =
*       PRTDATAX            =
*       EXTENSIONIN         =
*       EXTENSIONINX        =
      .
    APPEND wa_return TO it_return.
    CLEAR : wa_headdata, wa_clientdata, wa_clientdatax.
    REFRESH : it_matdesc.
  ENDLOOP.


  LOOP AT it_return INTO wa_return.

    WRITE : / wa_return-message.

  ENDLOOP.
