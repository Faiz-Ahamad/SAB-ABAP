*----------------------------------------------------------------------*
***INCLUDE Y_SUB_DISPLAY_GET_HDRF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_HDR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_INO  text
*      <--P_IT_DATA  text
*----------------------------------------------------------------------*
FORM get_hdr  USING    pv_ino TYPE yde_invno
              CHANGING pt_data TYPE ytabstr_ord.

  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE pt_data
  WHERE inv_num = pv_ino.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ITM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_DATA  text
*      <--P_IT_DATA1  text
*----------------------------------------------------------------------*
FORM get_itm  USING    pt_data TYPE ytabstr_ord
              CHANGING pt_data1 TYPE ytabstr_itm.

  SELECT inv_num inv_itemnum item_cost curr
  FROM yinv_item
  INTO TABLE pt_data1
  FOR ALL ENTRIES IN pt_data
  WHERE inv_num = pt_data-ino.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATA_DIS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_DATA  text
*      -->P_IT_DATA1  text
*      <--P_IT_FINAL  text
*----------------------------------------------------------------------*
FORM data_dis  USING    pt_data TYPE ytabstr_ord
                        pt_data1 TYPE ytabstr_itm
               CHANGING pt_final TYPE YTABSTR_DIS.

  LOOP AT pt_data INTO wa_data.
    LOOP AT pt_data1 INTO wa_data1 WHERE ino = wa_data-ino.
      wa_final-ino =   wa_data-ino.
      wa_final-itype = wa_data-itype.
      wa_final-idate = wa_data-idate.
      wa_final-itmno = wa_data1-iitno.
      wa_final-icost = wa_data1-icost.
      wa_final-curr =  wa_data1-curr.
      APPEND wa_final TO pt_final.
      CLEAR wa_final.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HDR_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_INO[]  text
*      <--P_IT_DATA  text
*----------------------------------------------------------------------*
FORM get_hdr_2  USING    s_ino TYPE YTABSTR_SELECT
                CHANGING pt_data TYPE ytabstr_ord.

  SELECT inv_num inv_type inv_date
  FROM yinv_hdr
  INTO TABLE pt_data
  WHERE inv_num in s_ino.


ENDFORM.
