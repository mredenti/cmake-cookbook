# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

include(CMakePrintHelpers)

# project name and language
project(ENABLED_LANGUAGES LANGUAGES CXX Fortran CUDA)

get_property(_languages GLOBAL PROPERTY ENABLED_LANGUAGES) # GLOBAL has properties which refer to the project

foreach(lang ${_languages})

    message(STATUS "${lang}")

    cmake_print_variables(${CMAKE_${lang}_COMPILER_LIST})

endforeach()    


