import controlP5.*;
Thread loadThread;

ControlP5 cp5;
Roundabout roundabout;
//Info info;
Sensor sensor;
Utils utils = new Utils();
PVector offset;
//ArrayList<Car> cars;
ArrayList<Vehicle> vehicles;
int numLanes, i=0;
boolean showInfo;
boolean onlySimulation;
Vehicle vehicle;

void setup() {

  size(1000, 1000);
  frameRate(100);
  colorMode(RGB, 255);
  stroke(255, 255, 255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  vehicles = new ArrayList();

  //info = new Info(new PVector(10, 20), tesla, cars);
  //sensor  = new Sensor(tesla,cars);
  initGUI();

  //surface.setVisible(false);
}

void draw() {
  background(0);
  pushMatrix(); 
  scale(1, -1);
  translate(offset.x, -offset.y);

  ArrayList<Vehicle> toRemove = new ArrayList();

  for (Vehicle v : vehicles) {
    if (v.lastIdx-10 <= v.targetIdx) {
      println(vehicles + " removed"+v);
      toRemove.add(v);
    } else { 
      //vehicles.get(i).init();
      v.draw();
    }
  }

  for (Vehicle v : toRemove) {
    vehicles.remove(v);
  }

  for (Vehicle v : vehicles) {
    v.getSensorReadings(8);
  }

  checkTraffic();
  roundabout.draw();
  popMatrix();


  // info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void stop() {
  //tesla.stop = true;
  super.stop();
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
    .setRange(1, 6)
    .setValue(5)
    .setNumberOfTickMarks(6)
    .setSliderMode(Slider.FLEXIBLE);


  /*  cp5.addToggle("showInfo")
   .setPosition(10, height-100)
   .setSize(20, 20)
   .setValue(true);*/

  cp5.addToggle("onlySimulation")
    .setPosition(80, height-100)
    .setSize(20, 20)
    .setValue(false);
}

void sliderCars(int value) {
  if (vehicles.size() != value) addRandomCars(value);
}

void addRandomCars(int n) {

  vehicles.clear();

  for (int j=0; j < n; j++) {
    Vehicle v = new Vehicle(1, (int)random(1, 5));
    //loadThread = new Thread(v);
    //loadThread.start();
    vehicles.add(v);
  }
}

void checkTraffic() {
  if (vehicles.size() < 4) {
    try {
      vehicles.add(new Vehicle((int)random(0,4), (int)random(1, 5)));
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
  vehicles.add(new Vehicle((int)random(0,4), (int)random(1, 5)));
}

PVector setLane() {
  int a = (int)random(0, numLanes);
  return new PVector(30*a+165, 30*a+165);
}
