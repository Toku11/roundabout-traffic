import controlP5.*;
Thread loadThread;

ControlP5 cp5;
Roundabout roundabout;
Info info;
Sensor sensor;
Car tesla;
Utils utils = new Utils();
PVector offset;
ArrayList<Car> cars;
ArrayList<Vehicle> vehicles;
int numLanes,i=0;
boolean showInfo;
boolean onlySimulation;
Vehicle vehicle;

void setup() {
  
  size(1000, 1000);
  frameRate(500);
  colorMode(RGB,255);
  stroke(255,255,255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  
  
  tesla = new Car("red.png", setLane() , 10, numLanes);
  tesla.setColor(color(#E8351A));
  tesla.manualControl = true;
  tesla.showSensor=true;
  loadThread = new Thread(tesla);
  loadThread.start();

  cars = new ArrayList();
  vehicles = new ArrayList();
  
  info = new Info(new PVector(10, 20), tesla, cars);
  sensor  = new Sensor(tesla,cars);
  initGUI();
  vehicle = new Vehicle(1,4);

  //surface.setVisible(false);
}

void draw() {
 
  if (keyPressed) {
      tesla.keycode = keyCode;
  }
  else{
      tesla.keycode = 0;
  }
  
  background(0);
  pushMatrix(); 
  scale(1,-1);
  translate(offset.x, -offset.y);


  roundabout.draw();   
  //vehicle.draw();
  for(int i = 0; i < vehicles.size(); i++){
    if(vehicles.get(i).lastIdx - 10 <= vehicles.get(i).targetIdx){
      vehicles.remove(i); 
    }
    else 
    vehicles.get(i).draw();
  }
  /*tesla.getSensorReadings(36); 
  tesla.draw();
 // println(tesla.timeLap, ' ', tesla.speed,' ', tesla.time2);
  for (Car car : cars) {
    car.setPosition();
    car.draw();
  }
  for (Car car : cars) {
    car.getSensorReadings(8);
  }*/

    //println(tesla.isChanging(), ' ' ,tesla.actionProbability,',' ,tesla.countEffect,' ',tesla.casemove,' ',tesla.radius);
  popMatrix();
  
  
  info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void stop(){
  tesla.stop = true;
  super.stop();
}

void setEnvironment(){
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
  vehicles.clear();

  for (int j=0; j < n; j++) {
    Vehicle v = new Vehicle(2,(int)random(1,5));
    loadThread = new Thread(v);
    loadThread.start();
    vehicles.add(v);
    
    Car c = new Car("red.png", setLane(), int(random(10, 20)), numLanes);
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
