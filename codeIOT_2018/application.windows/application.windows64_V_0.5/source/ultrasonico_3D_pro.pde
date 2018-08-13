import peasy.*;
PeasyCam cam;

/*-------------------------------*/
import processing.serial.*;
Serial myPort;

String one ="";
String dado ="";
String data="";
int index1=0;

int tipo, DADO;
/*-------------------------------*/

float dist;
int alfa, beta;

float [] dice_x = new float [931];
float [] dice_y = new float [931];
float [] dice_z = new float [931];
float [] colores = new float [931];

int number = 0;
/*-------------------------------*/
ChildApplet child;

void settings() {
  size(1024, 600, P3D);
}

void setup (){
  surface.setTitle("graf_3D");
  child = new ChildApplet();

  colorMode(HSB);
  fill(255);
  noStroke();
  lights();

  cam = new PeasyCam(this, width);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);

  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil(';');
}

void draw (){
  while(myPort.available() > 0){
    data = myPort.readStringUntil(';');
    data = data.substring(0,data.length()-1);

    index1 = data.indexOf(",");
    one = data.substring(0, index1);
    dado = data.substring(index1+1, data.length());

    tipo = int(one);
    DADO = int(dado);

    if(tipo == 1){
      alfa = DADO;
    }
    if(tipo == 2){
      beta = DADO;
    }
    if(tipo == 3){
      dist = 2 * DADO;

      dice_x[number] = dist * cos(radians(alfa)) * cos(radians(beta));
      dice_y[number] = dist * cos(radians(alfa)) * sin(radians(beta));
      dice_z[number] = dist * sin(radians(alfa));

      colores[number] = map(dist/2, 2, 200, 0, 200);
      number++;
    }
  }

  background(7, 13, 22);

  sphere(5);
  for(int i = 0; i < number; i++){
    pushMatrix();
      translate(dice_x[i], dice_y[i], dice_z[i]);
      fill(colores[i], 255, 255);
      sphere(5);
    popMatrix();
  }

  int k = 0;
  int kk = 0;
  textSize(40);
  textAlign(CENTER, CENTER);

  for(int i = 0; i < 20; i++){
    pushMatrix();
      translate(k - 400, 500);
      fill(map(i, 0, 19, 0, 200), 255, 255);
      k += 40;
      box(40);
      if(i % 2 == 0){
        text(int(map(i, 0, 19, 2, 200)), kk - 20, 50);
        kk += 10;
      }
    popMatrix();
  }
}

class ChildApplet extends PApplet {
  //JFrame frame;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(300, 300);
  }
  public void setup() {
    surface.setTitle("information");
    textSize(18);
    textAlign(LEFT, CENTER);
  }

  public void draw() {
    background(7, 13, 22);

    text("angle alfa: " + alfa, 20, 20);
    text("angle beta: " + beta, 20, 135);
    text("dist: " + dist/2, 20, 260);
  }
}
