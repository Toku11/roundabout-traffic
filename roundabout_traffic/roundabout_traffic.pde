import controlP5.*;

ControlP5 cp5;
Roundabout roundabout;
Info info;

PVector offset;

ArrayList<Car> cars;
Car tesla;

boolean showInfo;
boolean onlySimulation;
int sliderTicks2 = 30;
int i=0;


void setup() {
  size(1000, 1000);
  frameRate(200);
  offset = new PVector(width/2, height/2);

  roundabout = new Roundabout(500, 2);

  tesla = new Car("red.png", new PVector(0, 0), 0);
  tesla.setColor(color(100));

  cars = new ArrayList();


  info = new Info(new PVector(10, 20), tesla, cars);

  initGUI();

}

void draw() {

  background(128);
  
  pushMatrix();
  translate(offset.x, offset.y); 
  roundabout.draw();
  for (Car car : cars) {
    car.setPosition();//new PVector(mouseX-width/2, mouseY-height/2));
    car.setRotation(new Vec2D(0, 0), car.distanceToCenter().y, 0.08);
    tesla.setRotation(new Vec2D(0, 0), tesla.distanceToCenter().y, 0.08);
    tesla.draw();
    car.draw();
  }
  popMatrix();


  info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void initGUI() {
  cp5 = new ControlP5(this);

  cp5.addSlider("sliderCars")
    .setPosition(10, height-60)
    .setWidth(100)
    .setRange(1, 5)
    .setValue(2)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);

  cp5.addToggle("showInfo")
    .setPosition(10, height-100)
    .setSize(20, 20)
    .setValue(true);

  cp5.addToggle("onlySimulation")
    .setPosition(80, height-100)
    .setSize(20, 20)
    .setValue(false);
}

void sliderCars(int value) {
  if (cars.size() != value) addRandomCars(value);
}

void addRandomCars(int n) {
  cars.clear();
  for (int j=0; j<n; j++) {
    Car c = new Car("red.png", new PVector(30*j+160, 30*j+160), (int)random(10, 20));
    c.setColor((int)random(0, 255));
    cars.add(c);
  }
}
