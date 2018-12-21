import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import processing.serial.*; 
import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class with_main extends PApplet {


ControlP5 main_button;
ControlP5 slider_color;
ControlP5 before;
ControlP5 conf;

int sliderValue = 25;
boolean display_dist = true;
int dist_max = 200;
int angle_alfa_max, angle_alfa_min, angle_beta_max, angle_beta_min;

ControlP5 comand_serial_port;

PImage main_photo;

ChildApplet windows_star_3d;
boolean windows_star_3d_open = false;
int alfa, beta;

boolean play_button_2 = false;
boolean play_button_3 = false;


Serial myPort;
int transX = 50;
int transY = 100;
int select = 0;
int selectAUX = 0;
String conect_now = "";
boolean conect = false;
boolean go = false;

public void settings (){
  size(600, 400);
}

public void setup (){
  surface.setTitle("Main");

  colorMode(HSB);
  main_photo = loadImage("main_photo.png");
  main_button = new ControlP5(this);
  slider_color = new ControlP5(this);
  before = new ControlP5(this);
  comand_serial_port = new ControlP5(this);
  conf = new ControlP5(this);

  create_button();
}

public void draw (){
  colorMode(RGB);
  background(sliderValue, sliderValue, sliderValue + 10);
  colorMode(HSB);

  if (play_button_2){
    before.setVisible(true);
    comand_serial_port.setVisible(true);
    main_button.setVisible(false);
    conf.setVisible(false);

    serial_port();
  }

  else if (play_button_3){
    before.setVisible(true);
    conf.setVisible(true);
    comand_serial_port.setVisible(false);
    main_button.setVisible(false);

    configuration();
  }

  else{
    before.setVisible(false);
    conf.setVisible(false);
    comand_serial_port.setVisible(false);
    main_button.setVisible(true);

    image(main_photo, 270, 62);
  }
}

public void button1 (){
  if(!windows_star_3d_open){
    windows_star_3d = new ChildApplet();
    windows_star_3d_open = true;
  }
}

public void button2 (){
  play_button_2 = true;
  play_button_3 = false;
}

public void button3 (){
  play_button_3 = true;
  play_button_2 = false;
}

public void before (){
  play_button_3 = false;
  play_button_2 = false;
}

public void connect (){
  if((select != 0) && (!conect)){
    myPort = new Serial(this, Serial.list()[select - 1], 115200);
    myPort.bufferUntil(';');
    conect_now = Serial.list()[select - 1];
    conect = true;
    selectAUX = select;
    go = true;
  }

  if((conect) && (select != selectAUX) && (select != 0)){
    myPort.stop();
    myPort = new Serial(this, Serial.list()[select - 1], 115200);
    myPort.bufferUntil(';');
    conect_now = Serial.list()[select - 1];
    selectAUX = select;
    go = true;
  }
}

public void disconnect (){
  if(conect){
    conect = false;
    conect_now = "";
    myPort.stop();
  }
}

public void plus_left (){
  select -= 1;
}

public void plus_right (){
  select += 1;
}

public void create_button (){
  slider_color.addSlider("sliderValue")
              .setLabel("")
              .setPosition(width - 100, height - 10)
              .setRange(0, 245)
              .setColorBackground(0xff7d2090)
              .setColorForeground(0xffc432e2)
              .setColorActive(0xff4a1255);

  before.addButton("before")
        .setPosition(5, 5)
        .setSize(70, 25)
        .setFont(createFont("Arial", 15))
        .setColorBackground(0xff7d2090)
        .setColorForeground(0xffc432e2)
        .setColorActive(0xff4a1255);

  main_button.addButton("button1")
             .setLabel("Start 3D")
             .setPosition(50, height/4 - 20)
             .setSize(200, 40)
             .setColorLabel(0xffffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(0xff7d2090)
             .setColorForeground(0xffc432e2)
             .setColorActive(0xff4a1255);

  main_button.addButton("button2")
             .setLabel("Serial port")
             .setPosition(50, height/2 - 20)
             .setSize(200, 40)
             .setColorLabel(0xffffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(0xff7d2090)
             .setColorForeground(0xffc432e2)
             .setColorActive(0xff4a1255);

  main_button.addButton("button3")
             .setLabel("configuration")
             .setPosition(50, height - height/4 - 20)
             .setSize(200, 40)
             .setColorLabel(0xffffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(0xff7d2090)
             .setColorForeground(0xffc432e2)
             .setColorActive(0xff4a1255);

  comand_serial_port.addButton("connect")
                    .setPosition(180 + transX, 0 + transY)
                    .setSize(200, 40)
                    .setColorLabel(0xffffffff)
                    .setFont(createFont("Arial", 20))
                    .setColorBackground(0xff7d2090)
                    .setColorForeground(0xffc432e2)
                    .setColorActive(0xff4a1255);

  comand_serial_port.addButton("disconnect")
                    .setPosition(180 + transX, 60 + transY)
                    .setSize(200, 40)
                    .setColorLabel(0xffffffff)
                    .setFont(createFont("Arial", 20))
                    .setColorBackground(0xff7d2090)
                    .setColorForeground(0xffc432e2)
                    .setColorActive(0xff4a1255);

  comand_serial_port.addButton("plus_left")
                    .setLabel("<")
                    .setPosition(-10 + transX, transY)
                    .setSize(10, 100)
                    .setColorLabel(0xffffffff)
                    .setFont(createFont("Arial", 14))
                    .setColorBackground(0xff7d2090)
                    .setColorForeground(0xffc432e2)
                    .setColorActive(0xff4a1255);

  comand_serial_port.addButton("plus_right")
                    .setLabel(">")
                    .setPosition(150 + transX, transY)
                    .setSize(10, 100)
                    .setColorLabel(0xffffffff)
                    .setFont(createFont("Arial", 14))
                    .setColorBackground(0xff7d2090)
                    .setColorForeground(0xffc432e2)
                    .setColorActive(0xff4a1255);

  conf.addToggle("display_dist")
      .setLabel("display info")
      .setPosition(20, 50)
      .setSize(80, 20)
      .setMode(Toggle.SWITCH)
      .setColorLabel(0xff924ca1)
      .setFont(createFont("Arial", 12))
      .setColorBackground(0xff3e3e3e)
      .setColorActive(0xffab25c6);

  conf.addSlider("dist_max")
      .setCaptionLabel("dist max")
      .setPosition(150, 50)
      .setSize(300, 20)
      .setRange(2, 200)
      .setValue(200)
      .setFont(createFont("Arial", 15))
      .setColorLabel(0xff924ca1)
      .setColorBackground(0xff3e3e3e)
      .setColorForeground(0xffab25c6)
      .setColorActive(0xffc432e2);

  conf.addKnob("angle_alfa_max")
      .setLabel("angle alfa max")
      .setPosition(30, 130)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(180)
      .setFont(createFont("Arial", 15))
      .setColorLabel(0xff924ca1)
      .setColorBackground(0xff3e3e3e)
      .setColorForeground(0xffab25c6)
      .setColorActive(0xffc432e2);

  conf.addKnob("angle_beta_max")
      .setLabel("angle beta max")
      .setPosition(200, 130)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(180)
      .setFont(createFont("Arial", 15))
      .setColorLabel(0xff924ca1)
      .setColorBackground(0xff3e3e3e)
      .setColorForeground(0xffab25c6)
      .setColorActive(0xffc432e2);

  conf.addKnob("angle_alfa_min")
      .setLabel("angle alfa min")
      .setPosition(30, 260)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(0)
      .setFont(createFont("Arial", 15))
      .setColorLabel(0xff924ca1)
      .setColorBackground(0xff3e3e3e)
      .setColorForeground(0xffab25c6)
      .setColorActive(0xffc432e2);

  conf.addKnob("angle_beta_min")
      .setLabel("angle beta min")
      .setPosition(200, 260)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(0)
      .setFont(createFont("Arial", 15))
      .setColorLabel(0xff924ca1)
      .setColorBackground(0xff3e3e3e)
      .setColorForeground(0xffab25c6)
      .setColorActive(0xffc432e2);
}
public void configuration (){
  fill(0xff3e3e3e);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(15);

  rect(575, 5, 20, 375);

  float perct = map(alfa, 0, 180, 0, 375);
  int perct_100 = PApplet.parseInt(map(perct, 0, 375, 0, 100));

  fill(0xffab25c6);
  rect(575, 5, 20, perct);
  text(perct_100 + "%", 555, perct + 5);

  fill(0xffffffff);
  text("s\nc\na\nn\nn\ne\nr", 585, 192);

  fill(0xff924ca1);
  if ((angle_alfa_min > angle_alfa_max) ||
     ((angle_beta_min > angle_beta_max)))
    text("angle min do not can > angle max", 165, 110);
}
public void serial_port (){
  pushMatrix();
    translate(transX, transY);
    fill(250);
    stroke(0);
    textSize(17);
    textAlign(CENTER, CENTER);

    rect(-10, 0, 170, 100);
    rect(-10, 115, 390, 20, 5, 5, 5, 5);
    line(0, 30, 150, 30);

    fill(0);
    text("now:", 25, 15);

    draw_dice();

    textSize(12);
    text("<", -5, 50);
    text(">", 155, 50);
  popMatrix();
}

public void draw_dice (){
  int tam = Serial.list().length;

  if(tam == 0)
    select = 0;

  if(select > tam)
    select = 0;

  if(select < 0)
    select = tam;

  text("/" + tam, 135, 65);

  int i = 0;
  while(i < tam){
    text(Serial.list()[i], 25 + i*60, 123);
    i ++;
  }

  if(select != 0)
    text(Serial.list()[select - 1], 30, 65);
  else
    text("not select", 50, 65);

  text(conect_now, 85, 15);
}
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  
  PeasyCam cam;

  /*-------------------------------*/
  String one ="";
  String dado ="";
  String data="";
  int index1=0;

  int tipo, DADO;
  /*-------------------------------*/
  float dist;

  float [] alfa_DB = new float [931];
  float [] beta_DB = new float [931];
  float [] dist_DB = new float [931];
  float [] dice_x = new float [931];
  float [] dice_y = new float [931];
  float [] dice_z = new float [931];
  float [] colores = new float [931];

  int number = 0;
  /*-------------------------------*/

  public void settings (){
    size(1024, 600, P3D);
    smooth(3);
  }

  public void setup (){
    surface.setTitle("Graf 3D");

    colorMode(HSB);
    fill(255);
    noStroke();
    lights();

    cam = new PeasyCam(this, width);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(5000);

    if ((Serial.list().length != 0) && (!conect)){
      myPort = new Serial(this, Serial.list()[0], 115200);
      myPort.bufferUntil(';');
      go = true;
      conect_now = Serial.list()[0];
    }
  }

  public void draw() {
    if(go){
      while(myPort.available() > 0){
        data = myPort.readStringUntil(';');
        data = data.substring(0, data.length()-1);

        index1 = data.indexOf(",");
        one = data.substring(0, index1);
        dado = data.substring(index1+1, data.length());

        tipo = PApplet.parseInt(one);
        DADO = PApplet.parseInt(dado);

        if(tipo == 1){
          alfa = DADO;
          alfa_DB[number] = alfa;
        }

        if(tipo == 2){
          beta = DADO;
          beta_DB[number] = beta;
        }

        if(tipo == 3){
          dist = 2 * DADO;

          dist_DB[number] = dist/2;
          dice_x[number] = dist * cos(radians(alfa)) * cos(radians(beta));
          dice_y[number] = dist * cos(radians(alfa)) * sin(radians(beta));
          dice_z[number] = dist * sin(radians(alfa));

          colores[number] = map(dist/2, 2, 200, 0, 200);
          number++;
        }
      }
    }

    colorMode(RGB);
    background(sliderValue, sliderValue, sliderValue + 10);
    colorMode(HSB);

    fill(255);
    sphere(5);
    for(int i = 0; i < number; i++){
      if((dist_max >= dist_DB[i]) &&
         (alfa_DB[i] <= angle_alfa_max) &&
         (angle_alfa_min <= alfa_DB[i]) &&
         (beta_DB[i] <= angle_beta_max) &&
         (angle_beta_min <= beta_DB[i]))
      {
        pushMatrix();
          translate(dice_x[i], dice_y[i], dice_z[i]);
          fill(colores[i], 255, 255);
          sphere(5);
        popMatrix();
      }
    }

    if(display_dist){
      fill(0xffffffff);
      stroke(0xffffffff);
      line(0, 0, 0, 430, 0,   0);
      text("X", 430, 0, 0);
      line(0, 0, 0, 0, 430,   0);
      text("Y", 0, 430, 0);
      line(0, 0, 0, 0,   0, 430);
      text("Z", 0, 0, 430);
      noStroke();

      int k = 0;
      int kk = 0;
      textSize(40);
      textAlign(RIGHT, CENTER);

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
