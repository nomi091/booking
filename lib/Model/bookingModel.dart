class BookingModel {
  int? id;
  int driverId;
  int vehicleId;
  String city;
  double totalCost;

BookingModel({
    this.id,
    required this.driverId,
    required this.vehicleId,
    required this.city,

    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "driverId": driverId,
      "vehicleId": vehicleId,
      "city": city,
      "totalCost": totalCost,
    };
  }
}