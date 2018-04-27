class Roundabout{
  int size;
  float lastI=2*PI/24;;
  
  Roundabout(int size, int lanes){
    this.size = size;
  }
  
  void draw(){
   //fill(128,128,0);
    noFill();
    arc(0, 0, 300,300,0,TWO_PI);

    for (int j=1;j<5;j++){
      for (int i=0; i<24;i=i+2){
        arc(0, 0, 300+60*j,300+60*j,lastI*i,lastI*(i+1));
        if (i%6==0 && j==1){
        arc(0, 0, 600,600,lastI*i+PI/8,lastI*(i+3)+PI/8);
       /* 
        0-2pi/6
        2pi/4-
        */
        
        }
      }
    }
  }
}
