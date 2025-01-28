
import processing.net.*;


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
