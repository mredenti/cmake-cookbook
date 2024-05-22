Classic CMake 

- https://github.com/rpavlik/cmake-modules/blob/main/module-docs/Example-FindMyPackage-UsingImportedTargets.cmake
- https://github.com/rpavlik/cmake-modules/blob/main/module-docs/Example-FindMySimplePackage.cmake

Modern way/style with Imported Targets

- https://github.com/avaucher/cmake-find-module-imported-target


# CMake Find Modules with Imported Targets

For many commonly-used libraries, one can find CMake find modules easily on the web.
However, many of those find modules only define variables for the include directories and libraries - a project using such a library must then manually set those dependencies in the following fashion:

```CMake
find_package(XXX REQUIRED)
target_include_directories(MyTarget PUBLIC ${XXX_INCLUDE_DIRS})
target_link_libraries(MyTarget PUBLIC ${XXX_LIBRARIES})
```

Nevertheless, modern CMake allows for use of imported targets, which simplifies the above to:

```CMake
find_package(XXX REQUIRED)
target_link_libraries(MyTarget PUBLIC XXX::XXX)
```

In addition to be shorter than the previous version, a big advantage is that it makes `MyTarget` independent of the specific installation of `XXX` when installing `MyTarget` as a CMake package ([here](https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#creating-packages) for details).

## Available Find modules

Many libraries already define imported targets and are not included in this project.


- Example findCMake module 

https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html#a-sample-find-module


#[=[

    This module supports requiring a minimum version 
    you can do find_package(FFTW <version>)

    Once done this will define 
        FFTW3_FOUND
        FFTW_INCLUDE_DIR
        FFTW_VERSION

    and the following imported targets

    FFTW3::FFTW

    This module reads hints about locations from the 
    following environment variables:

    FFTW_ROOT
    FFTW_ROOT_DIR

    FFTW_HOME
    FFTW_HOME_DIR


#]=]

# In the lecture we will describe how to create a simple find module for a library FOO

https://cmake.org/cmake/help/latest/guide/using-dependencies/index.html#imported-targets USAGE REQUIREMENTS

https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html#a-sample-find-module

Good explanation 

https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html#a-sample-find-module

# 
find_library(
    FFTW_LIBRARY 
    NAMES
        fftw 
        HINTS FFTW_LIB
        )

# helper for reporting the `find_package(MyLib)`
# resulting status.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MyLib
  FOUND_VAR MyLib_FOUND
  REQUIRED_VARS
    MyLib_LIBRARY
)

if (MyLib_FOUND AND NOT TARGET MyLib::MyLib)
  # create the IMPORTED target
  add_library(MyLib UNKNOWN IMPORTED)
  set_target_properties(MyLib PROPERTIES
    IMPORTED_LOCATION "${MyLib_LIBRARY}")
  add_library(MyLib::MyLib ALIAS MyLib)
endif()


Now we need to find the libraries and include files; we use the information from pkg-config to provide hints to CMake about where to look.

find_path(Foo_INCLUDE_DIR
  NAMES foo.h
  PATHS ${PC_Foo_INCLUDE_DIRS}
  PATH_SUFFIXES Foo
)
find_library(Foo_LIBRARY
  NAMES foo
  PATHS ${PC_Foo_LIBRARY_DIRS}
)
Alternatively, if the library is available with multiple configurations, you can use SelectLibraryConfigurations to automatically set the Foo_LIBRARY variable instead:

find_library(Foo_LIBRARY_RELEASE
  NAMES foo
  PATHS ${PC_Foo_LIBRARY_DIRS}/Release
)
find_library(Foo_LIBRARY_DEBUG
  NAMES foo
  PATHS ${PC_Foo_LIBRARY_DIRS}/Debug
)

include(SelectLibraryConfigurations)
select_library_configurations(Foo)
If you have a good way of getting the version (from a header file, for example), you can use that information to set Foo_VERSION (although note that find modules have traditionally used Foo_VERSION_STRING, so you may want to set both). Otherwise, attempt to use the information from pkg-config

set(Foo_VERSION ${PC_Foo_VERSION})
Now we can use FindPackageHandleStandardArgs to do most of the rest of the work for us

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Foo
  FOUND_VAR Foo_FOUND
  REQUIRED_VARS
    Foo_LIBRARY
    Foo_INCLUDE_DIR
  VERSION_VAR Foo_VERSION
)
This will check that the REQUIRED_VARS contain values (that do not end in -NOTFOUND) and set Foo_FOUND appropriately. It will also cache those values. If Foo_VERSION is set, and a required version was passed to find_package(), it will check the requested version against the one in Foo_VERSION. It will also print messages as appropriate; note that if the package was found, it will print the contents of the first required variable to indicate where it was found.

At this point, we have to provide a way for users of the find module to link to the library or libraries that were found. There are two approaches, as discussed in the Find Modules section above. The traditional variable approach looks like

if(Foo_FOUND)
  set(Foo_LIBRARIES ${Foo_LIBRARY})
  set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
  set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})
endif()
If more than one library was found, all of them should be included in these variables (see the Standard Variable Names section for more information).

When providing imported targets, these should be namespaced (hence the Foo:: prefix); CMake will recognize that values passed to target_link_libraries() that contain :: in their name are supposed to be imported targets (rather than just library names), and will produce appropriate diagnostic messages if that target does not exist (see policy CMP0028).

if(Foo_FOUND AND NOT TARGET Foo::Foo)
  add_library(Foo::Foo UNKNOWN IMPORTED)
  set_target_properties(Foo::Foo PROPERTIES
    IMPORTED_LOCATION "${Foo_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_Foo_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
  )
endif()
One thing to note about this is that the INTERFACE_INCLUDE_DIRECTORIES and similar properties should only contain information about the target itself, and not any of its dependencies. Instead, those dependencies should also be targets, and CMake should be told that they are dependencies of this target. CMake will then combine all the necessary information automatically.

The type of the IMPORTED target created in the add_library() command can always be specified as UNKNOWN type. This simplifies the code in cases where static or shared variants may be found, and CMake will determine the type by inspecting the files.


## 

Actually CMake's default is to search first for shared libraries and then for static libraries.

The key is the order of values in the CMAKE_FIND_LIBRARY_SUFFIXES global variable, which is e.g. set in CMakeGenericSystem.cmake as part of CMake's compiler/platform detection of the project() command to:

set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")


https://github.com/egpbos/findFFTW


# - Find fftw3 library
# Find the native FFTW3 includes and library
# This module defines
#  FFTW3_INCLUDE, where to find fftw3.h, etc.
# ---
#  FFTW3_LIBRARY, library to link against to use FFTW3
#  FFTW3_OMP_LIBRARY, library to link against to use FFTW3_omp
#  FFTW3_THREADS_LIBRARY, library to link against to use FFTW3_threads
#  FFTW3_FOUND, if false, do not try to use FFTW3.
#  FFTW3_OMP_FOUND, if false, do not try to use OpenMP FFTW3.
#  FFTW3_THREADS_FOUND, if false, do not try to use threaded FFTW3.
# ---
#  FFTW3L_LIBRARY, library to link against to use FFTW3l
#  FFTW3L_OMP_LIBRARY, library to link against to use FFTW3l_omp
#  FFTW3L_THREADS_LIBRARY, library to link against to use FFTW3l_threads
#  FFTW3L_FOUND, if false, do not try to use FFTW3l.
#  FFTW3L_OMP_FOUND, if false, do not try to use OpenMP FFTW3l.
#  FFTW3L_THREADS_FOUND, if false, do not try to use threaded FFTW3l.
# ---
#  FFTW3F_LIBRARY, library to link against to use FFTW3f
#  FFTW3F_OMP_LIBRARY, library to link against to use FFTW3f_omp
#  FFTW3F_THREADS_LIBRARY, library to link against to use FFTW3f_threads
#  FFTW3F_FOUND, if false, do not try to use FFTW3f.
#  FFTW3F_OMP_FOUND, if false, do not try to use OpenMP FFTW3f.
#  FFTW3F_THREADS_FOUND, if false, do not try to use threaded FFTW3f.
# ---
#  FFTW3Q_LIBRARY, library to link against to use FFTW3q
#  FFTW3Q_OMP_LIBRARY, library to link against to use FFTW3q_omp
#  FFTW3Q_THREADS_LIBRARY, library to link against to use FFTW3q_threads
#  FFTW3Q_FOUND, if false, do not try to use FFTW3q.
#  FFTW3Q_OMP_FOUND, if false, do not try to use OpenMP FFTW3q.
#  FFTW3Q_THREADS_FOUND, if false, do not try to use threaded FFTW3q.

function(add_imported_library lib_name library headers)
  add_library(FFTW3::${lib_name} UNKNOWN IMPORTED)
  set_target_properties(FFTW3::${lib_name} PROPERTIES
    IMPORTED_LOCATION ${library}
    INTERFACE_INCLUDE_DIRECTORIES ${headers}
  )
  set(${lib_name}_FOUND 1 CACHE INTERNAL "FFTW3 ${lib_name} found" FORCE)
  set(${lib_name}_LIBRARY ${library}
      CACHE STRING "Path to FFTW3::${lib_name} library" FORCE)
  set(FFTW3_INCLUDE ${headers}
      CACHE STRING "Path to FFTW3 headers" FORCE)
  mark_as_advanced(FORCE ${lib_name}_LIBRARY)
  mark_as_advanced(FORCE FFTW3_INCLUDE)
endfunction()

#as35 if (FFTW3_LIBRARY AND FFTW3_INCLUDE)
#as35   add_imported_library(${FFTW3_LIBRARY} ${FFTW3_INCLUDE})
#as35   if (FFTW3_OMP_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3_OMP_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3_THREAD_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3_THRED_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3L_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3L_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3L_OMP_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3L_OMP_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3L_THREAD_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3L_THRED_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3F_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3F_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3F_OMP_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3F_OMP_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3F_THREAD_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3F_THRED_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3Q_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3Q_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3Q_OMP_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3Q_OMP_LIBRARY} ${FFTW3_INCLUDE})
#as35   elseif (FFTW3Q_THREAD_LIBRARY AND FFTW3_INCLUDE)
#as35     add_imported_library(${FFTW3Q_THRED_LIBRARY} ${FFTW3_INCLUDE})
#as35   endif()
#as35   return()
#as35 endif()

find_path(FFTW3_INCLUDE NAMES fftw3.h
  HINTS "/usr/include" "/opt/local/include" "/app/include"
)

find_library(FFTW3_LIBRARY fftw3)
find_library(FFTW3_OMP_LIBRARY fftw3_omp)
find_library(FFTW3_THREAD_LIBRARY fftw3_threads)
find_library(FFTW3L_LIBRARY fftw3l)
find_library(FFTW3L_OMP_LIBRARY fftw3l_omp)
find_library(FFTW3L_THREAD_LIBRARY fftw3l_threads)
find_library(FFTW3F_LIBRARY fftw3f)
find_library(FFTW3F_OMP_LIBRARY fftw3f_omp)
find_library(FFTW3F_THREAD_LIBRARY fftw3f_threads)
find_library(FFTW3Q_LIBRARY fftw3q)
find_library(FFTW3Q_OMP_LIBRARY fftw3q_omp)
find_library(FFTW3Q_THREAD_LIBRARY fftw3q_threads)

# handle the QUIETLY and REQUIRED arguments and set FFTW3_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)

# FFTW3
find_package_handle_standard_args(FFTW3
                                  DEFAULT_MSG FFTW3_LIBRARY FFTW3_INCLUDE
                                 )
if (FFTW3_FOUND)
  add_imported_library("FFTW3" "${FFTW3_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3_OMP
find_package_handle_standard_args(FFTW3_OMP
                                  REQUIRED_VARS FFTW3_OMP_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3_OMP_FOUND)
  add_imported_library("FFTW3_OMP" "${FFTW3_OMP_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3_THREAD
find_package_handle_standard_args(FFTW3_THREAD
                                  REQUIRED_VARS FFTW3_THREAD_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3_THREAD_FOUND)
  add_imported_library("FFTW3_THREAD" "${FFTW3_THREAD_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3L
find_package_handle_standard_args(FFTW3L
                                  REQUIRED_VARS FFTW3L_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3L_FOUND)
  add_imported_library("FFTW3L" "${FFTW3L_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3L_OMP
find_package_handle_standard_args(FFTW3L_OMP
                                  REQUIRED_VARS FFTW3L_OMP_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3L_OMP_FOUND)
  add_imported_library("FFTW3L_OMP" "${FFTW3L_OMP_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3L_THREAD
find_package_handle_standard_args(FFTW3L_THREAD
                                  REQUIRED_VARS FFTW3L_THREAD_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3L_THREAD_FOUND)
  add_imported_library("FFTW3L_THREAD" "${FFTW3L_THREAD_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3F
find_package_handle_standard_args(FFTW3F
                                  REQUIRED_VARS FFTW3F_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3F_FOUND)
  add_imported_library("FFTW3F" "${FFTW3F_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3F_OMP
find_package_handle_standard_args(FFTW3F_OMP
                                  REQUIRED_VARS FFTW3F_OMP_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3F_OMP_FOUND)
  add_imported_library("FFTW3F_OMP" "${FFTW3F_OMP_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3F_THREAD
find_package_handle_standard_args(FFTW3F_THREAD
                                  REQUIRED_VARS FFTW3F_THREAD_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3F_THREAD_FOUND)
  add_imported_library("FFTW3F_THREAD" "${FFTW3F_THREAD_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3Q
find_package_handle_standard_args(FFTW3Q
                                  REQUIRED_VARS FFTW3Q_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3Q_FOUND)
  add_imported_library("FFTW3Q" "${FFTW3Q_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3Q_OMP
find_package_handle_standard_args(FFTW3Q_OMP
                                  REQUIRED_VARS FFTW3Q_OMP_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3Q_OMP_FOUND)
  add_imported_library("FFTW3Q_OMP" "${FFTW3Q_OMP_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

# FFTW3Q_THREAD
find_package_handle_standard_args(FFTW3Q_THREAD
                                  REQUIRED_VARS FFTW3Q_THREAD_LIBRARY FFTW3_INCLUDE
                                  HANDLE_COMPONENTS
                                  NAME_MISMATCHED
                                 )
if (FFTW3Q_THREAD_FOUND)
  add_imported_library("FFTW3Q_THREAD" "${FFTW3Q_THREAD_LIBRARY}" "${FFTW3_INCLUDE}")
endif()

pkg_check_modules(FFTW fftw3 QUIET)

if (FFTW3_FOUND)
  message("-- Found FFTW3: ${FFTW3_INCLUDE}, Version: ${FFTW_VERSION}")
endif (FFTW3_FOUND)


AND ALSO CHECK HELP findInit