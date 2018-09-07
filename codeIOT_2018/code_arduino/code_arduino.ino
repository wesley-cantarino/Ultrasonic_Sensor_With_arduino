#include <Servo.h>
#include <Ultrasonic.h>

/*-----------SERVO-----------*/
const int Ser1 = 9; //angle alpha servo cabeca
Servo ser1;

const int Ser2 = 10; //angle beta servo base
Servo ser2;
/*---------------------------*/

/*-----------ULTRA-----------*/
#define TRIGGER_PIN  2
#define ECHO_PIN     3

Ultrasonic ultrasonic(TRIGGER_PIN, ECHO_PIN);

float dist;
long times;
/*---------------------------*/

int down_alfa, down_beta, down_delay = 500;
boolean down = false;

int beta_min = 30, beta_max = 50;
int alfa_min = 30, alfa_max = 50;
/*---------------------------*/

void processing (int alfa, int beta){
  Serial.print("1");
  Serial.print(",");
  Serial.print(alfa);
  Serial.print(";");

  Serial.print("2");
  Serial.print(",");
  Serial.print(beta);
  Serial.print(";");

  Serial.print("3");
  Serial.print(",");
  //dist = k;
  Serial.print(dist);
  Serial.print(";");
}

void calcDIST (){
  times = ultrasonic.timing();
  dist = ultrasonic.convert(times, Ultrasonic::CM);
  dist = constrain(dist, 2, 400);
}

void go (int alfaAUX, int betaAUX, int tempo){
  int beta = beta_min;

  for(int alfa = alfa_min; alfa <= alfa_max; alfa = alfa + alfaAUX){
    alfa = constrain(alfa, alfa_min, alfa_max);
    ser1.write(alfa);

    if(alfa != 90){
      if(beta <= beta_min){
        while(beta <= beta_max){
          beta = constrain(beta, beta_min, beta_max);
          ser2.write(beta);
          delay(tempo);

          calcDIST();
          processing(alfa, beta);

          beta = beta + betaAUX;
        }
      }
      else {
        while(beta >= beta_min){
          beta = constrain(beta, beta_min, beta_max);
          ser2.write(beta);
          delay(tempo);

          calcDIST();
          processing(alfa, beta);

          beta = beta - betaAUX;
        }
      }
    }
  }
}

void setup (){
  Serial.begin(115200);

  ser1.attach(Ser1);
  ser2.attach(Ser2);
}

void leitura (){
  if (Serial.available() > 0){
    delay(100);

    while(Serial.available() > 0){
      down_alfa = Serial.read();
      down_beta = Serial.read();
      //down_delay = Serial.read(); //esta com erro

      down = true;
    }
  }
}

void loop (){
  leitura();

  if (down == true){
    go(down_alfa, down_beta, down_delay);
    /*down_delay = 1000;
    ser1.write(down_alfa);
    delay(down_delay);
    ser1.write(0);
    delay(down_delay);

    ser2.write(down_beta);
    delay(down_delay);
    ser2.write(0);
    delay(down_delay);*/

    down = false;
  }
}
