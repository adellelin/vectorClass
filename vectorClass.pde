// vim: set ts=2 expandtab:
// Please don't move or dele the line above!  Thx, Holly

// = new PVector(width/2, random(100));
// ADD
Vst vst;
Star star;
PVector hello; // starting position of stars
int caught = 0;
Star shootingS;
int framesLeft;
int timerStart;
int timer;


ArrayList<Star> starries = new ArrayList<Star> ();
ArrayList<Flower> garden = new ArrayList<Flower>();
ArrayList<Flower> postGarden = new ArrayList<Flower>();
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
  timerStart = int(millis()/1000);
  println(timerStart);
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
  mouseNet();
  popMatrix();

  // set starting position of each star
  hello = new PVector(-random(width/8), random(height/2, height/3));
  if (floor(random(20)) == 0 && garden.size() < 5) {
    // set population starting location
    //Star(PVector inCenter, float inRadius)
    starries.add(new Star(hello, random(5, 20)));
  }

  for (int i = 0; i < starries.size(); i++) {
    Star shootingS = starries.get(i);
    // set collision so that when star position meets mouse position, the stars get removed / caught
    float collideNet = dist(shootingS.newPos.x, shootingS.newPos.y, netPos.x, netPos.y);
    if (collideNet < 50.0) {
      starries.remove(shootingS);
      caught++;
    }

    // after a period of time, remove the star from the array list
    if (shootingS.age > 150) {
      starries.remove(shootingS);
    } else {
      shootingS.display();
      shootingS.update();
    }
  }

  // randomly increment the caught counter for testing
  //println(caught);
  //if (floor(random(30)) == 0) {
  //  caught++;
  //}
  // If we have caught 3 stars, push another blossom onto the garden
  if (caught == 1) {
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

      // NOTE: Removed the postGarden.add() code. We don't need to create
      // new Flowers for the postGarden as we're copying them from the garden
      // container.
    } 
    caught = 0; // reset catch counter
  } 

  stroke(64);
  // Display each flower in garden
  for (int i = 0; i < garden.size(); i++) {
    Flower blossom = garden.get(i);
    blossom.display();
  }
  
  // Handle player reaching 5 stars
  // NOTE: Pulled this code out of the loop above. The original code
  // this is based off was being run for each flower in the garden,
  // though only needed to be run once.
  if (garden.size() == 5) {
    postGarden = new ArrayList<Flower>(garden);
    garden.clear();
    starries.clear();
    framesLeft = 20;    // NOTE: Reset frames here
  }

  // NOTE: Do post garden animation  
  framesLeft--;
  // NOTE: Flowers in postGarden will de display as long as there are
  // frames left.
  if (framesLeft > 0) {
    for (Flower flower : postGarden) {
      flower.display();
    }
  }
  // NOTE: The game is reset when framesLeft == 0
  else if (framesLeft == 0) {
    startScreen();
    postGarden.clear();
  }
  // NOTE: When framesLeft are negative, nothing happens.


  //ADD
  vst.display();  // send the vectors to the board to be drawn
}

void startScreen() {
  // populate the markers arraylist with all the markers
  for (int i = 1; i < 6; i++) {
    markers.add(new Marker(180 + (i * 30), 580));
  }
}

void mouseNet() {
  for (int i = 1; i < 10; i++) {
    line(0, 10, 0, -25);
    //line(0, -25, 50, 0);
    PVector net = new PVector(0, -i * 2.5);
    PVector net2 = new PVector(i * 6, 0);
    PVector net3 = new PVector(i, -3/8 * i - 25); 
    stroke(150);
    line(net2.x, net2.y, net.x, net.y);
    line(net2.x, net2.y, net3.x, net3.y);
  }
}

// NOTE: Commented these out as they're no longer needed.
//void endAnimation() {
//  framesLeft = 5;
//  timerStart = int(millis()/1000) % (framesLeft + 1);
//  return;
//}

//boolean setTimer() {
//  return timerStart == framesLeft;
//  // return int(millis()/1000) - timerStart == framesLeft;
//}