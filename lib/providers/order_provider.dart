import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  bool modoDemo = false;
  final String pedidoCompletoApiUrl = 'http://localhost:3000/api/pedidoCompleto';
  final String notificarApiUrl = 'http://127.0.0.1:3000/api/notificarPedido';

  List<Order> get orders => _orders;

  OrderProvider() {
    if (modoDemo) {
      _loadInitialData();
    } else {
      fetchOrdersFromApi();
    }
  }

  void _loadInitialData() {
    _orders = [
      Order(
        id: '1',
        customerName: 'Carlos Rodríguez',
        whatsappNumber: '123456789',
        email: 'carlos@email.com',
        deliveryType: 'delivery',
        address: 'Av. Principal #123, La Paz',
        paymentType: 'efectivo',
        status: 'entregado',
        orderDate: DateTime.now().subtract(Duration(days: 1)),
        items: [
          OrderItem(productId: '1', productName: 'Lomo Saltado', unitPrice: 45.0, quantity: 2),
          OrderItem(productId: '4', productName: 'Limonada', unitPrice: 12.0, quantity: 2),
        ],
        deliveryFee: 10.0,
      ),
      Order(
        id: '2',
        customerName: 'Ana Gómez',
        whatsappNumber: '987654321',
        email: 'ana@email.com',
        deliveryType: 'pickup',
        paymentType: 'tarjeta',
        status: 'pendiente',
        orderDate: DateTime.now(),
        items: [
          OrderItem(productId: '2', productName: 'Ceviche', unitPrice: 40.0, quantity: 1, specialInstructions: 'Sin cebolla'),
          OrderItem(productId: '3', productName: 'Cheesecake', unitPrice: 25.0, quantity: 1),
        ],
      ),
    ];
    notifyListeners();
  }

  Future<void> fetchOrdersFromApi() async {
    // Puedes agregar lógica más adelante si usas la ruta GET completa
  }

  Future<bool> addOrder(Order order) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      _orders.add(order);
      notifyListeners();
      return true;
    }

    try {
      final response = await http.post(
        Uri.parse(pedidoCompletoApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cliente': {
            'id': null,
          },
          'pedido': {
            'observaciones': order.notes ?? '',
            'usuario': 'demo',
            'metodoPago': _mapPaymentType(order.paymentType),
            'direccion': order.address ?? '',
            'descuento': order.discount ?? 0,
          },
          'items': order.items.map((item) => {
            'productoId': int.tryParse(item.productId),
            'cantidad': item.quantity,
            'precio': item.unitPrice,
            'observaciones': item.specialInstructions ?? '',
            'toppings': item.toppings.entries.map((entry) => {
  'toppingId': entry.key,
  'cantidad': entry.value,
}).toList(),
          }).toList(),
        }),
      );

      if (response.statusCode == 201) {
  print('📦 Código respuesta: ${response.statusCode}');
  print('📦 Cuerpo respuesta: ${response.body}');

  final inserted = jsonDecode(response.body);
  final pedidoId = inserted['pedidoId']?.toString() ?? inserted['PedidoId']?.toString();

  if (pedidoId == null) {
    throw Exception('pedidoId no fue devuelto por el backend');
  }

  final resumenDetallado = order.items.map((item) {
  final line = '${item.quantity} x ${item.productName}';
  final toppings = item.toppings.entries.map((entry) {
    final cantidad = entry.value;
    final nombre = entry.key;
    return '   • ${cantidad}x topping $nombre';
  }).join('\n');

  return '$line${item.toppings.isNotEmpty ? '\n$toppings' : ''}';
}).join('\n\n');

  final notificarResp = await http.post(
    Uri.parse(notificarApiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nombre': order.customerName,
      'correo': (order.email?.isNotEmpty ?? false) ? order.email : 'jg012119@gmail.com',
      'total': order.total,
      'resumen': resumenDetallado,
    }),
  );

  print(resumenDetallado);

  if (notificarResp.statusCode == 200) {
    final data = jsonDecode(notificarResp.body);
    if (data['success'] != true) {
      print('❌ Fallo lógico al enviar correo: ${data['message']}');
    } else {
      print('✅ Correo enviado exitosamente');
    }
  } else {
    print('❌ Error HTTP al enviar notificación: ${notificarResp.body}');
  }

  _orders.add(order.copyWith(id: pedidoId));
  notifyListeners();
  return true;
} else {
  print('⚠️ Error inesperado: ${response.statusCode} → ${response.body}');
  throw Exception('Error al insertar pedido');
}
    } catch (e) {
      print('addOrder error: $e');
      return false;
    }
  }

  Future<bool> updateOrder(Order order) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        notifyListeners();
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      _orders.removeWhere((o) => o.id == orderId);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
  }

  List<Order> getOrdersByDate(DateTime date) {
    return _orders.where((o) =>
      o.orderDate.year == date.year &&
      o.orderDate.month == date.month &&
      o.orderDate.day == date.day).toList();
  }

  List<Order> getOrdersByCustomer(String customerName) {
    return _orders.where((o) =>
      o.customerName.toLowerCase().contains(customerName.toLowerCase())).toList();
  }

  double getTotalSales() {
    return _orders.where((o) => o.status.toLowerCase() == 'entregado')
        .fold(0.0, (sum, o) => sum + o.total);
  }

  double getTotalSalesByDate(DateTime date) {
    return _orders.where((o) =>
      o.status.toLowerCase() == 'entregado' &&
      o.orderDate.year == date.year &&
      o.orderDate.month == date.month &&
      o.orderDate.day == date.day)
      .fold(0.0, (sum, o) => sum + o.total);
  }

  int _mapPaymentType(String type) {
    switch (type.toLowerCase()) {
      case 'efectivo': return 1;
      case 'tarjeta': return 2;
      case 'transferencia': return 3;
      default: return 0;
    }
  }
}
