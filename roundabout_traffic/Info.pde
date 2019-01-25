class Info {
  PVector position;
  ArrayList<Vehicle> vehicles;
  Vehicle agent;
  
  int line, spacing = 14;

  Info(PVector position, ArrayList<Vehicle> vehicles, Vehicle agent) {
    this.agent = agent;
    this.position = position;
    this.vehicles = vehicles;
  }

  void draw(boolean active) {
    fill(255);
    if (!active) return;
    line = 0;
    //print(agent);
    printText("Pose: " + agent.pose.x + " " + agent.pose.y );
    for (Vehicle vehicle : vehicles) {
      printText("Speed: " + vehicle.v);
      printText("Ref Speed: " + vehicle.targetSpeed);
      printText("Yaw: " + vehicle.pose.z);
      line++;
    }
  }

  void printText(String str) {
    text(str, position.x, position.y + line * spacing);
    line++;
  }
}
