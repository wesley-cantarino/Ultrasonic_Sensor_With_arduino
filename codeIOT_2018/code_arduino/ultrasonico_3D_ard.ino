#include <Servo.h>
#include <Ultrasonic.h>

/*-----------SERVO-----------*/
const int Ser1 = 9; //angle alpha //servo cabeca
Servo ser1;

const int Ser2 = 10; //angle beta //servo base
Servo ser2;
/*---------------------------*/

/*-----------ULTRA-----------*/
#define TRIGGER_PIN  2
#define ECHO_PIN     3

Ultrasonic ultrasonic(TRIGGER_PIN, ECHO_PIN);

float dist;
long times;
/*---------------------------*/
//int k = 2;
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
  /*k += 20;
  if (k > 400)
    k = 2;*/
}

void calcDIST (){
  times = ultrasonic.timing();
  dist = ultrasonic.convert(times, Ultrasonic::CM);
  dist = constrain(dist, 2, 400);
}

void go (int alfaAUX, int betaAUX, int tempo){
  int beta = 0;

  for(int alfa = 0; alfa <= 180; alfa = alfa + alfaAUX){
    alfa = constrain(alfa, 0, 180);
    ser1.write(alfa);
    if(alfa != 90){
      if(beta <= 0){
        while(beta <= 180){
          beta = constrain(beta, 0, 180);
          ser2.write(beta);
          delay(tempo);

          calcDIST();
          processing(alfa, beta);

          beta = beta + betaAUX;
        }
      }
      else {
        while(beta >= 0){
          beta = constrain(beta, 0, 180);
          ser2.write(beta);
          delay(tempo);

          calcDIST();
          processing(alfa, beta);

          beta = beta - betaAUX;
        }
      }
    }

    while(alfa == 180){
      //trava ard
    }
  }
}

void setup (){
  Serial.begin(115200);

  ser1.attach(Ser1);
  ser2.attach(Ser2);
}

void loop (){
  go(6, 6, 100);
}
