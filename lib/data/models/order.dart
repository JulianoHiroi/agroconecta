/*

    {
        "id": "5dbd239c-10be-4165-8c8f-0d7de40ebedb",
        "productId": "cd723074-7891-4fcf-a22f-d4a8b27823be",
        "establishmentId": "08948da1-ec54-4896-8e4a-26e40260ab3a",
        "quantity": 1233,
        "statusId": 1,
        "statusName": "Pendente",
        "createdAt": "2025-07-02T01:31:11.642Z",
        "updatedAt": "2025-07-02T01:31:11.642Z",
        "productName": "Pepino",
        "amoutPayment": 0
    },
    
    */

class Order {
  final String id;
  final String productId;
  final String establishmentId;
  final double quantity;
  final int statusId;
  final String statusName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String productName;
  final double amountPayment;
  final String establishmentName;
  final String userId;
  final String userProductId;

  Order({
    required this.id,
    required this.productId,
    required this.establishmentId,
    required this.quantity,
    required this.statusId,
    required this.statusName,
    required this.createdAt,
    required this.updatedAt,
    required this.productName,
    required this.amountPayment,
    required this.establishmentName,
    required this.userId,
    required this.userProductId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      productId: json['productId'],
      establishmentId: json['establishmentId'],
      quantity: (json['quantity'] as num).toDouble(),
      statusId: json['statusId'],
      statusName: json['statusName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      productName: json['productName'],
      amountPayment: (json['amountPayment'] ?? json['amoutPayment'] ?? 0 as num)
          .toDouble(),
      establishmentName: json['establishmentName'] ?? 'Unknown',
      userId: json['userId'] ?? 'Unknown',
      userProductId: json['userProductId'] ?? 'Unknown',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'establishmentId': establishmentId,
      'quantity': quantity,
      'statusId': statusId,
      'statusName': statusName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'productName': productName,
      'amountPayment': amountPayment,
    };
  }

  @override
  String toString() {
    return 'Order{id: $id, productId: $productId, establishmentId: $establishmentId, quantity: $quantity, statusId: $statusId, statusName: $statusName, createdAt: $createdAt, updatedAt: $updatedAt, productName: $productName, amountPayment: $amountPayment}';
  }
}
