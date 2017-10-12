import controlP5.*; //<>// //<>//

PImage current_screen, im_screen_home, im_screen0_0, im_screen0_1, im_screen1, im_screen2;
PFont f;
ControlP5 cp5;

static int tab_height = 70, tab_width = 120; 

// There are 3 tabs
int color_tb_pres = color(200, 200, 255);
int color_tb_fore = color(200, 255, 200); 
int color_tb_back = color(255, 200, 200);

int gr_x = 0, gr_y = 520;
int tp_x = 120, tp_y = 520;
int sg_x = 240, sg_y = 520;

// 0: Grocery, 1: Temperature, 2: Suggestions
int tab_selected = 0;

// Button images
PImage[] btn_dec_imgs = {null, null, null};
PImage[] btn_inc_imgs = {null, null, null};
PImage[] btn_grocery_imgs = {null, null, null};
PImage[] btn_temp_imgs = {null, null, null};
PImage[] btn_sugg_imgs = {null, null, null};
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Grocery                                                                                              //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Group groceryGroup;
// There are 2 options for grocery, 2 possible status
// true: Weight,  false: Date
boolean grocery_sort = true;
int tg_x = 124, tg_y = 158, tg_width = 54, tg_height = 16;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Temperature                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Group temperatureGroup;
// A temperature controller has 2 buttons and 1 display
// There are a main controller and 3 smaller ones
final int BTN_TMP_MAIN_SIZE = 32, BTN_TMP_SMALL_SIZE = 32;
String temp_buttons[] = {
  "DecreaseMain", "IncreaseMain", 
  "DecreaseSec1", "IncreaseSec1", 
  "DecreaseSec2", "IncreaseSec2", 
  "DecreaseSec3", "IncreaseSec3",
  "DecreaseSec4", "IncreaseSec4"
};
float temp_buttons_pos[][] = {
  {206, 126}, {307, 126}, 
  {206, 206}, {307, 206}, 
  {206, 286}, {307, 286}, 
  {206, 366}, {307, 366},
  {206, 446}, {307, 446},
};
int temp_buttons_size[] = {
  BTN_TMP_MAIN_SIZE, BTN_TMP_MAIN_SIZE, 
  BTN_TMP_SMALL_SIZE, BTN_TMP_SMALL_SIZE, 
  BTN_TMP_SMALL_SIZE, BTN_TMP_SMALL_SIZE, 
  BTN_TMP_SMALL_SIZE, BTN_TMP_SMALL_SIZE,
  BTN_TMP_SMALL_SIZE, BTN_TMP_SMALL_SIZE
};

final int LBL_TMP_MAIN_SIZE = 32, LBL_TMP_SMALL_SIZE = 32;
String temp_labels[] = {
  "TempMain", "TempSec1", "TempSec2", "TempSec3", "TempSec4"
};
float temp_labels_pos[][] = {
  {263, 126}, 
  {263, 206}, 
  {263, 286}, 
  {263, 366},
  {263, 446}
};
int temp_labels_size[] = {
  LBL_TMP_MAIN_SIZE, 
  LBL_TMP_SMALL_SIZE, 
  LBL_TMP_SMALL_SIZE, 
  LBL_TMP_SMALL_SIZE,
  LBL_TMP_SMALL_SIZE
};
Textlabel labels[] = {null, null, null, null, null};
int temp_values[] = {0, 2, 1, -1, 1};
ControlFont temp_font;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Suggestions                                                                                          //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
String sugg_labels[] = {"Meal1", "Meal2", "Meal3"};
String sugg_titles[] = {"Meal 1+", "Meal 2+", "Meal 3+"};
Accordion suggestionsGroup;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Home                                                                                                 //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(360, 640);
  noStroke();
  cp5 = new ControlP5(this);
  
  PFont pfont = createFont("Arial", 20, true);
  temp_font = new ControlFont(pfont, 25);
  
  for(int i = 0; i < 3; i++) {
    btn_dec_imgs[i] = loadImage("btn_dec"+String.valueOf(i)+".png");
    btn_inc_imgs[i] = loadImage("btn_inc"+String.valueOf(i)+".png");
    btn_grocery_imgs[i] = loadImage("btn_grocery"+String.valueOf(i)+".png");
    btn_temp_imgs[i] = loadImage("btn_temp"+String.valueOf(i)+".png");
    btn_sugg_imgs[i] = loadImage("btn_sugg"+String.valueOf(i)+".png");
  }
  
  setTabs();
  
  im_screen_home = loadImage("Home.png");
  im_screen0_0 = loadImage("Grocery0.png");
  im_screen0_1 = loadImage("Grocery1.png");
  im_screen1 = loadImage("Temperature.png");
  im_screen2 = loadImage("Suggestions.png");

  displayHome();
}

void draw() {
  background(current_screen);
}

public void setTabs() {

  cp5.addButton("Grocery")
    .setValue(0)
    .setPosition(gr_x, gr_y)
    .setSize(tab_width, tab_height)
    .setImages(btn_grocery_imgs)
    ;

  cp5.addButton("Temperature")
    .setValue(1)
    .setPosition(tp_x, tp_y)
    .setSize(tab_width, tab_height)
    .setImages(btn_temp_imgs)
    ;

  cp5.addButton("Suggestions")
    .setValue(2)
    .setPosition(sg_x, sg_y)
    .setSize(tab_width, tab_height)
    .setImages(btn_sugg_imgs)
    ;

  // This button is added to avoid the suggestions elements to be displayed at start
  cp5.addButton("Home")
    .setValue(0)
    .setPosition(0, 0)
    .setSize(0, 0)
    .setLabel("");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Grocery                                                                                              //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
public void displayGrocery() {
  groceryGroup = new Group(cp5, "GroceryGroup");

  // Controllers
  Toggle tgSort = new Toggle(cp5, "GrocerySort");
  tgSort
    .setPosition(tg_x, tg_y)
    .setSize(tg_width, tg_height)
    .setValue(grocery_sort)
    .setMode(ControlP5.SWITCH)
    .setGroup(groceryGroup)
    ;
  groceryGroup.addDrawable(tgSort);
}

void GrocerySort(boolean value) {
  grocery_sort = value;
  if (grocery_sort) {
    current_screen = im_screen0_0;
  } else {
    current_screen = im_screen0_1;
  }
  println("toggle grocery: " + String.valueOf(value));
}

public void Grocery(int value) {
  if (tab_selected == value) {
    return;
  }

  clearBody();

  tab_selected = value;

  if (grocery_sort) {
    current_screen = im_screen0_0;
  } else {
    current_screen = im_screen0_1;
  }

  displayGrocery();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Temperature                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
public void displayTemperature() {
  temperatureGroup = new Group(cp5, "TemperatureGroup");

  // Controllers
  for (int i = 0; i < temp_labels.length; i++) {
    Textlabel current = new Textlabel(cp5, temp_labels[i], 0, 0);
    current
      .setText(String.valueOf(temp_values[i]))
      .setPosition(temp_labels_pos[i])
      ;
    current.setFont(temp_font);
    current.setColorValue(0x00000000);
    temperatureGroup.addDrawable(current);
    labels[i] = current;

    Button currentDec = new Button(cp5, temp_buttons[i*2]);
    currentDec
      .setPosition(temp_buttons_pos[i*2])
      .setSize(temp_buttons_size[i*2], temp_buttons_size[i*2])
      .setGroup(temperatureGroup)
      .setImages(btn_dec_imgs)
      .addListener(new TemperatureControlListener(i, temp_values, labels, false));
    temperatureGroup.addDrawable(currentDec);
   
    Button currentInc = new Button(cp5, temp_buttons[i*2+1]);
    currentInc
      .setPosition(temp_buttons_pos[i*2+1])
      .setSize(temp_buttons_size[i*2+1], temp_buttons_size[i*2+1])
      .setGroup(temperatureGroup)
      .setImages(btn_inc_imgs)
      .addListener(new TemperatureControlListener(i, temp_values, labels, true));
    temperatureGroup.addDrawable(currentInc);    
  }
}

class TemperatureControlListener implements ControlListener {
  int mindex;
  int[] mvalues;
  Textlabel mlabels[];
  boolean mincrease;
  final int TEMP_OFFSET = 2;
  public TemperatureControlListener(int index, int[] values, Textlabel[] labels, boolean increase) {
    mindex = index;
    mvalues = values;
    mlabels = labels;
    mincrease = increase;
  }

  public void controlEvent(ControlEvent theEvent) {     
    if (mindex == 0) { // increase or decrease all temperatures
      for (int i = 0; i < mlabels.length; i++) {
        if (mincrease) {
          mvalues[i]++;
        } else {
          mvalues[i]--;
        }
      }
    } else {
      if (mincrease && mvalues[mindex] < mvalues[0] + TEMP_OFFSET) {
        mvalues[mindex]++;
      } else if (!mincrease && mvalues[mindex] > mvalues[0] - TEMP_OFFSET) {
        mvalues[mindex]--;
      }
    }

    for (int i = 0; i < mlabels.length; i++) {
      mlabels[i].setText(String.valueOf(mvalues[i]));
    }
  }
}
public void Temperature(int value) {
  if (tab_selected == value) {
    return;
  }

  clearBody();

  tab_selected = value;
  current_screen = im_screen1;

  displayTemperature();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Suggestions                                                                                          //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
public void displaySuggestions() {
  suggestionsGroup = new Accordion(cp5, "SuggestionsGroup")
    .setPosition(50, 70)
    .setMinItemHeight(100)
    .setWidth(300)
    ;

  for (int i = 0; i < sugg_labels.length; i++) {
    Group meal = new Group(cp5, sugg_labels[i]);
    meal.setBarHeight(90)
        .setBackgroundColor(color_tb_pres)
        .setLabel(sugg_titles[i]);
    Button current = new Button(cp5, sugg_labels[i]);
    PImage im = loadImage(sugg_labels[i] + ".png");
    current.setPosition(0, 0)
      .setImages(im, im, im)
      .setGroup(meal)
      ;
    meal.addDrawable(current);
    suggestionsGroup.addItem(meal);
  }
}
public void Suggestions(int value) {
  if (tab_selected == value) {
    return;
  }

  clearBody();

  tab_selected = value;
  current_screen = im_screen2;

  displaySuggestions();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Home                                                                                                 //  
//////////////////////////////////////////////////////////////////////////////////////////////////////////
public void displayHome() {
  Home(-1);
}
public void Home(int value) {
  clearBody();
  current_screen = im_screen_home;
  tab_selected = value;
}

public void clearBody() {
  cp5.remove("GroceryGroup");
  cp5.remove("TemperatureGroup");
  cp5.remove("SuggestionsGroup");
}