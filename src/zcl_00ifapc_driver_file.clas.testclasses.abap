*"* use this source file for your ABAP unit test classes
CLASS ltcl_driver_file DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA odrv_exp TYPE REF TO zcl_00ifapc_driver.
    DATA odrv_imp TYPE REF TO zcl_00ifapc_driver.
    DATA odrv_del TYPE REF TO zcl_00ifapc_driver.
    METHODS setup.
    METHODS: a_import_test FOR TESTING RAISING cx_static_check.
    METHODS: d_export_test FOR TESTING RAISING cx_static_check.
    METHODS: h_delete_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_driver_file IMPLEMENTATION.
  METHOD setup.
    odrv_exp = zcl_00ifapc_driver=>factory( zcl_00ifapc_driver=>c_drv_file ).
    odrv_imp = zcl_00ifapc_driver=>factory( zcl_00ifapc_driver=>c_drv_file ).
    odrv_del = zcl_00ifapc_driver=>factory( zcl_00ifapc_driver=>c_drv_file ).

    cl_abap_unit_assert=>assert_not_initial(
      EXPORTING
        act              = odrv_exp                          " Actual Data Object
        msg              = 'Object Not Loaded ->zcl_00ifapc_driver'             " Message in Case of Error
        level            = if_aunit_constants=>fatal " Severity (TOLERABLE, >CRITICAL<, FATAL)
    ).
    DATA filename TYPE string VALUE '/tmp/log001.log'.
    odrv_exp->set_param( name = 'FILENAME' value = filename  ).
    odrv_imp->set_param( name = 'FILENAME' value = filename  ).
    odrv_del->set_param( name = 'FILENAME' value = filename  ).
  ENDMETHOD.

  METHOD a_import_test.

    DATA(str1) = |test text { sy-datum }|.
    DATA str2 LIKE str1.

    TRY.
        odrv_exp->_export( str1 ).
      CATCH cx_root INTO DATA(cx_error).
        cl_abap_unit_assert=>fail(
            msg    = cx_error->get_text(  )
            level  = if_aunit_constants=>critical " Severity (TOLERABLE, >CRITICAL<, FATAL)
        ).
    ENDTRY.

  ENDMETHOD.

  METHOD d_export_test.
    DATA str2 TYPE string.
    TRY.
        odrv_imp->_import( IMPORTING ldata = str2 ).
      CATCH cx_root INTO DATA(cx_error).
        cl_abap_unit_assert=>fail(
            msg    = cx_error->get_text(  )
            level  = if_aunit_constants=>critical " Severity (TOLERABLE, >CRITICAL<, FATAL)
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD h_delete_test.
    DATA str2 TYPE string.

    odrv_del->_delete( ).

    TRY.
        odrv_imp->_import( IMPORTING ldata = str2 ).
      CATCH zcx_00ifapc_msg INTO DATA(cx_noexiste).
        cl_abap_unit_assert=>assert_initial(
            act              = str2
            msg              = 'Debe estar Vacio/No encontrado'
            level            = if_aunit_constants=>critical
        ).
    ENDTRY.

  ENDMETHOD.


ENDCLASS.
