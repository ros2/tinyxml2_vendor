# TinyXML2_FOUND
# TinyXML2_INCLUDE_DIRS
# TinyXML2_LIBRARIES

# try to find the CMake config file for TinyXML2 first
find_package(TinyXML2 CONFIG QUIET)
if(TinyXML2_FOUND)
  message(STATUS "Found TinyXML2 via Config file: ${TinyXML2_DIR}")
  if(NOT TINYXML2_LIBRARY)
    # in this case, we're probably using TinyXML2 version 5.0.0 or greater
    # in which case tinyxml2 is an exported target and we should use that
    if(TARGET tinyxml2)
      set(TINYXML2_LIBRARY tinyxml2)
    elseif(TARGET tinyxml2::tinyxml2)
      set(TINYXML2_LIBRARY tinyxml2::tinyxml2)
    else()
      message(FATAL_WARNING "Unable to determine target for TinyXML2")
    endif()
    list(APPEND TinyXML2_TARGETS ${TINYXML2_LIBRARY})
  else()
    # Only perform that logic once
    if(NOT TARGET tinyxml2::tinyxml2)
      add_library(tinyxml2::tinyxml2 UNKNOWN IMPORTED)
      # TINYXML2_LIBRARY is composed of debug;<path\to\debug.lib>;optimized;<path\to\release.lib>
      # we have to extract the appropriate component based on the current configuration.
      # TODO(karsten1987) That if/else access can most likely be a onliner with a generator expression.
      if(CMAKE_BUILD_TYPE MATCHES DEBUG)
        list(GET TINYXML2_LIBRARY 1 TINYXML2_LIBRARY_PATH)
      else()
        list(GET TINYXML2_LIBRARY 3 TINYXML2_LIBRARY_PATH)
      endif()
      set_property(TARGET tinyxml2::tinyxml2 PROPERTY IMPORTED_LOCATION ${TINYXML2_LIBRARY_PATH})
      set_property(TARGET tinyxml2::tinyxml2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${TINYXML2_INCLUDE_DIR})
    endif()
    list(APPEND TinyXML2_TARGETS tinyxml2::tinyxml2)
  endif()
else()
  find_path(TINYXML2_INCLUDE_DIR NAMES tinyxml2.h)

  find_library(TINYXML2_LIBRARY tinyxml2)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(TinyXML2 DEFAULT_MSG TINYXML2_LIBRARY TINYXML2_INCLUDE_DIR)

  mark_as_advanced(TINYXML2_INCLUDE_DIR TINYXML2_LIBRARY)

  if(NOT TARGET tinyxml2::tinyxml2)
    add_library(tinyxml2::tinyxml2 UNKNOWN IMPORTED)
    set_property(TARGET tinyxml2::tinyxml2 PROPERTY IMPORTED_LOCATION ${TINYXML2_LIBRARY})
    set_property(TARGET tinyxml2::tinyxml2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${TINYXML2_INCLUDE_DIR})
  endif()
  list(APPEND TinyXML2_TARGETS tinyxml2::tinyxml2)
endif()

# Set mixed case INCLUDE_DIRS and LIBRARY variables from upper case ones.
if(NOT TinyXML2_INCLUDE_DIRS)
  set(TinyXML2_INCLUDE_DIRS ${TINYXML2_INCLUDE_DIR})
endif()
if(NOT TinyXML2_LIBRARIES)
  set(TinyXML2_LIBRARIES ${TINYXML2_LIBRARY})
endif()
