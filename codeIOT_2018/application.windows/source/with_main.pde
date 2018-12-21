import controlP5.*;
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

import processing.serial.*;
Serial myPort;
int transX = 50;
int transY = 100;
int select = 0;
int selectAUX = 0;
String conect_now = "";
boolean conect = false;
boolean go = false;

void settings (){
  size(600, 400);
}

void setup (){
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

void draw (){
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

void create_button (){
  slider_color.addSlider("sliderValue")
              .setLabel("")
              .setPosition(width - 100, height - 10)
              .setRange(0, 245)
              .setColorBackground(#7d2090)
              .setColorForeground(#c432e2)
              .setColorActive(#4a1255);

  before.addButton("before")
        .setPosition(5, 5)
        .setSize(70, 25)
        .setFont(createFont("Arial", 15))
        .setColorBackground(#7d2090)
        .setColorForeground(#c432e2)
        .setColorActive(#4a1255);

  main_button.addButton("button1")
             .setLabel("Start 3D")
             .setPosition(50, height/4 - 20)
             .setSize(200, 40)
             .setColorLabel(#ffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(#7d2090)
             .setColorForeground(#c432e2)
             .setColorActive(#4a1255);

  main_button.addButton("button2")
             .setLabel("Serial port")
             .setPosition(50, height/2 - 20)
             .setSize(200, 40)
             .setColorLabel(#ffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(#7d2090)
             .setColorForeground(#c432e2)
             .setColorActive(#4a1255);

  main_button.addButton("button3")
             .setLabel("configuration")
             .setPosition(50, height - height/4 - 20)
             .setSize(200, 40)
             .setColorLabel(#ffffff)
             .setFont(createFont("Arial", 20))
             .setColorBackground(#7d2090)
             .setColorForeground(#c432e2)
             .setColorActive(#4a1255);

  comand_serial_port.addButton("connect")
                    .setPosition(180 + transX, 0 + transY)
                    .setSize(200, 40)
                    .setColorLabel(#ffffff)
                    .setFont(createFont("Arial", 20))
                    .setColorBackground(#7d2090)
                    .setColorForeground(#c432e2)
                    .setColorActive(#4a1255);

  comand_serial_port.addButton("disconnect")
                    .setPosition(180 + transX, 60 + transY)
                    .setSize(200, 40)
                    .setColorLabel(#ffffff)
                    .setFont(createFont("Arial", 20))
                    .setColorBackground(#7d2090)
                    .setColorForeground(#c432e2)
                    .setColorActive(#4a1255);

  comand_serial_port.addButton("plus_left")
                    .setLabel("<")
                    .setPosition(-10 + transX, transY)
                    .setSize(10, 100)
                    .setColorLabel(#ffffff)
                    .setFont(createFont("Arial", 14))
                    .setColorBackground(#7d2090)
                    .setColorForeground(#c432e2)
                    .setColorActive(#4a1255);

  comand_serial_port.addButton("plus_right")
                    .setLabel(">")
                    .setPosition(150 + transX, transY)
                    .setSize(10, 100)
                    .setColorLabel(#ffffff)
                    .setFont(createFont("Arial", 14))
                    .setColorBackground(#7d2090)
                    .setColorForeground(#c432e2)
                    .setColorActive(#4a1255);

  conf.addToggle("display_dist")
      .setLabel("display info")
      .setPosition(20, 50)
      .setSize(80, 20)
      .setMode(Toggle.SWITCH)
      .setColorLabel(#924ca1)
      .setFont(createFont("Arial", 12))
      .setColorBackground(#3e3e3e)
      .setColorActive(#ab25c6);

  conf.addSlider("dist_max")
      .setCaptionLabel("dist max")
      .setPosition(150, 50)
      .setSize(300, 20)
      .setRange(2, 200)
      .setValue(200)
      .setFont(createFont("Arial", 15))
      .setColorLabel(#924ca1)
      .setColorBackground(#3e3e3e)
      .setColorForeground(#ab25c6)
      .setColorActive(#c432e2);

  conf.addKnob("angle_alfa_max")
      .setLabel("angle alfa max")
      .setPosition(30, 130)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(180)
      .setFont(createFont("Arial", 15))
      .setColorLabel(#924ca1)
      .setColorBackground(#3e3e3e)
      .setColorForeground(#ab25c6)
      .setColorActive(#c432e2);

  conf.addKnob("angle_beta_max")
      .setLabel("angle beta max")
      .setPosition(200, 130)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(180)
      .setFont(createFont("Arial", 15))
      .setColorLabel(#924ca1)
      .setColorBackground(#3e3e3e)
      .setColorForeground(#ab25c6)
      .setColorActive(#c432e2);

  conf.addKnob("angle_alfa_min")
      .setLabel("angle alfa min")
      .setPosition(30, 260)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(0)
      .setFont(createFont("Arial", 15))
      .setColorLabel(#924ca1)
      .setColorBackground(#3e3e3e)
      .setColorForeground(#ab25c6)
      .setColorActive(#c432e2);

  conf.addKnob("angle_beta_min")
      .setLabel("angle beta min")
      .setPosition(200, 260)
      .setSize(100, 15)
      .setRange(0, 180)
      .setValue(0)
      .setFont(createFont("Arial", 15))
      .setColorLabel(#924ca1)
      .setColorBackground(#3e3e3e)
      .setColorForeground(#ab25c6)
      .setColorActive(#c432e2);
}
