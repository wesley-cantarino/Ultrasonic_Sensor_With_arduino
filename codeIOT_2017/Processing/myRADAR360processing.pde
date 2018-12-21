import processing.serial.*;
import java.io.IOException;
import java.awt.event.KeyEvent;

Serial myPort;
PImage img;
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;

void setup(){
  //size(1360,760);            //Tamanho da tela 
  fullScreen();                //Tela toda
  smooth();
  myPort = new Serial(this, "COM4", 9600);
  myPort.bufferUntil('.');
  background(100, 200, 100);    
}


void draw(){
   noStroke();
   fill(0,4); 
   rect(0, 0, width, height-height*0.00001);
   fill(98,245,31);
   
   drawRadar();
   drawLine();
   //iDistance = 67;      //para teste
   drawObject();      
   drawText();
}


void serialEvent (Serial myPort) {
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); 
  angle= data.substring(0, index1);
  distance= data.substring(index1+1, data.length());
  
  iAngle = int(angle);
  iDistance = int(distance);
}


void drawRadar() {
  pushMatrix();
  translate(663, 384);           //centro      
  noFill();
  strokeWeight(2);
  stroke(250,250,250);           //Branco
  
  // draws the arc lines
  arc(0,0,690,690,PI,2*TWO_PI);
  arc(0,0,460,460,PI,2*TWO_PI);
  arc(0,0,230,230,PI,2*TWO_PI);
  
  stroke(250,250,250);          //Branco
  
  // draws the angle lines
  line(-385,0,385,0);
  
  line(385*cos(radians(30)),385*sin(radians(30)),-385*cos(radians(30)),-385*sin(radians(30)));
  line(385*cos(radians(60)),385*sin(radians(60)),-385*cos(radians(60)),-385*sin(radians(60)));
  line(+385*cos(radians(120)),+385*sin(radians(120)),-385*cos(radians(120)),-385*sin(radians(120)));
  line(+385*cos(radians(150)),+385*sin(radians(150)),-385*cos(radians(150)),-385*sin(radians(150)));
  
  line(0,-365,0,365);
  popMatrix();
}

void drawLine(){
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);             //verde
  translate(663, 384);           //centro      
  line(0,0,(height-height*0.558)*cos(radians(iAngle)),-(height-height*0.558)*sin(radians(iAngle)));
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(663, 384);  // moves the starting coordinats to new location
  strokeWeight(15);
  stroke(255,10,10); // red color
  
  pixsDistance = iDistance*((height-height*0.558)/90);          // O max que pixsDistance pode ir é 500!!!
                                                                //X = (height-height*0.558) / 90
  
  if(iDistance <= 90){
  //line(500*cos(radians(iAngle)),-500*sin(radians(iAngle)),pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)), (height-height*0.558)*cos(radians(iAngle)), -(height-height*0.558)*sin(radians(iAngle)));
  //line(x1,y1,x2,y2);
  }
  popMatrix();
}

void drawText() {
  stroke(30,250,60);
  pushMatrix();  
  fill(98,245,31);
  rect(10,234,220,300);
  rect(1136,234,220,300);
  noStroke();
  fill(31,31,31);
  rect(10,234,220,300);
  rect(1136,234,220,300);
  
  if(iDistance > 90) {     
   noObject = "> 90cm";
  }
  else {
   noObject = "In Range";
  }
  
  fill(255,255,255); //color white
  textSize(25);
  text("Object: " + noObject,20,284);
  textSize(40);
  text("" + iAngle +"°", 80,392);
  
  textSize(30);
  text("Dist: ", 1138,392);
  textSize(40);
  text("" + iDistance +" cm", 1210, 392);
  
  textSize(20);
  text("30cm",780,420);
  text("60cm",895,420);
  text("90cm",1010,420);
   
  //fill(98,245,60); //verde
  fill(255,255,255); //branco
  textSize(25);
  
  translate(663, 384);
  text("0°",390,9);
  resetMatrix();
  
  translate(663, 384);
  text("180°",-420,-10);
  resetMatrix();
  
  translate(663, 384);
  text("90°",-16,-365);
  resetMatrix();
  
  translate(663, 384);
  text("270°",-25,382);
  resetMatrix();
  
  translate(663, 384);
  text("30°",320,-200);
  resetMatrix();
  
  translate(663, 384);
  text("150°",-368,-200);
  resetMatrix();
  
  translate(663, 384);
  text("210°",-380,220);
  resetMatrix();
  
  translate(663, 384);
  text("330°",320,220);
  resetMatrix();
  
  translate(663, 384);
  text("60°",180,-340);
  resetMatrix();
  
  translate(663, 384);
  text("120°",-220,-340);
  resetMatrix();
  
  translate(663, 384);
  text("240°",-220,360);
  resetMatrix();
  
  translate(663, 384);
  text("300°",180,360);
  resetMatrix();
  
  popMatrix();
}