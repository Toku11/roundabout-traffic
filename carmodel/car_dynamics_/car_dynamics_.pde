import controlP5.*;
import processing.net.*;

Agent agent2;
ControlP5 cp5;
PVector offset;
void setup() {
  //c = new Client(this, "127.0.0.1", 65432);
  size(1000, 1000);
  frameRate(1000);
  colorMode(RGB, 255);
  stroke(255, 255, 255);
  offset = new PVector(width/2, height/2);
  
  agent2 = new Agent(true);
  agent2.start();
  //surface.setVisible(false);
}

void draw() {
        background(0);

        pushMatrix(); 
        scale(1, -1);
        translate(offset.x, -offset.y);
       
        line(0,0,165,0);
       
        agent2.draw();

        popMatrix();

}

public void keyPressed(){
  //print(keyCode);
  agent2.keycode = keyCode;
}

public void keyReleased(){
  //print("released");
  //agent2.keycode = 0;
}
