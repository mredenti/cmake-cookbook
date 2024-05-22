cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-10 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

#[=[
    We append the current source directory, CMAKE_CURRENT_SOURCE_DIR, to the
    list of paths where CMake will look for modules, CMAKE_MODULE_PATH. This is
    where our own FindFFTW.cmake module is located
#]=]

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})


#[=[
We will discuss FindZeroMQ.cmake later, but now that the FindZeroMQ.cmake
module is available, we search for the library. This is a required dependency for
our project. Since we did not use the QUIET option to find_package, status
messages will be printed automatically when the library is found
#]=]

find_package(FFTW3 REQUIRED)