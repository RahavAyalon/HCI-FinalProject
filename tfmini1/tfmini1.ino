#include <SoftwareSerial.h>
#include "TFMini.h"
TFMini tfmini;


int redPin = 11; //select the pin for the red LED
int bluePin =13; // select the pin for the  blue LED
int greenPin =12;// select the pin for the green LED 
int val;

//float cyclicArray[32];
float currentAverage = 0;
float lastAverage = 0;
int counter = 0;
int changeCounter = 0;                //how many times the 
float LR = 0.1;

float angle = 45;          //angel (in degrees) of the sensor
float hight = 61;          //hight (in cm) of the sensor
float initDistance;   //expected diagonal distance based on the angle and hight 

SoftwareSerial SerialTFMini(2, 3);          //The only value that matters here is the first one, 2, Rx
 
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

void calculateInitDistance()
{
  float angle_rad = (angle * PI) / 180;       //convert degrees to radians
  initDistance = hight * (1 / cos(angle_rad));
}
 
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

  float distance = 0;
  float strength = 0;
  for (int i = 31; 0 < i; i--) {           //we initilize reference average
    getTFminiData(&distance, &strength);    //we read from sensor into distance
    while (!distance)
    {
      getTFminiData(&distance, &strength);
    }
    lastAverage += (distance / 32);   
  }

  calculateInitDistance();

  analogWrite(redPin, 0);
  analogWrite(bluePin, 0);
  analogWrite(greenPin, 200);
  delay(1000);
  analogWrite(redPin, 0);
  analogWrite(bluePin, 0);
  analogWrite(greenPin, 0);
}
 
void loop()
{
  float distance = 0;
  float strength = 0;

  getTFminiData(&distance, &strength);    //we read from sensor into distance
  while (!distance)
  {
    getTFminiData(&distance, &strength);
  }
  
//  Serial.println(counter);
  Serial.println(distance);

  
//  Serial.print("cm\t");
//  Serial.print("strength: ");
//  Serial.println(strength);
  
//  for (int i = 31; 0 < i; i--) {        //we shift all vals in cyclicArray to the right
//    cyclicArray[i] = cyclicArray[i-1];
//  }
    
//  cyclicArray[0] = distance;          //insert distance measurment into first cell of cyclicArray
//  currentAverage += float(distance >> five);    //LSH 5 = divide by 32  


  currentAverage += distance / 32;     
  counter++;                          //update counter
       
  if (counter == 32){
      counter = 0;                     //we reset counter to refill cyclicArray once again

      Serial.print("current ");
      Serial.println(currentAverage,0);
      Serial.print("last ");
      Serial.println(lastAverage,0);
      Serial.print("init ");
      Serial.println(initDistance,0);

 

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
       if (lastAverage + 40 < currentAverage){   //there is a diviation above the tolorance
        if (changeCounter == 4){
          analogWrite(redPin,200);
          analogWrite(bluePin,0);
          analogWrite(greenPin,0);
          delay(3000);
          analogWrite(redPin,0);
          analogWrite(bluePin,0);
          analogWrite(greenPin,0);
          
          changeCounter = 0;                  //check if we want to reset or not
//          currentAverage = 0;
        }
        else{                                //there is change but still uncertain
          changeCounter++;
//          currentAverage = 0;
        }
        
       }
      else{                                //change is within tolorance - we increase last
        lastAverage += (currentAverage - lastAverage) * LR;
//        currentAverage = 0;
        changeCounter = 0;
      }
     currentAverage = 0;
     }

     else if(lastAverage > currentAverage and lastAverage > initDistance - 1){      //we decrease last gradually until we get to init
       lastAverage -= (lastAverage - initDistance) * LR;    //we decrease last against current  
       currentAverage = 0;

     }    
}
}
