class Info {
  PVector position;
  ArrayList<Vehicle> vehicles;
  
  int line, spacing = 14;

  Info(PVector position, ArrayList<Vehicle> vehicles) {
    this.position = position;
    this.vehicles = vehicles;
  }

  void draw(boolean active) {
    if (!active) return;
    line = 0;

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
