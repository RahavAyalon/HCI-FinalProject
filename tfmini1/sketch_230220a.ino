int angle = 100;
int height = 100;
int emergencyDialSettings = 523456789;
String notificationType = "vibration";

int redPin = 11; //select the pin for the red LED
int greenPin =12;// select the pin for the green LED 
int bluePin =13; // select the pin for the  blue LED


void setup() {
  pinMode(11, OUTPUT);   //set pin as output , blue led
  pinMode(12, OUTPUT);   //set pin as output , red led
  pinMode(13, OUTPUT);   //set pin as output , yellow led
  Serial.begin(9600);    //start serial communication @9600 bps
}

void loop(){
  if(Serial.available()){  //id data is available to read
    String inString = Serial.readStringUntil('*');
    Serial.println(inString);
    if (inString[0] == 'a') {
      angle = (inString.substring(2)).toInt();
      analogWrite(redPin,200);
      analogWrite(bluePin,0);
      analogWrite(greenPin,0);
      
      delay(1000);
      Serial.print(inString.substring(2).toInt());
    }
    else if (inString[0] == 'h') {
      height = (inString.substring(2)).toInt();
    }    
    else if (inString[0] == 'e') {
      emergencyDialSettings = (inString.substring(2)).toInt();
    }
    else if (inString[0] == 'n') {
      notificationType = inString.substring(2);
    }
    //      digitalWrite(11, HIGH);
//    if(inString.equals("sonto")){ 
//      digitalWrite(11, HIGH);   // turn the LED on (HIGH is the voltage level)
    }  
  
}
