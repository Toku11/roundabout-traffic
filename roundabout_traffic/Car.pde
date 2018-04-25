class Car {
  PImage carrito;
  PVector position, ratio;
  color col;
  int time=0,lastTime=0;
  int i=0,speed;
  float rotation,scale,dis,v;
  Vec2D center;

  Car(String image, PVector position, int speed) {
    this.position = position;
    this.ratio = position;
    this.speed = speed;
    carrito = loadImage(image);
    imageMode(CENTER);

  }

  public void draw() {
    //rotate and applyMatrix works fine but with applMatrix you can Scale and move the center
    float alpha=this.scale*cos(this.rotation);
    float beta=this.scale*sin(this.rotation);
    tint(col);
    pushMatrix();
    translate(this.position.x,this.position.y);
    //rotate(-this.rotation); 
    applyMatrix(alpha,beta,(1-alpha)*this.center.x-beta*this.center.y
    ,-beta, alpha, this.center.x+(1-alpha)*this.center.y);
    image(carrito, 0, 0);     
    popMatrix();
      
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition() {
    randomMove();
    float x=(this.ratio.x)*cos(radians(this.i));
    float y=(this.ratio.y)*sin(radians(this.i));
    
    this.position = new PVector(x,-y);

  }
  
  public void setRotation(Vec2D center, float angle, float scale){
    this.center = center;
    this.scale = scale;
    this.rotation = angle;
  }
  
  public Vec2D distanceToCenter() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    float ang = atan2(-y, x);
    return new Vec2D (d2center,ang);
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

  public Vec2D distanceToCar(Car car) {

    float x=car.position.x;
    float y=car.position.y;
    float posex=this.position.x;
    float posey=this.position.y;
    this.dis = sqrt(pow(posex-x, 2)+pow(posey-y, 2));
    float ang = atan2(-y+posey, x-posex);
    return new Vec2D(this.dis, ang);
  }
  
  public void randomMove(){ 
    //TODO: cambiar funciones de velocidad a m/s y no dependiente de frame rate
    //porque se atrasan los carritos, insertar modelo cinemático de los vehículos
    //hacer integral con condiciones iniciales
    
    this.time= millis()-this.lastTime;
    if (this.time>=10/*this.speed*/){
      this.lastTime=millis();
      if(i<360){ this.i=this.i+1;
      float w=1.0/this.time*180/PI;
      this.v=this.ratio.x/this.time;
     // println("angular" + w, "lineal"+ v);
      }
      else this.i=0;
    }
    
  }
}
