*&---------------------------------------------------------------------*
*& Report Y_SUB_DISPLAY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_sub_display.

PARAMETERS p_ino TYPE yde_invno.


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

DATA : it_final TYPE YTABSTR_DIS,
       wa_final TYPE ystr_dis.

PERFORM get_hdr USING p_ino CHANGING it_data.


IF it_data IS NOT INITIAL.
  PERFORM get_itm USING it_data CHANGING it_data1.
ENDIF.

PERFORM data_dis USING it_data it_data1 CHANGING it_final.

LOOP at it_final INTO wa_final.
  WRITE : / wa_final-ino , wa_final-itype, wa_final-idate,
            wa_final-itmno, wa_final-icost, wa_final-curr.
ENDLOOP.

INCLUDE y_sub_display_get_hdrf01.

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
