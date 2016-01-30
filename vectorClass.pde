
// = new PVector(width/2, random(100));
// ADD
Vst v;
Star star;
PVector hello; // starting position of stars

ArrayList<Star> shootingS = new ArrayList<Star> ();
ArrayList<Flower> bouquet = new ArrayList<Flower>();

void setup() {
  //ADD
  size(600, 512, P2D);
  v = new Vst(this, createSerial());
  blendMode(ADD);   // lines brighter where they overlap
  noFill();   // don't fill in shapes
  stroke(212, 128, 32, 128);  // (r,g,b,alpha) for lines
  frameRate(25);
}

void draw() {
  background(0);
  stroke(100);

  pushMatrix();
  translate(mouseX, mouseY);
  for (int i = 0; i < 3; i++) {
    rotate(PI/3);
    line(-5, 0, 5, 0);
  }
  popMatrix();
  // set starting position of each star
  hello = new PVector(-random(width/8), random(height/4, height));
  if (floor(random(10)) == 0) {
    // set population starting location
    //Star(PVector inCenter, float inRadius)
    shootingS.add(new Star(hello, random(5, 20)));
  }

  for (int i = 0; i < shootingS.size(); i++) {
    Star group = shootingS.get(i);
    // after a period of time, remove the star from the array list
    if (group.age > 150) {
      shootingS.remove(group);
    } else {

      group.display();
      group.update();
    }
  }

  // draw a cursor

  //int test = random(9);
  if (floor(random(40)) == 0) {
    // (xpos, ypos, num_petals, scale_size[0.5, 1.5], rotation_rate[-0.2, 0.2])
    bouquet.add(new Flower(
      random(50, 500), 
      random(50, 550), 
      (int)ceil(random(5.1, 8.9)), 
      random(0.5, 1.5)));
  }

  for (int i = 0; i < bouquet.size(); i++) {
    Flower blossom = bouquet.get(i);
    if (blossom.age > 140) {
      bouquet.remove(blossom);
    } else {
      blossom.display();
    }
  }
  //ADD
  v.display();  // send the vectors to the board to be drawn
}

//ADD
void line(PVector p0, PVector p1)
{
  if (p0 == null || p1 == null)
    return;

  line(p0.x, p0.y, p1.x, p1.y);
}

void line(float x0, float y0, float x1, float y1)
{
  if (v.send_to_display)
  {
    super.line(x0, y0, x1, y1);
    return;
  }

  int s = g.strokeColor;
  boolean bright = red(s) == 255 && green(s) == 255 && blue(s) == 255;
  v.line(bright, x0, y0, x1, y1);
}


void ellipse(float x, float y, float rx, float ry)
{
  // Deduce how long r is in real pixels
  float r = abs(modelX(0, 0, 0) - modelX((rx+ry), 0, 0));
  int steps = 30; //(int)(r / 5);
  float dtheta = 2 * PI / steps;
  float theta = dtheta;
  float x0 = rx;
  float y0 = 0;

  for (int i = 0; i < steps; i++, theta += dtheta)
  {
    float x1 = rx * cos(theta);
    float y1 = ry * sin(theta);
    line(x + x0, y + y0, x + x1, y + y1);
    x0 = x1;
    y0 = y1;
  }
}