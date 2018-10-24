/*
This code is a Java implementation of the code de Atsushi Sakai 
Path tracking simulation with Stanley steering control and P speed control.
maintainer: Tokunaga Oscar oscar.tokunaga@cinvestav.com
*/

class Vehicle extends Thread{
  int time = 0, lanes;
  float v = 0.0f, Kp = 1.0, k = 0.5,
        L = 2.9f, max_steer = radians(30.0);
  PVector pose = new PVector();
  Utils utils = new Utils();
  CubicSplinePlanner csp = new CubicSplinePlanner();

  Vehicle(PVector pose, float vel, int lanes){
    this.pose = pose;
    this.v = vel;
    this.lanes = lanes;
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
    for(int set : inOut){
      switch(set){
        case 1:{
          pos = new PVector(0, -(180 + 30 * lanes));
          break;}
        case 2:{
          pos = new PVector((180 + 30 * lanes), 0);     
          break;}
        case 3:{
          pos = new PVector(0, (180 + 30 * lanes));
          break;}
        case 4:{
          pos = new PVector(-(180 + 30 * lanes), 0);
          break;}
        default:{
          print("Not a valid Lane specified: setting to 0");
          pos = new PVector(0, -(180 + 30 * lanes));
          break;}
      }
      output.add(pos);
    }
    return output;
  }
  
  
  private ArrayList<ArrayList<Float>> createSpline(int[] inOut, int lane){
    //Es necesario crear x y y para el spline 
    ArrayList<PVector> splineVals = initializeSpline(inOut);
    PVector iPos = splineVals.get(0), fPos = splineVals.get(1);
    ArrayList<Float> x_list = new ArrayList<Float>();
    ArrayList<Float> y_list = new ArrayList<Float>();
    ArrayList<ArrayList<Float>> spline;
    
    x_list.add(iPos.x);
    y_list.add(iPos.y);
    x_list.add(fPos.x);
    y_list.add(fPos.y);
    fPos.z = fPos.z < 0 ? fPos.z + 360 : fPos.z;

    if(this.psi < fPos.z-20){
      for(i = this.psi; i < 360; i = i + 30){
        if(i > this.psi && i < fPos.z-10){
          x_list.add(x_list.size()-1, (165 + 30*lane) * cos(radians(i)));
          y_list.add(y_list.size()-1, (165 + 30*lane) * sin(radians(i)));
        }
      }    
    }
    else{
      for(i = this.psi; i < 360+fPos.z-15; i = i + 30){
        if(i > this.psi){
          x_list.add(x_list.size()-1, (165 + 30*lane) * cos(radians(i)));
          y_list.add(y_list.size()-1, (165 + 30*lane) * sin(radians(i)));
        }
      }       
    }

    float[] x = utils.arrayListToArray(x_list);
    float[] y = utils.arrayListToArray(y_list);

    spline = csp.calc_spline_course(x,y,0.5);
    return spline;
  }*/
}
