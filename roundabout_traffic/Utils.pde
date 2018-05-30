  public class utils {
    float y, x;

    utils() {   
    }
    
    public boolean nonMax(float vel){
    if (vel<=20.0)  return true;
    else  return false;
    }
    
    public boolean nonMin(float vel){
    if (vel<=10.0) return true;
    else return false;
    }
  
    public boolean inRange(float val,float x, float y){
    if (val>=x && val<=y) return true;
    else return false;
    }
  }
 
