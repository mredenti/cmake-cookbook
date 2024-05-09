# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-06 LANGUAGES Fortran)

message(STATUS "Is the Fortran compiler loaded? ${CMAKE_Fortran_COMPILER_LOADED}")
if(CMAKE_Fortran_COMPILER_LOADED)
  message(STATUS "The Fortran compiler ID is: ${CMAKE_Fortran_COMPILER_ID}")
  message(STATUS "Is the Fortran from GNU? ${CMAKE_COMPILER_IS_GNUG77}")
  message(STATUS "The Fortran compiler version is: ${CMAKE_Fortran_COMPILER_VERSION}")
endif()
