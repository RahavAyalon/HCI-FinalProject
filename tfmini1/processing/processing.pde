import controlP5.*; //import ControlP5 library
import processing.serial.*;

Serial port;

ControlP5 cp5; //create ControlP5 object
PFont font;
PImage image;
Textfield angleTextfield, heightTextfield, emergencyDialSettingsTextfield, notificationTypeTextfield, metricsTextfield;
Button angleButton, angleEnterButton, heightButton, heightEnterButton, emergencyDialSettingsButton, notificationTypeButton, 
metricsButton, emergencyDialSettingsEnterButton, notificationTypeEnterButton, metricsEnterButton;
String str = null;
float myVal;
int sonto;

boolean firstContact = false;        // Whether we've heard from the microcontroller


void setup(){ //same as arduino program
  println("windowWidth: " + displayWidth);
  println("windowHeight: " + displayHeight);
  size(1920, 1080);    //window size, (width, height)
  surface.setLocation(0,0);
  printArray(Serial.list());   //prints all available serial ports
  
  port = new Serial(this, "COM7", 115200);  //i have connected arduino to com3, it would be different in linux and mac os
  

  //lets add buton to empty window
  
  cp5 = new ControlP5(this);
  font = createFont("david bold", 40);    // custom fonts for buttons and title
  image = loadImage("C:\\Users\\rahav\\Documents\\sketch_230220a\\data\\lior.jpg"); // Load the image
  

  angleButton = cp5.addButton("angleButton")     
    .setPosition(displayWidth * 5/8, displayHeight * 0.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 14)      //(width, height)
    .setFont(font)
    .setLabel("זווית החיישן")
    .setColorBackground(color(90, 154, 215))
  ;   

  heightButton = cp5.addButton("heightButton")     //"קליברציה אחורית" is the name of button
    .setPosition(displayWidth * 5/8, displayHeight * 2/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 14)      //(width, height)
    .setFont(font)
    .setLabel("גובה החיישן")
    .setColorBackground(color(90, 154, 215))
  ;

  emergencyDialSettingsButton = cp5.addButton("emergencyDialSettingsButton")     //"blue" is the name of button
    .setPosition(displayWidth * 5/8, displayHeight * 3.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 14)      //(width, height)
    .setFont(font)
    .setLabel("הגדרות חיוג חירום")    
    .setColorBackground(color(90, 154, 215))
  ;
  
  notificationTypeButton = cp5.addButton("notificationTypeButton")     //"alloff" is the name of button
    .setPosition(displayWidth * 5/8, displayHeight * 5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 14)      //(width, height)
    .setFont(font)
    .setLabel("סוג התראה")
    .setColorBackground(color(90, 154, 215))
  ;
  
    metricsButton = cp5.addButton("metricsButton")     //"alloff" is the name of button
    .setPosition(displayWidth * 5/8, displayHeight * 6.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 14)      //(width, height)
    .setFont(font)
    .setLabel("קריאת מדדים")    
    .setColorBackground(color(90, 154, 215))
  ;
  
  //port.write("a *");

}

void draw(){  //same as loop in arduino
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  //image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  fill(255, 255, 255);               //text color (r, g, b)
  textFont(font);

  String buffer = "";
  while (port.available() > 0) {
    sonto = port.read();
    buffer += char(sonto);
    
    
    //if (sonto != null) {
    //  background(0);
    //  myVal = float(str);
    //  //println(myVal);
    //}
  }
  if (buffer.length() != 0) {
      println(buffer);
  }
}

void serialEvent(Serial port) {

    // read a byte from the serial port:

    int inByte = port.read();

    // if this is the first byte received, and it's an A, clear the serial
    // buffer and note that you've had first contact from the microcontroller.

    if (firstContact == false) {
 
      if (inByte == 'A') {

        port.clear();          // clear the serial port buffer

        firstContact = true;     // you've had first contact from the microcontroller

        port.write('A');       // ask for more

      }
    }
}


void angleButton(){
  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  
  angleTextfield = cp5.addTextfield("angleTextfield")
    .setPosition(500, 50)
    .setSize(150, 70)
    .setFont(font)
    .setLabel("");
    
  angleEnterButton = cp5.addButton("angleEnterButton")    
    .setPosition(500, 150)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setColorBackground(color(90, 154, 215))
    .setLabel("Enter");
}

void angleEnterButton() {
  angleTextfield.hide();
  angleEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  port.write("a " + angleTextfield.getText() + "*");
}


void heightButton(){
  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  
  heightTextfield = cp5.addTextfield("heightTextfield")
    .setPosition(500, 50)
    .setSize(150, 70)
    .setFont(font)
    .setLabel("");
    
  heightEnterButton = cp5.addButton("heightEnterButton")    
    .setPosition(500, 150)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setColorBackground(color(90, 154, 215))
    .setLabel("Enter");
}


void heightEnterButton() {
  heightTextfield.hide();
  heightEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  
  port.write("h " + heightTextfield.getText() + "*");
}

void emergencyDialSettingsButton () {
  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  
  emergencyDialSettingsTextfield = cp5.addTextfield("emergencyDialSettingsTextfield")
    .setPosition(500, 50)
    .setSize(150, 70)
    .setFont(font)
    .setLabel("");
    
  emergencyDialSettingsEnterButton = cp5.addButton("emergencyDialSettingsEnterButton")    
    .setPosition(500, 150)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setColorBackground(color(90, 154, 215))
    .setLabel("Enter");
}


void emergencyDialSettingsEnterButton() {
  emergencyDialSettingsTextfield.hide();
  emergencyDialSettingsEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  
  port.write("e " + emergencyDialSettingsTextfield.getText() + "*");
}

void notificationTypeButton () {
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  
  //notificationTypeTextfield = cp5.addTextfield("notificationTypeTextfield")
  //  .setPosition(500, 50)
  //  .setSize(150, 70)
  //  .setFont(font)
  //  .setLabel("");
    
  //notificationTypeEnterButton = cp5.addButton("notificationTypeEnterButton")    
  //  .setPosition(500, 150)  //x and y coordinates of upper left corner of button
  //  .setSize(150, 70)      //(width, height)
  //  .setColorBackground(color(90, 154, 215))
  //  .setLabel("Enter");

  //DropdownList notificationTypeDropdownList = cp5.addDropdownList("notificationTypeDropdownList")
  //.setLabel("סוג התראה")
  //.setPosition(500, 150)
  //.setColorBackground(color(90, 154, 215))
  //.setFont(font)
  //.setItemHeight(20)
  //.setBarHeight(25);
  
  //notificationTypeDropdownList
  //.addItem("רטט", notificationTypeDropdownList)
  //.addItem("לד", notificationTypeDropdownList)
  //.addItem("זמזם", notificationTypeDropdownList);
}

void notificationTypeEnterButton() {
  notificationTypeTextfield.hide();
  notificationTypeEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  
  port.write("n " + notificationTypeTextfield.getText() + "*");
}

void metricsButton(){
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  
  metricsTextfield = cp5.addTextfield("metricsTextfield")
    .setPosition(500, 50)
    .setSize(150, 70)
    .setFont(font)
    .setLabel("");
    
  metricsEnterButton = cp5.addButton("metricsEnterButton")    
    .setPosition(500, 150)  //x and y coordinates of upper left corner of button
    .setSize(150, 70)      //(width, height)
    .setColorBackground(color(90, 154, 215))
    .setLabel("Enter");
   
}

void metricsEnterButton() {
  metricsTextfield.hide();
  metricsEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  
  port.write("m " + metricsTextfield.getText() + "*");
}
