*&---------------------------------------------------------------------*
*& Report Y_AB_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Y_AB_CLASS.


PARAMETERS : p_vbeln TYPE vbeln_va.

PARAMETERS : p_r1 TYPE C RADIOBUTTON GROUP R1,
             p_r2 TYPE C RADIOBUTTON GROUP R1.

DATA : lo_object1 TYPE REF TO Y_SUB_1,
       lo_object2 TYPE REF TO Y_SUB_2.

DATA : p_erdat TYPE erdat,
       p_erzet TYPE erzet,
       p_ernam TYPE ernam,
       p_vbtyp TYPE vbtyp.


IF p_r1 = 'X'.

  CREATE OBJECT lo_object1.
  CALL METHOD lo_object1->display
    EXPORTING
      pvbeln = p_vbeln
    IMPORTING
      perdat = p_erdat
      perzet = p_erzet
      pernam = p_ernam
      pvbtyp = p_vbtyp
      .
  WRITE : 'VBAK', / p_erdat,
                  / p_erzet,
                  / p_ernam,
                  / p_vbtyp.


ENDIF.

IF p_r2 = 'X'.

  CREATE OBJECT lo_object2.
  CALL METHOD lo_object2->display
    EXPORTING
      pvbeln = p_vbeln
    IMPORTING
      perdat = p_erdat
      perzet = p_erzet
      pernam = p_ernam
      pvbtyp = p_vbtyp
      .
  WRITE : 'VBRK', / p_erdat,
                  / p_erzet,
                  / p_ernam,
                  / p_vbtyp.


ENDIF.
