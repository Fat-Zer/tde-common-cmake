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

macro( __tde_internal_find_qt_program __progname __output )
  find_program( ${__output}
    NAMES ${__progname}
    HINTS ${QTDIR}/bin $ENV{QTDIR}/bin
    PATHS ${BINDIR} )
  if( NOT ${__output} )
    tde_message_fatal( "${__progname} are NOT found.\n Please check if Qt are correctly installed." )
  endif( NOT ${__output} )
endmacro( __tde_internal_find_qt_program )


if( NOT QT_FOUND )

  # we search for moc only if is not already set (by user or previous run of cmake)
  if( NOT QT_MOC_EXECUTABLE )
    __tde_internal_find_qt_program( moc QT_MOC_EXECUTABLE )
  endif( NOT QT_MOC_EXECUTABLE )

  message( STATUS "checking for 'Qt'")

  # we run moc, to check which qt version is using
  execute_process(
    COMMAND ${QT_MOC_EXECUTABLE} -v
    ERROR_VARIABLE __output
    RESULT_VARIABLE __result
    ERROR_STRIP_TRAILING_WHITESPACE )

  # parse moc response, to extract Qt version
  if( __result EQUAL 1 )
    string( REGEX MATCH "^.*Qt (.+)\\)$" __dummy  "${__output}" )
    set( __version  "${CMAKE_MATCH_1}" )
    if( NOT __version )
      tde_message_fatal( "Invalid response from moc:\n ${__output}" )
    endif( NOT __version )
  else( __result EQUAL 1 )
    tde_message_fatal( "Unable to run moc!\n Qt are correctly installed?\n LD_LIBRARY_PATH are correctly set?" )
  endif( __result EQUAL 1 )

  # search for uic
  __tde_internal_find_qt_program( uic QT_UIC_EXECUTABLE )

  # try to find path to qt.h
  # we assume that this path is Qt's include path
  find_path( QT_INCLUDE_DIR qt.h
    ${QT_INCLUDE_DIR}
    ${QTDIR}/include
    $ENV{QTDIR}/include )

  if( NOT QT_INCLUDE_DIR )

    tde_message_fatal(
 "Unable to find qt.h!
 Qt are correctly installed?
 Try to set QT_INCLUDE_DIR manually.
 Example: cmake -DQT_INCLUDE_DIR=/usr/qt/3/include" )

  endif( NOT QT_INCLUDE_DIR )

  # try to find libqt-mt.so
  # we assume that this is Qt's libraries path
  find_path( QT_LIBRARY_DIR libqt-mt.so
    ${QT_LIBRARY_DIR}
    ${QTDIR}/lib
    $ENV{QTDIR}/lib )

  if( NOT QT_LIBRARY_DIR )

    tde_message_fatal(
 "Unable to find libqt-mt.so!
 Qt are correctly installed?
 Try to set QT_LIBRARY_DIR manually.
 Example: cmake -DQT_LIBRARY_DIR=/usr/qt/3/lib" )

  endif( NOT QT_LIBRARY_DIR )

  message( STATUS "  found Qt, version ${__version}" )
  set( QT_FOUND true CACHE INTERNAL QT_FOUND FORCE )
  set( QT_LIBRARIES "qt-mt" CACHE INTERNAL QT_LIBRARIES FORCE )
  set( QT_DEFINITIONS "-DQT_NO_ASCII_CAST -DQT_CLEAN_NAMESPACE -DQT_NO_STL -DQT_NO_COMPAT -DQT_NO_TRANSLATION" CACHE INTERNAL QT_DEFINITIONS FORCE )

endif( NOT QT_FOUND )
