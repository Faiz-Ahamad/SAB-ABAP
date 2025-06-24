class Y_CL1 definition
  public
  final
  create public .

public section.

  methods GET_DATA
    importing
      !PVBELN type VBELN_VA
    exporting
      !LT_OUTPUT type YTSTR_DETAILS .
  methods GET_DATA_SELECT
    importing
      !SVBELN type YTABSTR_SELECT1
    exporting
      !LT_OUTPUT type YTSTR_DETAILS .
protected section.
private section.
ENDCLASS.



CLASS Y_CL1 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Y_CL1->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] PVBELN                         TYPE        VBELN_VA
* | [<---] LT_OUTPUT                      TYPE        YTSTR_DETAILS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.

    TYPES : BEGIN OF ity_vbak,
              vbeln TYPE vbeln_va,
              erdat TYPE erdat,
              erzet TYPE erzet,
              ernam TYPE ernam,
            END OF ity_vbak.

    DATA : it_vbak TYPE TABLE OF ity_vbak,
           wa_vbak TYPE ity_vbak.

    TYPES : BEGIN OF ity_vbap,
              vbeln TYPE vbeln_va,
              POSNR TYPE POSNR_VA,
              matnr TYPE matnr,
            END OF ity_vbap.

    DATA : it_vbap TYPE TABLE OF ity_vbap,
           wa_vbap TYPE ity_vbap.

*    DATA : lt_output TYPE TABLE OF ystr_details,
     DATA : wa_output TYPE ystr_details.


    SELECT vbeln erdat erzet ernam
    FROM vbak
    INTO TABLE it_vbak
    WHERE vbeln = pvbeln.


    IF it_vbak IS NOT INITIAL.
      SELECT vbeln POSNR matnr
      FROM vbap
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak
      WHERE vbeln = it_vbak-vbeln.
    ENDIF.

    LOOP AT it_vbak INTO wa_vbak.
      LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln.

        wa_output-vbeln = wa_vbak-vbeln.
        wa_output-erdat = wa_vbak-erdat.
        wa_output-erzet = wa_vbak-erzet.
        wa_output-ernam = wa_vbak-ernam.
        wa_output-posnr = wa_vbap-posnr.
        wa_output-matnr = wa_vbap-matnr.
        APPEND wa_output TO lt_output.
        CLEAR : wa_output.

      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Y_CL1->GET_DATA_SELECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] SVBELN                         TYPE        YTABSTR_SELECT1
* | [<---] LT_OUTPUT                      TYPE        YTSTR_DETAILS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data_select.

    TYPES : BEGIN OF ity_vbak,
              vbeln TYPE vbeln_va,
              erdat TYPE erdat,
              erzet TYPE erzet,
              ernam TYPE ernam,
            END OF ity_vbak.

    DATA : it_vbak TYPE TABLE OF ity_vbak,
           wa_vbak TYPE ity_vbak.

    TYPES : BEGIN OF ity_vbap,
              vbeln TYPE vbeln_va,
              posnr TYPE posnr_va,
              matnr TYPE matnr,
            END OF ity_vbap.

    DATA : it_vbap TYPE TABLE OF ity_vbap,
           wa_vbap TYPE ity_vbap.

*    DATA : lt_output TYPE TABLE OF ystr_details,
    DATA : wa_output TYPE ystr_details.


    SELECT vbeln erdat erzet ernam
    FROM vbak
    INTO TABLE it_vbak
    WHERE vbeln IN svbeln.


    IF it_vbak IS NOT INITIAL.
      SELECT vbeln posnr matnr
      FROM vbap
      INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbak
      WHERE vbeln = it_vbak-vbeln.
    ENDIF.

    LOOP AT it_vbak INTO wa_vbak.
      LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln.

        wa_output-vbeln = wa_vbak-vbeln.
        wa_output-erdat = wa_vbak-erdat.
        wa_output-erzet = wa_vbak-erzet.
        wa_output-ernam = wa_vbak-ernam.
        wa_output-posnr = wa_vbap-posnr.
        wa_output-matnr = wa_vbap-matnr.
        APPEND wa_output TO lt_output.
        CLEAR : wa_output.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
