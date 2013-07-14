class Mustache {
  int NO_OF_CTRLS = 15; // must be a multiple of 3
  int CURRENT = -1;
  Handle[] handles = new Handle[NO_OF_CTRLS];
  PVector ORIGIN;
  float SCALE;
  boolean DRAGGING = false;
  boolean SHOW_HANDLES = true;
  boolean SEE_THRU = true;
  boolean CLICK_HANDLED = false;
  boolean DISPLAY_GUI = true;


  Mustache() {
    float x, y;
    float spacing = TWO_PI / NO_OF_CTRLS;
    SCALE = width / 4;
    ORIGIN = new PVector(width/2, height/2);
    for (int i = 0; i < NO_OF_CTRLS; i++) {
      x = cos(spacing * i);
      y = sin(spacing * i);
      handles[i] = new Handle(x, y, i, ORIGIN, SCALE, this);
    }
  }
  
  public void toggle_menu() {
    DISPLAY_GUI = !DISPLAY_GUI;
  }

  public void update(float x, float y) {
    // if any of the handles reports being grabbed,
    // update its coordinates
    // but not if the whole shape is being dragged
    // or if handles are hidden
    if (DRAGGING || ! SHOW_HANDLES || DISPLAY_GUI) return; 
    if (CURRENT == -1) {
      // check if a handle is being grabbed
      for (int i = 0; i < NO_OF_CTRLS; i++) {
        if (handles[i].check_grabbed(x, y)) {
          CURRENT = i;
          handles[CURRENT].update(x, y);
          CLICK_HANDLED = true;
          break;
        }
      }
    } 
    else {
      // a handle is selected
      handles[CURRENT].update(x, y);
    }
  }

  public void set_origin(float x, float y, float oldX, float oldY) {
    if (DISPLAY_GUI) return; // no movement of mustache when in menu mode
    float dx = x - oldX;
    float dy = y - oldY;
    DRAGGING = true;
    ORIGIN.x = ORIGIN.x + dx;
    ORIGIN.y = ORIGIN.y + dy;
    for (int i = 0; i < NO_OF_CTRLS; i++) {
      handles[i].set_origin(ORIGIN);
    }
    if (dx != 0 || dy != 0) CLICK_HANDLED = true;
  }

  public void deselect() {
    if (CURRENT > -1) handles[CURRENT].release();
    CURRENT = -1;
    DRAGGING = false;
  }

  public boolean is_not_active() {
    return CURRENT == -1;
  }

  public boolean is_active() {
    return CURRENT != -1;
  }


  public void render() {
    draw_line();
    if (SHOW_HANDLES & ! DRAGGING & !DISPLAY_GUI) draw_handles();
  }

  public void draw_line() {
    pushStyle();
    noStroke();
    color c = is_active() || DRAGGING ? color(255, 255, 99, 150) : color(255, 255, 99);
    fill(c);
    beginShape();

    vertex(handles[0].getRealX(), handles[0].getRealY());
    for (int i=1; i < NO_OF_CTRLS; i = i+3) {
      PVector p1 = handles[i].real_coords();
      PVector p2 = handles[i+1].real_coords();
      PVector p3 = i==NO_OF_CTRLS-2 ? handles[0].real_coords() : handles[i+2].real_coords();
      bezierVertex(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }

    endShape();
    popStyle();
  }

  public void toggle_handles() {
    if (DRAGGING) return;
    SHOW_HANDLES = ! SHOW_HANDLES;
  }

  public void draw_handles() {
    pushStyle();
    strokeWeight(1);
    stroke(255, 0, 0, 150);
    for (int i=-1; i < NO_OF_CTRLS-2; i = i+3) {
      PVector p1 = i==-1 ? handles[NO_OF_CTRLS-1].real_coords() : handles[i].real_coords();
      PVector p2 = handles[i+1].real_coords();
      PVector p3 = handles[i+2].real_coords();
      line(p1.x, p1.y, p2.x, p2.y);
      line(p2.x, p2.y, p3.x, p3.y);
    }
    popStyle();
    for (int i = 0; i < NO_OF_CTRLS; i++) {
      handles[i].render();
    }
  }
}

