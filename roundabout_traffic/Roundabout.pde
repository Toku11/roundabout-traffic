float x1;
float y1;
float x1_1;
float y1_1;
class Roundabout{
  int lanes;
  float rot = PI / 12;
  Roundabout(){
  }
  
  void draw(){
    noFill();
    //stroke(255);

    for (int j = 0; j <= this.lanes; j++){
      if (j == 0) arc(0, 0, 300, 300, 0, TWO_PI);//interna
      if (j == this.lanes){ //externo
        int diam = 300 + 60 * j;
        for(int i = 0; i < 4; i++){
          float rotatedInitialAngle = i * HALF_PI + PI / 5;
          float rotatedFinalAngle = (i+1) * HALF_PI - PI / 5;
          
          x1 = diam / 2 * cos(rotatedInitialAngle);
          y1 = diam / 2 * sin(rotatedInitialAngle);
          x1_1 = diam / 2 * cos(rotatedFinalAngle);
          y1_1 = diam / 2 * sin(rotatedFinalAngle);
          arc(0, 0, diam, diam, rotatedInitialAngle, rotatedFinalAngle);
          println(utils.roundAngle(cos(rotatedInitialAngle)),utils.roundAngle(sin(rotatedInitialAngle)));
          line(x1, y1, x1 + 300 * utils.roundAngle(cos(rotatedInitialAngle)), y1 + 
                300 * utils.roundAngle(sin(rotatedInitialAngle)));
          line(x1_1, y1_1, x1_1 + 300 * utils.roundAngle(cos(rotatedFinalAngle)), y1_1 
              + 300  * utils.roundAngle(sin(rotatedFinalAngle)));
        }
      }
      for (int i = 0; i < 24; i = i + 2){
        if (j != 0 && j != this.lanes) arc(0, 0, 300 + 60 * j, 300 + 60 * j, rot * i, rot * (i + 1));
      }
    }
  }
  
  public void setLanes(int numberLanes){
    this.lanes = numberLanes;
  }
}
