Roundabout roundabout;
int i=0;
Car tesla;
ArrayList<Car> cars;

void setup() {
  size(800, 600);
  frameRate = 1;
  roundabout = new Roundabout(500, 2);

  tesla = new Car("red.png", new PVector(0, 0),10);
  tesla.setColor(color(100));

  cars = new ArrayList();
  cars.add(new Car("red.png", new PVector(0, 0),10));
  cars.add(new Car("red.png", new PVector(0, 0),50));
  cars.get(0).setColor(color(180));
}

void draw() {
  
  background(128);
  translate(width/2, height/2);
  
  roundabout.draw();
  
  tesla.setRotation(new Vec2D(0,0),0, 1.0);


  if (i<=360) i=i+1;
  else i=0;
  
  for (Car car : cars) {
      car.setPosition();//new PVector(mouseX-width/2, mouseY-height/2));
      car.setRotation(new Vec2D(0,0),car.distanceToCenter().y, 0.1);
      tesla.setRotation(new Vec2D(0,0),tesla.distanceToCenter().y, 0.1);
      tesla.draw();
      car.draw();
    
  }
}

void mouseClicked() {
  Vec2D vec = tesla.distanceToCar(cars.get(0));

  println("Distance to center: " + tesla.distanceToCenter().x);
  println("Distance to car: " + vec.x + " Angulo: "+ vec.y*180/PI);
  println("sensor: " + tesla.sensor(cars.get(0), new PVector(300,300) ));
  println("x: "+mouseX);
}
