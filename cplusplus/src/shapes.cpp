#include "shapes.h"

#include <cmath>

double Circle::get_area() const { return M_PI * radius * radius; }

double Circle::get_perimeter() const { return 2 * M_PI * radius; }

double Circle::get_radius() const { return radius; }
