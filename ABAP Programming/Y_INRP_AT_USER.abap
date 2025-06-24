*&---------------------------------------------------------------------*
*& Report Y_INRP_AT_USER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_inrp_at_user.


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
DATA : lv_ino TYPE yde_invno.

SELECT-OPTIONS : s_ino FOR lv_ino.

START-OF-SELECTION.
  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_data
  WHERE inv_num IN s_ino.

  LOOP AT it_data INTO wa_data.
    WRITE : / wa_data-ino , wa_data-itype , wa_data-idate.
  ENDLOOP.

*AT LINE-SELECTION.
*  SELECT inv_num inv_itemnum item_cost
*  FROM yinv_item
*  INTO TABLE it_data1
*  WHERE inv_num = sy-lisel+0(10).    "Using Substring we get the invoice number from the string.
*
*  LOOP AT it_data1 INTO wa_data1.
*    WRITE : / wa_data1-ino , wa_data1-iitm , wa_data1-icost.
*  ENDLOOP.

  SET PF-STATUS 'FUNCTION'.

AT USER-COMMAND.
  IF sy-ucomm = 'ASCENDING'.
    SORT it_data BY ino.
    LOOP AT it_data INTO wa_data.
      WRITE : / wa_data-ino , wa_data-itype , wa_data-idate.
    ENDLOOP.
  ENDIF.
  IF sy-ucomm = 'DESCENDING'.
    SORT it_data BY ino DESCENDING.
    LOOP AT it_data INTO wa_data.
      WRITE : / wa_data-ino , wa_data-itype , wa_data-idate.
    ENDLOOP.
  ENDIF.
