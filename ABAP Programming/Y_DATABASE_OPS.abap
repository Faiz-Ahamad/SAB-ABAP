*&---------------------------------------------------------------------*
*& Report Y_DATABASE_OPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_database_ops.

TYPES : ity_data TYPE yinv_hdr.

TYPES: BEGIN OF ity_display,
         itype TYPE yde_invtype,
         idate TYPE yde_invdate,
       END OF ity_display.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.
DATA : wa_data1 TYPE yde_invno.

DATA : wa_display TYPE ity_display.


PARAMETERS : ino TYPE yde_invno OBLIGATORY.
PARAMETERS : itype TYPE yde_invtype MODIF ID t1.
PARAMETERS : idate TYPE yde_invdate MODIF ID d1.
SELECTION-SCREEN : BEGIN OF LINE.
PARAMETERS : p_r1 TYPE c RADIOBUTTON GROUP r1 USER-COMMAND select.
SELECTION-SCREEN : COMMENT 3(6) TEXT-000.
PARAMETERS : p_r2 TYPE c RADIOBUTTON GROUP r1.
SELECTION-SCREEN : COMMENT 12(6) TEXT-001.
PARAMETERS : p_r3 TYPE c RADIOBUTTON GROUP r1.
SELECTION-SCREEN : COMMENT 21(6) TEXT-002.
PARAMETERS : p_r4 TYPE c RADIOBUTTON GROUP r1 DEFAULT 'X'.
SELECTION-SCREEN : COMMENT 30(6) TEXT-003.
SELECTION-SCREEN : END OF LINE.


START-OF-SELECTION.

* INSERT

  IF p_r1 = 'X'.
    wa_data-inv_num = ino.
    wa_data-inv_type = itype.
    wa_data-inv_date = idate.
    INSERT yinv_hdr FROM wa_data.
    IF sy-subrc = 0 .
      WRITE 'Inserted Sucessfully'.

    ELSE.
      WRITE 'Inserted Failed'.
    ENDIF.
  ENDIF.

* DELETE

  IF p_r2 = 'X'.
    wa_data-inv_num = ino.
    DELETE yinv_hdr FROM wa_data.
    IF sy-subrc = 0 .
      WRITE : 'Deleted Sucessfully', ':', ino.
    ENDIF.
  ENDIF.

* UPDATE

  IF p_r3 = 'X'.
    wa_data-inv_num = ino.
    wa_data-inv_type = itype.
    wa_data-inv_date = idate.
    UPDATE yinv_hdr FROM wa_data.
    IF sy-subrc = 0.
      WRITE : 'Record Updated Sucessfully',':',ino.
    ENDIF.
  ENDIF.

  IF p_r4 = 'X'.
    wa_data-inv_num = ino.
    wa_data-inv_type = itype.
    wa_data-inv_date = idate.
    MODIFY yinv_hdr FROM wa_data.
    IF sy-subrc = 0.
      WRITE : 'Record Modified Sucessfully',':',ino.
    ENDIF.
  ENDIF.



AT SELECTION-SCREEN .
* INSERT
  IF p_r1 = 'X'.
    SELECT SINGLE inv_num
    FROM yinv_hdr
    INTO wa_data1
    WHERE inv_num = ino.
    CLEAR wa_data1.
    IF sy-subrc = 0.
      MESSAGE e004(yoru) WITH ino.
    ENDIF.
  ENDIF.

*DELETE

  IF p_r2 = 'X'.
    SELECT SINGLE inv_num
    FROM yinv_hdr
    INTO wa_data1
    WHERE inv_num = ino.
    IF sy-subrc <> 0.
      MESSAGE e005(yoru) WITH ino.
    ENDIF.
  ENDIF.

  IF p_r3 = 'X'.
    SELECT SINGLE inv_num
    FROM yinv_hdr
    INTO wa_data1
    WHERE inv_num = ino.
    IF sy-subrc <> 0.
      MESSAGE e005(yoru) WITH ino.
    ELSE.
      SELECT inv_type inv_date
      FROM yinv_hdr
      INTO wa_display
      WHERE inv_num = ino.
      ENDSELECT.
    ENDIF.
  ENDIF.

  IF p_r4 = 'X'.
    SELECT inv_type inv_date
    FROM yinv_hdr
    INTO wa_display
    WHERE inv_num = ino.
    ENDSELECT.
    IF sy-subrc <> 0.
      CLEAR wa_display.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.

  IF p_r2 = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 't1' OR screen-group1 = 'd1'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF p_r3 = 'X'.

    itype = wa_display-itype .
    idate = wa_display-idate .

  ENDIF.

  IF p_r4 = 'X'.

    itype = wa_display-itype .
    idate = wa_display-idate .

  ENDIF.
