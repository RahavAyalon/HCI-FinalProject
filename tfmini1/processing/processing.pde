// --- Imports --- //<>//
import controlP5.*; 
import processing.serial.*;

// --- Global Variables ---
Serial port;
ControlP5 cp5; 
PFont font;
PImage image;
Textfield angleTextfield, heightTextfield, emergencyDialSettingsTextfield, notificationTypeTextfield, metricsTextfield;
Button angleButton, angleEnterButton,notificationTypeVibrateButton, notificationTypeBuzzerButton, notificationTypeLedButton, 
strengthButton, initialDistanceButton, heightButton,distanceButton, heightEnterButton, emergencyDialSettingsButton, notificationTypeButton, 
metricsButton, emergencyDialSettingsEnterButton, notificationTypeEnterButton, backToMainMenuButton, saveButton;

int curChar;                         // Current character being read from Arduino
boolean isReadingSensor = false;     // Whether we're currently reading data from the sensor
boolean firstContact = false;        // Whether we've heard from the microcontroller 

 //<>//
void setup(){
  size(1920, 1080);                  // Window size, (width, height)
  surface.setLocation(0,0);
  printArray(Serial.list());         // Print all available serial ports
  
  //port = new Serial(this, "COM7", 115200);
  //if (port.available() > 0) {
  //}
  
  cp5 = new ControlP5(this);
  font = createFont("david bold", 40);     // Custom fonts for buttons and title
  image = loadImage("./lior.jpg");         // Load the image

  background(223, 130 , 68); 
  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  fill(255, 255, 255);               
  textFont(font);

  angleButton = cp5.addButton("angleButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 0.5/8)
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("זווית החיישן")
    .setColorBackground(color(90, 154, 215));   

  heightButton = cp5.addButton("heightButton")
    .setPosition(displayWidth * 6.75/8, displayHeight * 1.65/8) 
    .setSize(displayWidth / 7, displayWidth / 16)    
    .setFont(font)
    .setLabel("גובה החיישן")
    .setColorBackground(color(90, 154, 215));

  emergencyDialSettingsButton = cp5.addButton("emergencyDialSettingsButton")
    .setPosition(displayWidth * 6.75/8, displayHeight * 2.9/8) 
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("הגדרות חיוג חירום")    
    .setColorBackground(color(90, 154, 215));
  
  notificationTypeButton = cp5.addButton("notificationTypeButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 4.15/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("סוג התראה")
    .setColorBackground(color(90, 154, 215));
  
    metricsButton = cp5.addButton("metricsButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 5.4/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("קריאת מדדים")    
    .setColorBackground(color(90, 154, 215));
  
     saveButton = cp5.addButton("saveButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 6.65/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("יציאה")    
    .setColorBackground(color(90, 154, 215));
}

void draw(){  
  //while (port.available() > 0) {
  //  mySerialEvent();
  //}
}

void mySerialEvent() {
    int inByte = port.read();                  
    // Read a byte from the serial port
    // If this is the first byte received, and it's an A, clear the serial buffer and note that you've had first contact from the microcontroller
    if (firstContact == false) {
      if (inByte == 'A') {
        port.clear();              // Clear the serial port buffer
        firstContact = true;       // You've had first contact from the microcontroller
        port.write('A');           // Ask for more
      }
    }
    else{
      String buffer = "";
      while (port.available() > 0) {
        curChar = port.read();
        buffer += char(curChar);

    }
    if (buffer.length() != 0) {
        String[] list = split(buffer, '\n');
        if (isReadingSensor) {
          background(223, 130 , 68); 
        }
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


void setLock(Controller theController, boolean theValue) {
  theController.setLock(theValue);
  if(theValue) {
    theController.setColorBackground(color(8, 44, 92));
  } else {
    theController.setColorBackground(color(8, 44, 92));
  }
}



void angleButton(){
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();

  angleTextfield = cp5.addTextfield("angleTextfield")
    .setPosition(displayWidth * 5.5/8, displayHeight * 0.5/8)
    .setSize(displayWidth / 7, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  angleEnterButton = cp5.addButton("angleEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 0.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 7, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
}

void angleEnterButton() {
  background(223, 130 , 68); 

  angleTextfield.hide();
  angleEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("a " + angleTextfield.getText() + "*");
}


void heightButton(){  
  angleButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();
  
  heightTextfield = cp5.addTextfield("heightTextfield")
    .setPosition(displayWidth * 5.5/8, displayHeight * 1.65/8)
    .setSize(displayWidth / 7, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  heightEnterButton = cp5.addButton("heightEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 1.65/8) 
    .setSize(displayWidth / 7, displayWidth / 16)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
}


void heightEnterButton() {
  background(223, 130 , 68); 
   
  heightTextfield.hide();
  heightEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("h " + heightTextfield.getText() + "*");
}

void emergencyDialSettingsButton () {  
  angleButton.hide();
  heightButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();
  
  emergencyDialSettingsTextfield = cp5.addTextfield("emergencyDialSettingsTextfield")
    .setPosition(displayWidth * 5.5/8, displayHeight * 2.9/8)
    .setSize(displayWidth / 7, displayWidth / 16)
    .setFont(font)
    .setLabel("");
    
  emergencyDialSettingsEnterButton = cp5.addButton("emergencyDialSettingsEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 2.9/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("שמירה");
}


void emergencyDialSettingsEnterButton() {
  background(223, 130 , 68); 
  emergencyDialSettingsTextfield.hide();
  emergencyDialSettingsEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("e " + emergencyDialSettingsTextfield.getText() + "*");
}

void notificationTypeButton () {  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  metricsButton.hide();
  saveButton.hide();
  
  notificationTypeVibrateButton = cp5.addButton("notificationTypeVibrateButton")
    .setPosition(displayWidth * 5.95/8, displayHeight * 4.15/8)
    .setSize(displayWidth / 12, displayWidth / 16)
    .setFont(font)
    .setLabel("רטט");
    
   notificationTypeBuzzerButton = cp5.addButton("notificationTypeBuzzerButton")
  .setPosition(displayWidth * 5.15/8, displayHeight * 4.15/8)
  .setSize(displayWidth / 12, displayWidth / 16)
  .setFont(font)
  .setLabel("באזר");
  
   notificationTypeLedButton = cp5.addButton("notificationTypeLedButton")
  .setPosition(displayWidth * 4.35/8, displayHeight * 4.15/8)
  .setSize(displayWidth / 12, displayWidth / 16)
  .setFont(font)
  .setLabel("לד");

}

void notificationTypeVibrateButton() {
  background(223, 130 , 68); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("n 0*");
}

void notificationTypeBuzzerButton() {
  background(223, 130 , 68); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("n 1*");
}

void notificationTypeLedButton() {
  background(223, 130 , 68); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
  port.write("n 2*");
}

void metricsButton(){
  background(223, 130 , 68); 

  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();

  backToMainMenuButton = cp5.addButton("backToMainMenuButton")    
    .setPosition(displayWidth * 0.15/8, displayHeight * 6.5/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(90, 154, 215))
    .setLabel("חזרה לתפריט הראשי");
  

  distanceButton = cp5.addButton("distanceButton")    
    .setPosition(displayWidth * 1.15/8, displayHeight * 1.5/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("מרחק");
  
    setLock(cp5.getController("distanceButton"),true);

    strengthButton = cp5.addButton("strengthButton")    
    .setPosition(displayWidth * 3.15/8, displayHeight * 1.5/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("עוצמה");  
    
     setLock(cp5.getController("strengthButton"),true);

    initialDistanceButton = cp5.addButton("initialDistanceButton")    
    .setPosition(displayWidth * 5.15/8, displayHeight * 1.5/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setLabel("מרחק נורמה"); 
    
     setLock(cp5.getController("initialDistanceButton"),true);
    
    isReadingSensor = true;
    port.write("m *");
}

void backToMainMenuButton() {
  background(223, 130 , 68); 
  
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
  
  isReadingSensor = false;
  image(image, 50, 50, displayWidth / 2, displayWidth / 2);
}


void saveButton(){
    background(223, 130 , 68);  //<>//
    port.write("s exit*");
    exit();
}
