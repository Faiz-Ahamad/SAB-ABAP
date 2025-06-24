class Y_SUB_1 definition
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



CLASS Y_SUB_1 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Y_SUB_1->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] PVBELN                         TYPE        VBELN_VA
* | [<---] PERDAT                         TYPE        ERDAT
* | [<---] PERZET                         TYPE        ERZET
* | [<---] PERNAM                         TYPE        ERNAM
* | [<---] PVBTYP                         TYPE        VBTYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method DISPLAY.

    SELECT SINGLE erdat erzet ernam vbtyp
    FROM vbak
    INTO (perdat ,perzet, pernam, pvbtyp)
    WHERE vbeln = pvbeln.

  endmethod.
ENDCLASS.
