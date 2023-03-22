import websockets.*;
import java.awt.*; //<>//
import java.awt.Robot.*;
import java.awt.event.KeyEvent.*;

WebsocketClient wsc;
Robot robot;

boolean[] bts; //<>//

void setup() {
  wsc = new WebsocketClient(this, "ws://localhost:8025/keypad"); //<>//
  bts = new boolean[2];
  
  size(200, 200);
  
  frameRate(240); //<>//

  try {
    robot = new Robot();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  fill(0);
  background(255); //<>//
  if (bts[0] == true) {
    rect(0, 0, width*0.5, height);
    robot.keyPress(88);
  } else {
    robot.keyRelease(88);
  }
  if (bts[1] == true) {
    rect(width*0.5, 0, width*0.5, height);
    robot.keyPress(89);
  } else {
    robot.keyRelease(89);
  }
  //println(bts);
  //println(int(bts[0]) + "  ;  " + int(bts[1]));
}

void webSocketEvent(String msg) {
  bts = boolean(int(split(msg, ',')));
  //println(msg);
}

void mouseClicked() {
  wsc = new WebsocketClient(this, "ws://localhost:8025/keypad");
  bts = new boolean[2];
}
