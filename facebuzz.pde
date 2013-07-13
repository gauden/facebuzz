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
    mustache.update(mouseX, mouseY);
    if (mustache.is_not_active()) mustache.set_origin(mouseX, mouseY);
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

