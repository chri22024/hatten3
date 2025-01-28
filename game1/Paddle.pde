class Paddle {
  float x, y;
  float radius;
  color paddleColor;

  Paddle(float startX, float startY, float r, color c) {
    x = startX;
    y = startY;
    radius = r;
    paddleColor = c;
  }

  void display() {
    fill(paddleColor);
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
