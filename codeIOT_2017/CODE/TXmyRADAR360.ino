#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include <Servo.h>
#define ANmax 180  //angulo maximo
#define ANmin 0   //angulo minimo
Servo Servo1;
Servo Servo2;

const int SERVO1 = 10; //azul
const int SERVO2 = 9;  //preto

const int trigPin = 3;
const int echoPin = 2;
const int trigPin2 = 5;
const int echoPin2 = 4;
long duration;
float distance;

int DICE[2];
RF24 radio(7,8);
const byte address[6] = "00001";

void setup(void){
  Servo1.attach(SERVO1);
  Servo2.attach(SERVO2);
  pinMode(trigPin, OUTPUT);
  pinMode(trigPin2, OUTPUT);
  Serial.begin(9600);
  radio.begin();
  radio.openWritingPipe(address);
  radio.setPALevel(RF24_PA_MIN);
  radio.stopListening();
}

void loop(){
  teste();
  /*for(int a = 0; a <= 180; a++){
    Servo1.write(a);
    delay(15);
    DICE[0] = a;
    DICE[1] = funDIST1();
    radio.write( DICE, sizeof(DICE) ); 
  }
  
  for(int a = 1; a <= 180; a++){
    Servo2.write(a);
    delay(15);
    DICE[0] = a + 180;
    DICE[1] = funDIST2();
    radio.write( DICE, sizeof(DICE) ); 
  }*/
}

int teste(){
  DICE[0] = 1;
  DICE[1] = 4;
  radio.write( DICE, sizeof(DICE) ); 
  delay(50); 
}

float funDIST1(){
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); 
  distance= duration*0.034/2;
  distance = constrain(distance, 2, 400);
  return distance;
}

float funDIST2(){
  digitalWrite(trigPin2, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin2, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);
  duration = pulseIn(echoPin2, HIGH); 
  distance= duration*0.034/2;
  distance = constrain(distance, 2, 400);
  return distance;
}
