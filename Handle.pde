class Handle {
  PVector pos;
  boolean GRABBED;
  int rad = 10;
  int INDEX;
  PVector ORIGIN;
  float SCALE;

  Handle(float x, float y, int index, PVector o, float s) {
    ORIGIN = o;
    SCALE = s;
    pos = new PVector(x, y);
    INDEX = index;
    GRABBED = false;
  }

  public void update() {
    pos = new PVector(getNormalX(mouseX), getNormalY(mouseY));
  }

  public boolean check_grabbed() {
    float diffX = abs(mouseX - getRealX());
    float diffY = abs(mouseY - getRealY());
    if (diffX < rad+rad/2 & diffY < rad+rad/2) {
      GRABBED = true;
    } else {
      GRABBED = false;
    }
    return GRABBED;
  }

  public void release() {
    GRABBED = false;
  }
  
  public float getRealX() {
    return pos.x * SCALE + ORIGIN.x;
  }
  
  public float getRealY() {
    return pos.y * SCALE + ORIGIN.y;
  }
  
  public float getNormalX(float x) {
    return (x - ORIGIN.x) / SCALE ;
  }
  
  public float getNormalY(float y) {
    return (y - ORIGIN.y) / SCALE ;
  }
  
  public PVector real_coords() {
    return new PVector(getRealX(), getRealY());
  }
  
  public void set_origin(PVector o) {
    ORIGIN = o;
  }

  public void render() {
    pushStyle();
    pushMatrix();
    translate(ORIGIN.x, ORIGIN.y);
    color c = INDEX % 3 == 0 ? color(255,0,0) : color(0,0,255);
    stroke(c);
    fill(c);
    ellipse(pos.x * SCALE, pos.y * SCALE, rad*2, rad*2);
    popMatrix();
    popStyle();
  }
}

