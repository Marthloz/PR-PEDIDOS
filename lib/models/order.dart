class OrderItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? specialInstructions;
  final Map<String, int> toppings; // nuevo campo

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.specialInstructions,
    this.toppings = const {},
  });

  double get subtotal {
    // Los toppings se suman de forma fija por unidad, si quieres precios, deberías incluir un map de precios también
    return unitPrice * quantity;
    // Si se quisiera incluir precios adicionales por toppings aquí, se necesita acceder al costo (lo cual no viene incluido).
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'toppings': toppings, // serializamos el map
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
  final String deliveryType; // 'pickup' or 'delivery'
  final String? address;
  final String paymentType; // 'cash', 'card', 'transfer'
  final String status; // 'pendiente', 'en preparación', 'entregado', 'cancelado'
  final DateTime orderDate;
  final List<OrderItem> items;
  final double? deliveryFee;
  final double? discount;
  final String? notes;

  Order({
    required this.id,
    required this.customerName,
    required this.whatsappNumber,
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
