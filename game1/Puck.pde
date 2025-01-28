class Puck {
  float x, y;
  float radius;
  color puckColor;

  Puck(float startX, float startY, float r, color c) {
    x = startX;
    y = startY;
    radius = r;
    puckColor = c;
  }

  void display() {
    fill(puckColor);
    noStroke();
    ellipse(x, y, radius * 2, radius * 2);
  }

  void setPosition(float newX, float newY) {
    x = newX;
    y = newY;
  }

  PVector getPosition() {
    return new PVector(x, y);
  }
}
