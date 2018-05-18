  public class utils {
    float y, x;

    utils() {   
    }
    
    public boolean nonMax(int vel){
    if (vel<=40)  return true;
    else  return false;
    }
    
    public boolean nonMin(int vel){
    if (vel<=10) return true;
    else return false;
    }
  
    public boolean inRange(float val,float x, float y){
    if (val>=x && val<=y) return true;
    else return false;
    }
  }
 
