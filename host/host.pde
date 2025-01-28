
import processing.net.*;


Server myServer;
int n;
void setup(){

  n = 0;
  size(200, 200);
  myServer = new Server(this, 5204);

}


void draw(){

  n = (n + 1) % 255;


  background(0, 0, n );


}
