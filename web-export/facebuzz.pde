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
    fileName = year() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + millis() + ".png";
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


int HORIZONTAL = 0;
int VERTICAL   = 1;
int UPWARDS    = 2;
int DOWNWARDS  = 3;

class Widget
{

  
  PVector pos;
  PVector extents;
  String name;

  color inactiveColor = color(60, 60, 100);
  color activeColor = color(100, 100, 160);
  color bgColor = inactiveColor;
  color lineColor = color(255);
  
  
  
  void setInactiveColor(color c)
  {
    inactiveColor = c;
    bgColor = inactiveColor;
  }
  
  color getInactiveColor()
  {
    return inactiveColor;
  }
  
  void setActiveColor(color c)
  {
    activeColor = c;
  }
  
  color getActiveColor()
  {
    return activeColor;
  }
  
  void setLineColor(color c)
  {
    lineColor = c;
  }
  
  color getLineColor()
  {
    return lineColor;
  }
  
  String getName()
  {
    return name;
  }
  
  void setName(String nm)
  {
    name = nm;
  }


  Widget(String t, int x, int y, int w, int h)
  {
    pos = new PVector(x, y);
    extents = new PVector (w, h);
    name = t;
    //registerMethod("mouseEvent", this);
  }

  void display()
  {
  }

  boolean isClicked()
  {
    if (mouseX > pos.x && mouseX < pos.x+extents.x 
      && mouseY > pos.y && mouseY < pos.y+extents.y)
    {
      //println(mouseX + " " + mouseY);
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public void mouseEvent(MouseEvent event)
  {
    //if (event.getFlavor() == MouseEvent.PRESS)
    //{
    //  mousePressed();
    //}
  }
  
  
  boolean mousePressed()
  {
    return isClicked();
  }
  
  boolean mouseDragged()
  {
    return isClicked();
  }
  
  
  boolean mouseReleased()
  {
    return isClicked();
  }
}

class Button extends Widget
{
  PImage activeImage = null;
  PImage inactiveImage = null;
  PImage currentImage = null;
  color imageTint = color(255);
  
  Button(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }
  
  void setImage(PImage img)
  {
    setInactiveImage(img);
    setActiveImage(img);
  }
  
  void setInactiveImage(PImage img)
  {
    if(currentImage == inactiveImage || currentImage == null)
    {
      inactiveImage = img;
      currentImage = inactiveImage;
    }
    else
    {
      inactiveImage = img;
    }
  }
  
  void setActiveImage(PImage img)
  {
    if(currentImage == activeImage || currentImage == null)
    {
      activeImage = img;
      currentImage = activeImage;
    }
    else
    {
      activeImage = img;
    }
  }
  
  void setImageTint(color c)
  {
    imageTint = c;
  }

  void display()
  {
    if(currentImage != null)
    {
      //float imgHeight = (extents.x*currentImage.height)/currentImage.width;
      float imgWidth = (extents.y*currentImage.width)/currentImage.height;
      
      
      pushStyle();
      imageMode(CORNER);
      //tint(imageTint);
      image(currentImage, pos.x, pos.y, imgWidth, extents.y);
      stroke(bgColor);
      noFill();
      rect(pos.x, pos.y, imgWidth,  extents.y);
      //noTint();
      popStyle();
    }
    else
    {
      pushStyle();
      stroke(lineColor);
      fill(bgColor);
      rect(pos.x, pos.y, extents.x, extents.y);
  
      fill(lineColor);
      textAlign(CENTER, CENTER);
      text(name, pos.x + 0.5*extents.x, pos.y + 0.5* extents.y);
      popStyle();
    }
  }
  
  boolean mousePressed()
  {
    if (super.mousePressed())
    {
      bgColor = activeColor;
      if(activeImage != null)
        currentImage = activeImage;
      return true;
    }
    return false;
  }
  
  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      bgColor = inactiveColor;
      if(inactiveImage != null)
        currentImage = inactiveImage;
      return true;
    }
    return false;
  }
}

class Toggle extends Button
{
  boolean on = false;

  Toggle(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }


  boolean get()
  {
    return on;
  }

  void set(boolean val)
  {
    on = val;
    if (on)
    {
      bgColor = activeColor;
      if(activeImage != null)
        currentImage = activeImage;
    }
    else
    {
      bgColor = inactiveColor;
      if(inactiveImage != null)
        currentImage = inactiveImage;
    }
  }

  void toggle()
  {
    set(!on);
  }

  
  boolean mousePressed()
  {
    return super.isClicked();
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      toggle();
      return true;
    }
    return false;
  }
}

class RadioButtons extends Widget
{
  public Toggle [] buttons;
  
  RadioButtons (int numButtons, int x, int y, int w, int h, int orientation)
  {
    super("", x, y, w*numButtons, h);
    buttons = new Toggle[numButtons];
    for (int i = 0; i < buttons.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x+i*(w+5);
        by = y;
      }
      else
      {
        bx = x;
        by = y+i*(h+5);
      }
      buttons[i] = new Toggle("", bx, by, w, h);
    }
  }
  
  void setNames(String [] names)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(i >= names.length)
        break;
      buttons[i].setName(names[i]);
    }
  }
  
  void setImage(int i, PImage img)
  {
    setInactiveImage(i, img);
    setActiveImage(i, img);
  }
  
  void setAllImages(PImage img)
  {
    setAllInactiveImages(img);
    setAllActiveImages(img);
  }
  
  void setInactiveImage(int i, PImage img)
  {
    buttons[i].setInactiveImage(img);
  }

  
  void setAllInactiveImages(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(img);
    }
  }
  
  void setActiveImage(int i, PImage img)
  {
    buttons[i].setActiveImage(img);
  }
  
  
  
  void setAllActiveImages(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(img);
    }
  }

  void set(String buttonName)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].getName().equals(buttonName))
      {
        buttons[i].set(true);
      }
      else
      {
        buttons[i].set(false);
      }
    }
  }
  
  int get()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].get())
      {
        return i;
      }
    }
    return -1;
  }
  
  String getString()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].get())
      {
        return buttons[i].getName();
      }
    }
    return "";
  }

  void display()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].display();
    }
  }

  boolean mousePressed()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mousePressed())
      {
        return true;
      }
    }
    return false;
  }
  
  boolean mouseDragged()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseReleased())
      {
        for(int j = 0; j < buttons.length; j++)
        {
          if(i != j)
            buttons[j].set(false);
        }
        //buttons[i].set(true);
        return true;
      }
    }
    return false;
  }
}

class Slider extends Widget
{
  float minimum;
  float maximum;
  float val;
  int textWidth = 60;
  int orientation = HORIZONTAL;

  Slider(String nm, float v, float min, float max, int x, int y, int w, int h, int ori)
  {
    super(nm, x, y, w, h);
    val = v;
    minimum = min;
    maximum = max;
    orientation = ori;
    if(orientation == HORIZONTAL)
      textWidth = 60;
    else
      textWidth = 20;
  }

  float get()
  {
    return val;
  }

  void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  void display()
  {
    pushStyle();
    textAlign(LEFT, TOP);
    fill(lineColor);
    text(name, pos.x, pos.y);
    stroke(lineColor);
    noFill();
    if(orientation ==  HORIZONTAL){
      rect(pos.x+textWidth, pos.y, extents.x-textWidth, extents.y);
    } else {
      rect(pos.x, pos.y+textWidth, extents.x, extents.y-textWidth);
    }
    noStroke();
    fill(bgColor);
    float sliderPos; 
    if(orientation ==  HORIZONTAL){
        sliderPos = map(val, minimum, maximum, 0, extents.x-textWidth-4); 
        rect(pos.x+textWidth+2, pos.y+2, sliderPos, extents.y-4);
    } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2, extents.x-4, sliderPos);
    } else if(orientation == UPWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2 + (extents.y-textWidth-4-sliderPos), extents.x-4, sliderPos);
    };
    popStyle();
  }

  
  boolean mouseDragged()
  {
    if (super.mouseDragged())
    {
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textWidth, pos.x+extents.x-4, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-4, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-4, maximum, minimum));
      };
      return true;
    }
    return false;
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textWidth, pos.x+extents.x-10, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, maximum, minimum));
      };
      return true;
    }
    return false;
  }
}

class MultiSlider extends Widget
{
  Slider [] sliders;

  MultiSlider(String [] nm, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super(nm[0], x, y, w, h*nm.length);
    sliders = new Slider[nm.length];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider(nm[i], 0, min, max, bx, by, w, h, orientation);
    }
  }

  void set(int i, float v)
  {
    if(i >= 0 && i < sliders.length)
    {
      sliders[i].set(v);
    }
  }
  
  float get(int i)
  {
    if(i >= 0 && i < sliders.length)
    {
      return sliders[i].get();
    }
    else
    {
      return -1;
    }
    
  }

  void display()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      sliders[i].display();
    }
  }

  
  boolean mouseDragged()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseReleased())
      {
        return true;
      }
    }
    return false;
  }
}

class Handle {
  PVector pos;
  boolean GRABBED;
  int rad = 8;
  int INDEX;
  PVector ORIGIN;
  float SCALE;
  Mustache PARENT;

  Handle(float x, float y, int index, PVector o, float s, Mustache parent) {
    ORIGIN = o;
    SCALE = s;
    pos = new PVector(x, y);
    INDEX = index;
    GRABBED = false;
    PARENT = parent;
  }

  public void update(float x, float y) {
    pos = new PVector(getNormalX(x), getNormalY(y));
  }

  public boolean check_grabbed(float x, float y) {
    float diffX = abs(x - getRealX());
    float diffY = abs(y - getRealY());
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
    stroke(255);
    color c = INDEX % 3 == 0 ? color(255,0,0) : color(0,0,255);
    fill(c);
    ellipse(pos.x * SCALE, pos.y * SCALE, rad*2, rad*2);
    popMatrix();
    popStyle();
  }
}

class Menu {
  ArrayList<Button> BUTTONS; 
  int BTN_HEIGHT = 36;
  int BTN_WIDTH = 36;
  int MENU_HEIGHT = 60;
  int BTN_SPACING = 5; 
  int x, y, w, h;

  Menu() {
    BUTTONS = new ArrayList<Button>();
    x = BTN_SPACING;
    y = height - MENU_HEIGHT + (MENU_HEIGHT - BTN_HEIGHT)/2;
    w = 36;
    h = 36;
    
    addButton("stroke", "./data/icon_stroke.png");
    addButton("fill", "./data/icon_fill.png");
    addButton("transparent", "./data/icon_swatch_transparent.png");
    addButton("red", "./data/icon_swatch_red.png");
    addButton("green", "./data/icon_swatch_green.png");
    addButton("yellow", "./data/icon_swatch_yellow.png");
    addButton("blue", "./data/icon_swatch_blue.png");
    addButton("white", "./data/icon_swatch_white.png");
    addButton("kontrast", "./data/icon_swatch_black.png");
    x = width - BTN_WIDTH - BTN_SPACING;
    addButton("discsave", "./data/icon_discsave.png");
  }
  
  public String checkButtons() {
    String result = "";
    for (int i = 0; i < BUTTONS.size(); i++) {
      Button btn = (Button)BUTTONS.get(i);
      if (btn.mouseReleased()) {
        result = btn.name;
        break;
      }
    }
    return result;
  }

  public void addButton(String name, String imgpath) {
    Button btn = new Button(name, x, y, w, h);
    PImage img = loadImage(imgpath);
    btn.setImage(img);
    BUTTONS.add(btn);
    x = x + BTN_SPACING + BTN_WIDTH;
  }

  public void render() {
    // Show Menu
    // draw a transparent rectangle behind the UI to make it
    // more visible
    pushStyle();
    fill(0, 128);
    noStroke();
    rect(0, height - 60, width, 60);

    // draw all the UI elements
    for (int i = 0; i < BUTTONS.size(); i++) {
      Button btn = (Button)BUTTONS.get(i);
      btn.display();
    }
    popStyle();
  }
}

class Mustache {
  int NO_OF_CTRLS = 15; // must be a multiple of 3
  int CURRENT = -1;
  Handle[] handles = new Handle[NO_OF_CTRLS];
  PVector ORIGIN;
  float SCALE;
  Menu MENU;
  boolean DRAGGING = false;
  boolean SAVING_IMAGE = false;
  boolean SHOW_HANDLES = true;
  boolean SEE_THRU = true;
  boolean CLICK_HANDLED = false;
  boolean DISPLAY_GUI = true;
  
  color BLACK = color(0,0,0);  
  color WHITE = color(255,255,255);  
  color RED = color(204,0,0);  
  color GREEN = color(0, 128,0);  
  color BLUE = color(0, 0, 255);  
  color YELLOW = color(255, 255, 0);
  
  boolean FILL = true;
  boolean TRANSPARENCY = true;
  color CLR = YELLOW;


  Mustache(Menu _menu) {
    MENU = _menu;
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
    if (mouseY > height - MENU.MENU_HEIGHT) return; // keep menu visible
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
  
  public void do_command(String choice) {
    char c = (char) choice.charAt(0);
    switch (c) {
      case 'f':
//        println("Turn fill on");
        FILL = true;
        break;
      case 's':
//        println("Turn stroke on");
        FILL = false;
        break;
      case 't':
//        println("Turn transparency on");
        TRANSPARENCY = !TRANSPARENCY;
        break;
      case 'r':
//        println("Red");
        CLR = RED;
        break;
      case 'g':
//        println("Green");
        CLR = GREEN;
        break;
      case 'b':
//        println("Blue");
        CLR = BLUE;
        break;
      case 'y':
//        println("Yellow");
        CLR = YELLOW;
        break;
      case 'w':
//        println("White");
        CLR = WHITE;
        break;
      case 'k':
//        println("Black");
        CLR = BLACK;
        break;
      case 'd':
        println("Save to disc");
        SAVING_IMAGE = true;
        break;
      default:
        FILL = true;
        CLR = YELLOW;
    }
  }


  public void render() {
    draw_line();
    if (SHOW_HANDLES & ! DRAGGING & !DISPLAY_GUI) draw_handles();
  }

  public void draw_line() {
    pushStyle();
    if (FILL) {
      noStroke();
      fill(CLR);
    } else {
      strokeWeight(10);
      noFill();
      stroke(CLR);
    }
    boolean state = is_active() || DRAGGING;
    set_transparency(state);
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
    stroke(255);
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
  
  public void set_transparency(boolean active_or_dragging) {
    float r = red(CLR);
    float g = green(CLR);
    float b = blue(CLR);
    float a = TRANSPARENCY ? 128 : 255;
    if (active_or_dragging) a = 128;
    CLR = color(r,g,b,a);
  }
}


