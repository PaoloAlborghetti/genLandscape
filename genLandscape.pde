/* 
 //--------------------------------------------------//----------------------------------------------------//
 
 Some example created with this code : https://vimeo.com/45254453.
 More info at : http://radical-reaction-ad.blogspot.it/
 
 code by Paolo Alborghetti 2015 (cc)Attribution-ShareAlike
 
 N : turn on/off agent preview
 T : turn on/off agent tail preview
 D : turn on/off landscape preview
 
 ENJOY! :)
 */

import toxi.geom.*;
import controlP5.*;

//------------------------------------------------DECLARE

int popu = 10000;
FlowField flowfield;
ArrayList<Agent> agents;

boolean mountain = true;
boolean tailPrev=false;
boolean LB = false;
boolean appWander = true;
boolean futPrev = false;
boolean expTiff = false;
boolean dis=true;
int vidcount;
int fcount = 153;

int time=0;

Vec3D att ;
Vec3D att2 ;
Vec3D att3 ;
Vec3D att4 ;

Vec3D c1;
Vec3D c2 ;
Vec3D c3 ;
Vec3D c4 ;

ControlP5 controlP5;
ControlWindow controlWindow;

void setup() {
  size(1280, 600, P2D);
  smooth();

  //--------------------------------------------UI CONTROLS

  initController();
  ui();

  //--------------------------------------------INITIALIZE

  att4 = new Vec3D((width)/2, (height)/2, 0);

  c1 = new Vec3D((width), 0, 0);
  c2 = new Vec3D((width), (height), 0);
  c3 = new Vec3D(0, (height), 0);
  c4 = new Vec3D(0, 0, 0);

  att = new Vec3D(random(width), random(height), 0);
  att2 = new Vec3D(random(width), random(height), 0);
  att3 = new Vec3D(random(width), random(height), 0);


  flowfield = new FlowField(3);
  agents = new ArrayList<Agent>();

  for (int i = 0; i < popu; i++) {
    Vec3D origin = new Vec3D (random(width), random(height), 0);
    agents.add(new Agent(origin));
  }
}

void draw() {
  background(0);

  if (mountain) flowfield.display();
  for (Agent v : agents) {
    v.FutLoc();
    v.follow(flowfield);
    v.run();
    v.deposit(flowfield);
    if (appWander) v.wander();
  }

  if (time > 40) {
    agents.clear();
    for (int i = 0; i < popu; i++) {
      Vec3D origin = new Vec3D (random(width), random(height), 0);
      agents.add(new Agent(origin));      
      time = 0;
    }
  }
  time++; 

  //------------------------------------------------------display attractors
  fill(0, 225, 220, 200);
  noStroke();
  ellipse(att2.x, att2.y, 5, 5);
  ellipse(att3.x, att3.y, 5, 5);
  ellipse(att.x, att.y, 5, 5);
  ellipse(att4.x, att4.y, 5, 5);  
  //------------------------------------------------------display attractors
}

//-------------------------------------------------------------PREVIEW MODE OPTIONS

void keyPressed() {
  if (key == 'c' || key == 'C') {
    flowfield.init();
  }
  if (key == 'd' || key == 'D') {
    mountain = !mountain;
  }
  if (key == 't' || key == 'T') {
    tailPrev=!tailPrev;
  }
  if (key == 'l'|| key == 'L') {
    LB=!LB;
  }
  if (key == 'w'|| key == 'W') {
    appWander=!appWander;
  }
  if (key == 'f'|| key == 'F') {
    futPrev=!futPrev;
  }
  if (key == 'e'|| key == 'E') {
    PNGImg();
  }
  if (key == 'n'|| key == 'N') {
    dis = !dis;
  }
}

void PNGImg() {
  println(frameCount); 
  saveFrame("data/####_"+day()+"_"+hour()+"_"+minute()+".png");
}

