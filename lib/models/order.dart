class OrderItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? specialInstructions;
  final Map<String, int> toppings;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.specialInstructions,
    this.toppings = const {},
  });

  double get subtotal => unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'toppings': toppings,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      specialInstructions: map['specialInstructions'],
      toppings: Map<String, int>.from(map['toppings'] ?? {}),
    );
  }
}

class Order {
  final String id;
  final String customerName;
  final String whatsappNumber;
  final String email; // Nuevo campo
  final String deliveryType;
  final String? address;
  final String paymentType;
  final String status;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double? deliveryFee;
  final double? discount;
  final String? notes;

  Order({
    required this.id,
    required this.customerName,
    required this.whatsappNumber,
    required this.email,
    required this.deliveryType,
    this.address,
    required this.paymentType,
    required this.status,
    required this.orderDate,
    required this.items,
    this.deliveryFee,
    this.discount,
    this.notes,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get total {
    double total = subtotal;
    if (deliveryFee != null) total += deliveryFee!;
    if (discount != null) total -= discount!;
    return total;
  }

  Order copyWith({
    String? id,
    String? customerName,
    String? whatsappNumber,
    String? email,
    String? deliveryType,
    String? address,
    String? paymentType,
    String? status,
    DateTime? orderDate,
    List<OrderItem>? items,
    double? deliveryFee,
    double? discount,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      deliveryType: deliveryType ?? this.deliveryType,
      address: address ?? this.address,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'deliveryType': deliveryType,
      'address': address,
      'paymentType': paymentType,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'deliveryFee': deliveryFee,
      'discount': discount,
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['customerName'],
      whatsappNumber: map['whatsappNumber'],
      email: map['email'],
      deliveryType: map['deliveryType'],
      address: map['address'],
      paymentType: map['paymentType'],
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
      items: List<OrderItem>.from(
        map['items']?.map((item) => OrderItem.fromMap(item)) ?? [],
      ),
      deliveryFee: map['deliveryFee'],
      discount: map['discount'],
      notes: map['notes'],
    );
  }
}