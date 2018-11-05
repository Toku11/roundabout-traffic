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
int numLanes,i=0;
boolean showInfo;
boolean onlySimulation;
Vehicle vehicle;

void setup() {
  
  size(1000, 1000);
  frameRate(100);
  colorMode(RGB,255);
  stroke(255,255,255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  vehicles = new ArrayList();
  
  //info = new Info(new PVector(10, 20), tesla, cars);
  //sensor  = new Sensor(tesla,cars);
  initGUI();

  //surface.setVisible(false);
}

void draw() {
 /*
  if (keyPressed) {
      tesla.keycode = keyCode;
  }
  else{
      tesla.keycode = 0;
  }
  */
  background(0);
  pushMatrix(); 
  scale(1,-1);
  translate(offset.x, -offset.y);


  //vehicle.draw();
  for(int i = 0; i < vehicles.size(); i++){
    if(vehicles.get(i).lastIdx-1 <= vehicles.get(i).targetIdx){
      println(vehicles + " removed"+ vehicles.get(i));
      vehicles.remove(i); 
    }
    else{ 
    vehicles.get(i).init();
    vehicles.get(i).draw();
    }
  }
  for(int i = 0; i < vehicles.size(); i++){
      vehicles.get(i).getSensorReadings(8);
  }
  checkTraffic();
  roundabout.draw();   
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
  
  
 // info.draw(showInfo);
  text("Framerate: "+frameRate, 10, height-10);
}

void stop(){
  //tesla.stop = true;
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
    Vehicle v = new Vehicle(1,(int)random(1,5));
    //loadThread = new Thread(v);
    //loadThread.start();
    vehicles.add(v);
  }
  
}

void checkTraffic(){
  if(vehicles.size() < 4){
    vehicles.add(new Vehicle(1,(int)random(1,5)));
  }
}
void sliderLanes(int value){
  numLanes = value;
  sliderCars(value);
  roundabout.setLanes(value);
  }
  
PVector setLane(){
  int a = (int)random(0,numLanes);
  return new PVector(30*a+165,30*a+165);
}
