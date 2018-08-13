class ChildApplet extends PApplet {
  public ChildApplet (){
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  import peasy.*;
  PeasyCam cam;

  /*-------------------------------*/
  String one ="";
  String dado ="";
  String data="";
  int index1=0;

  int tipo, DADO;
  /*-------------------------------*/
  float dist;

  //float [] alfa_DB = new float [931];
  //float [] beta_DB = new float [931];
  //float [] dist_DB = new float [931];
  PVector [] dice_ard_DB = new PVector [1000];

  //float [] dice_x = new float [931];
  //float [] dice_y = new float [931];
  //float [] dice_z = new float [931];
  PVector [] dice = new PVector [1000];

  float [] colores = new float [1000];

  int number = 0;
  /*-------------------------------*/

  public void settings (){
    size(1024, 600, P3D);
    smooth(3);
  }

  public void setup (){
    surface.setTitle("Graf 3D");

    for (int i = 0; i < 1000; i++){
      dice_ard_DB[i] = new PVector(0, 0, 0);
      dice[i] = new PVector(0, 0, 0);
    }

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

        tipo = int(one);
        DADO = int(dado);

        if(tipo == 1){
          alfa = DADO;
          dice_ard_DB[number].x = alfa;
        }

        if(tipo == 2){
          beta = DADO;
          dice_ard_DB[number].y = beta;
        }

        if(tipo == 3){
          dist = /*2**/DADO;

          dice_ard_DB[number].z = dist/**2*/;
          //dice_x[number] = dist * cos(radians(alfa)) * cos(radians(beta));
          //dice_y[number] = dist * cos(radians(alfa)) * sin(radians(beta));
          //dice_z[number] = dist * sin(radians(alfa));
          dice[number].x = dist * cos(radians(alfa)) * cos(radians(beta));
          dice[number].y = dist * cos(radians(alfa)) * sin(radians(beta));
          dice[number].z = dist * sin(radians(alfa));


          colores[number] = map(dist/*/2*/, 2, 400, 0, 255);
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
      if((dist_max >= dice_ard_DB[i].z) &&
         (dice_ard_DB[i].x <= angle_alfa_max) &&
         (angle_alfa_min <= dice_ard_DB[i].x) &&
         (dice_ard_DB[i].y <= angle_beta_max) &&
         (angle_beta_min <= dice_ard_DB[i].y))
      {
        pushMatrix();
          //translate(dice_x[i], dice_y[i], dice_z[i]);
          translate(dice[i].x, dice[i].y, dice[i].z);
          fill(colores[i], 255, 255);
          sphere(5);
        popMatrix();
      }
    }

    if(display_dist){
      if(sliderValue < 150){
        fill(#ffffff);
        stroke(#ffffff);
      }
      else {
        fill(#000000);
        stroke(#000000);
      }
      line(0, 0, 0, 430, 0,   0);
      text("X", 430, 0, 0);
      line(0, 0, 0, 0, 430,   0);
      text("Y", 0, 430, 0);
      line(0, 0, 0, 0,   0, 430);
      text("Z", 0, 0, 430);
      noStroke();

      int k = 0;
      int kk = 50;
      textSize(40);
      textAlign(RIGHT, CENTER);

      for (int i = 0; i < 20; i++){
        pushMatrix();
          translate(k - 400, 500);
          fill(int(map(i, 0, 19, 0, 255)), 255, 255);
          k += 40;
          box(40);

          if (i == 0){
            for (int j = 0; j < 8; j++){
              text(int(map(j, 0, 7, 0, 400)), map(j, 0, 8, -40, 960), 50);
            }
          }
        popMatrix();
      }
    }
  }
}
