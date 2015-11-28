class FlowField {

  //-------------------------------------------------------DECALRE VARIABLES

  Vec3D[][] field;
  Vec3D[][] fieldBackup;
  int cols, rows; 
  int resolution; 
  color colStart = color(0, 200, 200);
  color colEnd = color(255, 170, 0);
  PShape groupField;
  int counter;

  //-------------------------------------------------------CONSTRUCTOR

  FlowField(int r) {
    resolution = r;
    cols = width/resolution;
    rows = height/resolution;
    field = new Vec3D[cols][rows];
    fieldBackup = new Vec3D[cols][rows];
    init();
  }

  //----------------------------------------------------------------------FUNCTIONS

  void init() {

    groupField = createShape(GROUP);

    noiseSeed((int)random(10000));

    for (int i = 0; i < cols; i++) {

      for (int j = 0; j < rows; j++) {

        Vec3D c = new Vec3D(i*resolution, j*resolution, 0);
        Vec3D d = attRep (att, c, 1, 20, 0.1);
        Vec3D e = attRep (att2, c, -1, 20, 0.1);        
        Vec3D f = attRep (att3, c, 1, 20, 0.1);
        Vec3D g = attRep (att4, c, -1, 20, 0.1);
        Vec3D sum = new Vec3D();

        sum.addSelf(d);
        sum.addSelf(e);
        sum.addSelf(f);
        sum.addSelf(g);
        sum.scaleSelf(1);

        field[i][j] =sum ;
      }
    }
  }

  // -------------------------------------------------------------------DISPLAY

  void display() {
    counter = 0;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        counter++;
        drawVector(field[i][j], i*resolution, j*resolution, 1);
      }
    }
  }

  // -------------------------------------------------------------------DRAW VECTOR

  void drawVector(Vec3D v, float x, float y, float scayl) {
    pushMatrix();
    translate(x, y);  
    float HH = v.headingXY();
    float tt = map(degrees(HH), -180, 180, 0, 1);
    color cc = lerpColor(colStart, colEnd, tt);
    stroke(cc);
    strokeWeight(0.3);
    rotate(HH);  
    line(0, 0, 10, 0);
    popMatrix();
  }

  // -------------------------------------------------------------------LOOK UP

  Vec3D lookup(Vec3D lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].copy();
  }

  // -------------------------------------------------------------------DEPOSIT PHEROMONE

  void depositPher(Vec3D dep, Vec3D pheromone) {
    int column = int(constrain(dep.x/resolution, 0, cols-1));
    int row = int(constrain(dep.y/resolution, 0, rows-1));
    field[column][row] = pheromone.copy();
  }

  //----------------------------------------------create attractor or repulsor

  Vec3D attRep (Vec3D AR, Vec3D pos, float charge, float rad, float force) {
    Vec3D diff = AR.sub(pos);        
    diff.scaleSelf(charge);
    float r =rad/diff.magnitude();
    diff.normalize();
    diff.scaleSelf(r *force);
    return diff;
  }
}
