class Roundabout{
  int size;
  
  Roundabout(int size, int lanes){
    this.size = size;
  }
  
  void draw(){
   //fill(128,128,0);
    noFill();
    arc(0, 0, 300,300,0,TWO_PI);
    arc(0, 0, 710,710,0,TWO_PI);
  }
}
