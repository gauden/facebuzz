// Cat photograph by Aristote2 on https://commons.wikimedia.org/wiki/File:Daphnis_1.JPG

Handle handle;
Mustache mustache;
PImage img;
boolean DRAGGED = false;

// for debugging
String txtOutput;
int clickMillis = 0;

void setup() {
  size(600, 600);
  mustache = new Mustache();
  img = loadImage("cat.jpg");
  smooth();

  // for debugging
  fill(color(255, 255, 255));
  PFont sans = loadFont("SansSerif-14.vlw");
  textFont(sans, 14);
  txtOutput = "";
}

void draw() {
  background(255);
  image(img, 0.0, 0.0);
  if (mousePressed) {
    mustache.update(mouseX, mouseY);
    if (mustache.is_not_active()) mustache.set_origin(mouseX, mouseY, pmouseX, pmouseY);
  }
  mustache.render();

  // for debugging
  fill(color(255, 255, 255, 255));
  txtOutput = mustache.DISPLAY_GUI ? "SHOWING menu" : "HIDING menu";
  txtOutput += "\n" + DRAGGED;
  text(txtOutput, 30, 30);
}

void mouseReleased() {
  mustache.deselect();
  if (mustache.CLICK_HANDLED) {
    mustache.CLICK_HANDLED = false;
  }
  else {
    if (!DRAGGED) mustache.toggle_menu();
  }
  DRAGGED = false;
}

void mouseDragged() {
  DRAGGED = true;
}



