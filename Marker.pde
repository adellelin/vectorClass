// vim: set ts=2 expandtab:
// Please don't move or delete the line above!  Thx, Holly

class Marker {
	float xpos;
	float ypos;

	// Constructor
	Marker(float tempxpos, float tempypos) {
		xpos = tempxpos;
		ypos = tempypos;
	}

	void display() {
    pushMatrix();
    
    stroke(255);
  
    // move to marker center position
    translate(xpos, ypos);

    // draw the marker
    for (int i = 0; i < 3; i++) {
      rotate(PI/3);
      line(-5, 0, 5, 0);
    }

    popMatrix();
  }
}
