import controlP5.*;
import processing.net.*;
Client client;
Agent agent;
Info info;
ControlP5 cp5;
PVector offset;
boolean kUp, kDown, kLeft, kRight, kSpace, kESC;


void setup() {
  client = new Client(this, "127.0.0.1", 65432);
  size(1000, 1000);
  frameRate(1000);
  colorMode(RGB, 255);
  stroke(255, 255, 255);
  offset = new PVector(width/2, height/2);
  
  agent = new Agent();
  info = new Info(new PVector(10,20), agent);
  //surface.setVisible(false);
}

void draw() {
  if(client.available() > 0 ){
        background(0);
        pushMatrix(); 
        scale(1, -1);
        translate(offset.x, -offset.y);
        String input = client.readString();   
        input = input.substring(0, input.indexOf("\n"));
        int [] data  = int(split(input, ' '));
        client.write(agent.position_wc.x + " " + agent.position_wc.y);

        agent.draw();

        popMatrix();
        agent.keycodes = new boolean[] {kUp, kDown, kLeft, kRight, kSpace, kESC};
        info.draw(true);
  }
}

public void keyPressed(){
    switch (keyCode)
  {
   case 38 : kUp = true; break;
   case 40 : kDown = true; break;
   case 37 : kLeft = true; break;
   case 39 : kRight = true; break;
   case 32 : kSpace = true; break;
   case 27 : kESC = true; break;
  }
}

public void keyReleased(){
  switch (keyCode)
  {
   case 38 : kUp = false; break;
   case 40 : kDown = false; break;
   case 37 : kLeft = false; break;
   case 39 : kRight = false; break;
   case 32 : kSpace = false; break;
   case 27 : kESC = false; break;
  }
}
