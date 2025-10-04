class Order {
  final int? id;
  final int petId;
  final int quantity;
  final DateTime shipDate;
  final String status;
  final bool complete;

  Order({
    this.id,
    required this.petId,
    required this.quantity,
    required this.shipDate,
    required this.status,
    required this.complete,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      petId: json['petId'],
      quantity: json['quantity'],
      shipDate: DateTime.parse(json['shipDate']),
      status: json['status'],
      complete: json['complete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'quantity': quantity,
      'shipDate': shipDate.toIso8601String(),
      'status': status,
      'complete': complete,
    };
  }
}
