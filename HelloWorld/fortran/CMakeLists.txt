# set minimum cmake version
cmake_minimum_required(VERSION 3.21)

# project name and language
project(HelloWorld LANGUAGES Fortran)

add_executable(hello_world hello.f90)
