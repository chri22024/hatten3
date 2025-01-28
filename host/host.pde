
import processing.net.*;


Server server;
int n;
void setup(){

  n = 0;
  size(200, 200);
  server = new Server(this, 5024);

}


void draw(){


  background(0, 0, n );


}
