class Info {
  PVector position;
  Agent agent;
  
  int line, spacing = 14;

  Info(PVector position, Agent agent) {
    this.agent    = agent;
    this.position = position;
  }

  void draw(boolean active) {
    fill(255);
    if (!active) return;
    line = 0;
    printText("Pose: " + agent.position_wc.x + " " + agent.position_wc.y );
    printText("Phi: " + degrees(agent.headingAngle)+" Yaw: "+ degrees(agent.steerAngle));
    printText("KM/H: " + agent.car.getKilometersPerHour() + " T: " + agent.car.throttle);
    printText("RPM " + agent.engine.lastRPM + " G: " +agent.engine.currentGear);
    printText("Torque " + agent.car.cartype.axleRear.getTorque());
    printText("Angular V " + agent.car.angularvelocity);
    printText("TR slip " + agent.car.cartype.axleRear.slipAngle);
    printText("TF slip " + agent.car.cartype.axleFront.slipAngle);
    printText("Accel: " + agent.acceleration.x +"  " +agent.acceleration.y);
    line++;
    }

  void printText(String str) {
    text(str, position.x, position.y + line * spacing);
    line++;
  }
}
