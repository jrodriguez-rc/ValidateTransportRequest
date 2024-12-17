CLASS zcl_parameter_import DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS main REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_parameter_import IMPLEMENTATION.


  METHOD main.

    FINAL(TransportRequest) = CONV sxco_transport( 'S4HK902835' ).

    MODIFY ENTITIES OF ZR_Parameter_S
           ENTITY ParamAll
           UPDATE
           FIELDS ( TransportRequestID )
           WITH VALUE #( ( SingletonId        = 1
                           TransportRequestID = TransportRequest ) )
           ENTITY ParamAll
           CREATE BY \_Param
           AUTO FILL CID
           FIELDS ( Id Value )
           WITH VALUE #( ( SingletonId = 1
                           %target     = VALUE #( ( Id    = 1
                                                    Value = 'Param 1' )
                                                  ( Id    = 2
                                                    Value = 'Param 2' )
                                                  ( Id    = 3
                                                    Value = 'Param 3' )
                                                  ( Id    = 4
                                                    Value = 'Param 4' )
                                                  ( Id    = 5
                                                    Value = 'Param 5' ) ) ) )
           FAILED DATA(failed) ##NEEDED
           REPORTED DATA(reported) ##NEEDED
           MAPPED DATA(mapped) ##NEEDED.

    COMMIT ENTITIES IN SIMULATION MODE
           RESPONSE OF ZR_Parameter_S
           FAILED DATA(failed_commit) ##NEEDED
           REPORTED DATA(reported_commit) ##NEEDED.

    LOOP AT reported_commit-ParamAll ASSIGNING FIELD-SYMBOL(<reported_ParamAll>).
      out->write( <reported_ParamAll>-%msg->if_message~get_text( ) ).
    ENDLOOP.

    LOOP AT reported_commit-Param ASSIGNING FIELD-SYMBOL(<reported_Param>).
      out->write( <reported_Param>-%msg->if_message~get_text( ) ).
    ENDLOOP.

    LOOP AT reported_commit-%other ASSIGNING FIELD-SYMBOL(<reported_other>).
      out->write( <reported_other>->if_message~get_text( ) ).
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
