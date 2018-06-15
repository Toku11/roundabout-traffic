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
    
    public boolean isOut(PVector point){
      if (point.x<=-500 || point.y<=-500 || point.x>=500 || point.y>=500){
        return true;}
      return false;
    }
    public boolean isRed(PVector point){
      float col = get((int)point.x+500,(int)point.y+500)>>16&0xFF;
      float col2 =get((int)point.x+500,(int)point.y+500) & 0xFF;
      if(col!=col2) return true;
      return false;
    }
  }
 
