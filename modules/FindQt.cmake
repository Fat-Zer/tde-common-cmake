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

option( WITH_QT3 "Use TQt for Qt3" ON )
option( WITH_QT4 "Use TQt for Qt4 [EXPERIMENTAL]" OFF )

if( NOT QT_FOUND )

# See if TQt for Qt4 is available
# HACK HACK HACK
# This detection relies on the fact that TQt for Qt3 utilizes TQt.pc,
# whereas TQt for Qt4 utilizes tqt.pc
# Please find a better way to do this!
pkg_search_module( TQT tqt )

if( TQT_FOUND )
  set( WITH_QT3 "OFF" )
  set (WITH_QT4 "ON" )
endif()

if( WITH_QT4 )
  # Set a default if not manually set
  if ( NOT QT_INCLUDE_DIRS )
    set( QT_INCLUDE_DIRS "/usr/include/qt4" )
  endif ( NOT QT_INCLUDE_DIRS )
  if ( NOT QT_LIBRARY_DIRS )
    set( QT_LIBRARY_DIRS "/usr/lib" )
  endif ( NOT QT_LIBRARY_DIRS )

  # we search for moc only if is not already set (by user or previous run of cmake)
  if( NOT QT_MOC_EXECUTABLE )
    __tde_internal_find_qt_program( moc QT_MOC_EXECUTABLE )
  endif( NOT QT_MOC_EXECUTABLE )

  message( STATUS "checking for 'Qt4'")

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
  __tde_internal_find_qt_program( uic-tqt QT_UIC_EXECUTABLE )

  # try to find path to qt.h
  # we assume that this path is Qt's include path
  find_path( QT_INCLUDE_DIRS Qt/qconfig.h
    ${QT_INCLUDE_DIRS}
    ${QTDIR}/include
    $ENV{QTDIR}/include )

  if( NOT QT_INCLUDE_DIRS )

    tde_message_fatal(
 "Unable to find qconfig.h!
 Qt are correctly installed?
 Try to set QT_INCLUDE_DIRS manually.
 Example: cmake -DQT_INCLUDE_DIRS=/usr/qt/4/include" )

  endif( NOT QT_INCLUDE_DIRS )

  # try to find libQtCore.so
  # we assume that this is Qt's libraries path
  find_path( QT_LIBRARY_DIRS libQtCore.so
    ${QT_LIBRARY_DIRS}
    ${QTDIR}/lib
    $ENV{QTDIR}/lib )

  if( NOT QT_LIBRARY_DIRS )

    tde_message_fatal(
 "Unable to find libQtCore.so!
 Qt are correctly installed?
 Try to set QT_LIBRARY_DIRS manually.
 Example: cmake -DQT_LIBRARY_DIRS=/usr/qt/4/lib" )

  endif( NOT QT_LIBRARY_DIRS )

  message( STATUS "  found Qt, version ${__version}" )
  include_directories( ${QT_INCLUDE_DIRS} )
  set( QT_FOUND true CACHE INTERNAL QT_FOUND FORCE )
  set( QT_LIBRARIES "QtCore QtGui" CACHE INTERNAL QT_LIBRARIES FORCE )
  set( QT_DEFINITIONS "-DQT_NO_ASCII_CAST -DQT_CLEAN_NAMESPACE -DQT_NO_STL -DQT_NO_COMPAT -DQT_NO_TRANSLATION -DQT_THREAD_SUPPORT -D_REENTRANT" CACHE INTERNAL QT_DEFINITIONS FORCE )

endif( WITH_QT4 )

if( WITH_QT3 )

  # we search for moc only if is not already set (by user or previous run of cmake)
  if( NOT QT_MOC_EXECUTABLE )
    __tde_internal_find_qt_program( moc QT_MOC_EXECUTABLE )
  endif( NOT QT_MOC_EXECUTABLE )

  message( STATUS "checking for 'Qt3'")

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
  find_path( QT_INCLUDE_DIRS qt.h
    ${QT_INCLUDE_DIRS}
    ${QTDIR}/include
    $ENV{QTDIR}/include )

  if( NOT QT_INCLUDE_DIRS )

    tde_message_fatal(
 "Unable to find qt.h!
 Qt are correctly installed?
 Try to set QT_INCLUDE_DIRS manually.
 Example: cmake -DQT_INCLUDE_DIRS=/usr/qt/3/include" )

  endif( NOT QT_INCLUDE_DIRS )

  # try to find libqt-mt.so
  # we assume that this is Qt's libraries path
  find_path( QT_LIBRARY_DIRS libqt-mt.so
    ${QT_LIBRARY_DIRS}
    ${QTDIR}/lib
    $ENV{QTDIR}/lib )

  if( NOT QT_LIBRARY_DIRS )

    tde_message_fatal(
 "Unable to find libqt-mt.so!
 Qt are correctly installed?
 Try to set QT_LIBRARY_DIRS manually.
 Example: cmake -DQT_LIBRARY_DIRS=/usr/qt/3/lib" )

  endif( NOT QT_LIBRARY_DIRS )

  # check if Qt3 is patched for compatibility with TQt
  tde_save( CMAKE_REQUIRED_INCLUDES CMAKE_REQUIRED_LIBRARIES )
  set( CMAKE_REQUIRED_INCLUDES ${QT_INCLUDE_DIRS} )
  set( CMAKE_REQUIRED_LIBRARIES -L${QT_LIBRARY_DIRS} qt-mt )
  check_cxx_source_compiles("
    #include <qobjectlist.h>
    #include <qobject.h>
    int main(int, char**) { QObject::objectTreesListObject(); return 0; } "
    HAVE_PATCHED_QT3 )
  tde_restore( CMAKE_REQUIRED_INCLUDES CMAKE_REQUIRED_LIBRARIES )
  if( NOT HAVE_PATCHED_QT3 )
    tde_message_fatal( "Your Qt3 is not patched for compatibility with tqtinterface" )
  endif()

  message( STATUS "  found patched Qt, version ${__version}" )
  set( QT_FOUND true CACHE INTERNAL QT_FOUND FORCE )
  set( QT_LIBRARIES "qt-mt" CACHE INTERNAL QT_LIBRARIES FORCE )
  set( QT_DEFINITIONS "-DQT_NO_ASCII_CAST -DQT_CLEAN_NAMESPACE -DQT_NO_STL -DQT_NO_COMPAT -DQT_NO_TRANSLATION -DQT_THREAD_SUPPORT -D_REENTRANT" CACHE INTERNAL QT_DEFINITIONS FORCE )

endif( WITH_QT3 )

endif( NOT QT_FOUND )
