*&---------------------------------------------------------------------*
*& Report Y_INTERNAL_TABLES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_internal_tables.


TYPES : BEGIN OF ity_data,
          inv_no   TYPE yde_invno,
          inv_type TYPE yde_invtype,
          inv_date TYPE yde_invdate,
        END OF ity_data.
DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

wa_data-inv_no = 12.
wa_data-inv_type = 'INV'.
wa_data-inv_date = '20250604'.
APPEND wa_data TO it_data.

wa_data-inv_no = 10.
wa_data-inv_type = 'CRE'.
wa_data-inv_date = '20250603'.
APPEND wa_data TO it_data.

wa_data-inv_no = 1.
wa_data-inv_type = 'DEB'.
wa_data-inv_date = '20250603'.
INSERT wa_data INTO it_data INDEX 1.

wa_data-inv_no = 5.
wa_data-inv_type = 'CRE'.
wa_data-inv_date = '20250603'.
APPEND wa_data TO it_data.

wa_data-inv_no = 2.
wa_data-inv_type = 'DEB'.
wa_data-inv_date = '20250603'.
APPEND wa_data TO it_data.

SORT it_data BY inv_no.

*READ TABLE it_data INTO wa_data WITH KEY inv_type = 'CRE'.
*IF sy-subrc = 0.
*write : wa_data-inv_no ,wa_data-inv_type, wa_data-inv_date.
*ENDIF.

*MODIFY
LOOP AT it_data INTO wa_data.
  IF wa_data-inv_no = '2'.
    wa_data-inv_type = 'INV'.
    MODIFY it_data FROM wa_data TRANSPORTING inv_type.
  ENDIF.
ENDLOOP.



LOOP AT it_data INTO wa_data.
  WRITE / wa_data-inv_no.
  WRITE wa_data-inv_type.
  WRITE wa_data-inv_date.
*  WRITE / .
ENDLOOP.


DATA lv_lines(2) TYPE n.
DESCRIBE TABLE it_data LINES lv_lines.
WRITE :/ 'Number of records :',lv_lines.
