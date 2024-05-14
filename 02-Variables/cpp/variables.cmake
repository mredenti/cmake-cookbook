set(CMAKE_CXX_STANDARD 11)
# compiler must exactly satisfy the standard
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(CMakePrintHelpers)

# use macro to print name of each variable followed by its value
cmake_print_variables(CMAKE_CXX_COMPILER)
cmake_print_variables(CMAKE_CXX_STANDARD)
cmake_print_variables(CMAKE_CXX_STANDARD_REQUIRED)
cmake_print_variables(CMAKE_CXX_EXTENSIONS)
