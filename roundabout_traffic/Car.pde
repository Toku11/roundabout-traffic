/*Scale 10:1*/
class Car {
PImage carImage;
  PVector position;
  color col;
  int lastTime=0,lastTime2=0, psi=0, lanes, time, time2, countEffect=0;
  float angle, speed, timeLap,actionProbability, radius ;
  boolean change = false;
  boolean showSensor=true;
  utils utils = new utils();

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
    tint(col);
    pushMatrix();
    translate(this.position.x, -this.position.y);
    rotate(distanceToCenter().y);
    image(carImage, 0, 0);     
    popMatrix();
    /*println(carImage.width, carImage.height);*/
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition() {
    vehicleMove();
    float x = this.radius*cos(radians(this.psi));
    float y = this.radius*sin(radians(this.psi));
    this.position = new PVector(x, y);
  }

  public void vehicleMove() { 
    speedStimation();
    this.time = millis()-this.lastTime2;    
    if (this.time >= 3000 || isChanging()) {
      this.lastTime2 = millis();
      movement();
      }
  } 
  
    public void speedStimation(){
      this.time2 = millis()-this.lastTime;
      if (this.time2 >= this.timeLap) {
        this.lastTime = millis();
        this.speed = (radians(1)*(this.radius/(this.timeLap/1000.0)))/10;//10*m/s
      if (this.psi < 360) this.psi=this.psi+1;
      else this.psi = 0;
    }
  }
    
  public void movement(){
    
      if (!isChanging()) {
          actionProbability = random(0,1);
      }
      
      if (utils.inRange(actionProbability,0.001,0.20) && !utils.nonMin(this.timeLap)){//speed up
          speedUp();
      }
      else if (utils.inRange(actionProbability, 0.2,0.45) && utils.nonMax(this.timeLap)){//decrease speed
          speedDown();
      }
      else if (utils.inRange(actionProbability, 0.45,0.65) && this.radius<135+this.lanes){//right lane chan
        laneChange('r');
      }
      else if (utils.inRange(actionProbability, 0.65,0.85) && this.radius>165){//left lane change
        laneChange('l');

      }
      else{//keep
      }
  }
      
  public void speedUp(){
    this.timeLap = this.timeLap - 1;
  }
  
  public void speedDown(){
    this.timeLap = this.timeLap + 1;
  }
  
  public void keepLastSpeed(){
    if (this.speed>10)
    this.timeLap = ((this.radius*radians(1)) / (this.speed*10))*1000.0;
  }
  
  public void laneChange(char side){
   switch (side){
      case 'r':
         this.radius = this.radius+laneEffect();
         //this.radius = this.radius+laneEffect(); 
         keepLastSpeed();
         break;
      case 'l':
         this.radius = this.radius-laneEffect();
         //this.radius = this.radius-laneEffect();
         keepLastSpeed();         
         break;
      default:
         break;
   }    
  }

 public boolean isChanging(){
      return this.change;
  }
 
 public int laneEffect(){
   if (this.countEffect>=30){
     this.countEffect=0;
     this.change=false;
     return 0;
   }
   else{
     this.countEffect++;
     this.change = true;
     return 1;
   }
 }
    
  public PVector distanceToCenter() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    this.angle = atan2(-y, x)-HALF_PI;
    return new PVector (d2center, angle);
  }

  public PVector distanceToCar(Car car) {

    float x=car.position.x;
    float y=car.position.y;
    float posex=this.position.x;
    float posey=this.position.y;
    float dis = sqrt(pow(posex-x, 2)+pow(posey-y, 2));
    float ang = atan2(y-posey, x-posex);
    return new PVector(dis, ang);
  }

  public void getSensorReadings(){
    ArrayList<PVector> arm = makeSensor();
    for(int i=-0; i<=360;i=i+45){
      getSensorDistance(arm,radians(i));
    }
    // Hay que modificar aqui para que sean mas brazos, verificar el offset porque no lo vi
    // para todos los puntos en sensor distance
  }

  public ArrayList makeSensor(){
    int spread = 3;
    ArrayList<PVector> points= new ArrayList<PVector>();

    for(int i=1;i<=7;i++){
      points.add(new PVector(26+(spread*i),0));
    }
    return points;
  }
  
  public int getSensorDistance(ArrayList<PVector> points, float offset){
    int i=0;
    for (PVector point:points){
      i++;
      PVector rotatedPoint=getRotatedPoint(point, offset);
      if(utils.isOut(rotatedPoint)) return i;
      else{
       if (utils.isRed(rotatedPoint)) return i;}//}
     if (showSensor){
        ellipse(rotatedPoint.x,rotatedPoint.y,1,1);
      }
    }
   return i;
  }
   
  
  public PVector getRotatedPoint(PVector point, float offset){
    float new_x = point.x*cos(this.angle+offset)-point.y*sin(this.angle+offset)+ this.position.x;
    float new_y = point.x*sin(this.angle+offset)+point.y*cos(this.angle+offset)- this.position.y;

    return new PVector(new_x,new_y);
    
  }
  
  public int sensor(Car car, PVector vector) {
    PVector k=distanceToCar(car);
    //x:distance,y:angle
    if (k.y >= PI/4 && k.y <= 3*PI/4 && k.x < vector.y) return 1;
    else if (abs(k.y) > 3*PI/4 && k.x < vector.x) return 2;
    else if (abs(k.y) < PI/4 && k.x < vector.x) return 3;
    else if (k.y <= -PI/4 && k.y >= -3*PI/4 && k.x < vector.y) return 4;
    else return 0;
  }
}
