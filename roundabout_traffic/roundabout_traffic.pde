import controlP5.*;

ControlP5 cp5;
Roundabout roundabout;
Info info;

PVector offset;

ArrayList<Car> cars;
Car tesla;
int numLanes;
boolean showInfo;
boolean onlySimulation;



void setup() {
  size(1000, 1000);
  frameRate(200);
  offset = new PVector(width/2, height/2);

  roundabout = new Roundabout(500);

  tesla = new Car("red.png", new PVector(0, 0), 0, numLanes);
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
  tesla.setRotation(new Vec2D(0, 0), tesla.distanceToCenter().y, 0.08);
  tesla.draw();
  for (Car car : cars) {
    car.setPosition();//new PVector(mouseX-width/2, mouseY-height/2));
    car.setRotation(new Vec2D(0, 0), car.distanceToCenter().y, 0.08);
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
    .setValue(5)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
  cp5.addSlider("sliderLanes")
    .setPosition(180, height-60)
    .setWidth(100)
    .setRange(1, 5)
    .setValue(5)
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
    Car c = new Car("red.png",lane(), (int)random(10, 20), numLanes);
    c.setColor((int)random(0, 255));
    cars.add(c);
  }
}
  
void sliderLanes(int value){
  numLanes = value;
  sliderCars(value);
  roundabout.setLanes(value);
  }
  
PVector lane(){
  int a = (int)random(0,numLanes);
  return new PVector(30*a+160,30*a+160);
}
