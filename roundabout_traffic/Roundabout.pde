class Roundabout{
  int size;
  
  Roundabout(int size, int lanes){
    this.size = size;
  }
  
  void draw(){
   //fill(128,128,0);
    noFill();
    ellipse(0, 0, size/3,size/3);
  }
}
