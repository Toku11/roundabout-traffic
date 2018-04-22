class Car {
  PImage carrito;
  PVector position;
  color col;
  int w, h;

  Car(String image, PVector position, int w, int h) {
    this.position = position;
    carrito = loadImage(image);
    this.w=w;
    this.h=h;
  }

  public void draw() {
    tint(col);
    pushMatrix();
    translate(this.position.x, this.position.y);
    rotate(PI/2);
    imageMode(CENTER);
    image(carrito, position.x, position.y, w, h);
    popMatrix();
  }

  public void setColor(color col) {
    this.col=col;
  }

  public void setPosition(PVector v) {
    this.position = v;
  }

  public float distance2Center() {
    float x=this.position.x; 
    float y=this.position.y;
    float d2center=sqrt(pow(x, 2)+pow(y, 2));
    return d2center;
  }
  public int sensor(Car car, PVector vector) {
    Vec2D k=distance2Car(car);
    if (k.a >= PI/4 && k.a <= 3*PI/4 && k.d < vector.y) {
      return 1;
    } else if (abs(k.a) > 3*PI/4 && k.d < vector.x) {  
      return 2;
    } else if (abs(k.a) < PI/4 && k.d < vector.x) {  
      return 3;
    } else if (k.a <= -PI/4 && k.a >= -3*PI/4 && k.d < vector.y) {  
      return 4;
    } else {
      return 0;
    }
  }

  public Vec2D distance2Car(Car car) {

    float x=car.position.x;
    float y=car.position.y;
    float posex=this.position.x;
    float posey=this.position.y;
    float dis = sqrt(pow(posex-x, 2)+pow(posey-y, 2));
    float ang = atan2(-y+posey, x-posex);
    return new Vec2D(dis, ang);
  }
}