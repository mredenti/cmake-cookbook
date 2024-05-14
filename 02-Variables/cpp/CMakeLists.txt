cmake_minimum_required(VERSION 3.21)

project(Variables DESCRIPTION "Variables" LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

add_subdirectory(src)

include(CMakePrintHelpers)

# use macro to print name of each variable followed by its value
cmake_print_variables(CMAKE_CXX_STANDARD)

cmake_print_variables(CMAKE_SOURCE_DIR)
cmake_print_variables(CMAKE_BINARY_DIR)
