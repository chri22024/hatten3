class GameField {
  int width, height;
  color fieldColor;

  GameField(int w, int h, color c) {
    width = w;
    height = h;
    fieldColor = c;
  }

  void display() {
    background(fieldColor);
    stroke(255);
    strokeWeight(3);
    line(width / 2, 0, width / 2, height); // 中央線
    line(0, 50, width, 50); // 上側のゴールライン
    line(0, height - 50, width, height - 50); // 下側のゴールライン
  }
}
