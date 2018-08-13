void serial_port (){
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

void draw_dice (){
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
