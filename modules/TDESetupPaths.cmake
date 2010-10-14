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

macro( tde_setup_paths )

  # --prefix
  # install architecture-independent files in PREFIX
  if( NOT PREFIX )
    set( PREFIX "${CMAKE_INSTALL_PREFIX}" )
  else( NOT PREFIX )
    # PREFIX have precedence over CMAKE_INSTALL_PREFIX
    set( CMAKE_INSTALL_PREFIX "${PREFIX}" )
  endif( NOT PREFIX )

  # --exec-prefix
  # install architecture-dependent files in EPREFIX
  if( NOT EPREFIX )
    set( EPREFIX "${PREFIX}" )
  endif( NOT EPREFIX )

  # --bindir
  # user executables
  if( NOT BINDIR )
    set( BINDIR "${EPREFIX}/bin" )
  endif( NOT BINDIR )

  # --sbindir
  # system admin executables
  if( NOT SBINDIR )
    set( SBINDIR "${EPREFIX}/sbin" )
  endif( NOT SBINDIR )

  # --libexecdir
  # program executables
  if( NOT LIBEXECDIR )
    set( LIBEXECDIR "${EPREFIX}/libexec" )
  endif( NOT LIBEXECDIR )

  # --sysconfdir
  # read-only single-machine data
  if( NOT SYSCONFDIR )
    set( SYSCONFDIR "${PREFIX}/etc" )
  endif( NOT SYSCONFDIR )

  # --sharedstatedir
  # modifiable architecture-independent data
  if( NOT SHAREDSTATEDIR )
    set( SHAREDSTATEDIR "${PREFIX}/com" )
  endif( NOT SHAREDSTATEDIR )

  # --localstatedir
  # modifiable single-machine data
  if( NOT LOCALSTATEDIR )
    set( LOCALSTATEDIR "${PREFIX}/var" )
  endif( NOT LOCALSTATEDIR )

  # --libdir
  # object code libraries
  if( NOT LIBDIR )
    set( LIBDIR "${EPREFIX}/lib" )
  endif( NOT LIBDIR )

  # --includedir
  # C header files
  if( NOT INCLUDEDIR )
    set( INCLUDEDIR "${PREFIX}/include" )
  endif( NOT INCLUDEDIR )

  # --oldincludedir
  # C header files for non-gcc
  if( NOT OLDINCLUDEDIR )
    set( OLDINCLUDEDIR "/usr/include" )
  endif( NOT OLDINCLUDEDIR )

  # --datarootdir
  # read-only arch.-independent data root
  if( NOT DATAROOTDIR )
    set( DATAROOTDIR "${PREFIX}/share" )
  endif( NOT DATAROOTDIR )

  # --datadir
  # read-only architecture-independent data
  if( NOT DATADIR )
    set( DATADIR "${DATAROOTDIR}" )
  endif( NOT DATADIR )

  # --infodir
  # info documentation
  if( NOT INFODIR )
    set( INFODIR "${DATAROOTDIR}/info" )
  endif( NOT INFODIR )

  # --localedir
  # locale-dependent data
  if( NOT LOCALEDIR )
    set( LOCALEDIR "${DATAROOTDIR}/locale" )
  endif( NOT LOCALEDIR )

  # --mandir
  # man documentation
  if( NOT MANDIR )
    set( MANDIR "${DATAROOTDIR}/man" )
  endif( NOT MANDIR )

  # --docdir
  # documentation root
  if( NOT DOCDIR )
    set( DOCDIR "${DATAROOTDIR}/doc/${PACKAGE}" )
  endif( NOT DOCDIR )

  # --htmldir
  # html documentation
  if( NOT HTMLDIR )
    set( HTMLDIR "${DOCDIR}" )
  endif( NOT HTMLDIR )

  # --dvidir
  # dvi documentation
  if( NOT DVIDIR )
    set( DVIDIR "${DOCDIR}" )
  endif( NOT DVIDIR )

  # --pdfdir
  # pdf documentation
  if( NOT PDFDIR )
    set( PDFDIR "${DOCDIR}" )
  endif( NOT PDFDIR )

  # --psdir
  # ps documentation
  if( NOT PSDIR )
    set( PSDIR "${DOCDIR}" )
  endif( NOT PSDIR )

endmacro( tde_setup_paths )
