class Sensor {
  private int range;
  Car teslas;
  ArrayList<Car> cars;
  PVector position;
  
Sensor(PVector position, Car car, ArrayList<Car> cars) {
    this.position = position;
    this.teslas = car;
    this.cars = cars;
  }

  void setRange(int range) {
    this.range = range;
  }
  

}
