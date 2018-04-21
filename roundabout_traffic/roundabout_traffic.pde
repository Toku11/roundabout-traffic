Roundabout roundabout;

void setup(){
  size(800, 600);
  
  roundabout = new Roundabout(500);
}

void draw(){
  background(0);
  roundabout.draw();
}
