class Sensor {
  private int range;
  Car tesla;
  ArrayList<Car> cars;
  PVector position;
  
Sensor(PVector position, Car car, ArrayList<Car> cars) {
    this.position = position;
    this.tesla = car;
    this.cars = cars;
  }



  void setRange(int range) {
    this.range = range;
  }
  

}
