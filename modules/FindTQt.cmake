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

if( WITH_QT4 )

pkg_search_module( TQT tqt )

if( NOT TQT_FOUND )
  tde_message_fatal( "Unable to find TQt for Qt4!\n Try adding the directory in which the tqt.pc file is located\nto the PKG_CONFIG_PATH variable." )
endif()

# under Qt4 the standard moc is used
if( NOT TQT_TMOC_EXECUTABLE )
  find_program( TQT_TMOC_EXECUTABLE
    NAMES moc
    HINTS ${TQTDIR}/bin $ENV{TQTDIR}/bin
    PATHS ${BINDIR} )
endif( NOT TQT_TMOC_EXECUTABLE )

if ( TQT_LIBRARIES )
  set( TQT_LIBRARIES "${TQT_LIBRARIES} -lQtCore -lQtGui" CACHE INTERNAL TQT_LIBRARIES FORCE )
else ( TQT_LIBRARIES )
  set( TQT_LIBRARIES "QtCore -lQtGui" CACHE INTERNAL TQT_LIBRARIES FORCE )
endif ( TQT_LIBRARIES )

endif( WITH_QT4 )

if( WITH_QT3 )

pkg_search_module( TQT TQt )

if( NOT TQT_FOUND )
  tde_message_fatal( "Unable to find TQt for Qt3!\n Try adding the directory in which the TQt.pc file is located\nto the PKG_CONFIG_PATH variable." )
endif()

# for Qt3, find tmoc, a simple TQt wrapper around the standard moc
if( NOT TQT_TMOC_EXECUTABLE )
  find_program( TQT_TMOC_EXECUTABLE
    NAMES tmoc
    HINTS ${TQTDIR}/bin $ENV{TQTDIR}/bin
    PATHS ${BINDIR} )
endif( NOT TQT_TMOC_EXECUTABLE )

endif( WITH_QT3 )