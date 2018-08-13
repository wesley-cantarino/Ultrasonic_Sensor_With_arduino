import controlP5.*;
ControlP5 cp5;

PImage main_photo;

ChildApplet child;

void settings() {
  size(600, 400);
}

void setup (){
  surface.setTitle("Main");

  colorMode(HSB);
  main_photo = loadImage("main_photo.png");
  cp5 = new ControlP5(this);

  cp5.addButton("button1")
     .setLabel("Start 3D")
     .setPosition(50, height/4 - 20)
     .setSize(200, 40)
     .setColorLabel(#ffffff)
     .setFont(createFont("Arial", 20))
     .setColorBackground(#7d2090)
     .setColorForeground(#c432e2)
     .setColorActive(#4a1255);

  cp5.addButton("button2")
      .setLabel("Serial port")
      .setPosition(50, height/2 - 20)
      .setSize(200, 40)
      .setColorLabel(#ffffff)
      .setFont(createFont("Arial", 20))
      .setColorBackground(#7d2090)
      .setColorForeground(#c432e2)
      .setColorActive(#4a1255);

  cp5.addButton("button3")
     .setLabel("configuration")
     .setPosition(50, height - height/4 - 20)
     .setSize(200, 40)
     .setColorLabel(#ffffff)
     .setFont(createFont("Arial", 20))
     .setColorBackground(#7d2090)
     .setColorForeground(#c432e2)
     .setColorActive(#4a1255);
}

void draw (){
  background(#161515);
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
