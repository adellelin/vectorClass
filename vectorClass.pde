// vim: set ts=2 expandtab:
// Please don't move or dele the line above!  Thx, Holly

// = new PVector(width/2, random(100));
// ADD
Vst vst;
PVector hello; // starting position of stars
int caught = 0;

// if using millis()
int timerDuration = 5000;
int timer;

ArrayList<Star> starries = new ArrayList<Star> ();
ArrayList<Flower> garden = new ArrayList<Flower>();
ArrayList<Marker> markers = new ArrayList<Marker>();

// for end enimation sequence
boolean isAnimatingPostGarden = false;
ArrayList<Flower> postGarden = new ArrayList<Flower>();
int timerStart;
int animationTime = 2000;
int framesLeft;

void setup() {
  //ADD
  size(512, 600, P2D);
  vst = new Vst(this, createSerial());
  blendMode(ADD);   // lines brighter where they overlap
  noFill();   // don't fill in shapes
  stroke(212, 128, 32, 128);  // (r,g,b,alpha) for lines
  frameRate(25);
  startScreen();
}


void draw() {
  background(0);
  stroke(100);
  // show the 5 tics at bottom of screen
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
    caught = 0; // reset star catcher counter
  } 

  stroke(64);
  for (int i = 0; i < garden.size(); i++) {
   Flower blossom = garden.get(i);
   blossom.display();
  }
  //for (Flower blossom : garden) {
  //  blossom.display();
  //}
  if (garden.size() == 5) {
    // copy contents from garden into postGarden
    postGarden = new ArrayList<Flower>(garden); 
    garden.clear();
    starries.clear();
   // framesLeft = 40;
   timerStart = millis();
   println(timerStart);
  
   isAnimatingPostGarden = true;
  }
  //framesLeft --;

 // if (framesLeft > 0) {
   if (isAnimatingPostGarden && millis() < (timerStart + 2000)) {
   starries.clear();
    for (Flower flower : postGarden) {
      flower.display();
      
    }
  } 
  //else if (framesLeft == 0) {
    else if (isAnimatingPostGarden) {
      isAnimatingPostGarden = false;
    startScreen();
    //garden.clear();
    postGarden.clear();
  } // framesLeft will continue to go negative

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
  for (int i = 1; i < 11; i++) {
    line(0, 10, 0, -28);
    PVector net = new PVector(0, -i * 2.8);
    PVector net2 = new PVector(i * 6, 0);
    PVector net3 = new PVector(i * 5, .54 * i * 5 -30); 
    // draw the soft net in a thinner strokeweight
    stroke(150);
    line(net2.x, net2.y, net.x, net.y);
    line(net2.x, net2.y, net3.x, net3.y);
  }
}

void endAnimation() {
  framesLeft = 5;
  timerStart = int(millis()/1000) % (framesLeft + 1);
  return;
}

boolean setTimer() {
  return timerStart == framesLeft;
  // return int(millis()/1000) - timerStart == framesLeft;
}