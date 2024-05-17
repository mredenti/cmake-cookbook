cmake_minimum_required(VERSION 3.21)

project(Find LANGUAGES CXX)

#[=[
    The CXX component refers to the MPI C API being usable from C++
    whereas MPI_CXX refers to the MPI-2 C++ API that was removed in MPI-3
#]=]

find_package(MPI REQUIRED COMPONENTS CXX)

include(CMakePrintHelpers)

cmake_print_properties(
    TARGETS
        MPI::MPI_CXX
    PROPERTIES
        IMPORTED
        NAME
)

set(MPI_VARS
    MPI_CXX_COMPILER
    MPI_CXX_COMPILE_OPTIONS
    MPI_CXX_COMPILE_DEFINITIONS
    MPI_CXX_INCLUDE_DIRS
    MPI_CXX_LINK_FLAGS
    MPI_CXX_LIBRARIES
    MPI_CXX_HEADER_DIR
    MPI_VERSION)

foreach(_mpi_var ${MPI_VARS})
    cmake_print_variables(${_mpi_var})
endforeach()