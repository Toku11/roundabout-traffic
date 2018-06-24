  public class utils {
    float y, x;
    utils() {   
    }
    
    public boolean isVelMin(float vel){
    if (vel >= 20.0)  return true;
    else  return false;
    }
    
    public boolean isVelMax(float vel){
    if (vel <= 10.0) return true;
    else return false;
    }
  
    public boolean inRange(float val,float x, float y){
    if (val >= x && val <= y) return true;
    else return false;
    }
    
    public boolean isOut(PVector point){
      if (point.x <= -500 || point.y <= -500 || point.x >= 500 || point.y >= 500){
        return true;}
      return false;
    }
    
    public boolean isRed(PVector point){
      float col = get((int)point.x + 500,(int)point.y + 500) >> 16 & 0xFF;
      float col2 = get((int)point.x + 500,(int)point.y + 500) & 0xFF;
      if(col != col2) return true;
      return false;
    }
    
    public boolean isBlocked(ArrayList<PVector> sensors, char side){
      for(PVector sensor:sensors){
        if(sensor.x < 7.0 && side=='r'&& inRange(sensor.y,45,135)) {return true;}
        if(sensor.x < 7.0 && side=='l'&& inRange(sensor.y,225,315)){return true;}
        if(sensor.x < 7.0 && side=='f'&& sensor.y==0){return true;}
      }
      return false;
    }
     
  }
 
