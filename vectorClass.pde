// vim: set ts=2 expandtab:
// Please don't move or dele the line above!  Thx, Holly

// = new PVector(width/2, random(100));
// ADD
Vst v;
Star star;
PVector hello; // starting position of stars
int caught = 0;

ArrayList<Star> starries = new ArrayList<Star> ();
ArrayList<Flower> garden = new ArrayList<Flower>();
ArrayList<Marker> markers = new ArrayList<Marker>();

void setup() {
  //ADD
  size(512, 600, P2D);
  v = new Vst(this, createSerial());
  blendMode(ADD);   // lines brighter where they overlap
  noFill();   // don't fill in shapes
  stroke(212, 128, 32, 128);  // (r,g,b,alpha) for lines
  frameRate(25);

  // populate the markers arraylist with all the markers
  for (int i = 1; i < 6; i++) {
    markers.add(new Marker(180 + (i * 30), 580));
  }
}


void draw() {
  background(0);
  stroke(100);

  
  for (int i = 0; i < markers.size(); i++) {
    Marker tic = markers.get(i);
    tic.display();
  }
	
  pushMatrix();
  // set the position of the mouse and net here
  PVector netPos = new PVector(width - 150, mouseY);
  translate(netPos.x, netPos.y);
  scale(1.5);
  // draw a net in place of the mouse;
  for (int i = 1; i < 10; i++) {
   //rotate(PI/2);
   //quad(0, 0, 80, 0, 5, -50,0, -50 );
   line(0, 0, 0, -25);
   PVector net = new PVector(0, -i * 2.5);
   PVector net2 = new PVector(i * 6, 0);
   PVector net3 = new PVector(i, - 3 / 8 * i - 25); 
   line(net2.x, net2.y, net.x, net.y);
   line(net2.x, net2.y, net3.x, net3.y);
  }
  popMatrix();
  // set starting position of each star
  hello = new PVector(-random(width/8), random(height/2, height/3));
  if (floor(random(20)) == 0) {
    // set population starting location
    //Star(PVector inCenter, float inRadius)
    starries.add(new Star(hello, random(5, 20)));
  }

  for (int i = 0; i < starries.size(); i++) {
    Star shootingS = starries.get(i);
    // after a period of time, remove the star from the array list
    float collideNet = dist(shootingS.newPos.x, shootingS.newPos.y, netPos.x, netPos.y);
    if(collideNet < 50.0) {
    starries.remove(shootingS);
  }
    if (shootingS.age > 150) {
      starries.remove(shootingS);
    } else {
      shootingS.display();
      shootingS.update();
    }
  }

  // randomly increment the caught counter for testing
  println(caught);
  if (floor(random(30)) == 0) {
    caught++;
  }
  // If we have caught 3 stars, push another blossom onto the garden
  if (caught == 3) {
    if (garden.size() < 5) {
      // remove tic from markers
      markers.remove(0);
      // add blossom to garden  
      //(xpos, ypos, num_petals, scale_size, rotation_rate, rotation_dir)
      garden.add(new Flower(
        random(80, 420), 
        random(450, 540), 
        (int)ceil(random(5.1, 8.9)), 
        random(0.5, 1.5),
        random(-0.2, 0.2)));
    } 
    caught = 0; // reset catch counter
  }
  for (int i = 0; i < garden.size(); i++) {
    Flower blossom = garden.get(i);
    blossom.display();  
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
  int steps = 20; //(int)(r / 5);
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

void triangle(float x1, float y1, float x2, float y2, float x3, float y3) 
{
 line(x1, y1, x2, y2);
 line(x2, y2, x3, y3);
 line(x3, y3, x1, y1);
}

void quad(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) 
{
 line(x1, y1, x2, y2);
 line(x2, y2, x3, y3);
 line(x3, y3, x4, y4);
 line(x4, y4, x1, y1);
}
 
 
