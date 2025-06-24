*&---------------------------------------------------------------------*
*& Modulpool  Y_MD_SUBSCREEN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM Y_MD_SUBSCREEN.

TABLES : yinv_hdr.

TYPES : BEGIN OF ity_hdr,
        ino TYPE YDE_INVNO,
        itype TYPE YDE_INVTYPE,
        idate TYPE YDE_INVDATE,
        END OF ity_hdr.

DATA : it_hdr TYPE TABLE OF ity_hdr,
       wa_hdr TYPE ity_hdr.


INCLUDE y_md_subscreen_status_0100o01.

INCLUDE y_md_subscreen_user_commandi01.
