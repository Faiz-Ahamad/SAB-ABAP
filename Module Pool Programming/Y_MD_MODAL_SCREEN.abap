*&---------------------------------------------------------------------*
*& Modulpool  Y_MD_MODAL_SCREEN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM Y_MD_MODAL_SCREEN.

TABLES : yinv_hdr.

TYPES : BEGIN OF ity_hdr,
        ino TYPE YDE_INVNO,
        itype TYPE YDE_INVTYPE,
        idate TYPE YDE_INVDATE,
        END OF ity_hdr.

DATA : it_hdr TYPE TABLE OF ity_hdr,
       wa_hdr TYPE ity_hdr.

INCLUDE y_md_modal_screen_user_commi01.
