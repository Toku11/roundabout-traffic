import controlP5.*;
import processing.net.*;

Thread loadThread;
Client c;
String input;
Vehicle vehicle;
Vehicle agent;
//Agent agent2;
ControlP5 cp5;
Roundabout roundabout;
Info info;
Utils utils = new Utils();
PVector offset;
ArrayList<Vehicle> vehicles;
int numLanes, i=0, numCars;
boolean showInfo, debug, restarted = true;
int data[];

void setup() {
  c = new Client(this, "127.0.0.1", 65432);
  size(1000, 1000);
  frameRate(1000);
  colorMode(RGB, 255);
  stroke(255, 255, 255);
  offset = new PVector(width/2, height/2);
  roundabout = new Roundabout();
  vehicles = new ArrayList();
  agent = new Vehicle((int)random(100,1000), (int)random(0, numLanes));
 // agent2 = new Agent(true);
  info = new Info(new PVector(10,20), vehicles, agent);
  initGUI();
  //agent2.start();
  //surface.setVisible(false);
}

void draw() {
  
  if(restarted){

    pushMatrix();
    scale(1,-1);
    translate(offset.x, -offset.y);
    drawGame();
    step();
    agent.step();
    agent.draw();
    restarted = false; 
    popMatrix();
  }


  if (c.available() > 0) { 
        pushMatrix(); 
        scale(1, -1);
        translate(offset.x, -offset.y);
        
        drawGame(); // previous state
        line(0,0,165,0);
        input = c.readString(); 
        input = input.substring(0,input.indexOf("\n"));  // Only up to the newline
        data = int(split(input, ' '));  // Split values into an array
        step();
        //agent2.draw();
        agent.draw();
        agent.step();
        //for (Vehicle v : vehicles) {
          //v.draw();
          //v.getSensorReadings(16);
        //} 
        checkDensity();
        checkTraffic();
        popMatrix();
        info.draw(showInfo);
        text("Framerate: "+frameRate, 10, height-10);
      }
        //v.draw();


  //for (Vehicle v : vehicles) {
  //  v.getSensorReadings(16);
  //}

}

public void keyPressed(){
  //print(keyCode);
  //agent2.keycode = keyCode;
}

public void keyReleased(){
  //print("released");
  //agent2.keycode = 0;
}
void drawGame(){
  background(25,83,25);
  roundabout.draw();
  for (Vehicle v : vehicles) {
    v.draw();
  }
}

void initGUI() {
  cp5 = new ControlP5(this);

  cp5.addSlider("sliderLanes")
    .setPosition(180, height-60)
    .setWidth(100)
    .setRange(1, 5)
    .setValue(2)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);

  cp5.addSlider("sliderCars")
    .setPosition(10, height-60)
    .setWidth(100)
    .setRange(1, 20)
    .setValue(10)
    .setNumberOfTickMarks(20)
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

void checkDensity(){
  ArrayList<Vehicle> toRemove = new ArrayList();
  for (Vehicle v : vehicles) {
    if (v.lastIdx - 1 <= v.targetIdx || 
        utils.euclideanDist(v.pose.x, 0, v.pose.y, 0) >= 1000) {
        toRemove.add(v);
    } 
  }
  for (Vehicle v : toRemove) {
    vehicles.remove(v);
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

void step() {
 //for( int k = 0; k <= 1; k++){
  for (Vehicle v : vehicles) {
      v.step();
      //v.getSensorReadings(16);
    }
 // }
  for (PVector arm : vehicles.get(0).sensorRange){
    c.write(arm.x + " " + arm.y + " ");
  }
}

void addVehicle(){
    Vehicle v = new Vehicle((int)random(100,1000), (int)random(0, numLanes));
    v.DEBUG = debug;
    //loadThread = new Thread(v);
    //loadThread.start();
    vehicles.add(v);
}
PVector setLane() {
  int a = (int)random(0, numLanes);
  return new PVector(30*a+165, 30*a+165);
}
