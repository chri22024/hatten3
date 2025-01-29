import processing.net.*;

Client client;
Ball ball;
Player player;
AIPlayer aiPlayer;
final String IP = "127.0.0.1";
final int PORT = 5204;

void setup() {
  size(800, 600);
  client = new Client(this, IP, PORT);
  ball = new Ball();
  player = new Player(width - 30);
  aiPlayer = new AIPlayer(30);
  println("サーバーに接続:");
}

void draw() {
  background(0);
  handleServerCommunication();
  displayGame();
  
  
  //println(player.score + ":" + aiPlayer.score);
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
        player.score = gameState.getInt("playerScore");
        aiPlayer.score = gameState.getInt("aiPlayerScore");
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
  displayScore(player, aiPlayer);
}

void mouseMoved() {
  player.setY(mouseY);

  //println(mouseY);
  //println(player.y);
}

void displayScore(Paddle p1, Paddle p2){
  textSize(30);
  text("SCORE >" + p2.score + ":" + p1.score, width * 1/3, 100);
}

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

class Paddle {
  float x, y;
  float paddleWidth, paddleHeight;
  int score;

  Paddle(float x) {
    this.x = x;
    this.y = height/2;
    this.paddleWidth = 10;
    this.paddleHeight = 100;
    this.score = 0;
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
    //println(y + "," + newY + "," + height);
  }
}

class Player extends Paddle {
  Player(float x) {
    super(x);
  }
}

class AIPlayer extends Paddle {
  AIPlayer(float x) {
    super(x);
  }
}
