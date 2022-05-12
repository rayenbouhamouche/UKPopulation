PImage ukAdminMap;
Table data;
PShape map;
float XMoving = PI/4;
float YMoving = PI/4;
float x = 0;
float y = 0;
float speed = 0.01;
int state;
float zoom = 2.5;
boolean zooming = false;

void textDisplay(){
  text("* press 1 to get the Population of 1991",-1200,850,15);
  text("* press 2 to get the Population of 2001",-1200,900,15);
  text("* press 3 to get the Population of2011",-1200,950,15);
  text("* arrow keys is set to move image",-1200,1000,15);
  text("* to zoom in or zoom out you need to scroll up or down",-1200,1050,15);
  text("* Holding the mouse will rotate the image",-1200,1100,15);
}

void setup(){
  //P3D is a parameter that provide a 3D graphics 
 size (2500,1200, P3D);
 smooth();
 // uploading the image
  ukAdminMap = loadImage("uk-admin.jpg");
  //Reading the content of the file and creates a String array
  data = loadTable("data.csv", "header");
  rectMode(CENTER);
  map= createShape(RECT, 0,0,2600,2800);
  map.setTexture(ukAdminMap);
  
}



void draw(){
  
  background(168,205,234);
  rotateX(XMoving) ; rotateY(YMoving);
  fill(250,250,300);
  lights();
  noStroke();
  textSize(35);
  fill(0,0,0);
  textDisplay();
  shape(map);
  //showing the object to the location in 3D
  translate(-1225,-1400);
  
  //for-loop to access the excel data
  for (TableRow row : data.rows()){
    int no = row.getInt("No");
    String city = row.getString("City");

    String xOf1991 = row.getString("1991");
    String yOf1991 = xOf1991.replace(",","").replace("...","0");
    int remove1991 = Integer.parseInt(yOf1991);

    String xOf2001 = row.getString("2001");
    String yOf2001 = xOf2001.replace(",","").replace("...","0");
    int remove2001 = Integer.parseInt(yOf2001);

    String xOf2011 = row.getString("2011");
    String yOf2011 = xOf2011.replace(",","").replace("...","0");
    int remove2011 = Integer.parseInt(yOf2011);

    int xPos = row.getInt("xPos");
    int yPos = row.getInt("yPos");
    
    int devisionOfRemove1991 = remove1991/1000;
    int devisionOfRemove2001 = remove2001/1000;
    int devisionOfRemove2011 = remove2011/1000;
    
    //test data 
    println (no, city, xOf1991, xOf2001, xOf2011, xPos, yPos);
    
    if(state == 0){
      graphBar(devisionOfRemove1991,15, xPos, yPos, city);
    }else if(state == 1){
      graphBar(devisionOfRemove2001,15,xPos,yPos,city);
    }else if(state == 2){
      graphBar(devisionOfRemove2011,15,xPos,yPos,city);
    }
  }
  //Setting Camera position in 3D environments by changing the ey position 
  camera(x, y, (height*1)/tan(PI/4.5)*zoom, x, y,0,0,1,0);
}

//create bar graph inside the image 
void graphBar(int Height, float Width, float x, float y, String city) {
  float ukPopulation = map(Height,0,1,0,1);
  fill(10,60,60,ukPopulation);
  
  pushMatrix();
  float boxLong = Height;
  translate(x,y,boxLong/2);
  box(Width,Width,boxLong);
  popMatrix();
  fill(50);
  text(city, x+Width, y+(Width/2),5);
}

// speed movement
void move() {
  y = y - speed;
  if(y <0) {
    y = height;
  }
}

//speed of Mouse usage
void mouseDragged(){
  XMoving += (pmouseY-mouseY) * speed;
  YMoving += (pmouseX-mouseX) * speed;
}

//Keyboard Movement (up - down - left - right)
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      x-=70;
    } else if (keyCode == RIGHT) {
      x+=70;
    } else if(keyCode == UP) {
      y-=70;
    }else if (keyCode == DOWN) { 
      y+=70;
    }
  }
  if(keyPressed){
    if(key == '1'){
      state = 0;
      return;
    }
    else if(key == '2'){
      state = 1;
      return;
    }
    else if(key == '3'){
      state = 2;
      return;
    }
  }
}

//Mouse wheel represent the zoom in or zoom out in this function

void mouseWheel(MouseEvent event){
  float Event = event.getCount();
  zoom += Event;
}
void zoomIn(){
  zoom -= 5;
}
void zoomOut(){
  zoom += 5;
}

//Double Clicking on the mouse it will flip the page 
void mouseClicked(MouseEvent event){
  if (event.getCount() == 2 && zooming == false){
    zoomIn();
    zooming = true;
  }
  else if (event.getCount() == 2 && zooming == true){
    zoomOut();
    zooming = false;
  }
}
