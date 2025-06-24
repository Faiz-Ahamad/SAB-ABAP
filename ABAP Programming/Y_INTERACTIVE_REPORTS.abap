*&---------------------------------------------------------------------*
*& Report Y_INTERACTIVE_REPORTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_interactive_reports.

TYPES : BEGIN OF ity_data,
          ino   TYPE yde_invno,
          itype TYPE yde_invtype,
          idate TYPE yde_invdate,
        END OF ity_data.
TYPES : BEGIN OF ity_data1,
          ino   TYPE yde_invno,
          iitm  TYPE yde_invitemnum,
          icost TYPE yde_cost,
        END OF ity_data1.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.
DATA : it_data1 TYPE TABLE OF ity_data1,
       wa_data1 TYPE ity_data1.
DATA : lv_ino       TYPE yde_invno,
       lv_field(30) TYPE c,
       lv_value(30) TYPE c.


SELECT-OPTIONS : s_ino FOR lv_ino.

START-OF-SELECTION.
  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_data
  WHERE inv_num IN s_ino.

  LOOP AT it_data INTO wa_data.
    WRITE : / wa_data-ino UNDER TEXT-000,
              wa_data-itype UNDER TEXT-001,
              wa_data-idate UNDER TEXT-002.
*    HIDE : wa_data-ino , wa_data-itype , wa_data-idate.
  ENDLOOP.


AT LINE-SELECTION.


* BY USING SY_LISEL

*  SELECT inv_num inv_itemnum item_cost
*  FROM yinv_item
*  INTO TABLE it_data1
*  WHERE inv_num = sy-lisel+0(10).    "Using Substring we get the invoice number from the string.
*
*  LOOP AT it_data1 INTO wa_data1.
*    WRITE : / wa_data1-ino , wa_data1-iitm , wa_data1-icost.
*  ENDLOOP.



* BY USING HIDE STATEMENT

*  SELECT inv_num inv_itemnum item_cost
*  FROM yinv_item
*  INTO TABLE it_data1
*  WHERE inv_num = wa_data-ino.
*
*  LOOP AT it_data1 INTO wa_data1.
*    WRITE : / wa_data1-ino , wa_data1-iitm , wa_data1-icost.
*  ENDLOOP.


*BY USING GET CURSOR FIELD.

  GET CURSOR FIELD lv_field VALUE lv_value.

  IF lv_field = 'WA_DATA-INO'.

    SELECT inv_num inv_itemnum item_cost
    FROM yinv_item
    INTO TABLE it_data1
    WHERE inv_num = lv_value.

    LOOP AT it_data1 INTO wa_data1.
      WRITE : / wa_data1-ino UNDER TEXT-000 ,
                wa_data1-iitm UNDER TEXT-003,
                wa_data1-icost UNDER TEXT-004.
    ENDLOOP.
  ELSE.
    MESSAGE i003(yoru).
  ENDIF.

TOP-OF-PAGE.
  WRITE : TEXT-000 , 16 TEXT-001 , 29 TEXT-002 .

TOP-OF-PAGE DURING LINE-SELECTION.
  WRITE : TEXT-000 , TEXT-003, TEXT-004.
