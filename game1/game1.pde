// クライアント側 (HockeyClient.pde)
import processing.net.*;

Client client;
Ball ball;
Player player;
AIPlayer aiPlayer;
final String SERVER_IP = "127.0.0.1";
final int PORT = 12345;

void setup() {
  size(800, 600);
  client = new Client(this, SERVER_IP, PORT);
  ball = new Ball();
  player = new Player(width - 30);
  aiPlayer = new AIPlayer(30);
  println("サーバーに接続: " + SERVER_IP + ":" + PORT);
}

void draw() {
  background(0);
  handleServerCommunication();
  displayGame();
}

void handleServerCommunication() {
  if (client.available() > 0) {
    String data = client.readString();
    if (data != null && data.trim().length() > 0) {
      try {
        JSONObject gameState = parseJSONObject(data.trim());
        ball.position.x = gameState.getFloat("ballX");
        ball.position.y = gameState.getFloat("ballY");
        ball.velocity.x = gameState.getFloat("ballVelX");
        ball.velocity.y = gameState.getFloat("ballVelY");
        aiPlayer.y = gameState.getFloat("aiY");
        //player.y = gameState.getFloat("playerY");
      }
      catch (Exception e) {
        println("エラー: " + e.getMessage());
      }
    }
  }

  JSONObject playerState = new JSONObject();
  playerState.setFloat("playerY", player.y);
  client.write(playerState.toString() + "\n");
}

void displayGame() {
  ball.display();
  player.display();
  aiPlayer.display();
}

void mouseMoved() {
  player.setY(mouseY);

  //println(mouseY);
  //println(player.y);
}

// ボールクラス
class Ball {
  PVector position;
  PVector velocity;
  float size;

  Ball() {
    position = new PVector(width/2, height/2);
    velocity = new PVector();
    size = 10;
  }

  void display() {
    fill(255);
    noStroke();
    ellipse(position.x, position.y, size * 2, size * 2);
  }
}

// パドルの基底クラス
class Paddle {
  float x, y;
  float paddleWidth, paddleHeight;

  Paddle(float x) {
    this.x = x;
    this.y = height/2;
    this.paddleWidth = 10;
    this.paddleHeight = 100;
  }

  void display() {
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(x, y, paddleWidth, paddleHeight);
  }

  void setY(float newY) {
    float n = 0;
    //println(newY);
    if (newY < paddleHeight/2) {
      n = paddleHeight/2;
    } else if (newY > height - paddleHeight * 1/2) {
      n = height - paddleHeight * 1/2;
    } else {
      n = newY;
    }
    
    y = n;
    println(y + "," + newY + "," + height);
  }
}

// プレイヤークラス
class Player extends Paddle {
  Player(float x) {
    super(x);
  }
}

// AIプレイヤークラス（クライアント側では表示用のみ）
class AIPlayer extends Paddle {
  AIPlayer(float x) {
    super(x);
  }
}
