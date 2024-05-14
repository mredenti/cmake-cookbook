program compute_areas

  use iso_fortran_env, only: compiler_version, compiler_options

  use class_Circle
  use class_Square

  implicit none

  type(Circle) :: c
  type(Square) :: s

  print '(4a)', 'This file was compiled by ', &
              compiler_version(), ' using the options ', &
              compiler_options()

  c = Circle(2.5293)
  s = Square(10.0)

  call c%print
  call s%print

end program
