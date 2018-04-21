class Roundabout{
  int size;
  
  Roundabout(int size, int lanes){
    this.size = size;
  }
  
  void draw(){
    fill(0,255,0);
    ellipse(width/2, height/2, size/3,size/3);
  }
}
