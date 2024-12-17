CLASS lhc_rap_tdat_cts DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS get
      RETURNING VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.



CLASS lhc_rap_tdat_cts IMPLEMENTATION.


  METHOD get.

    result = mbc_cp_api=>rap_tdat_cts( tdat_name              = 'ZPARAMETER'
                                       table_entity_relations = VALUE #( ( entity = 'Param' table = 'ZPARAM' ) ) )
                                       ##NO_TEXT.

  ENDMETHOD.


ENDCLASS.



CLASS lhc_ParamAll DEFINITION INHERITING FROM cl_abap_behavior_handler FINAL.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR ParamAll
        RESULT result.

    METHODS selectcustomizingtransptreq FOR MODIFY
        IMPORTING keys FOR ACTION ParamAll~SelectCustomizingTransptReq
        RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR ParamAll
        RESULT result.

ENDCLASS.



CLASS lhc_ParamAll IMPLEMENTATION.


  METHOD get_instance_features.

    DATA edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    DATA selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.

    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.

    READ ENTITIES OF ZR_Parameter_S IN LOCAL MODE
         ENTITY ParamAll
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(all).
    IF all[ 1 ]-%is_draft = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.

    result = VALUE #( ( %tky                                = all[ 1 ]-%tky
                        %action-edit                        = edit_flag
                        %assoc-_Param                       = edit_flag
                        %action-SelectCustomizingTransptReq = selecttransport_flag ) ).

  ENDMETHOD.


  METHOD selectcustomizingtransptreq.

    MODIFY ENTITIES OF ZR_Parameter_S IN LOCAL MODE
           ENTITY ParamAll
           UPDATE FIELDS ( TransportRequestID HideTransport )
           WITH VALUE #( FOR key IN keys
                         ( %tky               = key-%tky
                           TransportRequestID = key-%param-TransportRequestID
                           HideTransport      = abap_false ) ).

    READ ENTITIES OF ZR_Parameter_S IN LOCAL MODE
         ENTITY ParamAll
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(entities).

    result = VALUE #( FOR entity IN entities
                      ( %tky   = entity-%tky
                        %param = entity ) ).

  ENDMETHOD.


  METHOD get_global_authorizations.

    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZR_PARAMETER' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0
                                  THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).

    result-%update      = is_authorized.
    result-%action-Edit                        = is_authorized.
    result-%action-SelectCustomizingTransptReq = is_authorized.

  ENDMETHOD.


ENDCLASS.



CLASS lsc_ParamAll DEFINITION INHERITING FROM cl_abap_behavior_saver FINAL.

  PROTECTED SECTION.

    METHODS save_modified    REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.



CLASS lsc_ParamAll IMPLEMENTATION.


  METHOD save_modified.

    READ TABLE update-ParamAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes( transport_request = all-TransportRequestID
                                                create            = REF #( create )
                                                update            = REF #( update )
                                                delete            = REF #( delete ) ).
    ENDIF.

  ENDMETHOD.


  METHOD cleanup_finalize ##NEEDED.

  ENDMETHOD.


ENDCLASS.



CLASS lhc_Param DEFINITION INHERITING FROM cl_abap_behavior_handler FINAL.

  PRIVATE SECTION.

    METHODS validatetransportrequest FOR VALIDATE ON SAVE
              IMPORTING
                keys FOR Param~ValidateTransportRequest.

    METHODS get_global_features FOR GLOBAL FEATURES
              IMPORTING
                REQUEST requested_features FOR Param
              RESULT result.

ENDCLASS.



CLASS lhc_Param IMPLEMENTATION.


  METHOD validatetransportrequest.

    DATA change TYPE REQUEST FOR CHANGE ZR_Parameter_S.

    SELECT SINGLE TransportRequestID
      FROM zparam_d_s
      WHERE SingletonId = 1
      INTO @DATA(TransportRequestID).

    lhc_rap_tdat_cts=>get( )->validate_changes( transport_request = TransportRequestID
                                                table             = 'ZPARAM'
                                                keys              = REF #( keys )
                                                reported          = REF #( reported )
                                                failed            = REF #( failed )
                                                change            = REF #( change-Param ) ).

  ENDMETHOD.


  METHOD get_global_features.

    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.

    result-%update = edit_flag.
    result-%delete = edit_flag.

  ENDMETHOD.


ENDCLASS.
