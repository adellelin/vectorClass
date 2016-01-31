// vim: set ts=2 expandtab:
// Please don't move or dele the line above!  Thx, Holly

// = new PVector(width/2, random(100));
// ADD
Vst vst;
Star star;
PVector hello; // starting position of stars
int caught = 0;

ArrayList<Star> starries = new ArrayList<Star> ();
ArrayList<Flower> garden = new ArrayList<Flower>();
ArrayList<Marker> markers = new ArrayList<Marker>();

void setup() {
  //ADD
  size(512, 600, P2D);
  vst = new Vst(this, createSerial());
  vst.colorStroke = color(220, 220, 255);
  blendMode(ADD);   // lines brighter where they overlap
  noFill();   // don't fill in shapes
  stroke(212, 128, 32, 128);  // (r,g,b,alpha) for lines
  frameRate(25);
  startScreen();
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
   line(0, 10, 0, -25);
   PVector net = new PVector(0, -i * 2.5);
   PVector net2 = new PVector(i * 6, 0);
   PVector net3 = new PVector(i, - 3 / 8 * i - 25); 
   stroke(150);
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
    caught++;
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
  //if (floor(random(30)) == 0) {
  //  caught++;
  //}
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
 
  stroke(64);
  for (int i = 0; i < garden.size(); i++) {
    Flower blossom = garden.get(i);
    blossom.display();  
    if(garden.size() == 5) {
   background(0);
   //clears arraylist
   garden.clear();
   startScreen();
    }
  }  

  //ADD
  vst.display();  // send the vectors to the board to be drawn
}

void startScreen() {
    // populate the markers arraylist with all the markers
  for (int i = 1; i < 6; i++) {
    markers.add(new Marker(180 + (i * 30), 580));
  }
  
} 