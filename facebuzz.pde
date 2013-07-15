/** 
 **   F A C E B U Z Z: 
 **   A toy for decorating bitmaps with vector blobs
 **
 **   FaceBuzz by Gauden Galea, 2013
 **   GUI Classes by Mick Grierson, Matthew Yee-King, Marco Gillies
 **    
 **   Software is licensed under the MIT license, see LICENSE
 **   Dog image by Tiago (CC BY 2.0) http://flic.kr/p/ejmQsA
 **/

Handle handle;
Mustache mustache;
Menu MENU;
PImage img;
boolean DRAGGED = false;
boolean JUST_SAVED_IMG = false;
String INPUT_IMAGE = "dog.png";
String fileName = "";
boolean JAVASCRIPT_MODE = false;

// uncomment for debugging
String txtOutput;
//int clickMillis = 0;

void setup() {
  size(640, 480);
  MENU = new Menu();
  mustache = new Mustache(MENU);
  img = loadImage(INPUT_IMAGE);
  smooth();
  
  // Hack to detect if this is running in Java or Javascript mode
  // Java will download the same image twice for t1 and t2
  // JavaScript has no access to data folder, so t2 is empty
  // Note: There is probably a neater way of doing this.
  /* @pjs preload="icon_fill.png"; */
  PImage t1 = loadImage("icon_fill.png");
  PImage t2 = loadImage("./data/icon_fill.png");
  JAVASCRIPT_MODE = t1.pixels.length != t2.pixels.length;

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
    if (!menu_choice.equals("")) {
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

