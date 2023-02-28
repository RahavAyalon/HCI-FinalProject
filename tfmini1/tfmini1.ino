#include <SoftwareSerial.h>
#include <EEPROM.h>
#include "TFMini.h"
TFMini tfmini;

int redPin = 11; //select the pin for the red LED
int bluePin =13; // select the pin for the  blue LED
int greenPin =12;// select the pin for the green LED 
int val;

float currentAverage = 0;
float lastAverage = 0;
int counter = 0;
int changeCounter = 0;                //how many times the 
float DLR = 0.2;                       //learning rate
float ULR = 0.05;
float distance = 0;
float strength = 0;

int notificationType = 1;
int emergencyPhone = 0;
float angle = 45;           //angel (in degrees) of the sensor
float height = 61;          //height (in cm) of the sensor

float initDistance;   //expected diagonal distance based on the angle and height

SoftwareSerial SerialTFMini(2, 3);          //The only value that matters here is the first one, 2, Rx

void setup()
{
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  Serial.begin(115200);       //Initialize hardware serial port (serial debug port)

  while (!Serial);            // wait for serial port to connect. Needed for native USB port only
  Serial.println ("Initializing...");
  SerialTFMini.begin(TFMINI_BAUDRATE);    //Initialize the data rate for the SoftwareSerial port
  tfmini.begin(&SerialTFMini);            //Initialize the TF Mini sensor

  establishContact();  // send a byte to establish contact until receiver responds
  delay(50);
  if (Serial.available() > 0) {   //processing detected  
    techMode();                   //Enter technician mode
  }
  getVariables();                 //fetch variables from EEPROM  
  calculateInitDistance();

  
  for (int i = 31; 0 < i; i--) {           //we initilize reference average
    getTFminiData(&distance, &strength);    //we read from sensor into distance
    while (!distance)
    {
      getTFminiData(&distance, &strength);
    }
    lastAverage += (distance / 25);   
  }

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

//    if (height == 57) {
//        analogWrite(redPin,200);
//        analogWrite(bluePin,200);
//        analogWrite(greenPin,0);
//    }

  

  float distance = 0;
  float strength = 0;

  getTFminiData(&distance, &strength);    //we read from sensor into distance
  while (!distance)
  {
    getTFminiData(&distance, &strength);
  }


//    Serial.println(
//      " Distance: " + String(distance) + " cm \n" + 
//      "Initial Distance: " + String(initDistance) + " cm \n" +
//      "Strength: " + String(strength) + " \n");

  currentAverage += distance / 25;     
  counter++;                          //update counter
       
  if (counter == 25){
    Serial.println(
      " current: " + String(currentAverage) + " cm \n" + 
      "last: " + String(lastAverage) + " cm \n");
    
      counter = 0;                     //we reset counter to refill cyclicArray once again
      
      if (currentAverage < 10){   //something is very close to the sensor
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
       if (lastAverage + 30 < currentAverage){   //there is a diviation above the tolorance
        if (changeCounter == 4){
          if (notificationType == 0){       //vibrating motor
            analogWrite(4 ,200);
            delay(3000);
            analogWrite(4 ,0);
          }
          else if (notificationType == 1){   //Buzzer
              


          }
            
          else if (notificationType == 2){                             //LED
          analogWrite(redPin,200);
          analogWrite(bluePin,0);
          analogWrite(greenPin,0);
          delay(3000);
          analogWrite(redPin,0);
          analogWrite(bluePin,0);
          analogWrite(greenPin,0);
          
          changeCounter = 0;                  //check if we want to reset or not
        }
        }
        else{                                //there is change but still uncertain
          changeCounter++;
        }
       }
      else{                                //change is within tolorance - we increase last
        lastAverage += (currentAverage - lastAverage) * ULR;
        changeCounter = 0;
      }
     currentAverage = 0;
     }

     else if(lastAverage > currentAverage and lastAverage > initDistance - 1){      //we decrease last gradually until we get to init
       lastAverage -= (lastAverage - currentAverage) * DLR;    //we decrease last against current  

     }
    currentAverage = 0;
    
  }
}


void establishContact() {
    delay(100);
    Serial.print('A');   // send a capital A
    delay(300);

}

void techMode(){
  analogWrite(redPin,100);    //confirmation light
  analogWrite(bluePin,130);
  analogWrite(greenPin,130);

  int counter = 0;
  while(true){                //enter technician mode loop
    

    String inString = Serial.readString();
    if (inString[0] == 'a') {
       angle = (inString.substring(2)).toInt();

       delay(100);
       EEPROM.write(0, angle);
       delay(100);
      }
      
    else if (inString[0] == 'h') {
       height = (inString.substring(2)).toInt();
       delay(100);
       EEPROM.write(1, height);
       delay(100);
    }    
    
    else if (inString[0] == 'e') {
     emergencyPhone = (inString.substring(2)).toInt();
     
     delay(100);
     EEPROM.write(2, emergencyPhone);
     delay(100);
    }
    
    else if (inString[0] == 'n') {
      notificationType = (inString.substring(2)).toInt();
      delay(100);
      EEPROM.write(3, notificationType);
      delay(100);
    }

   else if (inString[0] == 'm'){
      int counter = 0;
      while (true){
        while (!Serial);            // wait for serial port to connect. Needed for native USB port only
        getTFminiData(&distance, &strength);    //we read from sensor into distance   
        if (counter == 11520){
          Serial.println(" D" + String(distance));
          Serial.println("S" + String(strength));
          Serial.println("I" + String(initDistance));
          
          counter = 0;
        }
        counter++;
      }
    }
    else if (inString[0] == 's'){
      break;
    }
  }
} 
   
void calculateInitDistance()
{
  float angle_rad = (angle * PI) / 180;       //convert degrees to radians
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

void getVariables(){
  //get global variables values from EEPROM
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

  analogWrite(redPin,0);    //confirmation light
  analogWrite(bluePin,0);
  analogWrite(greenPin,200);
  delay(300);
  analogWrite(redPin,0);    //confirmation light OFF
  analogWrite(bluePin,0);
  analogWrite(greenPin,0);
}
  
