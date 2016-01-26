public class Star {
  float points = 5;
  float circAngle = 360/points * 2;
  float radius;

  int x = 0;
  int y = 0;
  float vx;
  float vy;
  float sx = 0.1;
  float sy = -1;

  PVector acceleration;
  PVector startPos;
  PVector velocity;
  PVector newPos;
  int age = 0;
 
  float G = 9.81;
  float dt = 1.0/50;
  
  
  Star(PVector inCenter, float inRadius) {
    //save star parameters to be accessed locally
    this.startPos = inCenter;
    this.radius = inRadius;
    starAngle(random(45,60), random(10, 15));
    //background(0);
    //stroke(212, 128, 32, 128);
    //int num_steps = (int)(x_radius + y_radius)/4;
  }

  void display() {
    //background(0);

    stroke(255);

    //draw star
    for (float i = 0; i < 720; i+= circAngle) {
      PVector point1 = new PVector(cos(radians(i))*(radius), sin(radians(i))*(radius));
      PVector point2 = new PVector(cos(radians(i + circAngle))*(radius), sin(radians(i + circAngle))*(radius));
      PVector cPoint1 = PVector.add(startPos, point1);
      PVector cPoint2 = PVector.add(startPos, point2);
      line(cPoint1.x, cPoint1.y, cPoint2.x, cPoint2.y);
      
    }
    
    age += 1;
  }

  void update() {
    // add movement to star location
    //velocity = new PVector(.1, .3);//new PVector(random(3), int(random(-4)));  
    //acceleration = new PVector(0.0001, 0.001);
   
    vx = vx;
    vy = vy - G * dt; //gravity pulls down
    // update star position
    sx = sx + vx * dt;
    sy = sy + vy * dt;
    // println(sx + " and " + sy);
    velocity = new PVector(sx, -sy); 
    newPos = startPos.add(velocity);
  }


  void starAngle(float a, float v) {
    
    vx = cos(a * PI/180) * v;
    vy = sin(a * PI/180) * v;
    println(a * PI/180 + "angle " + cos(a * PI/180));
   
  }
  
  void starPower(float theta, float length) {
  }
}