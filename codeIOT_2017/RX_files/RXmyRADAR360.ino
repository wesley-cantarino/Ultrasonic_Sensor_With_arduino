#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"

int DICE[2];

RF24 radio(7,8);

const byte address[6] = "00001";

void setup(void){
  Serial.begin(9600);
  radio.begin();
  radio.openReadingPipe(0, address);
  radio.setPALevel(RF24_PA_HIGH);
  radio.startListening();
}

void loop(void){
  if ( radio.available() ){
    teste();

    /*radio.read( DICE, sizeof(DICE) );  
    Serial.print(DICE[0]);
    Serial.print(",");
    Serial.print(DICE[1]);
    Serial.print(".");  //tirar ln*/
  }  
}

int teste(){
  radio.read( DICE, sizeof(DICE) );  
  
  Serial.print(DICE[0]);
  Serial.print(" ");
  Serial.println(DICE[1]);
}
