
// = new PVector(width/2, random(100));
Star star;
PVector hello;
ArrayList<Star> shootingS = new ArrayList<Star> ();

/*
void setup() {
  size(1024,700);
  background(0);
  frameRate(25);
  noFill();
  star = new Star();
}


void draw() {
  star.display();
  star.update();
}
*/

void setup() {
  size(1024,700);
  background(0);
  frameRate(25);
  noFill();

  
}

void draw() {
  background(0);
  stroke(100);
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
  if(group.age > 150) {
    shootingS.remove(group);
  } else {
    group.display();
    group.update();
    }
  }
}