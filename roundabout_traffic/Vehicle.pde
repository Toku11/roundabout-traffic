/*
This code is a Java implementation of the code de Atsushi Sakai 
Path tracking simulation with Stanley steering control and P speed control.
maintainer: Tokunaga Oscar oscar.tokunaga@cinvestav.com
*/

class Vehicle extends Thread{
  boolean DEBUG = false;
  PImage vImage;
  int time = millis(), lanes, targetIdx = 0, lastIdx;
  float v = 0f, Kp = 1.0, k = 0.1, targetSpeed = 0,
        L = 3f, max_steer = radians(30.0);
  PVector pose = new PVector();
  Utils utils = new Utils();
  CubicSplinePlanner csp = new CubicSplinePlanner();
  ArrayList<ArrayList<Float>> spline;
  
  Vehicle(float vel, int lanes){
    this.targetSpeed = vel;
    this.lanes = lanes;
    vImage = loadImage("red.png");
    vImage.resize(50,20);
    imageMode(CENTER);
    this.spline = createSpline(randInOut(),2);
    this.lastIdx = spline.get(0).size();
  } 
  
  public void draw() {  
    //init();
    pushMatrix();
    translate(this.pose.x, this.pose.y);
    rotate(this.pose.z);
    image(vImage, 0, 0);  
    popMatrix();
    if(DEBUG)
    printSpline(this.spline);
  }
  
  int[] randInOut(){
    int[] output = new int[]{(int)random(1,4),(int)random(1,4)};
    return output;
  }
  void init(){
    float ai = pControl(this.targetSpeed, this.v);
    float[] sc = stanleyControl(this.spline, this.targetIdx);
    this.targetIdx = (int)sc[1];
    updateState(ai,sc[0]);
  }
  
  void updateStateAgents(){
  
  }
  void updateState(float accel, float delta){
    myDelay(100);
    delta = utils.clip_(delta, -max_steer, max_steer);
    float dt = clk() / 1000; 
    println(this.time);
    //println(clk());
    this.pose.x += this.v * cos(this.pose.z) * dt;
    this.pose.y += this.v * sin(this.pose.z) * dt;
    this.pose.z += this.v / L * tan(delta) * dt;
    this.pose.z = utils.normalizeAngle(this.pose.z);
    this.v += accel * dt;
  }
  
  int clk(){
    this.time = millis() - this.time;
    return this.time;
  }
  float pControl(float target, float current){
    return Kp * (target - current);
  }
  
  float[] stanleyControl(ArrayList<ArrayList<Float>> cs, int lastIdx){
    
    float[] nearest = calcTargetIdx(cs);
    nearest[0] = (lastIdx >= nearest[0]) ? lastIdx : nearest[0];
    float thetaE = utils.normalizeAngle(cs.get(2).get((int)nearest[0]) - this.pose.z);
    float thetaD = atan2(k * nearest[1], this.v);
    float delta = thetaE + thetaD;
    
    return new float[]{delta, nearest[0]}; 
  }
  
  float[] calcTargetIdx(ArrayList<ArrayList<Float>> cs){
    float fx = this.pose.x + L * cos(this.pose.z);
    float fy = this.pose.y + L * sin(this.pose.z);
    float errorFrontAxle = 999999.0f;
    
    for (int i = 0; i < cs.get(0).size(); ++i){
      float dx = fx - cs.get(0).get(i);
      float dy = fy - cs.get(1).get(i);
      float d = sqrt(pow(dx,2) + pow(dy,2));
      if(d < errorFrontAxle){
        errorFrontAxle = d;
        targetIdx = i;
      }  
    }
    
    float targetYaw = utils.normalizeAngle(atan2(fy - cs.get(1).get(targetIdx),
                                          fx - cs.get(0).get(targetIdx)) - this.pose.z);
    errorFrontAxle = (targetYaw > 0.0) ?  -errorFrontAxle : errorFrontAxle;
    return new float[] {targetIdx, errorFrontAxle};
    
  }
 
  private ArrayList<PVector> initializeSpline(int[]inOut){
    ArrayList<PVector> output = new ArrayList<PVector>();
    float x, y, phi;
    int i = 0;
    //println(inOut.length);
    for(int set : inOut){

      switch(set){
        case 1:{
          x = 50;
          y = -(200+ 30 * lanes);
          phi = atan2(-1, 0);
          break;}
        case 2:{
          x = (200 + 30 * lanes);
          y = 50;  
          phi = atan2(0, 1);
          break;}
        case 3:{
          x = -50;
          y = (200 + 30 * lanes);
          phi = atan2(1, 0 );
          break;}
        case 4:{
          x = -(200 + 30 * lanes);
          y = -50;
          phi = atan2(0, -1);
          break;}
        default:{
          println("Not a valid Lane specified: setting to 0");
          x = 50;
          y = -(180 + 30 * lanes);
          phi = atan2(-1, 0);
          break;}
      }


      
      if(i == 0){//entrada
         PVector pos = new PVector(x, y, phi);
         output.add(pos);
         y = (inOut[i] % 2 == 0) ? 0 : pos.y;
         x = (inOut[i] % 2 != 0) ? 0 : pos.x;
         output.add(0, new PVector(pos.x + x / 3, pos.y + y / 3, phi));
      }
      else{//salida
         PVector pos = new PVector(x, y, phi);
         pos.y = (inOut[i] % 2 == 0) ? -pos.y : pos.y;
         pos.x = (inOut[i] % 2 != 0) ? -pos.x : pos.x;
         output.add(pos);
         y = (inOut[i] % 2 == 0) ? 0 : pos.y;
         x = (inOut[i] % 2 != 0) ? 0 : pos.x;
        output.add(new PVector(pos.x + x / 3, pos.y + y / 3, phi));
      }
      i++;
    }
    return output;
  }
  
  
  public ArrayList<ArrayList<Float>> createSpline(int[] inOut, int lane){
    ArrayList<PVector> splineVals = initializeSpline(inOut);
    PVector iPos = splineVals.get(0), fPos = splineVals.get(splineVals.size()-1);
    ArrayList<Float> x_list = new ArrayList<Float>();
    ArrayList<Float> y_list = new ArrayList<Float>();
    ArrayList<ArrayList<Float>> spline;
    iPos.z += PI; // Rotación para dibujar el vehiculo
    fPos.z = (fPos.z < 0) ? fPos.z + TWO_PI : fPos.z;
    this.pose = iPos;
    
    for (PVector vector : splineVals){
      x_list.add(vector.x);
      y_list.add(vector.y);
    }
    
    PVector globalPose = distanceToCenter();
    float curveLength = fPos.z - globalPose.z;
    curveLength = (curveLength <= 0) ? TWO_PI + curveLength : curveLength;
    //println(degrees(fPos.z), degrees(globalPose.z), degrees(curveLength));
    for(float i = globalPose.z + PI/6; i < globalPose.z + curveLength - PI/18; i += PI/18){
      x_list.add(x_list.size() - 2, (165 + 30 * lane) * cos(i));
      y_list.add(y_list.size() - 2, (165 + 30 * lane) * sin(i));
    }
    
    float[] x = utils.arrayListToArray(x_list);
    float[] y = utils.arrayListToArray(y_list);
    spline = csp.calc_spline_course(x, y, 1);
    this.pose = utils.doubleArrayListToPVector(spline);
    return spline;
    
  }
  
  private void printSpline(ArrayList<ArrayList<Float>> spline){
    for (int i = 0; i < spline.get(0).size(); ++i){
      point(spline.get(0).get(i), spline.get(1).get(i));
    }
  }
  
  public PVector distanceToCenter() {
    float x = this.pose.x; 
    float y = this.pose.y;
    float d2center = sqrt(pow(x, 2) + pow(y, 2));
    float angle = atan2(y, x);
    angle = (angle < 0) ? angle + TWO_PI : angle;
    return new PVector (d2center, d2center, angle);
  }
  
  void myDelay(int ms){
      int time = millis();
      while(millis() - time < ms);
    }

  public void run(){
    while(true){
      init();
    }

  }
}
