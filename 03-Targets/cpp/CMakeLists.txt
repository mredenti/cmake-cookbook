# set minimum cmake version
cmake_minimum_required(VERSION 3.21)

# project name and language
project(HelloWorld LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(hello_world hello.cpp)
add_executable(HelloWorld::hello_world ALIAS hello_world)

# Print a few properties
include(CMakePrintHelpers)
cmake_print_properties(
    TARGETS 
        HelloWorld::hello_world
    PROPERTIES 
        ALIASED_TARGET 
        CXX_STANDARD CXX_STANDARD_REQUIRED CXX_EXTENSIONS)