/*Scale 10:1*/
public class Car extends Thread{
  PImage carImage;
  PVector position;
  color col;
  int L=20,signLane,lastTime = 0, lastTime2 = 0, psi = 0, lanes, time, time2, countEffect = 0;
  float angle, speed, timeLap, actionProbability = 0, radius, max_steer = 30.0;
  float maxsteer = radians(30), yaw = 0, v = 0;
  boolean change = false;
  boolean showSensor = false;
  boolean manualControl = false, stop = false;
  int keycode = 0;
  Utils utils = new Utils();
  CubicSplinePlanner csp = new CubicSplinePlanner();

  
  ArrayList<PVector> sensorRange = new ArrayList();
  
  Car(String image, PVector position, int timeLap/*ms*/, int lanes) {
    this.position = position;
    this.radius = position.x;
    this.timeLap = timeLap;
    this.lanes = lanes*30;
    carImage = loadImage(image);
    carImage.resize(50,20);
    imageMode(CENTER);

  }

  public void draw() {   
    PVector kk = new PVector(0,180 + lanes ,atan2(350,0) * 180 / PI);
    tint(col);
    pushMatrix();
    translate(this.position.x, -this.position.y);
    rotate(distanceToCenter().y);
    image(carImage, 0, 0);     
    popMatrix();
    if(showSensor){
      for(int i = 0; i < lanes/30; i++){
        printSpline(createSpline(position,kk, i));

      }
    }
    /*println(carImage.width, carImage.height);*/
  }

  public void setColor(color col) {  
    this.col = col;
  }


  public void setPosition() {
    //clk();
    //delta = constrain(delta, -maxsteer,maxsteer);
    //this.position.x    += this.v * cos(yaw) * this.time;
    //this.position.y    += this.v * sin(yaw) * this.time;
    //yaw  += this.v/L * tan(delta)*this.time;
    //normalize_angle();    
    //this.v = acceleration * this.time;
   // delay(1000);
    
    vehicleMove();
    float x = this.radius * cos(radians(this.psi));
    float y = this.radius * sin(radians(this.psi));
    
    this.position = new PVector(x, y);
  }
  
  public int clk(){
    this.time = millis() - this.time;
    return this.time;
  }

  public void vehicleMove() { 
    speedControl();
    this.time = millis() - this.lastTime;  
    
    if (!manualControl){
      avoidFrontalCrash();
      if (this.time >= 3000 || isChanging()) {
        this.lastTime = millis();
        movement();
      }
    }
      
    else if((this.time>=200 && keycode!=0)||isChanging()){
      this.lastTime = millis();
      movement();
    }
  } 
  
  public void avoidFrontalCrash(){
      if (utils.isBlocked(this.sensorRange,'f')) speedDown();
      else if(utils.isVelMin(this.timeLap)) this.timeLap = int(random(10,20));
  }
  

  
  public void speedControl(){
    /*keep the velocity even when there is a lanechange*/
    this.time2 = millis() - this.lastTime2;
    if (this.time2 >= timeLap + radians(1)*utils.lane(radius)*30*timeLap ) {
      speedStimate();
      this.lastTime2 = millis();
      if (this.psi < 360) this.psi = this.psi + 1;    
      else this.psi = 0;
    
    }
  }
  
  public void speedStimate(){
    this.speed = ((this.radius * radians(1))/ (this.time2 / 1000.0)) / 10;//10*m/s
  }
  
  public void movement(){
    
      if (!isChanging() && !manualControl) {
          actionProbability = random(0,1);
      }
      
      if(isChanging()&&(this.radius==165||this.radius==135+this.lanes)) laneEffect();
      
      if (isAllowed(actionProbability,'a') || keycode == 38)
      {//speed up
          speedUp();
      }
      else if (isAllowed(actionProbability,'b') || keycode == 40)
      {//decrease speed
          speedDown();
      }
      else if (isAllowed(actionProbability,'r') || (keycode == 39 && this.radius < 135 + this.lanes ))
      {//right lane chan
        actionProbability = 0.5;
        laneChange('r');
      }
      else if (isAllowed(actionProbability,'l') ||( keycode == 37 && this.radius >165))
      {//left lane change
        actionProbability = 0.8;
        laneChange('l');
      }
      else{//keep
      }
  }
  
  public boolean isAllowed(float actionProbability, char movement){
    
    switch (movement){
      
      case 'l':
        return (utils.inRange(actionProbability, 0.7,0.99) && this.radius >165 && 
                (!utils.isBlocked(this.sensorRange,'l')||isChanging()));
                
      case 'r':

        return (utils.inRange(actionProbability, 0.4,0.7) && this.radius < 135 + this.lanes && 
                (!utils.isBlocked(this.sensorRange,'r')||isChanging()));
                
      case 'a':
        return (utils.inRange(actionProbability,0.01,.3) && !utils.isVelMax(this.timeLap));
        
      case 'b':
        return (utils.inRange(actionProbability, 0.3,0.4) && !utils.isVelMin(this.timeLap));
        
      default:
        return false;
    }
  }
  
  public void speedUp(){
    this.timeLap = this.timeLap - 1;
  }
  
  public void speedDown(){
    this.timeLap = this.timeLap + 1;
  }
   
  public void laneChange(char side){
    switch (side){
    
      case 'r':
         this.radius = this.radius + laneEffect();
         signLane = 1;
         break;
      
      case 'l':
         this.radius = this.radius - laneEffect();
         signLane = -1;
         break;
      
      default:
         break;
    }    
  }
  

 public boolean isChanging(){   
   return this.change;
 }
 
 public int laneEffect(){
   if (this.countEffect >= 30){
     this.countEffect = 0;
     actionProbability = -1;
     this.change = false;
     return 0;
   }
   else{
     this.countEffect++;
     this.change = true;
     return 1;
   }
  }
    
  public PVector distanceToCenter() {
    float x = this.position.x; 
    float y = this.position.y;
    float d2center = sqrt(pow(x, 2) + pow(y, 2));
    this.angle = atan2(-y, x) - HALF_PI;
    return new PVector (d2center, angle);
  }

  public PVector distanceToCar(Car car) {
    float x = car.position.x;
    float y = car.position.y;
    float posex = this.position.x;
    float posey = this.position.y;
    float dis = sqrt(pow(posex-x, 2) + pow(posey-y, 2));
    float ang = atan2(y - posey, x - posex);
    return new PVector(dis, ang);
  }

  public void getSensorReadings(int numSensors){ 
    ArrayList<PVector> arm = makeSensor();
    ArrayList<PVector> range = new ArrayList<PVector>();
    
    for(int i = 0; i < 360; i = i + 360 / numSensors){
      int distance = getSensorDistance(arm,radians(i));
      range.add(new PVector(distance, i));      
    }
    this.sensorRange = range;
  }

  public ArrayList makeSensor(){  
    int spread = 2;
    int armLength = 7;
    ArrayList<PVector> points = new ArrayList<PVector>();

    for(int i = 1; i <= armLength; i++){
      points.add(new PVector(26 + (spread * i),0));
    }
    return points;
  }
  
  public int getSensorDistance(ArrayList<PVector> points, float offset){    
    int i = 0;
   
    for (PVector point:points){
      i++;
      PVector rotatedPoint = getRotatedPoint(point, offset);
      
      if(utils.isOut(rotatedPoint)) return i;
      else{ if (utils.isRed(rotatedPoint)) return i;}
      
      if (showSensor){
        ellipse(rotatedPoint.x,rotatedPoint.y,1,1);
      }
      
    }
   return i;
  }
   
  
  public PVector getRotatedPoint(PVector point, float offset){
    float new_x = point.x * cos(this.angle + offset) - point.y * sin(this.angle + offset) + this.position.x;
    float new_y = point.x * sin(this.angle + offset) + point.y * cos(this.angle + offset) - this.position.y;

    return new PVector(new_x,new_y); 
  }
  
  public int sensor(Car car, PVector vector) {
    PVector k = distanceToCar(car);
    //x:distance,y:angle
    if (k.y >= PI / 4 && k.y <= 3 * PI / 4 && k.x < vector.y) return 1;
    else if (abs(k.y) > 3 * PI / 4 && k.x < vector.x) return 2;
    else if (abs(k.y) < PI / 4 && k.x < vector.x) return 3;
    else if (k.y <= -PI/4 && k.y >= -3*PI/4 && k.x < vector.y) return 4;
    else return 0;
  }
  
  private ArrayList<ArrayList<Float>> createSpline(PVector iPos, PVector fPos,int lane){
    //Es necesario crear x y y para el spline 
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
  }
  
  private void printSpline(ArrayList<ArrayList<Float>> spline){
    for (int i = 0; i < spline.get(0).size();++i){
      point(spline.get(0).get(i), -spline.get(1).get(i));
   }
  }
  
  public void run(){
    while(!stop){
      setPosition();
    }

  }
  
}
