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
  frameRate(500);
  offset = new PVector(width/2, height/2);

  roundabout = new Roundabout();

  tesla = new Car("red.png", new PVector(0, 0), 10, numLanes);
  tesla.setColor(color(100));

  cars = new ArrayList();
  info = new Info(new PVector(10, 20), tesla, cars);
  
  initGUI();
  
  //surface.setVisible(false);
}

void draw() {

  background(128);
  
  pushMatrix();
  
  translate(offset.x, offset.y); 
  roundabout.draw();    
  tesla.setPosition();
  tesla.draw();
  println(tesla.time2);
  //tesla.makeSensor();
  
  for (Car car : cars) {
    car.setPosition();
    car.draw();
  }
  popMatrix();

  info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void initGUI() {
  cp5 = new ControlP5(this);
 
  cp5.addSlider("sliderLanes")
    .setPosition(180, height-60)
    .setWidth(100)
    .setRange(1, 5)
    .setValue(5)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
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
    Car c = new Car("red.png",setLane(), (int)random(10, 20), numLanes);
    c.setColor((int)random(0, 255));
    cars.add(c);
  }
}
  
void sliderLanes(int value){
  numLanes = value;
  tesla.lanes=value*30;
  sliderCars(value);
  roundabout.setLanes(value);
  }
  
PVector setLane(){
  int a = (int)random(0,numLanes);
  return new PVector(30*a+160,30*a+160);
}
