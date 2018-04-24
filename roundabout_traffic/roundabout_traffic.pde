Roundabout roundabout;

Car tesla;
ArrayList<Car> cars;

void setup() {
  size(800, 600);
  noStroke();
  frameRate = 120;
  Vec2D rot;
  roundabout = new Roundabout(500, 2);

  tesla = new Car("red.png", new PVector(0, 0), 30, 60);
  tesla.setColor(color(100));
  cars = new ArrayList();

  cars.add(new Car("red.png", new PVector(0, 0), 30, 60));
}

void draw() {
  background(128);
  translate(width/2, height/2);

  roundabout.draw();
  tesla.setRotation(new Vec2D(0,0),0, 1.0);
  tesla.draw();
  
  for (Car car : cars) {
    car.setPosition(new PVector(mouseX-width/2, mouseY-height/2));
    float angle=tesla.distance2Car(car).y;
    car.setRotation(new Vec2D(0,0),angle, 1.0);
    car.draw();
  }
}

void mouseClicked() {
  Vec2D vec = tesla.distance2Car(cars.get(0));

  println("Distance to center: " + tesla.distance2Center());
  println("Distance to car: " + vec.x + " Angulo: "+ vec.y*180/PI);
  println("sensor: " + tesla.sensor(cars.get(0), new PVector(300,300) ));
  println("x: "+mouseX);
}
