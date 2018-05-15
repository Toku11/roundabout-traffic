class Sensor {
  private int range;

  Sensor(int range) {
    this.range = range;
  }

  void setRange(int range) {
    this.range = range;
  }
  
  public boolean nonMax(int vel){
  if (vel<=20)  return true;
  else  return false;
  }
  public boolean nonMin(int vel){
  if (vel<=0) return true;
  else return false;
  }
  
  public boolean inRange(float val,float x, float y){
  if (val>=x && val<=y) return true;
  else return false;
  }
}
