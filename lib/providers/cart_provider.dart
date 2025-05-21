import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String? specialInstructions;
  final Map<String, int> selectedToppings; // nombre del topping → cantidad

  CartItem({
    required this.product,
    required this.quantity,
    this.specialInstructions,
    this.selectedToppings = const {},
  });

  double get total {
    final double toppingsCost = product.toppings.fold(0.0, (double sum, topping) {
      final qty = selectedToppings[topping.name] ?? 0;
      return sum + (qty * topping.extraCost);
    });

    return (product.price * quantity) + toppingsCost;
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  double get total => subtotal;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(
  Product product,
  int quantity,
  String? specialInstructions, {
  Map<String, int> selectedToppings = const {},
}) {
  // Verificar si ya existe el producto exacto (mismo ID y toppings)
  final existingIndex = _items.indexWhere((item) =>
    item.product.id == product.id &&
    _mapEquals(item.selectedToppings, selectedToppings)
  );

  if (existingIndex != -1) {
    // Reemplazar el ítem con los nuevos datos
    _items[existingIndex] = CartItem(
      product: product,
      quantity: quantity,
      specialInstructions: specialInstructions,
      selectedToppings: selectedToppings,
    );
  } else {
    // Agregar nuevo ítem
    _items.add(CartItem(
      product: product,
      quantity: quantity,
      specialInstructions: specialInstructions,
      selectedToppings: selectedToppings,
    ));
  }

  notifyListeners();
}


  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      final item = _items[index];
      _items[index] = CartItem(
        product: item.product,
        quantity: quantity,
        specialInstructions: item.specialInstructions,
        selectedToppings: item.selectedToppings,
      );
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool _mapEquals(Map<String, int> a, Map<String, int> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (a[key] != b[key]) return false;
  }
  return true;
}
}
