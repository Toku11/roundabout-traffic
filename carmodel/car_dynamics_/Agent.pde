 // https://github.com/jongallant/CarSimulator/blob/b6e464f873a2b8ff06b4c33630c55199e25f19f2/Assets/Scripts/Car.cs
//https://github.com/jongallant/CarSimulator
//https://nccastaff.bournemouth.ac.uk/jmacey/MastersProjects/MSc12/Srisuchat/Thesis.pdf
class Agent implements Runnable{
  // Vehicle variables//////////////////////////////
  static final int TRAIL_SIZE = 200;     /* number of dots in car trail */
  static final float DELTA_T = 0.01;    /* time between integration steps in physics modelling */
  
  CARTYPE []cartypes = new CARTYPE[1];
  TRAILPOINT [] trail = new TRAILPOINT [ TRAIL_SIZE ];
  
  int       num_trail = 0;
  boolean[] keycodes = new boolean[6];
  PVector   position_wc;
  PVector   velocity;
  PVector   velocity_wc;
  PVector   acceleration_wc;
  PVector   acceleration;
  float     headingAngle;
  float     steerAngle;
  float     sn, cs;
  float     absoluteVelocity;
  float     steerDirection = 0;
  float     steerInput;
  ENGINE    engine;
  CAR       car;
  color     vColor;
  PImage    vImage;
  

  class CAR
  {
   public CAR ()
   {
    cartype = new CARTYPE();
   }
    CARTYPE cartype;        // pointer to static car data
    PVector Velocity;
    float angularvelocity;
    float throttle;        // amount of throttle (input)
    float brake;           // amount of braking (input)
    float ebrake;
    void setThrottle(float val){
      this.throttle = val;
    }
    void setBrake(float val){
      this.brake = val;
    }
    void setEbrake(float val){
      this.ebrake = val;
    }
    float getVelocityMagnitude(){
     return sqrt(pow(this.Velocity.x, 2) + pow(this.Velocity.y, 2));
     }
   float getKilometersPerHour(){
     return getVelocityMagnitude() * 18.0 / 5.0;
   }

  }
  
  class CARTYPE
  {
    public CARTYPE()
    {
      axleFront = new AXLE();
      axleRear  = new AXLE();
    }
    AXLE axleFront;
    AXLE axleRear;
    float wheelbase;      // wheelbase in m
    float b;              // in m, distance from CG to front axle
    float c;              // in m, idem to rear axle
    float h;              // in m, height of CM from ground
    float mass;           // in kg
    float inertia;        // in kg.m
    float length,width;
    float wheellength,wheelwidth;
    float brakepower, ebrakepower;
  }
  
  class ENGINE
  {  
    public ENGINE(){
      gearRatios  = new float[]{5.8, 4.5, 3.74, 2.8, 1.6, 0.79, 4.2};
      torqueCurve = new int[]{100, 280, 325, 420, 460, 340, 300, 100};
      currentGear = 0;
    }
    float[] gearRatios;
    int  [] torqueCurve;
    int     currentGear;
    
    public void setCurrentGear(int val){
      this.currentGear = val;
    }
    public int getCurrentGear(){
      return currentGear;
    }
    public float gearRatio(){
      return gearRatios[getCurrentGear()];
    }
    public float effectiveGearRatio(){
      return gearRatios[gearRatios.length -1];
    }
    public float getTorque(CAR car){  
      return getTorque(getRPM(car));
    }
    public float getRPM(CAR car){
      return car.getVelocityMagnitude() / (PI * 2 / 60.0) * (gearRatio() * effectiveGearRatio());
    }
    public float getTorque(float rpm){
      if (rpm < 1000) {      
      return lerp (torqueCurve [0], torqueCurve [1], rpm / 1000f);
    } else if (rpm < 2000) {
      return lerp (torqueCurve [1], torqueCurve [2], (rpm - 1000) / 1000f);
    } else if (rpm < 3000) {
      return lerp (torqueCurve [2], torqueCurve [3], (rpm - 2000) / 1000f);
    } else if (rpm < 4000) {
      return lerp (torqueCurve [3], torqueCurve [4], (rpm - 3000) / 1000f);
    } else if (rpm < 5000) {
      return lerp (torqueCurve [4], torqueCurve [5], (rpm - 4000) / 1000f);
    } else if (rpm < 6000) {
      return lerp (torqueCurve [5], torqueCurve [6], (rpm - 5000) / 1000f);
    } else if (rpm < 7000) {
      return lerp (torqueCurve [6], torqueCurve [7], (rpm - 6000) / 1000f);
    } else {      
      return torqueCurve [6];
    }
    }
    public void updateAutomaticTransmission(CAR car){
      float rpm = getRPM(car);
      
      if(rpm > 6200){
        if(getCurrentGear() < 5){
          setCurrentGear(getCurrentGear() + 1);
        }
      } else if (rpm < 2000){
        if (getCurrentGear() > 0){
          setCurrentGear(getCurrentGear() - 1);
        }
      }
      
    }
    
  }
  
  class AXLE
  {
    public AXLE()
    {
      tireLeft  = new TIRE();
      tireRight = new TIRE();
      tireLeft.radius  = 0.5;
      tireRight.radius = 0.5;
    }
    TIRE  tireLeft;
    TIRE  tireRight;
    float weightRatio;
    float slipAngle;
    float ebrakegripratio;
    float totalTireGrip;
    float getAngularVelocity(){
      return tireLeft.angularVelocity + tireRight.angularVelocity;
    }
    
    float getTorque(){
      return (tireLeft.torque + tireRight.torque) / 2.0;
    }
    
    float getFrictionForce(){
      return (tireLeft.frictionForce + tireRight.frictionForce) / 2.0;
    }
  }

  class TIRE
  {
    float activeWeight;
    float angularVelocity;
    float torque;
    float grip;
    float radius;
    float frictionForce;
  }

  


  class TRAILPOINT
  {
    float x,y;
    float angle;
  }
 void init_cartypes(  )
 {
  CARTYPE cartype;

  cartype                           = cartypes[0];
  cartype.b                         = 2.0;                    // m
  cartype.c                         = 2.0;                    // m
  cartype.wheelbase                 = cartype.b + cartype.c;
  cartype.h                         = 0.55;                    // m
  cartype.mass                      = 1500;                   // kg
  cartype.inertia                   = 1500;                   // kg.m
  cartype.width                     = 1.8;                    // m
  cartype.length                    = 4.5;                    // m, must be > wheelbase
  cartype.wheellength               = 0.7;
  cartype.wheelwidth                = 0.3;
  cartype.brakepower                = 12000;
  cartype.ebrakepower               = 5000;
  cartype.axleFront.ebrakegripratio = 0.9;
  cartype.axleRear.ebrakegripratio  = 0.4;
  cartype.axleFront.totalTireGrip   = 2.5;
  cartype.axleRear.totalTireGrip    = 2.5;
  cartype.axleFront.weightRatio     = cartype.b / cartype.wheelbase;
  cartype.axleRear.weightRatio      = cartype.c / cartype.wheelbase;
 }

 void init_car( CAR car, CARTYPE cartype )
 {
  car.cartype          = cartype;
  car.Velocity         = new PVector(0,0,0);
  car.angularvelocity  = 0;
  car.throttle         = 0;
  car.brake            = 0;
  car.ebrake           = 0;
 }
 


 void init_trail(  ){
   num_trail = 0;
   for (int i = 0; i < TRAIL_SIZE; i++)
     trail[i] = new TRAILPOINT ();
  }
  
 float SGN (float value)
 { if (value < 0.0) return -1.0; else return 1.0; }

 float ABS (float value)
 { if (value < 0.0) return -value; else return value; }
 


 Thread runner;
 
 public void start()
 {
   if (runner == null){
     runner = new Thread(this);
     runner.start();
   }
 }
 
 public void run(){
   while(runner != null){
     handleKeyEvent(this.car);
     engine.updateAutomaticTransmission(this.car);
     do_physics(car, engine);
     add_to_trail( position_wc.x, position_wc.y, headingAngle );
   }
 }
 public void draw() {
    try {
      tint(vColor);
      pushMatrix();
      translate(position_wc.x*100, position_wc.y*100);
      println(position_wc.x, position_wc.y, headingAngle);
      rotate(headingAngle*100);
      image(vImage, 0, 0);  
      popMatrix();

    }
    catch(Exception e) {
      print("error");
    }
  }

 // These constants are arbitrary values, not realistic ones.
 static final float MAXSTEERANGLE        = 0.75;
 static final float STEERSPEED           = 2.5;
 static final float SPEEDSTEERCORRECTION = 300.0;
 static final float STEERADJUSTSPEED     = 1.0;
 
 public void handleKeyEvent(CAR car)
  {   
   car.setThrottle(0);
   car.setBrake(0);
   car.setEbrake(0);
   steerInput   = 0;
   if (keycodes[5] == true) {System.exit(0);}
   if( keycodes[0] == true)  {car.setThrottle(1);}
     else if( keycodes[1] == true ){car.setThrottle(-1);}
   if( keycodes[4] == true ) {car.setEbrake(1);}
   if( keycodes[2] == true ){steerInput = 1;} 
     else if( keycodes[3] == true ){steerInput = -1;}
   keycodes = new boolean[] {false, false, false, false, false, false};
   steerDirection = smoothSteering(steerInput);
   steerDirection = speedAdjustedSteering(steerDirection);
   steerAngle = steerDirection * MAXSTEERANGLE; 
 }
 
 float smoothSteering(float steerInput) {
    float steer = 0;

    if(abs(steerInput) > 0.001f) {
      steer = constrain(steerDirection + steerInput * DELTA_T * STEERSPEED, -1.0f, 1.0f); 
    }
    else
    {
      if (steerDirection > 0) {
        steer = max(steerDirection - DELTA_T * STEERADJUSTSPEED, 0);
      }
      else if (steerDirection < 0) {
        steer = min(steerDirection + DELTA_T * STEERADJUSTSPEED, 0);
      }
    }

    return steer;
  }

  float speedAdjustedSteering(float steerInput) {
    float activeVelocity = min(absoluteVelocity, 250.0f);
    float steer = steerInput * (1.0f - (absoluteVelocity / SPEEDSTEERCORRECTION));
    return steer;
  }
  
 static final float AIRDRAG         = 2.5;//5.0;     /* factor for air resistance (drag)         */
 static final float RESISTANCE      = 8.0;//;30.0;    /* factor for rolling resistance */
 static final float CA_R            = 5.2;   /* cornering stiffness */
 static final float CA_F            = 5.0;    /* cornering stiffness */
 static final float MAX_GRIP        = 2.0;     /* maximum (normalised) friction force, =diameter of friction circle */
 static final float WEIGHTTRANSFER  = 0.35;
 static final float GRAVITY         = -9.81;
 static final float SPEEDTURNINGSTB = 10.0;  /*speed turning stability*/

 
 void do_physics( CAR car, ENGINE engine)
 {
  velocity_wc = car.Velocity;
  sn = sin(headingAngle);
  cs = cos(headingAngle);
  // SAE convention: x is to the front of the car, y is to the right, z is down
  // transform velocity in world reference frame to velocity in car reference frame
  velocity.x =  cs * velocity_wc.x + sn * velocity_wc.y;
  velocity.y = -sn * velocity_wc.x + cs * velocity_wc.y;
  
  //Weight transfer
  float transferX = WEIGHTTRANSFER * acceleration.x * car.cartype.h / car.cartype.wheelbase;
  float transferY = WEIGHTTRANSFER * acceleration.y * car.cartype.h / car.cartype.width * 20; 
  
  // weight on each axle ratio is b / L
  float weightFront = car.cartype.mass * (car.cartype.axleFront.weightRatio * -GRAVITY - transferX);
  float weightRear  = car.cartype.mass * (car.cartype.axleRear.weightRatio * -GRAVITY + transferX);
  
  // Weight on each tire 
  car.cartype.axleFront.tireLeft.activeWeight  = weightFront - transferY;
  car.cartype.axleFront.tireRight.activeWeight = weightFront + transferY;
  car.cartype.axleRear.tireLeft.activeWeight   = weightRear - transferY;
  car.cartype.axleRear.tireRight.activeWeight  = weightRear + transferY;
  
 // Velocity of each tire
 car.cartype.axleFront.tireLeft.angularVelocity  = car.cartype.b * car.angularvelocity;
 car.cartype.axleFront.tireRight.angularVelocity = car.cartype.b * car.angularvelocity;
 car.cartype.axleRear.tireLeft.angularVelocity   = -car.cartype.c * car.angularvelocity;
 car.cartype.axleRear.tireRight.angularVelocity  = -car.cartype.c * car.angularvelocity;
 
 // Slip angle
 car.cartype.axleFront.slipAngle = atan2((velocity.y + car.cartype.axleFront.getAngularVelocity())
                                   ,(abs(velocity.x))) - SGN(velocity.x) * steerAngle;
 car.cartype.axleRear.slipAngle = atan2((velocity.y + car.cartype.axleRear.getAngularVelocity())
                                   ,(abs(velocity.x)));
 
 float activeBrake    = min(car.brake * car.cartype.brakepower 
                        + car.ebrake * car.cartype.ebrakepower, car.cartype.brakepower);
 float activeThrottle = (car.throttle * engine.getTorque(car)) * (engine.gearRatio() * engine.effectiveGearRatio());
 
 car.cartype.axleRear.tireLeft.torque = activeThrottle / car.cartype.axleRear.tireLeft.radius;
 car.cartype.axleRear.tireRight.torque = activeThrottle / car.cartype.axleRear.tireRight.radius;
 
 car.cartype.axleFront.tireLeft.grip = car.cartype.axleFront.totalTireGrip * (1.0f - car.ebrake * (1.0f - car.cartype.axleFront.ebrakegripratio));
 car.cartype.axleFront.tireRight.grip = car.cartype.axleFront.totalTireGrip * (1.0f - car.ebrake * (1.0f - car.cartype.axleFront.ebrakegripratio));
 car.cartype.axleRear.tireLeft.grip = car.cartype.axleRear.totalTireGrip * (1.0f - car.ebrake * (1.0f - car.cartype.axleRear.ebrakegripratio));
 car.cartype.axleRear.tireRight.grip = car.cartype.axleRear.totalTireGrip * (1.0f - car.ebrake * (1.0f - car.cartype.axleRear.ebrakegripratio));
 
 car.cartype.axleFront.tireLeft.frictionForce = constrain(-CA_F * car.cartype.axleFront.slipAngle, 
                                               -car.cartype.axleFront.tireLeft.grip, car.cartype.axleFront.tireLeft.grip) * car.cartype.axleFront.tireLeft.activeWeight;
 car.cartype.axleFront.tireRight.frictionForce = constrain(-CA_F * car.cartype.axleFront.slipAngle, 
                                               -car.cartype.axleFront.tireRight.grip, car.cartype.axleFront.tireRight.grip) * car.cartype.axleFront.tireRight.activeWeight;
 car.cartype.axleRear.tireLeft.frictionForce = constrain(-CA_R * car.cartype.axleRear.slipAngle, 
                                               -car.cartype.axleRear.tireLeft.grip, car.cartype.axleRear.tireLeft.grip) * car.cartype.axleRear.tireLeft.activeWeight;
 car.cartype.axleRear.tireRight.frictionForce = constrain(-CA_R * car.cartype.axleRear.slipAngle, 
                                               -car.cartype.axleRear.tireRight.grip, car.cartype.axleRear.tireRight.grip) * car.cartype.axleRear.tireRight.activeWeight;

 // Forces
 float tractionForceX = car.cartype.axleRear.getTorque() - activeBrake * SGN(velocity.x);
 float tractionForceY = 0;

 float dragForceX = -RESISTANCE * velocity.x - AIRDRAG * velocity.x * abs(velocity.x);
 float dragForceY = -RESISTANCE * velocity.y - AIRDRAG * velocity.y * abs(velocity.y);

 float totalForceX = dragForceX + tractionForceX;
 float totalForceY = dragForceY + tractionForceY 
       + cos (steerAngle) * car.cartype.axleFront.getFrictionForce() + car.cartype.axleRear.getFrictionForce();

 //adjust Y force so it levels out the car heading at high speeds
 if (absoluteVelocity > 10) {
      totalForceY *= (absoluteVelocity + 1) / (21.0 - SPEEDTURNINGSTB);
    }
 
 // If we are not pressing gas, add artificial drag - helps with simulation stability
 if (car.throttle == 0) {
   velocity = PVector.lerp (velocity, new PVector(0.0, 0.0), 0.005f);
 }
    
 // Acceleration
 acceleration.x = totalForceX / car.cartype.mass;
 acceleration.y = totalForceY / car.cartype.mass;

 acceleration_wc.x = cs * acceleration.x - sn * acceleration.y;
 acceleration_wc.y = sn * acceleration.x + cs * acceleration.y;

 // Velocity and speed
 velocity_wc.x += acceleration_wc.x * DELTA_T;
 velocity_wc.y += acceleration_wc.y * DELTA_T;

 absoluteVelocity = velocity_wc.mag();
 
 // Angular torque of car
 float angularTorque = (car.cartype.axleFront.getFrictionForce() * car.cartype.b) 
                     - (car.cartype.axleRear.getFrictionForce() * car.cartype.c);
                     
 // Car will drift away at low speeds
 if (absoluteVelocity < 0.5f && activeThrottle == 0)
 {
      acceleration = new PVector(0,0,0);
      absoluteVelocity = 0;
      velocity_wc = new PVector(0,0,0);
      angularTorque = 0;
      car.angularvelocity = 0;
      acceleration_wc = new PVector(0,0,0);
 }
 
 float angularAcceleration = angularTorque / car.cartype.inertia;
 
 // Update 
 car.angularvelocity += angularAcceleration * DELTA_T;

 // Simulation likes to calculate high angular velocity at very low speeds - adjust for this
 if (absoluteVelocity < 1 && abs (steerAngle) < 0.05) {
   car.angularvelocity = 0;
 } else if (car.getKilometersPerHour() < 0.75f) {
     car.angularvelocity = 0;
   }

 headingAngle += car.angularvelocity * DELTA_T;
 position_wc.x += DELTA_T * velocity_wc.x;
 position_wc.y += DELTA_T * velocity_wc.y;
 car.Velocity = velocity_wc;


 }

/*
 * End of Physics module
 */
void add_to_trail( float x, float y, float angle )
  {
   if( num_trail < TRAIL_SIZE-1 )
   {
     trail[num_trail].x = x;
     trail[num_trail].y = y;
     trail[num_trail].angle = angle;
     num_trail++;
    }
     else
     {
     //  System.arraycopy(trail, 1, trail, 0, TRAIL_SIZE-1);
      for (int i=0; i< TRAIL_SIZE-1; i++)
      {
       trail[i].x = trail[i+1].x;
       trail[i].y = trail[i+1].y;
       trail[i].angle = trail[i+1].angle;
      }
       trail[num_trail].x = x;
       trail[num_trail].y = y;
       trail[num_trail].angle = angle;
     }
  }
  
public Agent()
 {
   car               = new CAR();
   cartypes[0]       = new CARTYPE();
   engine            = new ENGINE();
   position_wc       = new PVector();
   acceleration      = new PVector();
   velocity          = new PVector();
   velocity_wc       = new PVector();
   acceleration_wc   = new PVector();
   absoluteVelocity  = 0;
   vImage            = loadImage("red.png");
   vImage.resize(45, 18);
   vColor            = color(random(100, 255),random(100, 255),random(100, 255));
   imageMode(CENTER);

   init_cartypes();
   init_car( car, cartypes[0] );
   init_trail();
 }
}
