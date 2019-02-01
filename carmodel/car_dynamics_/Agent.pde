 // https://github.com/jongallant/CarSimulator/blob/b6e464f873a2b8ff06b4c33630c55199e25f19f2/Assets/Scripts/Car.cs
//https://github.com/jongallant/CarSimulator
https://nccastaff.bournemouth.ac.uk/jmacey/MastersProjects/MSc12/Srisuchat/Thesis.pdf
class Agent implements Runnable{
  // Vehicle variables//////////////////////////////
  static final int TRAIL_SIZE = 200;     /* number of dots in car trail */
  static final float DELTA_T = 0.01;    /* time between integration steps in physics modelling */
  static final float INPUT_DELTA_T = 0.1;   /* delay between keyboard polls */
  static final float M_PI = 3.1415926;
  
  CARTYPE []cartypes = new CARTYPE[1];
  VEC2    screen_pos;
  float  scale;
  String  str;
  int     ticks = 1;        // ticks of DELTA_T second
  int     iticks = 1;       // ticks of INPUT_DELTA_T second
  TRAILPOINT [] trail = new TRAILPOINT [ TRAIL_SIZE ];
  int     num_trail = 0;
  
  int        keycode;

  VEC2       velocity;
  VEC2       acceleration_wc;
  float     rot_angle;
  float     sideslip;
  float     slipanglefront;
  float     slipanglerear;
  VEC2       force;
  int        rear_slip;
  int        front_slip;
  VEC2       resistance;
  VEC2       acceleration;
  float     torque;
  float     angular_acceleration;
  float     sn, cs;
  float     yawspeed;
  float     weight;
  VEC2       ftraction;
  VEC2       flatf, flatr;
  /////////////////////////////////////////////////////////////////////
  color vColor;
  PImage vImage;
  
   class VEC2
  { float x,y; }

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

  }
  
  class AXLE
  {
    public AXLE()
    {
      tireLeft  = new TIRE();
      tireRight = new TIRE();
    }
    TIRE  tireLeft;
    TIRE tireRight;
    float weightRatio;
    float slipAngle;
    
    float getAngularVelocity(){
      return tireLeft.angularVelocity + tireRight.angularVelocity;
    }
  }

  class TIRE
  {
    float activeWeight;
    float angularVelocity;
    float torque;
    float grip;
  }
  class CAR
  {
   public CAR ()
   {
    cartype = new CARTYPE();
    position_wc = new VEC2();
    velocity_wc = new VEC2();
   }
    CARTYPE cartype;        // pointer to static car data

    VEC2 position_wc;       // position of car centre in world coordinates
    VEC2 velocity_wc;       // velocity vector of car in world coordinates

    float angle;           // angle of car body orientation (in rads)
    float angularvelocity;

    float steerangle;      // angle of steering (input)
    float throttle;        // amount of throttle (input)
    float brake;           // amount of braking (input)
  }
  


  class TRAILPOINT
  {
    float x,y;
    float angle;
  }
 void init_cartypes(  )
 {
  CARTYPE cartype;

  cartype = cartypes[0];
  cartype.b = 2.0;                               // m
  cartype.c = 2.0;                               // m
  cartype.wheelbase = cartype.b + cartype.c;
  cartype.h = 1.0;                               // m
  cartype.mass = 1500;                           // kg
  cartype.inertia = 1500;                        // kg.m
  cartype.width = 1.8;                           // m
  cartype.length = 4.5;                           // m, must be > wheelbase
  cartype.wheellength = 0.7;
  cartype.wheelwidth = 0.3;
  cartype.axleFront.weightRatio = cartype.b / cartype.wheelbase;
  cartype.axleRear.weightRatio  = cartype.c / cartype.wheelbase;
 }

 void init_car( CAR car, CARTYPE cartype )
 {
  car.cartype = cartype;
  car.position_wc.x = 0;
  car.position_wc.y = 0;
  car.velocity_wc.x = 0;
  car.velocity_wc.y = 0;
  car.angle = 0;
  car.angularvelocity = 0;
  car.steerangle = 0;
  car.throttle = 0;
  car.brake = 0;
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

 CAR car;
 int quit;
 boolean applet;

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
     handleKeyEvent();
     do_physics(car, DELTA_T);
     add_to_trail( car.position_wc.x, car.position_wc.y, car.angle );
     try {runner.sleep(1);}
     catch(Exception e){}
   }
 }
 public void draw() {
    try {
      tint(vColor);
      pushMatrix();
      translate((float)car.position_wc.x, (float)car.position_wc.y);
      rotate(-(float)car.angle + HALF_PI);
      image(vImage, 0, 0);  
      popMatrix();
    }
    catch(Exception e) {
      print(e);
    }
  }
 public Agent( boolean runs )
 {
   car = new CAR();
   cartypes[0] = new CARTYPE();
   screen_pos = new VEC2();
   ftraction = new VEC2();
   flatf = new VEC2();
   flatr = new VEC2();
   resistance = new VEC2();
   acceleration = new VEC2();
   force = new VEC2();
   velocity = new VEC2();
   acceleration_wc = new VEC2();
   
   vImage = loadImage("red.png");
   vImage.resize(45, 18);
   vColor = color(random(100, 255),random(100, 255),random(100, 255));
   imageMode(CENTER);
   
   int lastticks=0;
   int lastiticks = 0;

   // initial scale of rendering
   scale = 10;     // pixels per m

   init_cartypes();
   init_car( car, cartypes[0] );

   init_trail();

   quit = 0;
 }
 // These constants are arbitrary values, not realistic ones.
public void handleKeyEvent()
 {
   println(keycode, UP);
   if (keycode == ESC) {System.exit(0); }
   if( keycode == UP) if( car.throttle < 100) car.throttle += 10;
   if( keycode == DOWN ) if( car.throttle >= 10) car.throttle -= 10;
   if( keycode == BACKSPACE )
   {
     car.brake = 100;
     car.throttle = 0;
   } else car.brake = 0;
   if( keycode == LEFT )
   {
     if( car.steerangle > - M_PI/4.0 ) car.steerangle -= M_PI/32.0;
   } else if( keycode == RIGHT )
     {
       if( car.steerangle <  M_PI/4.0 ) car.steerangle += M_PI/32.0;
     }

       rear_slip = 0;
       front_slip = 0;
  keycode = 0;
    /*if( kSpace )
    {
     front_slip = 1;
     rear_slip = 1;
    }*/
 }
 
 static final float DRAG            = 5.0;     /* factor for air resistance (drag)         */
 static final float RESISTANCE      = 30.0;    /* factor for rolling resistance */
 static final float CA_R            = -5.20;   /* cornering stiffness */
 static final float CA_F            = -5.0;    /* cornering stiffness */
 static final float MAX_GRIP        = 2.0;     /* maximum (normalised) friction force, =diameter of friction circle */
 static final float WEIGHTTRANSFER  = 0.35;
 static final float  GRAVITY         = -9.81;
 
 void do_physics( CAR car, float delta_t )
 {
   
  sn = sin(car.angle);
  cs = cos(car.angle);
  // SAE convention: x is to the front of the car, y is to the right, z is down
  // transform velocity in world reference frame to velocity in car reference frame
  velocity.x =  cs * car.velocity_wc.x + sn * car.velocity_wc.y;
  velocity.y = -sn * car.velocity_wc.x + cs * car.velocity_wc.y;
  
  //Weight transfer
  float transferX = WEIGHTTRANSFER * acceleration.x * car.cartype.h / car.cartype.wheelbase;
  float transferY = WEIGHTTRANSFER * acceleration.y * car.cartype.h / car.cartype.width; 
  
  // weight on each axle
  float weightFront = car.cartype.mass * (car.cartype.axleFront.weightRatio * -GRAVITY - transferX);
  float weightRear = car.cartype.mass * (car.cartype.axleRear.weightRatio * -GRAVITY + transferX);
  
  // Weight on each tire 
  car.cartype.axleFront.tireLeft.activeWeight = weightFront - transferY;
  car.cartype.axleFront.tireRight.activeWeight = weightFront + transferY;
  car.cartype.axleRear.tireLeft.activeWeight = weightRear - transferY;
  car.cartype.axleRear.tireRight.activeWeight = weightRear + transferY;
  
 // Velocity of each tire
 car.cartype.axleFront.tireLeft.angularVelocity = car.cartype.b * car.angularvelocity;
 car.cartype.axleFront.tireRight.angularVelocity = car.cartype.b * car.angularvelocity;
 car.cartype.axleRear.tireLeft.angularVelocity = -car.cartype.c * car.angularvelocity;
 car.cartype.axleRear.tireRight.angularVelocity = -car.cartype.c * car.angularvelocity;
 
 // Slip angle
 car.cartype.axleFront.slipAngle = atan2((velocity.y + car.cartype.axleFront.getAngularVelocity())
                                   ,(abs(velocity.x))) - SGN(velocity.x) * car.steerangle;
 car.cartype.axleRear.slipAngle = atan2((velocity.y + car.cartype.axleRear.getAngularVelocity())
                                   ,(abs(velocity.x)));
 
 float activeBrake = min(brake * brakePower+ eBrake * eBrakePower, brakePower);
 
 // Lateral force on wheels
 //
   // Resulting velocity of the wheels as result of the yaw rate of the car body
   // v = yawrate * r where r is distance of wheel to CG (approx. half wheel base)
   // yawrate (ang.velocity) must be in rad/s
   //
   yawspeed = car.cartype.wheelbase * 0.5 * car.angularvelocity;

   if( velocity.x == 0 )                // TODO: fix Math.singularity
        {rot_angle = 0;}
   else
    {rot_angle = atan2(yawspeed , velocity.x);}
   // Calculate the side slip angle of the car (a.k.a. beta)
   if( velocity.x == 0 )                // TODO: fix Math.singularity
        {sideslip = 0;}
   else
    {sideslip = atan2( velocity.y , velocity.x);}

   // Calculate slip angles for front and rear wheels (a.k.a. alpha)
   slipanglefront = sideslip + rot_angle - car.steerangle;
   slipanglerear  = sideslip - rot_angle;

   // weight per axle = half car mass times 1G (=9.8m/s^2)
   weight = car.cartype.mass * 9.8 * 0.5;

   // lateral force on front wheels = (Ca * slip angle) capped to friction circle * load
   flatf.x = 0;
   flatf.y = CA_F * slipanglefront;
   flatf.y = Math.min(MAX_GRIP, flatf.y);
   flatf.y = Math.max(-MAX_GRIP, flatf.y);
   flatf.y *= weight;
   if(front_slip==1)
       flatf.y *= 0.5;

   // lateral force on rear wheels
   flatr.x = 0;
   flatr.y = CA_R * slipanglerear;
   flatr.y = Math.min(MAX_GRIP, flatr.y);
   flatr.y = Math.max(-MAX_GRIP, flatr.y);
   flatr.y *= weight;
   if(rear_slip==1)
     flatr.y *= 0.5;

   // longtitudinal force on rear wheels - very simple traction model
   ftraction.x = 100*(car.throttle - car.brake*SGN(velocity.x));
   ftraction.y = 0;
   if(rear_slip==1)
     ftraction.x *= 0.5;

// Forces and torque on body

   // drag and rolling resistance
   resistance.x = -( RESISTANCE*velocity.x + DRAG*velocity.x*ABS(velocity.x) );
   resistance.y = -( RESISTANCE*velocity.y + DRAG*velocity.y*ABS(velocity.y) );

   // sum forces
   force.x = ftraction.x + Math.sin(car.steerangle) * flatf.x + flatr.x + resistance.x;
   force.y = ftraction.y + Math.cos(car.steerangle) * flatf.y + flatr.y + resistance.y;

   // torque on body from lateral forces
   torque = car.cartype.b * flatf.y - car.cartype.c * flatr.y;

// Acceleration

   // Newton F = m.a, therefore a = F/m
   acceleration.x = force.x/car.cartype.mass;
   acceleration.y = force.y/car.cartype.mass;
   angular_acceleration = torque / car.cartype.inertia;

// Velocity and position

   // transform acceleration from car reference frame to world reference frame
   /*acceleration_wc.x =  cs * acceleration.x - sn * acceleration.y;
   acceleration_wc.y =  sn * acceleration.x + cs * acceleration.y;*/
   acceleration_wc.x =  cs * acceleration.y + sn * acceleration.x;
   acceleration_wc.y = -sn * acceleration.y + cs * acceleration.x;
   // velocity is integrated acceleration
   //
   car.velocity_wc.x += delta_t * acceleration_wc.x;
   car.velocity_wc.y += delta_t * acceleration_wc.y;

   // position is integrated velocity
   //
   car.position_wc.x += delta_t * car.velocity_wc.x;
   car.position_wc.y += delta_t * car.velocity_wc.y;


// Angular velocity and heading

   // integrate angular acceleration to get angular velocity
   //
   car.angularvelocity += delta_t * angular_acceleration;

   // integrate angular velocity to get angular orientation
   //
   car.angle += delta_t * car.angularvelocity ;
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
}
