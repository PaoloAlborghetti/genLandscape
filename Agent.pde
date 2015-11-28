class Agent {

  //------------------------------------------------------- GLOBAL VARIABLES
  Vec3D loc;
  Vec3D velocity;
  Vec3D acceleration;
  float r;

  //future loc variables

  Vec3D futVec;
  Vec3D futLoc;

  //tail variables

  ArrayList <Vec3D> tail = new ArrayList <Vec3D> ();
  int Tcount = 0;
  int TLen = 20;
  int TStep = 5;


  //--------------------------------------------CONSTRUCTOR

  Agent(Vec3D _loc) {
    loc = _loc;
    r = 3.0;
    acceleration = new Vec3D(0, 0, 0);
    velocity = new Vec3D(random(-2, 2), random(-2, 2), 0);
  }

  //-------------------------------------------------------RUN

  void run() {
    update();
    borders();
    if (dis)display();
    drawTail();
  }

  //-------------------------------------------------------FOLLOW FIELD

  void follow(FlowField flow) {
    Vec3D desired = flow.lookup(futLoc);
    desired.scaleSelf(maxFVel);
    Vec3D steer = desired.sub(velocity);
    steer.limit(maxForce);  
    acceleration.addSelf(steer);
  }

  //-------------------------------------------------------DEPOSIT

  void deposit(FlowField flow) {
    flow.depositPher(loc, velocity);
  }

  //-------------------------------------------------------UPDATE

  void update() {
    velocity.addSelf(acceleration);
    velocity.limit(maxVel);
    if (velocity.magnitude()<minVel) {              
      velocity.normalize();
      velocity.scaleSelf(minVel);
    }
    loc.addSelf(velocity);
    acceleration.scaleSelf(0);
  }

  //--------------------------------------------------------PREDICT FUT LOC

  void FutLoc() {

    futVec = velocity.copy();
    futVec.normalize();
    futVec.scaleSelf(FLOC_MAG);
    futLoc = futVec.addSelf(loc);
    Vec3D futVecPrev = velocity.copy();
    futVecPrev.scaleSelf(5).addSelf(loc);
    stroke(255);
    strokeWeight(0.1);
    if (dis) line(loc.x, loc.y, futVecPrev.x, futVecPrev.y);
  }

  //-----------------------------------------------------------WANDER

  void wander() {
    float wanderR = 25;
    float wanderD = 40;
    float change = 0.6;
    wandertheta += random(-change, change);
    Vec3D circleLoc = velocity.copy();
    circleLoc.normalize();
    circleLoc.scaleSelf(wanderD);
    circleLoc.addSelf(loc); 
    Vec3D circleOffSet = new Vec3D(wanderR*cos(wandertheta), wanderR*sin(wandertheta), 0);
    Vec3D target = circleLoc.addSelf(circleOffSet);
    Vec3D steer = target.sub(loc);
    steer.normalize();
    steer.scaleSelf(0.1);
    acceleration.addSelf(steer);
  }

  //-------------------------------------------------------DISPLAY

  void display() {
    stroke(255,100);
    strokeWeight(2);
    point(loc.x, loc.y);
  }

  //------------------------------------------------------------DRAW TAIL

  void drawTail() {
    Tcount++;
    if (Tcount > TStep) {
      tail.add(loc.copy());
      Tcount = 0;
    }

    if (tail.size() > TLen) {
      tail.remove(0);
    }

    for ( int i = 1; i < tail.size (); i++ ) {    
      if (tailPrev) {
        Vec3D a = tail.get(i-1);
        Vec3D b = tail.get(i);
        if (a.distanceTo(b) < 30) {
          stroke(0, 200, 200, map(i, 0, tail.size(), 0, 100));
          strokeWeight(map(i, 0, tail.size(), 0.01, 0.5));
          line(a.x, a.y, b.x, b.y);
        }
      }
    }
  }

  //-------------------------------------------------------BORDERS

  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }
}

