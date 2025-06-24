*&---------------------------------------------------------------------*
*& Modulpool  Y_MD_DROPDOWN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM Y_MD_DROPDOWN.

TABLES :YDROP_DOWN.

TYPES : BEGIN OF ity_data,
        DIST TYPE YDE_DIST,
        END OF ity_data.

DATA : it_data TYPE TABLE OF ity_data,
       wa_data TYPE ity_data.

INCLUDE y_md_dropdown_user_command_i01.

INCLUDE y_md_dropdown_status_0100o01.
