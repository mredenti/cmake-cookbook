#include "geometry_circle.hpp"
#include "geometry_square.hpp"

#include <cstdlib>
#include <iostream>

int main() {
  using namespace geometry;

  double radius = 2.5293;
  double A_circle = area::circle(radius);
  std::cout << "A circle of radius " << radius << " has an area of " << A_circle
            << std::endl;

  double l = 10.0;
  double A_square = area::square(l);
  std::cout << "A square of side " << l << " has an area of " << A_square
            << std::endl;

  return EXIT_SUCCESS;
}
