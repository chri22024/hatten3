
import processing.net.*;



class Player{
  int playerId;
  float cx, cy;
  color col;


  Player(int id){
    this.playerId = id;

    if(this.playerId == 1){
      this.cx = width * 0.25;
      this.cy = height * 0.5;
      this.col = color(0, 255, 0);
    }else{
      this.cx = width * 0.75;
      this.cy = height * 0.5;
      this.col = color(255, 0, 0);

    }
  }
}


Server myServer;
void setup(){

  size(200, 200);
  myServer = new Server(this, 5204);

}


void draw(){


}


void clientEvent(Client c){
  while(c.available() > 0){
    int score = c.read();
    println(score);

  }

}



void serverEvent(Server s, Client c){
  println();
  println(c + "connected");
}


void disconnectedEvent(Client c){
  println();
  println("disconnected");
}
