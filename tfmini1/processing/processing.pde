// --- Imports --- //<>// //<>//
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
metricsButton, emergencyDialSettingsEnterButton, notificationTypeEnterButton, backToMainMenuButton, saveButton, detectedAngleButton;

int curChar;                         // Current character being read from Arduino
boolean isReadingSensor = false;     // Whether we're currently reading data from the sensor
boolean firstContact = false;        // Whether we've heard from the microcontroller 

void setup(){ //<>//
  fullScreen();
  surface.setLocation(0,0);
  printArray(Serial.list());         // Print all available serial ports
  
  port = new Serial(this, "COM3", 115200);
  if (port.available() > 0) {
  }
  
  cp5 = new ControlP5(this);
  //font = createFont("david", 38);     // Custom fonts for buttons and title
  font = createFont("felix007 Medium", 36);     // Custom fonts for buttons and title
  image = loadImage("./data//lior.jpg");         // Load the image
  

  
  background(198, 197, 195); 
  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
  fill(255, 255, 255);               
  textFont(font);

  angleButton = cp5.addButton("angleButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 0.5/8)
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("זווית החיישן")
    .setColorBackground(color(98, 146, 158));   

  heightButton = cp5.addButton("heightButton")
    .setPosition(displayWidth * 6.75/8, displayHeight * 1.65/8) 
    .setSize(displayWidth / 7, displayWidth / 16)    
    .setFont(font)
    .setLabel("גובה החיישן")
    .setColorBackground(color(98, 146, 158));

  emergencyDialSettingsButton = cp5.addButton("emergencyDialSettingsButton")
    .setPosition(displayWidth * 6.75/8, displayHeight * 2.9/8) 
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("הגדרות חיוג חירום")    
    .setColorBackground(color(98, 146, 158));
  
  notificationTypeButton = cp5.addButton("notificationTypeButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 4.15/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("סוג התראה")
    .setColorBackground(color(98, 146, 158));
  
    metricsButton = cp5.addButton("metricsButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 5.4/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("קריאת מדדים")    
    .setColorBackground(color(98, 146, 158));
  
     saveButton = cp5.addButton("saveButton")     
    .setPosition(displayWidth * 6.75/8, displayHeight * 6.65/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      
    .setFont(font)
    .setLabel("יציאה")    
    .setColorBackground(color(98, 146, 158));
}

void draw(){  
  while (port.available() > 0) {
    mySerialEvent();
  }
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
          background(198, 197, 195); 
          fill(255, 255, 255);
          rectMode(CENTER);
          rect(displayWidth * 3/8, displayHeight * 1.95/8, displayWidth / 5, displayWidth / 16);
          rect(displayWidth * 3/8, displayHeight * 3.15/8, displayWidth / 5, displayWidth / 16);
          rect(displayWidth * 3/8, displayHeight * 4.35/8, displayWidth / 5, displayWidth / 16);
          rect(displayWidth * 3/8, displayHeight * 5.55/8, displayWidth / 5, displayWidth / 16);

  
        }
        for (int i = 0; i < list.length; i++) {
          if ((list[i].length()) > 0 && isReadingSensor == true) {
            if (list[i].charAt(0) == 'D') {
              fill(84, 106, 123);               
              text(list[i].substring(1), displayWidth * 2.85/8 , displayHeight * 3.2/8);  
            }
            else if (list[i].charAt(0) == 'S') {
              fill(84, 106, 123);               
              text(list[i].substring(1), displayWidth * 2.8/8 , displayHeight * 5.6/8);  
            }
            else if (list[i].charAt(0) == 'I') {
              fill(84, 106, 123);               
              text(list[i].substring(1), displayWidth * 2.9/8 , displayHeight * 2/8);  
            }
            else if (list[i].charAt(0) == 'G') {
              fill(84, 106, 123);               
              text(list[i].substring(1), displayWidth * 2.85/8 , displayHeight * 4.4/8);  
            }
          }
        }       
      }    
  }
}


void setLock(Controller theController, boolean theValue) {
  theController.setLock(theValue);
  if(theValue) {
    theController.setColorBackground(color(84, 106, 123));
  } else {
    theController.setColorBackground(color(84, 106, 123));
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
    .setColorBackground(color(84, 106, 123)) 
    .setFont(font)
    .setLabel("");
    
  angleEnterButton = cp5.addButton("angleEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 0.5/8)  //x and y coordinates of upper left corner of button
    .setSize(displayWidth / 7, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(98, 146, 158))
    .setLabel("שמירה");
}

void angleEnterButton() {
  background(198, 197, 195); 

  angleTextfield.hide();
  angleEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
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
    .setColorBackground(color(84, 106, 123)) 
    .setFont(font)
    .setLabel("");
    
  heightEnterButton = cp5.addButton("heightEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 1.65/8) 
    .setSize(displayWidth / 7, displayWidth / 16)
    .setFont(font)
    .setColorBackground(color(98, 146, 158))
    .setLabel("שמירה");
}


void heightEnterButton() {
  background(198, 197, 195); 
   
  heightTextfield.hide();
  heightEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
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
    .setColorBackground(color(84, 106, 123)) 
    .setFont(font)
    .setLabel("");
    
  emergencyDialSettingsEnterButton = cp5.addButton("emergencyDialSettingsEnterButton")    
    .setPosition(displayWidth * 4.25/8, displayHeight * 2.9/8)  
    .setSize(displayWidth / 7, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(98, 146, 158))
    .setLabel("שמירה");
}


void emergencyDialSettingsEnterButton() {
  background(198, 197, 195); 
  emergencyDialSettingsTextfield.hide();
  emergencyDialSettingsEnterButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
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
    .setColorBackground(color(84, 106, 123))
    .setLabel("רטט");
    
   notificationTypeBuzzerButton = cp5.addButton("notificationTypeBuzzerButton")
  .setPosition(displayWidth * 5.15/8, displayHeight * 4.15/8)
  .setSize(displayWidth / 12, displayWidth / 16)
  .setColorBackground(color(84, 106, 123))  
  .setFont(font)
  .setLabel("באזר");
  
   notificationTypeLedButton = cp5.addButton("notificationTypeLedButton")
  .setPosition(displayWidth * 4.35/8, displayHeight * 4.15/8)
  .setSize(displayWidth / 12, displayWidth / 16)
  .setColorBackground(color(84, 106, 123))  
  .setFont(font)
  .setLabel("לד");

}

void notificationTypeVibrateButton() {
  background(198, 197, 195); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
  port.write("n 0*");
}

void notificationTypeBuzzerButton() {
  background(198, 197, 195); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
  port.write("n 1*");
}

void notificationTypeLedButton() {
  background(198, 197, 195); 
  
  notificationTypeVibrateButton.hide();
  notificationTypeBuzzerButton.hide();
  notificationTypeLedButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();

  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05);
  port.write("n 2*");
}

void metricsButton(){
  background(198, 197, 195); 
  
  angleButton.hide();
  heightButton.hide();
  emergencyDialSettingsButton.hide();
  notificationTypeButton.hide(); 
  metricsButton.hide();
  saveButton.hide();

  backToMainMenuButton = cp5.addButton("backToMainMenuButton")    
    .setPosition(displayWidth * 0.15/8, displayHeight * 6.9/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(98, 146, 158))
    .setLabel("חזרה לתפריט הראשי");
  

  distanceButton = cp5.addButton("distanceButton")    
    .setPosition(displayWidth * 4.15/8, displayHeight * 2.7/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(84, 106, 123)) 
    .setLabel("מרחק נוכחי בסנטימטרים");
  
    setLock(cp5.getController("distanceButton"),true);

    strengthButton = cp5.addButton("strengthButton")    
    .setPosition(displayWidth * 4.15/8, displayHeight * 5.1/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(84, 106, 123)) 
    .setLabel("עוצמה");  
    
     setLock(cp5.getController("strengthButton"),true);

    initialDistanceButton = cp5.addButton("initialDistanceButton")    
    .setPosition(displayWidth * 4.15/8, displayHeight * 1.5/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(84, 106, 123)) 
    .setLabel("מרחק נורמה בסנטימטרים"); 
    
     setLock(cp5.getController("initialDistanceButton"),true);
    
    detectedAngleButton = cp5.addButton("detectedAngleButton")    
    .setPosition(displayWidth * 4.15/8, displayHeight * 3.9/8)  
    .setSize(displayWidth / 5, displayWidth / 16)      //(width, height)
    .setFont(font)
    .setColorBackground(color(84, 106, 123)) 
    .setLabel("זווית נורמה בסנטימטרים"); 
     //<>//
     setLock(cp5.getController("detectedAngleButton"),true);
    
    isReadingSensor = true;
    port.write("m *");
}

void backToMainMenuButton() {
  background(198, 197, 195); 
  
  backToMainMenuButton.hide();
  distanceButton.hide();
  strengthButton.hide();
  initialDistanceButton.hide();
  detectedAngleButton.hide();
  
  angleButton.show();
  heightButton.show();
  emergencyDialSettingsButton.show();
  notificationTypeButton.show(); 
  metricsButton.show();
  saveButton.show();
  
  isReadingSensor = false;
  image(image, 20, 50, displayWidth * 1.07 / 2, displayHeight * 0.85 * 1.05); 
}


void saveButton(){ //<>//
    background(198, 197, 195); 
    port.write("s exit*");
    exit();
}
