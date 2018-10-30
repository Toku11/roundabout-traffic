class Info {
  PVector position;
  Car testCar;
  ArrayList<Car> aiCars;
  
  int line, spacing = 14;

  Info(PVector position, Car car, ArrayList<Car> cars) {
    this.position = position;
    this.testCar = car;
    this.aiCars = cars;
  }

/*  void draw(boolean active) {
    if (!active) return;
    line = 0;

    printText("Distance to center: " + testCar.distanceToCenter().x);

    for (Car car : cars) {
      line++;
      PVector vec = testCar.distanceToCar(car);
      printText("Distance: " + vec.x);
      printText("Angle: " + vec.y*180/PI +"°");
      printText("Speed: " + car.speed);
      printText("In range from sensor: " + testCar.sensor(car, new PVector(300, 300) ));
    }
  }*/

  void printText(String str) {
    text(str, position.x, position.y+line*spacing);
    line++;
  }
}
