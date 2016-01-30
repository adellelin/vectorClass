// vim: set ts=2 expandtab:
// Please don't move or dele the line above!  Thx, Holly

// = new PVector(width/2, random(100));
// ADD
Vst v;
Star star;
PVector hello; // starting position of stars
int caught = 0;

ArrayList<Star> shootingS = new ArrayList<Star> ();
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
