// Original Dog image by Tiago (CC BY 2.0) http://flic.kr/p/ejmQsA

Handle handle;
Mustache mustache;
Menu MENU;
PImage img;
boolean DRAGGED = false;
boolean JUST_SAVED_IMG = false;
String fileName;

// uncomment for debugging
String txtOutput;
//int clickMillis = 0;

void setup() {
  size(640, 480);
  MENU = new Menu();
  mustache = new Mustache(MENU);
  img = loadImage("dog.png");
  smooth();

  // uncomment for debugging
  fill(color(255, 255, 255));
  PFont sans = loadFont("SansSerif-14.vlw");
  textFont(sans, 14);
  //  txtOutput = "";
}

void draw() {
  if (mustache.SAVING_IMAGE & !JUST_SAVED_IMG) {
    // hide menu and handles
    // by re-rendering the image tne "mustache"
    background(255);
    image(img, 0.0, 0.0);
    mustache.render();

    // save to disc
    fileName = year() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + millis() + ".jpeg";
    save("./data/" + fileName);
    JUST_SAVED_IMG = true;
    mustache.SAVING_IMAGE = true;
    mustache.DISPLAY_GUI = false;
    // print message
    render_saved();
    // wait for user to click then clear message and resume
  } 
  else {
    background(255);
    image(img, 0.0, 0.0);
    if (mousePressed) {
      mustache.update(mouseX, mouseY);
      if (mustache.is_not_active()) mustache.set_origin(mouseX, mouseY, pmouseX, pmouseY);
    }
    mustache.render();
    if (mustache.DISPLAY_GUI) MENU.render();
  }
  
  if (JUST_SAVED_IMG) render_saved();
  

  // uncomment for debugging
  //  fill(color(255, 255, 255, 255));
  //  txtOutput = mustache.DISPLAY_GUI ? "SHOWING menu" : "HIDING menu";
  //  txtOutput += "\nDragging: " + DRAGGED;
  //  text(txtOutput, 30, 30);
}

void mouseReleased() {
  if (JUST_SAVED_IMG) JUST_SAVED_IMG=false;
  
  if (mustache.SAVING_IMAGE) {
    mustache.DISPLAY_GUI = false;
    mustache.SAVING_IMAGE = false;
  }
  if (mustache.DISPLAY_GUI) {
    String menu_choice = MENU.checkButtons();
    if (menu_choice != "") {
      mustache.do_command(menu_choice);
    }
  }

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


void render_saved() {
  // display message that image is saved
  pushStyle();
  fill(0, 128);
  noStroke();
  rect(0, height - 60, width, 60);


  fill(color(255, 255, 255, 255));
  txtOutput = "Image saved as " + fileName;
  text(txtOutput, 30, height-20);
  popStyle();
}

