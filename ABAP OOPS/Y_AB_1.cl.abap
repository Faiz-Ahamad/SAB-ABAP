class Y_AB_1 definition
  public
  abstract
  create public .

public section.

  methods DISPLAY
  abstract
    importing
      !PVBELN type VBELN_VA
    exporting
      !PERDAT type ERDAT
      !PERZET type ERZET
      !PERNAM type ERNAM
      !PVBTYP type VBTYP .
protected section.
private section.
ENDCLASS.



CLASS Y_AB_1 IMPLEMENTATION.
ENDCLASS.
