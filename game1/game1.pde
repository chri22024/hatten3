
import processing.net.*;

Client myClient;

int dataIn;
void setup(){

  size(200, 200);

  myClient = new Client(this, "127.0.0.1", 5204);
}
void draw(){


  if(myClient.available() > 0){
    dataIn = myClient.read();
  }
  background(dataIn);

}
