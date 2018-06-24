class Roundabout{
  int lanes;
  float rot=PI/12;
  Roundabout(){
  }
  
  void draw(){
    noFill();
    //stroke(255);
    for (int j=0;j<=this.lanes;j++){
      for (int i=0; i<24;i=i+2){
        if (j==0 && i==22) arc(0, 0, 300,300,0,TWO_PI);
        else if (j==this.lanes && i%6==0){ 
          int diam = 300+60*j;
          float rotatedInitialAngle = (i*rot)+PI/8;
          float rotatedFinalAngle = (i*rot)+3*PI/8;
          float x1 = diam/2 * cos(rotatedInitialAngle);
          float y1 = diam/2 * sin(rotatedInitialAngle);
          float x1_1 = diam/2 * cos(rotatedFinalAngle);
          float y1_1 = diam/2 * sin(rotatedFinalAngle);
          arc(0, 0, diam, diam,rotatedInitialAngle,rotatedFinalAngle);
          if(i==0){
              line(x1,y1,x1+100,y1);
              line(x1_1,y1_1,x1_1,y1_1+100);}
          if(i==6){
              line(x1,y1,x1,y1+100);
              line(x1_1,y1_1,x1_1-100,y1_1);}
          if(i==12){
              line(x1,y1,x1-100,y1);
              line(x1_1,y1_1,x1_1,y1_1-100);}
          if(i==18){
              line(x1,y1,x1,y1-100);
              line(x1_1,y1_1,x1_1+100,y1_1);}
        }
        else if (j!=0 && j!=this.lanes) arc(0, 0, 300+60*j,300+60*j,rot*i,rot*(i+1));

      }
    }
  }
  
  public void setLanes(int numberLanes){
    this.lanes = numberLanes;
  }
}
