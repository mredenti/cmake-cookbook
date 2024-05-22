# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindFFTW
-------

Finds the FFTW library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``FFTW::FFTW``
  The FFTW library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``FFTW_FOUND``
  True if the system has the Foo library.
``FFTW_VERSION``
  The version of the Foo library which was found.
``FFTW_INCLUDE_DIRS``
  Include directories needed to use Foo.
``FFTW_LIBRARIES``
  Libraries needed to link to Foo.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``FFTW_INCLUDE_DIR``
  The directory containing ``fftw3.h``.
``FFTW_LIBRARY``
  The path to the Foo library.

#]=======================================================================]

if( NOT FFTW_HOME AND DEFINED ENV{FFTW_HOME} )
    set( FFTW_ROOT $ENV{FFTW_HOME} )
endif()

if( NOT FFTW_ROOT AND DEFINED ENV{FFTW_ROOT} )
    set( FFTW_ROOT $ENV{FFTW_ROOT} )
endif()

# Find FFTW header path This command is used to find a directory containing the named file.
find_path( 
    FFTW_INCLUDE_DIR # # A cache entry, or a normal variable if ``NO_CACHE`` is specified, named by ``<VAR>`` is created to store the result of this command.
    NAMES 
        fftw3.h
    PATHS #   Specify directories to search in addition to the default locations. The ``ENV var`` sub-option reads paths from a system environment variable.
        ${FFTW_ROOT}/include
        /usr/local/include
        /usr/include
        /opt/fftw3/include
    DOC 
        "Path to FFTW include directory" # Specify the documentation string for the ``<VAR>`` cache entry.
)

find_library( # If the library is found the result is stored in the variable and the search will not be repeated unless the variable is cleared.
    FFTW_LIBRARY # A cache entry, or a normal variable if ``NO_CACHE`` is specified, named by ``<VAR>`` is created to store the result of this command.
    NAMES 
        fftw3 # will look for libfftw3.so on Unix CMake's default is to search first for shared libraries and then for static libraries
    PATHS #   Specify directories to search in addition to the default locations. The ``ENV var`` sub-option reads paths from a system environment variable.
        ${FFTW_ROOT}
    PATH_SUFFIXES 
        "lib" "lib64" 
    DOC 
        "Path to FFTW library" # Specify the documentation string for the ``<VAR>`` cache entry.
)

if(NOT ${CMAKE_C_PLATFORM_ID} STREQUAL "Windows")
find_library(ZeroMQ_LIBRARIES
NAMES
zmq
HINTS
${_ZeroMQ_ROOT}/lib
${_ZeroMQ_ROOT}/lib/x86_64-linux-gnu
)
else()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FFTW
  FOUND_VAR 
    FFTW_FOUND
  REQUIRED_VARS # This will check that the REQUIRED_VARS contain values (that do not end in -NOTFOUND) and set Foo_FOUND appropriately.
    FFTW_LIBRARY # Also, the values will be cached
    FFTW_INCLUDE_DIR # If Foo_VERSION is set, and a required version was passed to find_package(), it will check the requested version against the one in Foo_VERSION.
)

if(FFTW__FOUND)
  set(FFTW_LIBRARIES ${FFTW_LIBRARY})
  #set (FFTW3_LIBRARY_DIRS )
  set(FFTW_INCLUDE_DIRS ${FFTW_INCLUDE_DIR})
endif()


#[=[
    set(_ZeroMQ_H ${ZeroMQ_INCLUDE_DIRS}/zmq.h)
    function(_zmqver_EXTRACT _ZeroMQ_VER_COMPONENT _ZeroMQ_VER_OUTPUT)
    set(CMAKE_MATCH_1 "0")
    set(_ZeroMQ_expr "^[ \\t]*#define[ \\t]+${_ZeroMQ_VER_COMPONENT}[
    \\t]+([0-9]+)$")
    file(STRINGS "${_ZeroMQ_H}" _ZeroMQ_ver REGEX "${_ZeroMQ_expr}")
    string(REGEX MATCH "${_ZeroMQ_expr}" ZeroMQ_ver "${_ZeroMQ_ver}")
    set(${_ZeroMQ_VER_OUTPUT} "${CMAKE_MATCH_1}" PARENT_SCOPE)
    endfunction()
    _zmqver_EXTRACT("ZMQ_VERSION_MAJOR" ZeroMQ_VERSION_MAJOR)
    _zmqver_EXTRACT("ZMQ_VERSION_MINOR" ZeroMQ_VERSION_MINOR)
    _zmqver_EXTRACT("ZMQ_VERSION_PATCH" ZeroMQ_VERSION_PATCH)
#]=]


# CMake will recognize that values passed to target_link_libraries() that contain :: in their name are supposed to be imported targets 
# (rather than just library names)
# One thing to note about this is that the INTERFACE_INCLUDE_DIRECTORIES and similar properties should only contain information about the target itself, 
# and not any of its dependencies. Instead, those dependencies should also be targets, 
#and CMake should be told that they are dependencies of this target. CMake will then combine all the necessary information automatically.

if(FFTW3_FOUND AND NOT TARGET FFTW3::fftw3)
  add_library(FFTW3::fftw3 UNKNOWN IMPORTED) # The type of the IMPORTED target created in the add_library() command can always be specified as UNKNOWN type. 
  # This simplifies the code in cases where static or shared variants may be found, and CMake will determine the type by inspecting the files.
  set_target_properties(FFTW::fftw3 PROPERTIES
    IMPORTED_LOCATION "${FFTW_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${FFTW_INCLUDE_DIR}"
  )
endif()

# Creates an :ref:`IMPORTED library target <Imported Targets>` called ``<name>``.
# No rules are generated to build it, and the ``IMPORTED`` target property is ``True``.
# The target name has scope in the directory in which
# it is created and below, but the ``GLOBAL`` option extends visibility.
# It may be referenced like any target built within the project.

# Most of the cache variables should be hidden in the ccmake interface unless the user explicitly asks to edit them.
mark_as_advanced(
  FFTW_INCLUDE_DIR
  FFTW_LIBRARY
)


# maybe also try to find the component with fftw-mpi