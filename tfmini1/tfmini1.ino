// --- Includes ---

#include <SoftwareSerial.h>
#include <EEPROM.h>
#include "TFMini.h"

// --- Output Pins ---

int TFMiniPin1 = 2;
int TFMiniPin2 = 3;

int vibratePin = 4;
int buzzerPin = 5;

int redPin = 11; 
int bluePin = 13; 
int greenPin = 12;

// --- Global Variables ---
int val;
float distance = 0;                   // Current distance TFMini measured from the ground
float strength = 0;                   // The Certainity of the the distance TFMini returned
int changeCounter = 0;                // ????????????????????????????????????????????????? 
float angle = 0;
float lastAverage = 0;                // The last valid average of the 25 samples of TFMini
int samplesCounter = 0;               // How many samples we collected from TFMini in current stream
float currentAverage = 0;             // The average of the last 25 samples of TFMini

TFMini tfmini;
SoftwareSerial SerialTFMini(TFMiniPin1, TFMiniPin2);         

// Learning rate of for the calculation of the current distance from the ground (diagonally)
float DLR = 0.2;                      
float ULR = 0.05;

// Default notification type (Vibration=0, LED=1, Buzzer=2) and emergency phone to call in case of fall
int notificationType = 1;
int emergencyPhone = 0;

// Default distance and height of the sensor (should match real life placement of the sensor)
float angle = 45;           // Angle (in degrees) of the sensor
float height = 61;          // Height (in cm) of the sensor
float initDistance;         // Expected diagonal distance based on the angle and height
int fallDistance = 10;      // Distance that detects fall

void setup()
{
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(vibratePin, OUTPUT);           
  pinMode(buzzerPin, OUTPUT);           
  
  Serial.begin(115200);       // Initialize hardware serial port (serial debug port)

  while (!Serial);            // Wait for serial port to connect
  
  Serial.println ("Initializing...");
  SerialTFMini.begin(TFMINI_BAUDRATE);    // Initialize the data rate for the SoftwareSerial port
  tfmini.begin(&SerialTFMini);            // Initialize the TF Mini sensor
  
  establishConnection();                  // Send a char to establish connection until receiver responds
  delay(50);
  if (Serial.available() > 0) {           // Processing detected  
    techMode();                           // Enter technichian mode
  }
  getVariables();                         // Fetch variables from EEPROM  
  calculateInitDistance();                // Calculate initial normal distance of the sensor from the ground

  // Initilize reference average
  for (int i = 31; 0 < i; i--) {
    getTFminiData(&distance, &strength);    // Read from sensor into distance
    while (!distance)
    {
      getTFminiData(&distance, &strength);
    }
    lastAverage += (distance / 25);   
  }

  // LED notification to user - Initialization of the program is done
  analogWrite(redPin, 200);
  analogWrite(bluePin, 0);
  analogWrite(greenPin, 0);
  delay(1000);
  analogWrite(redPin, 0);
  analogWrite(bluePin, 0);
  analogWrite(greenPin, 0);
}



void loop()
{
  // Read data from TFMini to distance and strength
  float distance = 0;
  float strength = 0;
    
  getTFminiData(&distance, &strength);    
  while (!distance)
  {
    getTFminiData(&distance, &strength);
  }
  currentAverage += distance / 25;           // Calculate cuurent average according to the last samples
  samplesCounter++;                          // Update samplesCounter
       
  if (samplesCounter == 25){
    Serial.println(
      " current: " + String(currentAverage) + " cm \n" + 
      "last: " + String(lastAverage) + " cm \n");
    
      samplesCounter = 0;                     // Reset samplesCounter to calculate again
      
      if (currentAverage < fallDistance){     // Something is very close to the sensor - Fall
        analogWrite(redPin,0);
        analogWrite(bluePin,200);
        analogWrite(greenPin,0);
        delay(3000);
        analogWrite(redPin,0);
        analogWrite(bluePin,0);
        analogWrite(greenPin,0);
        currentAverage = 0;
     }
   
     else if (lastAverage < currentAverage){
       if (lastAverage + 30 < currentAverage){   // Diviation above the tolorance
        Serial.println(notificationType);
        if (changeCounter == 4){
          if (notificationType == 0){            // Vibrating motor
            digitalWrite(4 ,HIGH);
            delay(3000);
            digitalWrite(4 ,0);
          }
          else if (notificationType == 1){       // Buzzer
            digitalWrite(5 ,HIGH);
            delay(3000);
            digitalWrite(5 ,0);            
          }
          else if (notificationType == 2){       // LED
            analogWrite(redPin,200);
            analogWrite(bluePin,0);
            analogWrite(greenPin,0);
            delay(3000);
            analogWrite(redPin,0);
            analogWrite(bluePin,0);
            analogWrite(greenPin,0);
            changeCounter = 0;                    // Check if we want to reset or not
          }
        }
        else{                                     // There is change but still uncertain
          changeCounter++;
        }
       }
      else{                                       // Change is within tolorance - increase lastAverage
        lastAverage += (currentAverage - lastAverage) * ULR;
        changeCounter = 0;
      }
     currentAverage = 0;
     }
     else if (lastAverage > currentAverage and lastAverage > initDistance - 1){      // Decrease lastAverage gradually until we get to init
       lastAverage -= (lastAverage - currentAverage) * DLR;                          // Decrease lastAverage against currentAverage
     }
    currentAverage = 0;
  }
}


void establishConnection() {
    delay(100);
    Serial.print('A');   // send a capital A
    delay(300);

}

void techMode(){
  // Light to notify entrance to techMode
  analogWrite(redPin,100);    
  analogWrite(bluePin,130);
  analogWrite(greenPin,130);

  int samplesCounter = 0;
  
  while(true){                                      // Enter technician mode loop
    String inString = Serial.readString();
    if (inString[0] == 'a') {                       // Change angle
       angle = (inString.substring(2)).toInt();
       delay(100);
       EEPROM.write(0, angle);
       delay(100);
    }
    else if (inString[0] == 'h') {                  // Change height
       height = (inString.substring(2)).toInt();
       delay(100);
       EEPROM.write(1, height);
       delay(100);
    }    
    else if (inString[0] == 'e') {                  // Change the emergencies Phone Number
     emergencyPhone = (inString.substring(2)).toInt();
     delay(100);
     EEPROM.write(2, emergencyPhone);
     delay(100);
    }
    else if (inString[0] == 'n') {                  // Change the notification type
      notificationType = (inString.substring(2)).toInt();
      delay(100);
      EEPROM.write(3, notificationType);
      delay(100);
    }
   else if (inString[0] == 'm'){                    // view sensor reads - Send TFMini samples to proccesing
      int samplesCounter = 0;
      while (true){
        while (!Serial);                            // Wait for serial port to connect
        getTFminiData(&distance, &strength);        // Read from sensor into distance and strength   
        if (samplesCounter == 11520){               // Send only 1/11520 of the samples in over to avoid overflow
          Serial.println(" D" + String(distance));
          Serial.println("S" + String(strength));
          Serial.println("I" + String(initDistance));
          Serial.println("G" + String(angle));
          samplesCounter = 0;
        }
        samplesCounter++;
      }
    }
    else if (inString[0] == 's'){                   // Save and exit tech mode
      break;
    }
  }
} 
   
void calculateInitDistance()
{
  float angle_rad = (angle * PI) / 180;             // Convert degrees to radians
  initDistance = height * (1 / cos(angle_rad));
}
 

void getTFminiData(float* distance, float* strength)
{
  static char i = 0;
  char j = 0;
  int checksum = 0;
  static int rx[9];
  if (SerialTFMini.available())
  {
    rx[i] = SerialTFMini.read();
    if (rx[0] != 0x59)
    {
      i = 0;
    }
    else if (i == 1 && rx[1] != 0x59)
    {
      i = 0;
    }
    else if (i == 8)
    {
      for (j = 0; j < 8; j++)
      {
        checksum += rx[j];
      }
      if (rx[8] == (checksum % 256))
      {
        *distance = rx[2] + rx[3] * 256;
        *strength = rx[4] + rx[5] * 256;
      }
      i = 0;
    }
    else
    {
      i++;
    }
  }
}

void getVariables(){                // Get global variables values from EEPROM
  delay(50);
  angle = EEPROM.read(0);
  delay(50);

  delay(50);
  height = EEPROM.read(1);
  delay(50);

  delay(50);
  emergencyPhone = EEPROM.read(2);
  delay(50);

  delay(50);
  notificationType = EEPROM.read(3);
  delay(50);

  analogWrite(redPin,0);              // Confirmation light
  analogWrite(bluePin,0);
  analogWrite(greenPin,200);
  delay(300);
  analogWrite(redPin,0);              // Confirmation light OFF
  analogWrite(bluePin,0);
  analogWrite(greenPin,0);
}
  
