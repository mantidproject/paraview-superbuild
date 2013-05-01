# include the common qt.use.system.cmake file.
include("${SuperBuild_PROJECTS_DIR}/qt.use.system.cmake")

option(PACKAGE_SYSTEM_QT
  "When enabled and USE_SYSTEM_qt is ON, packages needed Qt files" ON)
if (NOT PACKAGE_SYSTEM_QT)
  return()
endif()

# for OSX, we add rules to pacakge system Qt.
function(__query_qmake VAR RESULT)
  execute_process(COMMAND "${QT_QMAKE_EXECUTABLE}" -query ${VAR}
    RESULT_VARIABLE return_code
    OUTPUT_VARIABLE output ERROR_VARIABLE output
    OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE)
  if(NOT return_code)
    file(TO_CMAKE_PATH "${output}" output)
    set(${RESULT} ${output} PARENT_SCOPE)
  endif(NOT return_code)
endfunction(__query_qmake)

# locate the bin dir and the plugins dir.
if (EXISTS "${QT_QMAKE_EXECUTABLE}")
  __query_qmake(QT_INSTALL_PLUGINS qt_plugins_dir)
  __query_qmake(QT_INSTALL_BINS qt_bin_dir)
  __query_qmake(QT_INSTALL_LIBS qt_lib_dir)

  install(DIRECTORY "${qt_plugins_dir}/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT Qt_Runtime
          # skip debug dylibs
          FILES_MATCHING REGEX "^.*_debug.*$" EXCLUDE
          PATTERN "*Qt*")

install(DIRECTORY "${qt_bin_dir}/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT Qt_Runtime

          # skip debug dylibs
          FILES_MATCHING REGEX "^.*_debug.*$" EXCLUDE
          PATTERN "*Qt*")

  install(DIRECTORY "${qt_lib_dir}/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT Qt_Runtime

          # skip debug dylibs
          FILES_MATCHING REGEX "^.*_debug.*" EXCLUDE
          PATTERN "*Qt*")
endif()
