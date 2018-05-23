/*Scale 10:1*/
class Car {
PImage carImage;
  PVector position, radius;
  color col;
  int lastTime=0,lastTime2=0, psi=0, lanes, time, time2;
  float angle, speed, timeLap;
  utils utils = new utils();

  Car(String image, PVector position, int timeLap/*ms*/, int lanes) {
    this.position = position;
    this.radius = position;
    this.timeLap = timeLap;
    this.lanes = lanes*30;
    carImage = loadImage(image);
    carImage.resize(50,21);
    imageMode(CENTER);
  }

  public void draw() {
    tint(col);
    pushMatrix();
    translate(this.position.x, -this.position.y);
    rotate(distanceToCenter().y-HALF_PI);
    image(carImage, 0, 0);     
    popMatrix();
    /*println(carImage.width, carImage.height);*/
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition() {
    vehicleMove();
    float x = this.radius.x*cos(radians(this.psi));
    float y = this.radius.y*sin(radians(this.psi));
    this.position = new PVector(x, y);
  }


  public PVector distanceToCenter() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    float angle = atan2(-y, x);
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

  public void vehicleMove() { 
    speedStimation();
    this.time = millis()-this.lastTime2;    
    if (this.time >= 3000) {
      this.lastTime2 = millis();
      randomMove();
      }

  }
  public void speedStimation(){
      this.time2 = millis()-this.lastTime;
      if (this.time2 >= this.timeLap) {
        this.lastTime = millis();
        this.speed = (radians(1)*(this.radius.x/(this.timeLap/1000.0)))/10;//10*m/s
      if (this.psi < 360) this.psi=this.psi+1;
      else this.psi = 0;
    }
  }
  
  
  public void randomMove(){
  float actionProbability = random(0,1);

      if (utils.inRange(actionProbability,0.001,0.20) && !utils.nonMin(this.timeLap)){//speed up
          speedUp();
      }
      else if (utils.inRange(actionProbability, 0.2,0.45) && utils.nonMax(this.timeLap)){//decrease speed
          speedDown();
      }
      else if (utils.inRange(actionProbability, 0.45,0.65) && this.radius.x<130+this.lanes){//right lane chan
        laneChange('r');
      }
      else if (utils.inRange(actionProbability, 0.65,0.85) && this.radius.x>160){//left lane change
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
    if (this.speed>0)
    this.timeLap = ((this.radius.x*radians(1)) / (this.speed*10))*1000.0;
  }
  
  public void laneChange(char side){
   switch (side){
      case 'r':
         this.radius.x = this.radius.x+30;
         this.radius.y = this.radius.y+30; 
         keepLastSpeed();
         break;
      case 'l':
         this.radius.x = this.radius.x-30;
         this.radius.y = this.radius.y-30;
         keepLastSpeed();         
         break;
      default:
         break;
   }
    
  }
    
  public void makeSensor(){
    int spread = 20;
    ArrayList<PVector> points= new ArrayList<PVector>();
    for(int i=1;i==40;i++){
      points.add(new PVector(20+(spread*i),this.position.y));
    }
  }
  
  /*public void getSensorDistance(ArrayList<PVector> points){
    int i=0;
    for (PVector point:points){
      i++;
      PVector rotatedPoint=getRotatedPoint(point);
    }
  }*/
  
 /* public PVector getRotatedPoint(PVector point){
    //float new_x = point.x*cos(this.angle)+
  }*/
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
