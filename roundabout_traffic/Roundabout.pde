class Roundabout{
  int size;
  
  Roundabout(int size, int lanes){
    this.size = size;
  }
  
  void draw(){
    fill(0,255,0);
    ellipse(0, 0, size/3,size/3);
  }
}