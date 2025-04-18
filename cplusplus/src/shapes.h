#pragma once

class Shape {
 public:
  virtual double get_area() const = 0;  // Pure virtual function for area
  virtual double get_perimeter()
      const = 0;  // Pure virtual function for perimeter
  virtual ~Shape() {
  }  // Virtual destructor for proper cleanup of derived classes
};

class Circle : public Shape {
 public:
  Circle(double radius) : radius(radius) {}
  double get_area() const override;
  double get_perimeter() const override;

  double get_radius() const;

 private:
  double radius;
};
