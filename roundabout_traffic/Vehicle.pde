/*
This code is a Java implementation of the code de Atsushi Sakai 
Path tracking simulation with Stanley steering control and P speed control.
maintainer: Tokunaga Oscar oscar.tokunaga@cinvestav.com
*/

class Vehicle extends Thread{
  PImage vImage;
  int time = 0, lanes;
  float v = 0.0f, Kp = 1.0, k = 0.5,
        L = 2.9f, max_steer = radians(30.0);
  PVector pose = new PVector();
  Utils utils = new Utils();
  CubicSplinePlanner csp = new CubicSplinePlanner();
  ArrayList<ArrayList<Float>> spline;
  
  Vehicle(float vel, int lanes){
    this.v = vel;
    this.lanes = lanes;
    vImage = loadImage("red.png");
    vImage.resize(50,20);
    imageMode(CENTER);
    this.spline = createSpline(new int[]{1,3},3);
  } 
  
  public void draw() {   
    updateState(0.0,0);
    pushMatrix();
    translate(this.pose.x, this.pose.y);
    rotate(this.pose.z);
    image(vImage, 0, 0);  
    popMatrix();
    printSpline(this.spline);
  }
  
  void updateState(float accel, float delta){
    utils.clip_(delta, -max_steer, max_steer);
    float dt = clk() / 1000; 
    this.pose.x += this.v * cos(this.pose.z) * dt;
    this.pose.y += this.v * sin(this.pose.z) * dt;
    this.pose.z += this.v / L * tan(delta) * dt;
    this.pose.z = utils.normalizeAngle(this.pose.z);
    this.v = accel * dt;
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
    int targetIdx = 0;
    
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
    PVector pos;
    float x, y, phi;
    for(int set : inOut){
      switch(set){
        case 1:{
          x = 0;
          y = -(180 + 30 * lanes);
          break;}
        case 2:{
          x = (180 + 30 * lanes);
          y = 0;  
          break;}
        case 3:{
          x = 0;
          y = (180 + 30 * lanes);
          break;}
        case 4:{
          x = -(180 + 30 * lanes);
          y = 0;
          break;}
        default:{
          println("Not a valid Lane specified: setting to 0");
          x = 0;
          y = -(180 + 30 * lanes);
          break;}
      }
      phi = atan2(y,x);
      pos = new PVector(x,y,phi);
      output.add(pos);
    }
    return output;
  }
  
  
  public ArrayList<ArrayList<Float>> createSpline(int[] inOut, int lane){
    ArrayList<PVector> splineVals = initializeSpline(inOut);
    PVector iPos = splineVals.get(0), fPos = splineVals.get(1);
    ArrayList<Float> x_list = new ArrayList<Float>();
    ArrayList<Float> y_list = new ArrayList<Float>();
    ArrayList<ArrayList<Float>> spline;
    iPos.z += PI; // Rotación para dibujar el vehiculo
    fPos.z = (fPos.z < 0) ? fPos.z + TWO_PI : fPos.z;
    this.pose = iPos;
    x_list.add(iPos.x);
    y_list.add(iPos.y);
    x_list.add(fPos.x);
    y_list.add(fPos.y);
    
    PVector globalPose = distanceToCenter();
    float curveLength = fPos.z - globalPose.z;
    curveLength = (curveLength <= 0) ? TWO_PI + curveLength : curveLength;
    println(globalPose.z, fPos.z, curveLength);
    
    for(float i = globalPose.z + PI/12; i < globalPose.z + curveLength - PI/12; i += PI/6){
      x_list.add(x_list.size() - 1, (165 + 30 * lane) * cos(i));
      y_list.add(y_list.size() - 1, (165 + 30 * lane) * sin(i));
    }
    
    float[] x = utils.arrayListToArray(x_list);
    float[] y = utils.arrayListToArray(y_list);
    spline = csp.calc_spline_course(x, y, 0.1);
    return spline;
    
  }
  
  private void printSpline(ArrayList<ArrayList<Float>> spline){
    for (int i = 0; i < spline.get(0).size();++i){
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
   /* 
    fPos.z = fPos.z < 0 ? fPos.z + 360 : fPos.z;



    
    return spline;
  }*/
}
