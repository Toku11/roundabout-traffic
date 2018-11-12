import controlP5.*;
Thread loadThread;

Vehicle vehicle;
ControlP5 cp5;
Roundabout roundabout;
Info info;
Utils utils = new Utils();
PVector offset;
ArrayList<Vehicle> vehicles;
int numLanes, i=0, numCars;
boolean showInfo, debug;


void setup() {

  size(1000, 1000);
  frameRate(100);
  colorMode(RGB, 255);
  stroke(255, 255, 255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  vehicles = new ArrayList();
  info = new Info(new PVector(10,20), vehicles);
  initGUI();

  //surface.setVisible(false);
}

void draw() {
  background(0);
  pushMatrix(); 
  scale(1, -1);
  translate(offset.x, -offset.y);

  ArrayList<Vehicle> toRemove = new ArrayList();
  roundabout.draw();
  for (Vehicle v : vehicles) {
    if (v.lastIdx - 1 <= v.targetIdx) {
      toRemove.add(v);
    } else { 
      v.draw();
      v.DEBUG = debug;
    }
  }

  for (Vehicle v : toRemove) {
    vehicles.remove(v);
  }

  for (Vehicle v : vehicles) {
    v.getSensorReadings(16);
  }

  checkTraffic();

  popMatrix();


  info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void setEnvironment() {
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
    .setRange(1, 20)
    .setValue(5)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);


  cp5.addToggle("showInfo")
   .setPosition(10, height-100)
   .setSize(20, 20)
   .setValue(true);

  cp5.addToggle("debug")
    .setPosition(80, height-100)
    .setSize(20, 20)
    .setValue(false);
}
void debug(boolean value){
  debug = value;
}
void sliderCars(int value) {
  numCars = value;
  if (vehicles.size() != value) addRandomCars(value);
}

void addRandomCars(int n) {

  vehicles.clear();

  for (int j=0; j < n; j++) {
    addVehicle();
  }
}

void checkTraffic() {
  if (vehicles.size() < numCars) {
    try {
      addVehicle();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}
void sliderLanes(int value) {
  numLanes = value;
  sliderCars(value);
  roundabout.setLanes(value);
}

void mouseClicked() {
  addVehicle();
}

void addVehicle(){
    Vehicle v = new Vehicle(100, (int)random(0, numLanes));
    //loadThread = new Thread(v);
    //loadThread.start();
    vehicles.add(v);
}
PVector setLane() {
  int a = (int)random(0, numLanes);
  return new PVector(30*a+165, 30*a+165);
}
