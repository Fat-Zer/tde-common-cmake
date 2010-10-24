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

pkg_search_module( TQT TQt )

# find tmoc, a simple TQt wrapper over moc
if( NOT TQT_TMOC_EXECUTABLE )
  find_program( TQT_TMOC_EXECUTABLE
    NAMES tmoc
    HINTS ${TQTDIR}/bin $ENV{TQTDIR}/bin
    PATHS ${BINDIR} )
endif( NOT TQT_TMOC_EXECUTABLE )
