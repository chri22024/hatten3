import processing.net.*;

Client client; // TCPクライアントオブジェクト
int screenWidth = 600;
int screenHeight = 400;


// スコア表示クラス (ここでは簡易的にグローバル変数で管理)
int myScore = 0;
int opponentScore = 0;

// ゲームオブジェクトのインスタンス
Paddle myPaddle;
Paddle opponentPaddle;
Puck gamePuck;
GameField field;

void setup() {
  size(600, 400);
  // smooth(); // より滑らかな描画 (必要に応じて)

  // ゲームオブジェクトの初期化
  field = new GameField(screenWidth, screenHeight, color(0, 100, 200));
  myPaddle = new Paddle(screenWidth / 2, screenHeight - 50, 30, color(0, 255, 0)); // 自分のパドルは緑
  opponentPaddle = new Paddle(screenWidth / 2, 50, 30, color(255, 255, 255)); // 相手のパドルは白
  gamePuck = new Puck(screenWidth / 2, screenHeight / 2, 20, color(255, 0, 0));

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

  // サーバーとの通信処理 (仮の場所)
  // if (client != null && client.available() > 0) {
  //   receiveData();
  // }
  // sendData();

  // 自分のパドルの位置をマウスで更新
  if (mousePressed) {
    myPaddle.setPosition(mouseX, mouseY);
    // パドルの位置を画面内に制限 (オプション)
    PVector pos = myPaddle.getPosition();
    pos.x = constrain(pos.x, myPaddle.radius, screenWidth - myPaddle.radius);
    pos.y = constrain(pos.y, myPaddle.radius, screenHeight - myPaddle.radius);
    myPaddle.setPosition(pos.x, pos.y);
  }
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
}
