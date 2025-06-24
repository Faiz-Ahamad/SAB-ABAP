*&---------------------------------------------------------------------*
*& Report YCL_PC_DB_OPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ycl_pc_db_ops.

DATA : lo_object TYPE REF TO ycl_inv_hdr.
DATA : lo_agent TYPE REF TO yca_inv_hdr.

DATA : lv_ino  TYPE yde_invno,
       lv_loc  TYPE yde_loc,
       lv_type TYPE yde_invtype,
       lv_date TYPE yde_invdate.

PARAMETERS : p_ino   TYPE yde_invno OBLIGATORY,
             p_iloc  TYPE yde_loc,
             p_itype TYPE yde_invtype,
             p_idate TYPE yde_invdate.

PARAMETERS : p_r1 TYPE c RADIOBUTTON GROUP r1,
             p_r2 TYPE c RADIOBUTTON GROUP r1 DEFAULT 'X',
             p_r3 TYPE c RADIOBUTTON GROUP r1.

START-OF-SELECTION.
  IF p_r1 = 'X'.
    lo_agent = yca_inv_hdr=>agent.
    TRY.
        CALL METHOD lo_agent->create_persistent
          EXPORTING
            i_inv_num = p_ino
          RECEIVING
            result    = lo_object.
      CATCH cx_os_object_existing .
    ENDTRY.
    TRY.
        CALL METHOD lo_object->set_loc
          EXPORTING
            i_loc = p_iloc.
      CATCH cx_os_object_not_found .
    ENDTRY.
    TRY.
        CALL METHOD lo_object->set_inv_type
          EXPORTING
            i_inv_type = p_itype.
      CATCH cx_os_object_not_found .
    ENDTRY.
    TRY.
        CALL METHOD lo_object->set_inv_date
          EXPORTING
            i_inv_date = p_idate.
      CATCH cx_os_object_not_found .
    ENDTRY.
    IF sy-subrc = 0.
      MESSAGE i008(yoru).
    ENDIF.

    COMMIT WORK.

  ENDIF.

  IF p_r2 = 'X'.
    TRY.
        CALL METHOD lo_agent->delete_persistent
          EXPORTING
            i_inv_num = p_ino.
      CATCH cx_os_object_not_existing .
    ENDTRY.
    IF sy-subrc = 0.
      MESSAGE i009(yoru).
    ENDIF.
    COMMIT WORK.
  ENDIF.
  IF p_r3 = 'X'.
    TRY.
        CALL METHOD lo_object->set_loc
          EXPORTING
            i_loc = p_iloc.
      CATCH cx_os_object_not_found .
    ENDTRY.
    TRY.
        CALL METHOD lo_object->set_inv_type
          EXPORTING
            i_inv_type = p_itype.
      CATCH cx_os_object_not_found .
    ENDTRY.
    TRY.
        CALL METHOD lo_object->set_inv_date
          EXPORTING
            i_inv_date = p_idate.
      CATCH cx_os_object_not_found .
    ENDTRY.
    IF sy-subrc = 0.
      MESSAGE i008(yoru).
    ENDIF.
    COMMIT WORK.
  ENDIF.


AT SELECTION-SCREEN.
  IF p_r1 = 'X'.
    CLEAR : lo_agent, lo_object.
    lo_agent = yca_inv_hdr=>agent.
    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_inv_num = p_ino
          RECEIVING
            result    = lo_object.
      CATCH cx_os_object_not_found .
    ENDTRY.
    IF lo_object IS NOT INITIAL.
      MESSAGE e004(yoru) WITH p_ino.
    ENDIF.
  ENDIF.
  IF p_r2 = 'X'.
    CLEAR : lo_agent, lo_object.
    lo_agent = yca_inv_hdr=>agent.
    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_inv_num = p_ino
          RECEIVING
            result    = lo_object.
      CATCH cx_os_object_not_found .
    ENDTRY.
    IF lo_object IS INITIAL.
      MESSAGE e005(yoru) WITH p_ino.
    ENDIF.
  ENDIF.
  IF p_r3 = 'X'.
    CLEAR : lo_agent, lo_object.
    lo_agent = yca_inv_hdr=>agent.
    TRY.
        CALL METHOD lo_agent->get_persistent
          EXPORTING
            i_inv_num = p_ino
          RECEIVING
            result    = lo_object.
      CATCH cx_os_object_not_found .
    ENDTRY.
    IF lo_object IS INITIAL.
      MESSAGE e005(yoru) WITH p_ino.
    ELSE.
      TRY.
          CALL METHOD lo_object->get_inv_num
            RECEIVING
              result = lv_ino.
        CATCH cx_os_object_not_found .
      ENDTRY.
      TRY.
          CALL METHOD lo_object->get_loc
            RECEIVING
              result = lv_loc.
        CATCH cx_os_object_not_found .
      ENDTRY.
      TRY.
          CALL METHOD lo_object->get_inv_type
            RECEIVING
              result = lv_type.
        CATCH cx_os_object_not_found .
      ENDTRY.
      TRY.
          CALL METHOD lo_object->get_inv_date
            RECEIVING
              result = lv_date.
        CATCH cx_os_object_not_found .
      ENDTRY.
    ENDIF.
  ENDIF.


AT SELECTION-SCREEN OUTPUT.
  IF p_r3 = 'X'.
    p_ino = lv_ino.
    p_iloc = lv_loc.
    p_itype = lv_type.
    p_idate = lv_date.
  ENDIF.
