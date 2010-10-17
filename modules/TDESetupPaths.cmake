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

#################################################
#####
##### __tde_internal_setup_paths_status

macro( __tde_internal_setup_paths_status __path __value __method )
  message( STATUS "  ${__path}=${__value} [${__method}]" )
endmacro( __tde_internal_setup_paths_status )


#################################################
#####
##### __tde_internal_setup_path

macro( __tde_internal_setup_path __path __default )
  set( __method "user" )
  if( NOT ${__path} )
    set( __method "default" )
    set( __kdeconfig_type ${ARGV2} )
    if( _use_kdeconfig AND __kdeconfig_type )
      execute_process(
        COMMAND ${KDECONFIG_EXECUTABLE} --expandvars --install ${__kdeconfig_type}
        OUTPUT_VARIABLE ${__path}
        RESULT_VARIABLE __result
        OUTPUT_STRIP_TRAILING_WHITESPACE )
      if( __result )
        tde_message_fatal( "Unable to run kde-config!\n kdelibs are correctly installed?\n LD_LIBRARY_PATH are correctly set?" )
      endif( __result )
    endif( _use_kdeconfig AND __kdeconfig_type )
    if( ${__path} )
      set( __method "kde-config" )
    else( ${__path} )
      set( ${__path} "${__default}" )
    endif( ${__path} )
  endif( NOT ${__path} )
  __tde_internal_setup_paths_status( ${__path} ${${__path}} ${__method} )
endmacro( __tde_internal_setup_path )


#################################################
#####
##### tde_setup_paths

macro( tde_setup_paths )

  message( STATUS "Setup install paths:" )

  # --prefix
  # install architecture-independent files in PREFIX
  if( NOT PREFIX )
    set( __method "CMAKE_INSTALL_PREFIX" )
    set( PREFIX "${CMAKE_INSTALL_PREFIX}" )
  else( NOT PREFIX )
    # PREFIX have precedence over CMAKE_INSTALL_PREFIX
    set( __method "user" )
    set( CMAKE_INSTALL_PREFIX "${PREFIX}" )
  endif( NOT PREFIX )
  __tde_internal_setup_paths_status( PREFIX ${PREFIX} ${__method} )

  # --exec-prefix
  # install architecture-dependent files in EPREFIX
  if( NOT EPREFIX )
    set( __method "default" )
    set( EPREFIX "${PREFIX}" )
  endif( NOT EPREFIX )
  __tde_internal_setup_paths_status( EPREFIX ${EPREFIX} ${__method} )

  # we will using kde-config for discover paths
  set( _use_kdeconfig ${ARGV0} )
  if( _use_kdeconfig )
    # KDECONFIG_EXECUTABLE is not set, so will must to search for it
    if( NOT KDECONFIG_EXECUTABLE )
      find_program( KDECONFIG_EXECUTABLE
        NAMES kde-config
        HINTS $ENV{KDEDIR}/bin
        PATHS "${EPREFIX}/bin" "${PREFIX}/bin" "${CMAKE_INSTALL_PREFIX}/bin" )
      if( NOT KDECONFIG_EXECUTABLE )
        tde_message_fatal(

"kde-config executable are NOT found!
 kdelibs(-devel) are installed? EPREFIX are correctly set?
 Try to set KDECONFIG_EXECUTABLE to kde-config path.
 Example: cmake -DKDECONFIG_EXECUTABLE=/usr/kde/3.5/bin/kde-config" )

      endif( NOT KDECONFIG_EXECUTABLE )
    endif( NOT KDECONFIG_EXECUTABLE )
  endif( _use_kdeconfig )

  # --bindir
  # user executables
  __tde_internal_setup_path( BINDIR "${EPREFIX}/bin" "exe" )

  # --sbindir
  # system admin executables
  __tde_internal_setup_path( SBINDIR "${EPREFIX}/sbin" )

  # --libexecdir
  # program executables
  __tde_internal_setup_path( LIBEXECDIR "${EPREFIX}/libexec" )

  # --sysconfdir
  # read-only single-machine data
  __tde_internal_setup_path( SYSCONFDIR "${PREFIX}/etc" )

  # --sharedstatedir
  # modifiable architecture-independent data
  __tde_internal_setup_path( SHAREDSTATEDIR "${PREFIX}/com" )

  # --localstatedir
  # modifiable single-machine data
  __tde_internal_setup_path( LOCALSTATEDIR "${PREFIX}/var" )

  # --libdir
  # object code libraries
  __tde_internal_setup_path( LIBDIR "${EPREFIX}/lib" "lib" )

  # --includedir
  # C header files
  __tde_internal_setup_path( INCLUDEDIR "${PREFIX}/include" "include" )

  # --oldincludedir
  # C header files for non-gcc
  __tde_internal_setup_path( OLDINCLUDEDIR "/usr/include" )

  # --datarootdir
  # read-only arch.-independent data root
  __tde_internal_setup_path( DATAROOTDIR "${PREFIX}/share" )

  # --datadir
  # read-only architecture-independent data
  __tde_internal_setup_path( DATADIR "${DATAROOTDIR}" )

  # --infodir
  # info documentation
  __tde_internal_setup_path( INFODIR "${DATAROOTDIR}/info" )

  # --localedir
  # locale-dependent data
  __tde_internal_setup_path( LOCALEDIR "${DATAROOTDIR}/locale" )

  # --mandir
  # man documentation
  __tde_internal_setup_path( MANDIR "${DATAROOTDIR}/man" )

  # --docdir
  # documentation root
  __tde_internal_setup_path( DOCDIR "${DATAROOTDIR}/doc/${PACKAGE}" )

  # --htmldir
  # html documentation
  __tde_internal_setup_path( HTMLDIR "${DOCDIR}" "html" )

  # --dvidir
  # dvi documentation
  __tde_internal_setup_path( DVIDIR "${DOCDIR}" )

  # --pdfdir
  # pdf documentation
  __tde_internal_setup_path( PDFDIR "${DOCDIR}" )

  # --psdir
  # ps documentation
  __tde_internal_setup_path( PSDIR "${DOCDIR}" )

endmacro( tde_setup_paths )
