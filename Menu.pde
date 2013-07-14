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

