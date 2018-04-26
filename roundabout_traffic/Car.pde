class Car {
  PImage carImage;
  PVector position, radius;
  color col;
  boolean init=false;
  int time=0,lastTime=0;
  int i=0;
  float angle,scale,xx=0,yy=0,psi=0,speed,ms;
  Vec2D center;

  Car(String image, PVector position, float speed) {
    this.position = position;
    this.radius = position;
    this.speed = speed;
    carImage = loadImage(image);
    imageMode(CENTER);

  }

  public void draw() {
    //rotate and applyMatrix works fine but with applMatrix you can Scale and move the center
    float alpha=this.scale*cos(this.angle+PI/2);
    float beta=this.scale*sin(this.angle+PI/2);
    tint(col);
    pushMatrix();
    translate(this.xx,-this.yy);
    //rotate(-this.angle); 
    applyMatrix(alpha,beta,(1-alpha)*this.center.x-beta*this.center.y
    ,-beta, alpha, this.center.x+(1-alpha)*this.center.y);
    image(carImage, 0, 0);     
    popMatrix();
      
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition() {
    randomMove();
    float x = this.radius.x*cos(this.psi);//float(this.time)/1000;
    float y = this.radius.y*sin(this.psi);//*float(this.time)/1000;
    this.xx=x;
    this.yy=y;
        // println("angular" + w, "lineal"+ v);
        //}
    //float x=(this.ratio.x)*cos(radians(this.i));
    //float y=(this.ratio.y)*sin(radians(this.i));
    //point(this.xx,this.yy);
    this.position = new PVector(x,y);

  }
  
  public void setRotation(Vec2D center, float angle, float scale){
    this.center = center;
    this.scale = scale;
    this.angle = angle;
    //println("Angulo"+angle*180/PI);
  }
  
  public Vec2D distanceToCenter() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    float ang = atan2(y, x);
    return new Vec2D (d2center,ang);
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
  
  public void randomMove(){ 
    if (this.init==false){
      this.init=true;
      this.lastTime=millis();
    }
    else
    {
        this.time= millis()-this.lastTime;
        if (this.time>=10){
        this.lastTime=millis();
        float v =201;//radians(this.speed)*(this.radius.x/(float(this.time)/1000.0));
        this.ms=v;
        float delta_psi_dot = v*tan(radians(0.1))/50;
        this.psi += delta_psi_dot;
        if (this.psi>PI)
          this.psi=this.psi-6.28;
        else if (this.psi<-3.14)
          this.psi=this.psi+6.28;
        //println("velocidad"+v, "Angulo"+this.psi*180/PI);
      }
    }
  }
   public void control(){
   
   
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
