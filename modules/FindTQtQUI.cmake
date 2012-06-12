#################################################
#
#  (C) 2010-2011 Serghei Amelian
#  serghei (DOT) amelian (AT) gmail.com
#
#  Improvements and feedback are welcome
#
#  This file is released under GPL >= 2
#
#################################################

macro( tqtqui_message )
  message( STATUS "${ARGN}" )
endmacro( )

pkg_search_module( TQTQUI tqtqui )

if( NOT TQTQUI_FOUND )
  tde_message_fatal( "Unable to find tqtqui!\n Try adding the directory in which the tqtqui.pc file is located\nto the PKG_CONFIG_PATH variable." )
endif( )

# tmoc_executable
tde_execute_process(
  COMMAND pkg-config tqtqui --variable=tmoc_executable
  OUTPUT_VARIABLE TMOC_EXECUTABLE OUTPUT_STRIP_TRAILING_WHITESPACE )

if( NOT EXISTS ${TMOC_EXECUTABLE} )
  tde_message_fatal( "tmoc is not found!\n tqtqui is correctly installed?" )
endif( )

tqtqui_message( "  tmoc path: ${TMOC_EXECUTABLE}" )


# check if tqtqui is usable
tde_save( CMAKE_REQUIRED_INCLUDES CMAKE_REQUIRED_LIBRARIES )
set( CMAKE_REQUIRED_INCLUDES ${TQTQUI_INCLUDE_DIRS} )
foreach( _dirs ${TQTQUI_LIBRARY_DIRS} )
  list( APPEND CMAKE_REQUIRED_LIBRARIES "-L${_dirs}" )
endforeach()
list( APPEND CMAKE_REQUIRED_LIBRARIES ${TQTQUI_LIBRARIES} )

check_cxx_source_compiles("
    #include <tqapplication.h>
    int main(int argc, char **argv) { TQApplication app(argc, argv); return 0; } "
  HAVE_USABLE_TQTQUI )

if( NOT HAVE_USABLE_TQTQUI )
  tde_message_fatal( "Unable to build a simple tqtqui test." )
endif( )

tde_restore( CMAKE_REQUIRED_INCLUDES CMAKE_REQUIRED_LIBRARIES )


# TQTQUI_CXX_FLAGS
foreach( _flag ${TQTQUI_CFLAGS_OTHER} )
  set( TQTQUI_CXX_FLAGS "${TQTQUI_CXX_FLAGS} ${_flag}" )
endforeach()
