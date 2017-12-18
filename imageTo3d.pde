import processing.video.*;

float rotX, rotZ;

int wid = 100, hei = 100;
Capture camera;

void setup() {
  size(600, 600, P3D);
  noFill();
  stroke(0);
  camera = new Capture(this, 640, 480);
  camera.start();
}

void draw() {
  background(0);

  pushMatrix(); 
  translate(width/2, height/2, 0);  //基準点を画面中央。z軸方向には-100

  camera(90.0, -100.0, 300.0, // 視点X, 視点Y, 視点Z
    10.0, 0.0, 20.0, // 中心点X, 中心点Y, 中心点Z
    0.0, 1.0, 0.0); // 天地X, 天地Y, 天地Z

  rotateY(rotX); 
  rotateX(rotZ);

  if (camera.available()) {
    camera.read();
    pushMatrix();
    rotateX(PI/2);
    image(camera, 0, 0, wid, hei);
    popMatrix();
  }


  grid();

  colorMode(HSB);
  stroke(255);
  for (int i = 0; i < wid; i += 1) {
    for (int j = 0; j < hei; j += 1) {

      color c = camera.get(i * camera.width/wid, j * camera.height/hei);
      fill(c);
      noStroke();
      float h = wid * hue(c)/255;
      pushMatrix();
      translate(i, -h/2 - 1, j);
      box(1, -h, 1);
      popMatrix();
      //line(i, 0, j, i, -h, j);
    }
  }

  popMatrix();
}

void mouseDragged() {
  rotX +=  (mouseX - pmouseX) * 0.01;
  rotZ +=  (mouseY - pmouseY) * 0.01;
}

void grid() {
  strokeWeight(2);
  stroke(255, 0, 0);
  line(-1000, 0, 0, 1000, 0, 0);  // X軸 = 赤
  stroke(0, 255, 0);
  //line(0, -1000, 0, 0, 1000, 0);  // Y軸 = 緑
  stroke(0, 0, 255);
  line(0, 0, -1000, 0, 0, 1000);  // Z軸 = 青

  stroke(255, 50); 
  strokeWeight(1);
  for (int i = -1000; i < 1000; i+= 10) {
    line(-1000, 0, i, 1000, 0, i);
    line(i, 0, -1000, i, 0, 1000);
  }
}