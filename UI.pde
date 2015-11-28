int sArray = 20;

float FLOC_MAG;
float wandertheta = 30;
float maxForce ;    // Maximum steering force
float maxFVel;  // Maximum steer velocity
float maxVel ;    //max update location velocity
float minVel = 0.4;

void  ui() {
  buildFSlider("FLOC_MAG", 0, 30, 3);
  buildFSlider("maxForce", 0, 5, 2);
  buildFSlider("maxFVel", 0, 5, 3);
  buildFSlider("maxVel", 0, 5, 3);
}

void initController() {
  controlP5 = new ControlP5(this);
  controlP5.setColorBackground(color(225, 225, 225, 200)); 
  controlP5.setColorForeground(color(100));
  controlP5.setColorActive(color(0, 0, 0, 255));
  //controlP5.setColorLabel(color(255)); 
  controlP5.setAutoDraw(true);
}

void buildFSlider(String name, float min, float max, float def) {
  Controller s1 = controlP5.addSlider(name, min, max, def, 20, sArray, 100, 10);
  sArray += 20;
  s1.setId(1);
  s1.setValue(def);
}

void buildISlider(String name, int min, int max, int def) {
  Controller s1 = controlP5.addSlider(name, min, max, def, 20, sArray, 100, 10);
  sArray += 20;
  s1.setId(1);
  s1.setValue(def);
  //s1.setWindow(controlWindow);
}
