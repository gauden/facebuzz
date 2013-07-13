// Cat photograph by Aristote2 on https://commons.wikimedia.org/wiki/File:Daphnis_1.JPG

Handle handle;
Mustache mustache;
PImage img;

// if multitouch events are fired, this is set to true
//boolean useMultiTouch = false;

void setup() {
  size(600, 600);
  mustache = new Mustache();
  img = loadImage("cat.jpg");
}

void draw() {
  background(255);
  image(img, 0.0, 0.0);
  if (mousePressed) {
    mustache.update();
    if (mustache.is_not_active()) mustache.set_origin();
  }
  mustache.render();
}

void mouseReleased() {
  mustache.deselect();
}


// respond to multitouch events
// from http://stuff.adrianpark.com/processingjs/sparks/
// COMMENT THIS OUT TO MAKE APP COMPILE IN PROCESSING IDE
//*/
//void touchMove(TouchEvent touchEvent) {
//  useMultiTouch = true;
//  int x;
//  int y;
//
//  if (touchEvent.touches.length == 1) {
//    x = touchEvent.touches[0].offsetX;
//    y = touchEvent.touches[0].offsetY;
//    mustache.update(x,y);
//    if (mustache.is_not_active()) mustache.set_origin(x,y);
//  } 
//  else {
//    for (int i = 0; i < touchEvent.touches.length; i++) {
//      x = touchEvent.touches[i].offsetX;
//      y = touchEvent.touches[i].offsetY;
//
//      ellipse(x, y, 60, 60);
//    }
//  }
//}
//*/

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

class Mustache {
  int NO_OF_CTRLS = 15; // must be a multiple of 3
  int CURRENT = -1;
  Handle[] handles = new Handle[NO_OF_CTRLS];
  PVector ORIGIN;
  float SCALE;
  boolean DRAGGING = false;
  boolean SHOW_HANDLES = true;
  boolean SEE_THRU = true;


  Mustache() {
    float x, y;
    float spacing = TWO_PI / NO_OF_CTRLS;
    SCALE = width / 4;
    ORIGIN = new PVector(width/2, height/2);
    for (int i = 0; i < NO_OF_CTRLS; i++) {
      x = cos(spacing * i);
      y = sin(spacing * i);
      handles[i] = new Handle(x, y, i, ORIGIN, SCALE);
    }
  }

  public void update() {
    // if any of the handles reports being grabbed,
    // update its coordinates
    // but not if the whole shape is being dragged
    // or if handles are hidden
    if (DRAGGING || ! SHOW_HANDLES) return; 
    if (CURRENT == -1) {
      // check if a handle is being grabbed
      for (int i = 0; i < NO_OF_CTRLS; i++) {
        if (handles[i].check_grabbed()) {
          CURRENT = i;
          handles[CURRENT].update();
          break;
        }
      }
    } 
    else {
      // a handle is selected
      handles[CURRENT].update();
    }
  }

  public void set_origin() {
    float dx = mouseX - pmouseX;
    float dy = mouseY - pmouseY;
//    println(dx + " " + dy);
    DRAGGING = true;
    ORIGIN.x = ORIGIN.x + dx;
    ORIGIN.y = ORIGIN.y + dy;
    for (int i = 0; i < NO_OF_CTRLS; i++) {
      handles[i].set_origin(ORIGIN);
    }
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
    if (SHOW_HANDLES & ! DRAGGING) draw_handles();
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
    stroke(255,0,0,150);
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


