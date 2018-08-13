void configuration (){
  fill(#3e3e3e);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(15);

  rect(575, 5, 20, 375);

  float perct = map(alfa, 0, 180, 0, 375);
  int perct_100 = int(map(perct, 0, 375, 0, 100));

  fill(#ab25c6);
  rect(575, 5, 20, perct);
  text(perct_100 + "%", 555, perct + 5);

  fill(#ffffff);
  text("s\nc\na\nn\nn\ne\nr", 585, 192);

  fill(#924ca1);
  if (((angle_alfa_min > angle_alfa_max) ||
     ((angle_beta_min > angle_beta_max))) &&
      (!go_up_dice))
    text("angle min do not can > angle max", 165, 110);
}

void up_dice_function (){
  println("bhee");
}
