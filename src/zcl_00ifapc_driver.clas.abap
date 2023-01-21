*** Developed by Daniel Esteves https://github.com/DE2020
CLASS zcl_00ifapc_driver DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.
    CONSTANTS c_drv_file TYPE zde_00ifapc_drvs VALUE 'F'.
    CONSTANTS c_drv_file_class TYPE string VALUE 'ZCL_00IFAPC_DRIVER_FILE'.

    CLASS-METHODS factory
      IMPORTING drv      TYPE zde_00ifapc_drvs
      RETURNING VALUE(r) TYPE REF TO zcl_00ifapc_driver.

    METHODS _delete ABSTRACT RAISING zcx_00ifapc_msg .
    METHODS _export ABSTRACT IMPORTING ldata TYPE string RAISING zcx_00ifapc_msg.
    METHODS _import ABSTRACT EXPORTING ldata TYPE string RAISING zcx_00ifapc_msg.
    METHODS set_param
      IMPORTING
        name  TYPE string
        value TYPE string.
    METHODS get_param
      IMPORTING
                name         TYPE string
      RETURNING VALUE(value) TYPE string.


ENDCLASS.



CLASS zcl_00ifapc_driver IMPLEMENTATION.

  METHOD factory.
    CASE drv.
      WHEN c_drv_file.
        CREATE OBJECT r TYPE (c_drv_file_class).
      WHEN OTHERS.
        r = factory( c_drv_file ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_param.
*        data lname type string VALUE 'ME->'.
*        lname = lname && name.
    ASSIGN me->(name) TO FIELD-SYMBOL(<any>).
    IF <any> IS ASSIGNED.
      <any> = value.
    ENDIF.
  ENDMETHOD.

  METHOD get_param.
    ASSIGN (name) TO FIELD-SYMBOL(<any>).
    IF <any> IS ASSIGNED.
      value = <any>.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
