/*Scale 10:1*/
class Car {
  PImage carImage;
  PVector position, radius;
  color col;
  int time,time2, lastTime=0,lastTime2=0, psi=0, timeLap;
  float angle, scale, speed;
  Vec2D center;

  Car(String image, PVector position, int timeLap/*ms*/) {
    this.position = position;
    this.radius = position;
    this.timeLap = timeLap;
    carImage = loadImage(image);
    imageMode(CENTER);
  }

  public void draw() {
    float alpha=this.scale*cos(this.angle+HALF_PI);
    float beta=this.scale*sin(this.angle+HALF_PI);
    tint(col);
    pushMatrix();
    translate(this.position.x, -this.position.y);
    applyMatrix(alpha, beta, (1-alpha)*this.center.x-beta*this.center.y
      , -beta, alpha, this.center.x+(1-alpha)*this.center.y);
    image(carImage, 0, 0);     
    popMatrix();
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition() {
    vehicleMove();
    float x = this.radius.x*cos(radians(this.psi))/*this.speed*//*this.time*/;
    float y = this.radius.y*sin(radians(this.psi));
    
    /*this.xx+=x
    this.yy=x*/
    
    this.position = new PVector(x, y);
  }

  public void setRotation(Vec2D center, float angle, float scale) {
    this.center = center;
    this.angle = angle;
    this.scale = scale;
  }

  public Vec2D distanceToCenter() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    float ang = atan2(y, x);
    return new Vec2D (d2center, ang);
  }

  public Vec2D distanceToCar(Car car) {

    float x=car.position.x;
    float y=car.position.y;
    float posex=this.position.x;
    float posey=this.position.y;
    float dis = sqrt(pow(posex-x, 2)+pow(posey-y, 2));
    float ang = atan2(y-posey, x-posex);
    return new Vec2D(dis, ang);
  }

  public void vehicleMove() { 
    this.time= millis()-this.lastTime;

    if (this.time>=this.timeLap) {

      this.lastTime=millis();
      this.speed=radians(1)*(this.radius.x/(this.time/1000.0))/10;//10*m/s

      if (this.psi<360) this.psi=this.psi+1;
      else this.psi=0;
    }
      
      this.time2= millis()-this.lastTime2;
      if (this.time2>=3000) {
      this.lastTime2=millis();
      float actionProbability = random(1);
      
      if (actionProbability<=0.2 && this.timeLap>=3){//decrease speed
      this.timeLap = this.timeLap - 3;
      }
      else if (actionProbability>0.2 && actionProbability<=0.4){//speed up
      this.timeLap = this.timeLap + 3;
      }
      else if (actionProbability>0.4 && actionProbability<=0.6 && this.radius.x<280){//left lane change
      this.radius.x=this.radius.x+ 30;
      this.radius.y=this.radius.y+ 30;
      }
      else if (actionProbability>0.6 && actionProbability<=0.8 && this.radius.x>160){//right lane change
      this.radius.x=this.radius.x- 30;
      this.radius.y=this.radius.y- 30;
      }
      else{//keep
      }}
      /*====== Drive the vehicle with front steering===========*/
      //float delta_psi_dot = this.speed*tan(radians(25))/48.8;
      /*this.psi += delta_psi_dot;
       if (this.psi>PI)
       this.psi=this.psi-6.28;
       else if (this.psi<-3.14)
       this.psi=this.psi+6.28;*/
      //println("velocidad"+v, "Angulo"+this.psi*180/PI);
      /*=========================================================*/

  }

  public int sensor(Car car, PVector vector) {
    Vec2D k=distanceToCar(car);
    //x:distance,y:angle
    if (k.y >= PI/4 && k.y <= 3*PI/4 && k.x < vector.y) return 1;
    else if (abs(k.y) > 3*PI/4 && k.x < vector.x) return 2;
    else if (abs(k.y) < PI/4 && k.x < vector.x) return 3;
    else if (k.y <= -PI/4 && k.y >= -3*PI/4 && k.x < vector.y) return 4;
    else return 0;
  }
}
