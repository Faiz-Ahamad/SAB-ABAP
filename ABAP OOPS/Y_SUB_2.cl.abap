class Y_SUB_2 definition
  public
  inheriting from Y_AB_1
  final
  create public .

public section.

  methods DISPLAY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS Y_SUB_2 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Y_SUB_2->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] PVBELN                         TYPE        VBELN_VA
* | [<---] PERDAT                         TYPE        ERDAT
* | [<---] PERZET                         TYPE        ERZET
* | [<---] PERNAM                         TYPE        ERNAM
* | [<---] PVBTYP                         TYPE        VBTYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display.

    SELECT SINGLE vbtyp erdat erzet ernam
    FROM vbrk
    INTO (pvbtyp , perdat, perzet, pernam)
    WHERE vbeln = pvbeln.

  ENDMETHOD.
ENDCLASS.
