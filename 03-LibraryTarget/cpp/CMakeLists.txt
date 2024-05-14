# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-08 LANGUAGES CXX)


include(CMakePrintHelpers)

cmake_print_variables(CMAKE_CXX_FLAGS)

list(APPEND flags "-fPIC" "-Wall")
if(NOT WIN32)
  list(APPEND flags "-Wextra" "-Wpedantic")
endif()

add_library(geometry STATIC)

# Set the policy to handle relative paths in target_sources
cmake_policy(SET CMP0076 NEW)

#[==[
  PRIVATE: only used when building this target
  INTERFACE: only used by things that consume this target, not the target itself
  PUBLIC: merges the two above

  https://leimao.github.io/blog/Transitive-VS-Non-Transitive-Dependency-In-Build/

  Or in other words 
    PRIVATE only cares about himself and does not allow inheritance. 
    INTERFACE only cares about others and allows inheritance. 
    PUBLIC cares about everyone and allows inheritance.
#]==]


target_include_directories(
  geometry 
  PUBLIC 
    ${PROJECT_SOURCE_DIR}/include)

target_sources(
  geometry
  PRIVATE # If you add a .cpp file as PUBLIC, you are saying that it should be compiled into the current target and anything that links to it
    geometry_circle.cpp
    geometry_square.cpp
  PUBLIC 
    ./include/geometry_circle.hpp
    ./include/geometry_square.hpp)

target_compile_options(geometry
  PRIVATE
    ${flags}
  )

add_executable(compute-areas compute-areas.cpp)
target_compile_options(compute-areas
  PRIVATE
    "-fPIC"
  )

target_link_libraries(compute-areas geometry)

# print properties of geometry library
get_target_property(GEOMETRY_SOURCES geometry SOURCES)
cmake_print_variables(GEOMETRY_SOURCES)