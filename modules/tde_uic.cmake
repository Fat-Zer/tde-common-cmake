#################################################
#
#  (C) 2010 Serghei Amelian
#  serghei (DOT) amelian (AT) gmail.com
#
#  Improvements and feedback are welcome
#
#  This file is released under GPL >= 2
#
#################################################

get_filename_component( _ui_basename ${UI_FILE} NAME_WE )

execute_process( COMMAND ${QT_UIC_EXECUTABLE}
  -nounload -tr tr2i18n
  ${UI_FILE}
  OUTPUT_VARIABLE _ui_h_content )

if( _ui_h_content )
  string( REGEX REPLACE "#ifndef " "#ifndef UI_" _ui_h_content "${_ui_h_content}" )
  string( REGEX REPLACE "#define " "#define UI_" _ui_h_content "${_ui_h_content}" )
  file( WRITE ${_ui_basename}.h "${_ui_h_content}" )
endif( )

if( TDE_QTPLUGINS_DIR )
  set( L -L ${TDE_QTPLUGINS_DIR} )
endif( )

execute_process( COMMAND ${QT_UIC_EXECUTABLE}
  -nounload -tr tr2i18n
  ${L}
  -impl ${_ui_basename}.h
  ${UI_FILE}
  OUTPUT_VARIABLE _ui_cpp_content )

if( _ui_cpp_content )
  string( REGEX REPLACE "tr2i18n\\(\"\"\\)" "QString::null" _ui_cpp_content "${_ui_cpp_content}" )
  string( REGEX REPLACE "tr2i18n\\(\"\", \"\"\\)" "QString::null" _ui_cpp_content "${_ui_cpp_content}" )
  file( WRITE ${_ui_basename}.cpp "#include <kdialog.h>\n#include <klocale.h>\n\n${_ui_cpp_content}" )
endif( )