import processing.net.*;

Client client; // TCPクライアントオブジェクト
int screenWidth = 600;
int screenHeight = 400;

int dataIn = 0;
// スコア表示クラス (ここでは簡易的にグローバル変数で管理)
int myScore = 0;
int enemyScore = 0;

// ゲームオブジェクトのインスタンス
Paddle myPaddle;
Paddle enemyPaddle;
Puck gamePuck;
GameField field;

void setup() {
  size(600, 400);
  // smooth(); // より滑らかな描画 (必要に応じて)

  // ゲームオブジェクトの初期化
  field = new GameField(screenWidth, screenHeight, color(0, 100, 200));
  myPaddle = new Paddle(screenWidth / 2, screenHeight - 50, 30, color(0, 255, 0)); // 自分のパドルは緑
  enemyPaddle = new Paddle(screenWidth / 2, 50, 30, color(255, 255, 255)); // 相手のパドルは白
  gamePuck = new Puck(screenWidth / 2, screenHeight / 2);


  client = new Client(this, "127.0.0.1", 5204);


}

void draw() {
  // フィールド描画
  field.display();

  // スコア表示
  drawScore();

  // パドル描画
  enemyPaddle.display(); // 相手パドルを先に描画 (重なり順序を考慮する場合)
  myPaddle.display();

  // パック描画
  gamePuck.display();
  
  sendData();

  // サーバーとの通信処理 (仮の場所)
  // if (client != null && client.available() > 0) {
  //   receiveData();
  // }
  // sendData();

  // 自分のパドルの位置をマウスで更新
  myPaddle.setPosition(mouseX, mouseY);
  // パドルの位置を画面内に制限 (オプション)
  PVector pos = myPaddle.getPosition();
  pos.x = constrain(pos.x, myPaddle.radius, screenWidth - myPaddle.radius);
  pos.y = constrain(pos.y, myPaddle.radius, screenHeight - myPaddle.radius);
  myPaddle.setPosition(pos.x, pos.y);


}

// スコア表示関数
void drawScore() {
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(myScore, screenWidth / 4, screenHeight / 2); // 左側に自分のスコア
  text(enemyScore, screenWidth * 3 / 4, screenHeight / 2); // 右側に相手のスコア
}


// データ受信関数 (TCP通信。まだ未実装)
void receiveData() {
  // String data = client.readStringUntil('\n');
  // if (data != null) {
  //   data = trim(data);
  //   // 受信したデータを解析し、ゲーム状態を更新する処理
  //   // 例: パックの位置、相手パドルの位置など
  //   // ...
  //   println("受信データ: " + data);
  // }
}

// データ送信関数 (TCP通信。まだ未実装)
void sendData() {
  // PVector myPaddlePos = myPaddle.getPosition();
  // String dataToSend = myPaddlePos.x + "," + myPaddlePos.y + "\n";
  // client.write(dataToSend);
  // println("送信データ: " + dataToSend);
  //
}

void clientEvent(Client client) {
  dataIn = client.read();

  println(dataIn);
}



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



class Puck {
  float x, y;

  Puck(float startX, float startY) {
    x = startX;
    y = startY;
  }

  void display() {
    fill(120);
    noStroke();
    ellipse(x, y, 40 * 2, 40 * 2);
  }

  void setPosition(float newX, float newY) {
    x = newX;
    y = newY;
  }

  PVector getPosition() {
    return new PVector(x, y);
  }
}
