*** Developed by Daniel Esteves https://github.com/DE2020
CLASS zcl_00ifapc_driver_file DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM zcl_00ifapc_driver.

  PUBLIC SECTION.
    METHODS:
      _delete REDEFINITION,
      _export REDEFINITION,
      _import REDEFINITION.

    DATA filename TYPE string.
  PRIVATE SECTION.
    METHODS get_filename
      RETURNING
        VALUE(r) TYPE string.

    METHODS check_filename
      RETURNING VALUE(r) TYPE string RAISING zcx_00ifapc_msg.

    CLASS-METHODS string_to_xstring
      IMPORTING
        !v       TYPE string
      RETURNING
        VALUE(r) TYPE xstring.

    CLASS-METHODS xstring_to_string
      IMPORTING
        !v       TYPE xstring
      RETURNING
        VALUE(r) TYPE string.
ENDCLASS.

CLASS zcl_00ifapc_driver_file IMPLEMENTATION.
  METHOD _delete.
    DATA(file) = check_filename(  ).
    TRY.
        DELETE DATASET file.
      CATCH cx_root INTO DATA(err).

        RAISE EXCEPTION TYPE zcx_00ifapc_msg
          MESSAGE ID 'Z00IFAPC_MSGCL'
          TYPE 'E'
          NUMBER '613' WITH
              err->get_text( ).
    ENDTRY.

  ENDMETHOD.

  METHOD _export.
    DATA(file) = check_filename(  ).

    TRY.
        DATA(xstr) = string_to_xstring( ldata ).
        OPEN DATASET file FOR OUTPUT IN BINARY MODE.
        TRANSFER xstr TO file.
      CATCH cx_root INTO DATA(err).
        CLOSE DATASET file.
        RAISE EXCEPTION TYPE zcx_00ifapc_msg
          MESSAGE ID 'Z00IFAPC_MSGCL'
          TYPE 'E'
          NUMBER '612' WITH
              err->get_text( ).
    ENDTRY.

    CLOSE DATASET file.
  ENDMETHOD.

  METHOD _import.
    FIELD-SYMBOLS <hex_container> TYPE x.
    DATA(file) = check_filename(  ).
    DATA xstr TYPE xstring.

    TRY .
        OPEN DATASET file FOR INPUT IN BINARY MODE.
        READ DATASET file INTO xstr.
        ldata = xstring_to_string( xstr ).
      CATCH cx_root INTO DATA(err).
        CLOSE DATASET file.
        RAISE EXCEPTION TYPE zcx_00ifapc_msg
          MESSAGE ID 'ZCM_LBS4H_MCLASS'
          TYPE 'E'
          NUMBER '611' WITH
              err->get_text( ).
    ENDTRY.

    CLOSE DATASET file.
  ENDMETHOD.

  METHOD get_filename.
    r = filename.
  ENDMETHOD.

  METHOD string_to_xstring.
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = v
      IMPORTING
        buffer = r
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
  ENDMETHOD.

  METHOD xstring_to_string.
    DATA output_length TYPE i.

    DATA binary_tab TYPE solix_tab.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = v
      IMPORTING
        output_length = output_length
      TABLES
        binary_tab    = binary_tab.


    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = output_length
      IMPORTING
        text_buffer  = r
      TABLES
        binary_tab   = binary_tab
      EXCEPTIONS
        OTHERS       = 0.
  ENDMETHOD.


  METHOD check_filename.
    IF get_filename( ) = space.
      RAISE EXCEPTION TYPE zcx_00ifapc_msg
        MESSAGE ID 'Z00IFAPC_MSGCL'
        TYPE 'E'
        NUMBER '010'.
    ENDIF.

    r = get_filename( ).
  ENDMETHOD.

ENDCLASS.
