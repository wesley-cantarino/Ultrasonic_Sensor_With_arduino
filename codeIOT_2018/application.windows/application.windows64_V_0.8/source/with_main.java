import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import peasy.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class with_main extends PApplet {


ControlP5 cp5;

PImage main_photo;

ChildApplet child;

public void settings() {
  size(600, 400);
}

public void setup (){
  surface.setTitle("Main");

  colorMode(HSB);
  main_photo = loadImage("main_photo.png");
  cp5 = new ControlP5(this);

  cp5.addButton("button1")
     .setLabel("Start 3D")
     .setPosition(50, height/4 - 20)
     .setSize(200, 40)
     .setColorLabel(0xffffffff)
     .setFont(createFont("Arial", 20))
     .setColorBackground(0xff7d2090)
     .setColorForeground(0xffc432e2)
     .setColorActive(0xff4a1255);

  cp5.addButton("button2")
      .setLabel("Serial port")
      .setPosition(50, height/2 - 20)
      .setSize(200, 40)
      .setColorLabel(0xffffffff)
      .setFont(createFont("Arial", 20))
      .setColorBackground(0xff7d2090)
      .setColorForeground(0xffc432e2)
      .setColorActive(0xff4a1255);

  cp5.addButton("button3")
     .setLabel("configuration")
     .setPosition(50, height - height/4 - 20)
     .setSize(200, 40)
     .setColorLabel(0xffffffff)
     .setFont(createFont("Arial", 20))
     .setColorBackground(0xff7d2090)
     .setColorForeground(0xffc432e2)
     .setColorActive(0xff4a1255);
}

public void draw (){
  background(0xff161515);
  image(main_photo, 270, 62);
}

public void button1 (){
  println("Pressed button1");

  child = new ChildApplet();
}

public void button2 (){
  println("Pressed button2");
}

public void button3 (){
  println("Pressed button3");
}
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  
  PeasyCam cam;

  /*-------------------------------*/
  
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

  public void settings() {
    size(1024, 600, P3D);
  }

  public void setup() {
    surface.setTitle("Graf 3D");

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

  public void draw() {
    while(myPort.available() > 0){
      data = myPort.readStringUntil(';');
      data = data.substring(0,data.length()-1);

      index1 = data.indexOf(",");
      one = data.substring(0, index1);
      dado = data.substring(index1+1, data.length());

      tipo = PApplet.parseInt(one);
      DADO = PApplet.parseInt(dado);

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

    background(0xff061418);

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
          text(PApplet.parseInt(map(i, 0, 19, 2, 200)), kk - 20, 50);
          kk += 10;
        }
      popMatrix();
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "with_main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
