import controlP5.*; //import ControlP5 library
import processing.serial.*;

Serial port;

ControlP5 cp5; //create ControlP5 object
PFont font;
PImage image;
Textfield angleTextfield, heightTextfield, emergencyDialSettingsTextfield, notificationTypeTextfield, metricsTextfield;
Button angleButton, angleEnterButton, strengthButton, initialDistanceButton, heightButton,distanceButton, heightEnterButton, emergencyDialSettingsButton, notificationTypeButton, 
metricsButton, emergencyDialSettingsEnterButton, notificationTypeEnterButton, backToMainMenuButton, saveButton;
String str = null;
float myVal;
int sonto;
boolean isReadingSensor = false;
boolean firstContact = false;        // Whether we've heard from the microcontroller //<>//


void setup(){ //same as arduino program
  println("windowWidth: " + displayWidth);
  println("windowHeight: " + displayHeight);
  size(1920, 1080);    //window size, (width, height)
  surface.setLocation(0,0);
  printArray(Serial.list());   //prints all available serial ports
  
  port = new Serial(this, "COM3", 115200);  //i have connected arduino to com3, it would be different in linux and mac os
  if (port.available() > 0) {
  }
  
  cp5 = new ControlP5(this);
  font = createFont("david bold", 40);    // custom fonts for buttons and title
  image = loadImage("C:\\Users\\rahav\\Documents\\sketch_230220a\\data\\lior.jpg"); // Load the image

  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  fill(255, 255, 255);               //text color (r, g, b)
  textFont(font);
  //frameRate(10);
  

  angleButton = cp5.addButton("angleButton")     
    .setPosition(displayWidth * 5.15/8, displayHeight * 0.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("זווית החיישן")
    .setColorBackground(color(90, 154, 215))
  ;   

  heightButton = cp5.addButton("heightButton")     //"קליברציה אחורית" is the name of button
    .setPosition(displayWidth * 5.15/8, displayHeight * 1.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("גובה החיישן")
    .setColorBackground(color(90, 154, 215))
  ;

  emergencyDialSettingsButton = cp5.addButton("emergencyDialSettingsButton")     //"blue" is the name of button
    .setPosition(displayWidth * 5.15/8, displayHeight * 2.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("הגדרות חיוג חירום")    
    .setColorBackground(color(90, 154, 215))
  ;
  
  notificationTypeButton = cp5.addButton("notificationTypeButton")     //"alloff" is the name of button
    .setPosition(displayWidth * 5.15/8, displayHeight * 3.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("סוג התראה")
    .setColorBackground(color(90, 154, 215))
  ;
  
    metricsButton = cp5.addButton("metricsButton")     //"alloff" is the name of button
    .setPosition(displayWidth * 5.15/8, displayHeight * 4.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("קריאת מדדים")    
    .setColorBackground(color(90, 154, 215))
  ;
  
     saveButton = cp5.addButton("saveButton")     //"alloff" is the name of button
    .setPosition(displayWidth * 5.15/8, displayHeight * 5.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("יציאה")    
    .setColorBackground(color(90, 154, 215))
  ;
}

void draw(){  //same as loop in arduino
  

  String buffer = "";

  while (port.available() > 0) {
    mySerialEvent();
  }

//    sonto = port.read();
//    buffer += char(sonto);
    
    //if (sonto != null) {
    //  background(0);
    //  myVal = float(str);
    //  //println(myVal);
  //}
  //if (buffer.length() != 0) {
  //    println(buffer);
  //}
}

void mySerialEvent() {
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
    else{
      String buffer = "";
    
      while (port.available() > 0) {
    
        sonto = port.read();
        buffer += char(sonto);

      }
      if (buffer.length() != 0) {
          String[] list = split(buffer, '\n');
          background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
          for (int i = 0; i < list.length; i++) {
            if ((list[i].length()) > 0 && isReadingSensor == true) {
              print(list[i]);
              if (list[i].charAt(0) == 'D') {
                text(list[i].substring(1), displayWidth * 1.8/8 , displayHeight * 3.5/8);  
              }
              else if (list[i].charAt(0) == 'S') {
                text(list[i].substring(1), displayWidth * 3.8/8 , displayHeight * 3.5/8);  
              }
              else if (list[i].charAt(0) == 'I') {
                text(list[i].substring(1), displayWidth * 5.8/8 , displayHeight * 3.5/8);  
              }
            }
          }       
      }    
  }
}


void angleButton(){
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)

  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();


  angleTextfield = cp5.addTextfield("angleTextfield")
    .setPosition(displayWidth * 3.15/8, displayHeight * 0.5/8)
    .setSize(displayWidth / 5, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  angleEnterButton = cp5.addButton("angleEnterButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 0.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
    
}

void angleEnterButton() {
   background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)

  angleTextfield.hide();
  angleEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  port.write("a " + angleTextfield.getText() + "*");
}


void heightButton(){
   background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  
  angleButton.hide();
  //heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();
  
  heightTextfield = cp5.addTextfield("heightTextfield")
    .setPosition(displayWidth * 3.15/8, displayHeight * 1.5/8)
    .setSize(displayWidth / 5, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  heightEnterButton = cp5.addButton("heightEnterButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 1.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
}


void heightEnterButton() {
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
   
  heightTextfield.hide();
  heightEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  port.write("h " + heightTextfield.getText() + "*");
}

void emergencyDialSettingsButton () {
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  
  angleButton.hide();
  heightButton.hide();
  //emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();
  
  emergencyDialSettingsTextfield = cp5.addTextfield("emergencyDialSettingsTextfield")
    .setPosition(displayWidth * 3.15/8, displayHeight * 2.5/8)
    .setSize(displayWidth / 5, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  emergencyDialSettingsEnterButton = cp5.addButton("emergencyDialSettingsEnterButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 2.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
}


void emergencyDialSettingsEnterButton() {
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  emergencyDialSettingsTextfield.hide();
  emergencyDialSettingsEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  port.write("e " + emergencyDialSettingsTextfield.getText() + "*");
}

void notificationTypeButton () {
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  //notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();
  
  notificationTypeTextfield = cp5.addTextfield("notificationTypeTextfield")
    .setPosition(displayWidth * 3.15/8, displayHeight * 3.5/8)
    .setSize(displayWidth / 5, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  notificationTypeEnterButton = cp5.addButton("notificationTypeEnterButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 3.5/8)
    .setFont(font)
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");

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
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  
  notificationTypeTextfield.hide();
  notificationTypeEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 0, 30, displayWidth / 2, displayWidth / 2);
  port.write("n " + notificationTypeTextfield.getText() + "*");
}

void metricsButton(){
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)

  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();

 
  backToMainMenuButton = cp5.addButton("backToMainMenuButton")    
    .setPosition(displayWidth * 0.15/8, displayHeight * 6.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("חזרה לתפריט הראשי");
    
    
  distanceButton = cp5.addButton("distanceButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 1.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(0,0,0))
    .setLabel("מרחק");
    
    strengthButton = cp5.addButton("strengthButton")    
    .setPosition(displayWidth * 3.15/8, displayHeight * 1.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(0,0,0))
    .setLabel("עוצמה");  
    
    initialDistanceButton = cp5.addButton("initialDistanceButton")    
    .setPosition(displayWidth * 5.15/8, displayHeight * 1.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(0,0,0))
    .setLabel("מרחק נורמה");  
  isReadingSensor = true;
    port.write("m *");
}

void backToMainMenuButton() {
  background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
  
  backToMainMenuButton.hide();
  distanceButton.hide();
  strengthButton.hide();
  initialDistanceButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
   //background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)
   isReadingSensor =false; //<>//
     
   image(image, 0, 30, displayWidth / 2, displayWidth / 2);
    

}


void saveButton(){
    background(223, 130 , 68); // background color of window (r, g, b) or (0 to 255)

    port.write("s exit*");
    exit();
}
