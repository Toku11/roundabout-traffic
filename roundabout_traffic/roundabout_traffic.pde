import controlP5.*;

ControlP5 cp5;
Roundabout roundabout;
Info info;
Sensor sensor;
Car tesla;

PVector offset;
ArrayList<Car> cars;

int numLanes;
boolean showInfo;
boolean onlySimulation;



void setup() {
  
  size(1000, 1000);
  frameRate(500);
  colorMode(RGB,255);
  stroke(255,255,255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  tesla = new Car("red.png", setLane()/*new PVector(80,-300)*/ , 10, numLanes);
  tesla.setColor(color(#E8351A));
  cars = new ArrayList();
  info = new Info(new PVector(10, 20), tesla, cars);
  sensor  = new Sensor(tesla,cars);
  initGUI();
  
  //surface.setVisible(false);
}

void draw() {

  background(0);
  
  pushMatrix();  
  translate(offset.x, offset.y);
  setEnvironment();
  
  for (Car car : cars) {
    car.getSensorReadings(8);
  }
    tesla.getSensorReadings(8); 

  popMatrix();
  
  
  info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void setEnvironment(){
  roundabout.draw();    
  tesla.setPosition();
  tesla.showSensor=true;
  tesla.draw();
  for (Car car : cars) {
    car.setPosition();
    car.draw();
  }


  
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
    .setRange(1, 10)
    .setValue(10)
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
    c.setColor(color(#BDFCED));//(int)random(100, 255));
    cars.add(c);
  }
  
}
  
void sliderLanes(int value){
  numLanes = value;
  tesla.lanes = value*30;
  sliderCars(value);
  roundabout.setLanes(value);
  }
  
PVector setLane(){
  int a = (int)random(0,numLanes);
  return new PVector(30*a+165,30*a+165);
}
