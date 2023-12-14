class VehicleModel {
  int vid;
  String imagePath;
  String color, make; // Add imagePath field
  VehicleModel({
    required this.vid,
    required this.color,
    required this.make,
    required this.imagePath, // Include imagePath in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'vid': vid,
      'color': color,
      'make': make,
      'imagePath': imagePath, // Store imagePath in the map
    };
  }
}
