import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load dummy data for demonstration
    _orders = [
      Order(
        id: '1',
        customerName: 'Carlos Rodríguez',
        whatsappNumber: '123456789',
        deliveryType: 'delivery',
        address: 'Av. Principal #123, La Paz',
        paymentType: 'efectivo',
        status: 'entregado',
        orderDate: DateTime.now().subtract(Duration(days: 1)),
        items: [
          OrderItem(
            productId: '1',
            productName: 'Lomo Saltado',
            unitPrice: 45.0,
            quantity: 2,
          ),
          OrderItem(
            productId: '4',
            productName: 'Limonada',
            unitPrice: 12.0,
            quantity: 2,
          ),
        ],
        deliveryFee: 10.0,
      ),
      Order(
        id: '2',
        customerName: 'Ana Gómez',
        whatsappNumber: '987654321',
        deliveryType: 'pickup',
        paymentType: 'tarjeta',
        status: 'pendiente',
        orderDate: DateTime.now(),
        items: [
          OrderItem(
            productId: '2',
            productName: 'Ceviche',
            unitPrice: 40.0,
            quantity: 1,
            specialInstructions: 'Sin cebolla',
          ),
          OrderItem(
            productId: '3',
            productName: 'Cheesecake',
            unitPrice: 25.0,
            quantity: 1,
          ),
        ],
      ),
      Order(
        id: '3',
        customerName: 'Luis Martínez',
        whatsappNumber: '456789123',
        deliveryType: 'delivery',
        address: 'Calle Secundaria #456, La Paz',
        paymentType: 'transferencia',
        status: 'en preparación',
        orderDate: DateTime.now().subtract(Duration(hours: 2)),
        items: [
          OrderItem(
            productId: '5',
            productName: 'Ají de Gallina',
            unitPrice: 42.0,
            quantity: 3,
          ),
          OrderItem(
            productId: '6',
            productName: 'Causa Limeña',
            unitPrice: 30.0,
            quantity: 1,
          ),
          OrderItem(
            productId: '4',
            productName: 'Limonada',
            unitPrice: 12.0,
            quantity: 4,
          ),
        ],
        deliveryFee: 10.0,
        notes: 'Tocar el timbre al llegar',
      ),
    ];

    notifyListeners();
  }

  Future<bool> addOrder(Order order) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _orders.add(order);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add order error: $e');
      return false;
    }
  }

  Future<bool> updateOrder(Order order) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update order error: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final updatedOrder = _orders[index].copyWith(status: newStatus);
        _orders[index] = updatedOrder;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update order status error: $e');
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _orders.removeWhere((o) => o.id == orderId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete order error: $e');
      return false;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
  }

  List<Order> getOrdersByDate(DateTime date) {
    return _orders.where((order) => 
      order.orderDate.day == date.day &&
      order.orderDate.month == date.month &&
      order.orderDate.year == date.year
    ).toList();
  }

  List<Order> getOrdersByCustomer(String customerName) {
    return _orders.where((order) => 
      order.customerName.toLowerCase().contains(customerName.toLowerCase())
    ).toList();
  }

  double getTotalSales() {
    return _orders
        .where((order) => order.status.toLowerCase() == 'entregado')
        .fold(0, (sum, order) => sum + order.total);
  }

  double getTotalSalesByDate(DateTime date) {
    return _orders
        .where((order) => 
          order.status.toLowerCase() == 'entregado' &&
          order.orderDate.day == date.day &&
          order.orderDate.month == date.month &&
          order.orderDate.year == date.year
        )
        .fold(0, (sum, order) => sum + order.total);
  }
}
