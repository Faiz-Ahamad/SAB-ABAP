*&---------------------------------------------------------------------*
*& Report Y_EVENTS_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_events_1.

DATA lv_ino TYPE yde_invno.

*PARAMETERS : p_ino TYPE yde_invno.

SELECT-OPTIONS : s_ino FOR lv_ino .

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
          iitm  TYPE yde_invitemnum,
          icost TYPE yde_cost,
          icurr TYPE yde_curr,
        END OF ity_data.

TYPES : BEGIN OF ity_data1,
          ino   TYPE yde_invno,
          iitm  TYPE yde_invitemnum,
          icost TYPE yde_cost,
          icurr TYPE yde_curr,
        END OF ity_data1.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

DATA : it_data1 TYPE TABLE OF ity_data1,
       wa_data1 TYPE ity_data1.


* FOR ALL ENTRIES IN


*SELECT inv_num inv_type inv_date
*FROM yinv_hdr
*INTO TABLE it_data
*WHERE inv_num IN s_ino.
*
*IF it_data IS NOT INITIAL.
*  SELECT inv_num inv_itemnum item_cost curr
*  FROM yinv_item
*  INTO TABLE it_data1
*  FOR ALL ENTRIES IN it_data
*  WHERE inv_num = it_data-ino.
*ENDIF.
*
*LOOP AT it_data INTO wa_data.
*  WRITE : / wa_data-ino, wa_data-itype ,wa_data-idate.
*ENDLOOP.
*
*DO 2 TIMES.
*  WRITE / .
*ENDDO.
*
*LOOP AT it_data1 INTO wa_data1.
*  WRITE :/ wa_data1-ino, wa_data1-iitm, wa_data1-icost, wa_data1-icurr.
*ENDLOOP.



* JOINS


SELECT a~inv_num a~inv_type a~inv_date b~inv_itemnum b~item_cost b~curr
FROM yinv_hdr AS a
JOIN yinv_item AS b
ON a~inv_num = b~inv_num
INTO TABLE it_data
WHERE a~inv_num IN s_ino.

WRITE sy-uline(115).
WRITE :/ sy-vline ,TEXT-000,
         19 sy-vline, TEXT-001,
         36 sy-vline, TEXT-002,
         49 sy-vline, TEXT-003,
         73 sy-vline, TEXT-004,
         95 sy-vline ,TEXT-005,
         115 sy-vline.
WRITE sy-uline(115).

LOOP AT it_data INTO wa_data.
  WRITE : / sy-vline ,wa_data-ino UNDER TEXT-000,
            19 sy-vline,wa_data-itype UNDER TEXT-001,
            36 sy-vline,wa_data-idate UNDER TEXT-002,
            49 sy-vline,wa_data-iitm UNDER TEXT-003,
            73 sy-vline,wa_data-icost UNDER TEXT-004,
            95 sy-vline,wa_data-icurr UNDER TEXT-005,
            115 sy-vline.
  WRITE sy-uline(115).
ENDLOOP.
