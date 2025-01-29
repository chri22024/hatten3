// サーバー側 (HockeyServer.pde)
import processing.net.*;

Server server;
Game game;
//Player player;
float playerY;

int windowW = 800;
int windowH = 600;
boolean one = true;
void setup() {

  server = new Server(this, 12345);
  game = new Game();
  //player = new Player();
  println("サーバー起動: ポート12345");
}

void draw() {
  background(0);
  game.update();
  //game.display();

  handleClientCommunication();
}

void handleClientCommunication() {
  Client client = server.available();
  if (client != null) {
    String input = client.readString();
    if (input != null && input.trim().length() > 0) {
      try {
        //JSONObject data = parseJSONObject(input.trim());
        //game.updatePlayerPosition(data.getFloat("playerY"));


        JSONObject gameState = new JSONObject();
        gameState.setFloat("ballX", game.ball.position.x);
        gameState.setFloat("ballY", game.ball.position.y);
        gameState.setFloat("ballVelX", game.ball.velocity.x);
        gameState.setFloat("ballVelY", game.ball.velocity.y);
        gameState.setFloat("aiY", game.aiPlayer.y);
        gameState.setFloat("playerY", game.player.y);

        JSONObject playerState = parseJSONObject(input.trim());
        playerY = playerState.getFloat("playerY");
        game.upDatePlayerY(playerY);

        server.write(gameState.toString() + "\n");
      }
      catch (Exception e) {
        println("エラー: " + e.getMessage());
      }
    }
  }
}

// ゲームクラス
class Game {
  Ball ball;
  Player player;
  AIPlayer aiPlayer;

  Game() {
    ball = new Ball();
    player = new Player(windowW - 30);    // プレイヤーは右側
    aiPlayer = new AIPlayer(30);        // AIは左側
  }

  void update() {
    ball.update();
    aiPlayer.update(ball);
    checkCollisions();

    //println(player.y);
  }

  void checkCollisions() {
    if (ball.checkPaddleCollision(player)) {
      ball.reverseX();
      ball.addSpeed(0.5);
    }
    if (ball.checkPaddleCollision(aiPlayer)) {
      ball.reverseX();
      ball.addSpeed(0.5);
    }
  }

  //void display() {
  //  ball.display();
  //  player.display();
  //  aiPlayer.display();
  //}

  void upDatePlayerY(float y) {
    player.y = y;
  }
}

// ボールクラス
class Ball {
  PVector position;
  PVector velocity;
  float size;
  float maxSpeed;

  Ball() {
    position = new PVector(windowW/2, windowH/2);
    velocity = new PVector(5, random(-3, 3));
    size = 10;
    maxSpeed = 15;
  }

  void update() {
    position.add(velocity);

    while (one) {
      println(windowW);
      println(windowH);
      println(position);
      one = false;
    }
    // 上下の壁での反射
    if (position.y - size < 0 || position.y + size > windowH) {
      velocity.y *= -1;
      position.y = constrain(position.y, size, windowH - size);
    }

    // 左右の壁に当たった場合はリセット
    if (position.x < 0 || position.x > windowW) {
      reset();
    }
  }

  void reset() {
    position = new PVector(windowW/2, windowH/2);
    velocity = new PVector(random(1) < 0.5 ? -5 : 5, random(-3, 3));
  }

  //void display() {
  //  fill(255);
  //  noStroke();
  //  ellipse(position.x, position.y, size * 2, size * 2);
  //}

  boolean checkPaddleCollision(Paddle paddle) {
    return position.x > paddle.x - size - paddle.paddlewindowW/2 &&
      position.x < paddle.x + paddle.paddlewindowW/2 + size &&
      position.y > paddle.y - paddle.paddlewindowH/2 - size &&
      position.y < paddle.y + paddle.paddlewindowH/2 + size;
  }

  void reverseX() {
    velocity.x *= -1;
  }

  void addSpeed(float increment) {
    float speed = velocity.mag();
    if (speed < maxSpeed) {
      velocity.mult(1 + increment);
    }
  }
}

// パドルの基底クラス
class Paddle {
  float x, y;
  float paddlewindowW, paddlewindowH;

  Paddle(float x) {
    this.x = x;
    this.y = windowH/2;
    this.paddlewindowW = 10;
    this.paddlewindowH = 100;
  }

  //void display() {
  //  fill(255);
  //  noStroke();
  //  rectMode(CENTER);
  //  rect(x, y, paddlewindowW, paddlewindowH);
  //}

  //void setY(float newY) {
  //  float n = 0;
  //  //println(newY);
  //  if (newY < windowH/4) {
  //    n = windowH/4;
  //  } else if (newY > windowH * 3/4) {
  //    n = windowH * 3/4;
  //  } else {
  //    n = newY;
  //  }

  //  y = n;
  //  println(y + "," + newY + "," + windowH);
  //}
}

// プレイヤークラス
class Player extends Paddle {
  Player(float x) {
    super(x);
  }
}

// AIプレイヤークラス
class AIPlayer extends Paddle {
  float reactionSpeed = 0.1;
  float predictionError = 20;

  AIPlayer(float x) {
    super(x);
  }

  void update(Ball ball) {
    if (ball.velocity.x < 0) {
      float predictedY = predictBallPosition(ball);
      float targetY = predictedY + random(-predictionError, predictionError);
      y = lerp(y, targetY, reactionSpeed);
    } else {
      y = lerp(y, windowH/2, 0.02);
    }
  }

  float predictBallPosition(Ball ball) {
    float timeToIntercept = (x - ball.position.x) / ball.velocity.x;
    return ball.position.y + ball.velocity.y * timeToIntercept;
  }
}
