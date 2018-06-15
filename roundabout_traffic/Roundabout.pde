class Roundabout{
  int lanes;
  float lastI=PI/12;
  Roundabout(){
  }
  
  void draw(){
    noFill();
    //stroke(255);
    for (int j=0;j<=this.lanes;j++){
      for (int i=0; i<24;i=i+2){
        if (j==0&& i==22) arc(0, 0, 300,300,0,TWO_PI);
        else if (j==this.lanes && i%6==0) arc(0, 0, 300+60*j,300+60*j,lastI*i+PI/8,lastI*(i+3)+PI/8);
        else if (j!=0 && j!=this.lanes) arc(0, 0, 300+60*j,300+60*j,lastI*i,lastI*(i+1));

      }
    }
  }
  
  public void setLanes(int numberLanes){
    this.lanes = numberLanes;
  }
}
