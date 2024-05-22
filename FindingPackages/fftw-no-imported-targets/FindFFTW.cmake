#[=======================================================================[
FindFFTW
-------

Find the Fast Fourier Transform  (MPI) implementation.

The Fastest Fourier Transform in the West (FFTW) is a C subroutine library
for computing discrete Fourier transforms (DFTs) in one or more dimensions, 
of arbitrary input size, and of both real and complex data (as well as of 
even/odd data, i.e. the discrete cosine/sine transforms or DCT/DST).


Variables for using FFTW
^^^^^^^^^^^^^^^^^^^^^^^


Depending on ... the following variables will be set:

``FFTW_FOUND``

``FFTW_VERSION``




#]=======================================================================]



#[=[

    Check whether the FFTW_ROOT CMake variable was set by the user.  
    This variable can be used to guide detection of the FFTW library 
    to a non-standard installation directory. The user might have set 
    FFTW_ROOT as an environmen variable as we check for that

#]=]


if(NOT FFTW_ROOT) # add also and not FFTW_HOME
    set(FFTW_ROOT "$ENV{FFTW_ROOT}") # mmm can you not just add HINTS to the find path..?
endif()

#[=[

    Search for the location of the fftw3.h header file on the system. 
    This is based on the _FFTW_ROOT variable and uses the find_path() 
    CMake command:

#]=]

if(NOT FFTW_ROOT)
    find_path(_FFTW_ROOT 
        NAMES 
            include/fftw3.h
        DOC 
            "Home directory of FFTW library.") # mmm I think I would rather set a FFTW_INCLUDE_DIR variable
else()
    set(_FFTW_ROOT "${FFTW_ROOT}")
endif()

find_path(
    FFTW_INCLUDE_DIRS 
    NAMES 
        fftw3.h 
        HINTS 
            ${_FFTW_ROOT}/include
    DOC 
        "Path to FFTW include directory")


#[=[

    If the header file was successfully found, FFTW_INCLUDE_DIRS is set to its
    location. We proceed to find the version of the ZFFTW library available, using
    string manipulations and regular expressions

#]=]


set(_ZFFTW_H ${FFTW_INCLUDE_DIRS}/fftw3.h)


#[=[

    # Cache Variables: (not for direct use in CMakeLists.txt)
    #  MYPACKAGE_ROOT
    #  MYPACKAGE_LIBRARY
    #  MYPACKAGE_INCLUDE_DIR
    #  MYPACKAGE_a_LIBRARY
    #  MYPACKAGE_a_INCLUDE_DIR
    #  MYPACKAGE_b_LIBRARY
    #  MYPACKAGE_b_INCLUDE_DIR
    #  MYPACKAGE_c_LIBRARY
    #  MYPACKAGE_c_INCLUDE_DIR

#]=]