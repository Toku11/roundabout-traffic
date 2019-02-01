class Roundabout{
  int lanes;
  float rot = PI / 12;
  Roundabout(){
  }
  
  void draw(){
    noFill();
    
    int diam = 300 + 60 * this.lanes;
    for (int j = 0; j <= this.lanes; j++){
        for(int i = 0; i < 4; i++){
          if(j == 0){
          float rotatedInitialAngle = i * HALF_PI + PI / 5;
          float rotatedFinalAngle = (i+1) * HALF_PI - PI / 5;
          float x1 = diam / 2 * cos(rotatedInitialAngle);
          float y1 = diam / 2 * sin(rotatedInitialAngle);
          float x2 = x1 + 500 * utils.roundAngle(cos(rotatedInitialAngle));
          float y2 = y1 + 500 * utils.roundAngle(sin(rotatedInitialAngle));
          float x1_1 = diam / 2 * cos(rotatedFinalAngle);
          float y1_1 = diam / 2 * sin(rotatedFinalAngle);
          float x2_1 = x1_1 + 500 * utils.roundAngle(cos(rotatedFinalAngle));
          float y2_1 = y1_1 + 500  * utils.roundAngle(sin(rotatedFinalAngle));
          if(i==0) fillLanes(abs(x1), abs(y1));
          arc(0, 0, diam, diam, rotatedInitialAngle, rotatedFinalAngle);
          line(x1, y1, x2, y2);
          line(x1_1, y1_1, x2_1, y2_1);
          }
          else break;
      }
      if (j == 0) arc(0, 0, 300, 300, 0, TWO_PI);//interna
      for (int i = 0; i < 24; i = i + 2){
        if (j != 0 && j != this.lanes) arc(0, 0, 300 + 60 * j, 300 + 60 * j, rot * i, rot * (i + 1));
      }
    }
  }
  
  public void setLanes(int numberLanes){
    this.lanes = numberLanes;
  }
  private void fillLanes(float x, float y){
    fill(0);
    noStroke();
    arc(0, 0, 300 + 60 * this.lanes, 300 + 60 * this.lanes, 0 , TWO_PI);
    rect(-500, min(x,y), 1000,  - min(x,y) * 2);
    rect(-min(x,y), 500, min(x,y) * 2, -1000);
    stroke(255,255,255);
    noFill();
  }
}
