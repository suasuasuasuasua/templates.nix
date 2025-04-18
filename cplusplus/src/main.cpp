#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

#include "shapes.h"

int main() {
  std::cout << "Hello, world!" << std::endl;

  std::vector<int> my_vector{1, 2, 3, 4, 5};

  for (std::size_t i = 0; i < my_vector.size(); ++i) {
    float val = static_cast<float>(my_vector[i]);
    Circle circle1 = Circle(val);

    std::cout << "Radius: " << circle1.get_radius()
              << " Area: " << circle1.get_area() << std::endl;
  }

  return 0;
}
