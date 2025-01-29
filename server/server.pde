import processing.net.*;

Server server;
Game game;
//Player player;
float playerY;

final int port = 5204;
final int windowW = 800;
final int windowH = 600;
boolean one = false;
void setup() {

  server = new Server(this, port);
  game = new Game();
  //player = new Player();
  println("サーバー起動");
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
        gameState.setInt("playerScore", game.player.score);
        gameState.setInt("aiPlayerScore", game.aiPlayer.score);

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

class Game {
  Ball ball;
  Player player;
  AIPlayer aiPlayer;



  Game() {
    ball = new Ball();
    player = new Player(windowW - 30);
    aiPlayer = new AIPlayer(30);
  }

  void update() {
    ball.update();
    aiPlayer.update(ball);
    checkHit();

    println("score is " + player.score + ":" + "score is " + aiPlayer.score);
  }

  void checkHit() {
    if (ball.isHit(player)) {
      ball.reverseX();
      ball.addSpeed(0.5);
    }
    if (ball.isHit(aiPlayer)) {
      ball.reverseX();
      ball.addSpeed(0.5);
    }
  }

  void addScore(Paddle p){
    p.score++;
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
    if (position.y - size < 0 || position.y + size > windowH) {
      velocity.y *= -1;
      position.y = constrain(position.y, size, windowH - size);
    }

    if (position.x < 0) {
      game.addScore(game.player);
      reset();
    }else if(position.x > windowW){
      game.addScore(game.aiPlayer);
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

  boolean isHit(Paddle paddle) {


    boolean isHit = false;
    if(position.x > paddle.x - size - paddle.paddlewindowW/2 &&
      position.x < paddle.x + paddle.paddlewindowW/2 + size &&
      position.y > paddle.y - paddle.paddlewindowH/2 - size &&
      position.y < paddle.y + paddle.paddlewindowH/2 + size){

      isHit = true;
    }
    return isHit;
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

class Paddle {
  float x, y;
  float paddlewindowW, paddlewindowH;

  int score;

  Paddle(float x) {
    this.x = x;
    this.y = windowH/2;
    this.paddlewindowW = 10;
    this.paddlewindowH = 100;
    this.score = 0;
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
class Player extends Paddle {
  Player(float x) {
    super(x);
  }
}

class AIPlayer extends Paddle {
  float reactionSpeed = 0.1;
  float predictionError = 200;

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
