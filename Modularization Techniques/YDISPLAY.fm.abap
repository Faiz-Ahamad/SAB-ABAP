FUNCTION ydisplay.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_INO) TYPE  YDE_INVNO
*"  EXPORTING
*"     REFERENCE(LT_FINAL) TYPE  YTABSTR_DIS
*"----------------------------------------------------------------------


  TYPES : BEGIN OF ity_data,
            ino   TYPE yde_invno,
            itype TYPE yde_invtype,
            idate TYPE yde_invdate,
          END OF ity_data.

  DATA : it_data TYPE TABLE OF ity_data,
         wa_data TYPE ity_data.

  TYPES : BEGIN OF ity_data1,
            ino   TYPE yde_invno,
            iitno TYPE yde_invitemnum,
            icost TYPE yde_cost,
            curr  TYPE yde_curr,
          END OF ity_data1.

  DATA : it_data1 TYPE TABLE OF ity_data1,
         wa_data1 TYPE ity_data1.

  DATA : wa_final TYPE ystr_dis.


  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE it_data
  WHERE inv_num = P_INO.

  IF it_data IS NOT INITIAL.
    SELECT inv_num inv_itemnum item_cost curr
    FROM yinv_item
    INTO TABLE it_data1
    FOR ALL ENTRIES IN it_data
    WHERE inv_num = it_data-ino.
  ENDIF.

  LOOP AT it_data INTO wa_data.
    LOOP AT it_data1 INTO wa_data1 WHERE ino = wa_data-ino.
      wa_final-ino =   wa_data-ino.
      wa_final-itype = wa_data-itype.
      wa_final-idate = wa_data-idate.
      wa_final-itmno = wa_data1-iitno.
      wa_final-icost = wa_data1-icost.
      wa_final-curr =  wa_data1-curr.
      APPEND wa_final TO lt_final.
      clear wa_final.
    ENDLOOP.
  ENDLOOP.


ENDFUNCTION.
