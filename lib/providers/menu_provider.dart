import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/promotion.dart';
import '../models/ToppingOption.dart';


class MenuProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Promotion> _promotions = [];

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<Promotion> get promotions => _promotions;

  MenuProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load dummy data for demonstration
    _categories = [
      Category(
        id: '1',
        name: 'Platos Principales',
        description: 'Platos principales de nuestra carta',
        imageUrl: 'assets/images/main_dishes.jpg',
        displayOrder: 1,
      ),
      Category(
        id: '2',
        name: 'Entradas',
        description: 'Deliciosas entradas para compartir',
        imageUrl: 'assets/images/appetizers.jpg',
        displayOrder: 2,
      ),
      Category(
        id: '3',
        name: 'Postres',
        description: 'Dulces tentaciones para finalizar',
        imageUrl: 'assets/images/desserts.jpg',
        displayOrder: 3,
      ),
      Category(
        id: '4',
        name: 'Bebidas',
        description: 'Refrescantes bebidas para acompañar',
        imageUrl: 'assets/images/drinks.jpg',
        displayOrder: 4,
      ),
    ];

    _products = [
  Product(
    id: '1',
    name: 'Lomo Saltado',
    description: 'Tradicional plato peruano con carne de res, cebolla, tomate y papas fritas',
    price: 45.0,
    category: '1',
    imageUrl: 'assets/images/lomo_saltado.jpg',
    ingredients: ['Carne de res', 'Cebolla', 'Tomate', 'Papas', 'Arroz'],
    toppings: [
      ToppingOption(name: 'Papas extra', extraCost: 5.0),
      ToppingOption(name: 'Salsa adicional', extraCost: 2.0),
    ],
  ),
  Product(
    id: '2',
    name: 'Ceviche',
    description: 'Pescado fresco marinado en limón con cebolla, cilantro y ají',
    price: 40.0,
    category: '2',
    imageUrl: 'assets/images/ceviche.jpg',
    ingredients: ['Pescado', 'Limón', 'Cebolla', 'Cilantro', 'Ají'],
    toppings: [
      ToppingOption(name: 'Choclo extra', extraCost: 3.0),
      ToppingOption(name: 'Camote adicional', extraCost: 2.5),
    ],
  ),
  Product(
    id: '3',
    name: 'Cheesecake',
    description: 'Delicioso pastel de queso con salsa de frutos rojos',
    price: 25.0,
    category: '3',
    imageUrl: 'assets/images/cheesecake.jpg',
    ingredients: ['Queso crema', 'Galleta', 'Frutos rojos'],
    toppings: [
      ToppingOption(name: 'Salsa de chocolate', extraCost: 3.0),
    ],
  ),
  Product(
    id: '4',
    name: 'Limonada',
    description: 'Refrescante limonada casera',
    price: 12.0,
    category: '4',
    imageUrl: 'assets/images/lemonade.jpg',
    ingredients: ['Limón', 'Azúcar', 'Agua'],
    toppings: [
      ToppingOption(name: 'Hojas de menta', extraCost: 1.0),
      ToppingOption(name: 'Hielo adicional', extraCost: 0.5),
    ],
  ),
  Product(
    id: '5',
    name: 'Ají de Gallina',
    description: 'Cremoso guiso de pollo con ají amarillo y nueces',
    price: 42.0,
    category: '1',
    imageUrl: 'assets/images/aji_gallina.jpg',
    ingredients: ['Pollo', 'Ají amarillo', 'Nueces', 'Pan', 'Leche'],
    toppings: [], // No toppings
  ),
  Product(
    id: '6',
    name: 'Causa Limeña',
    description: 'Pastel frío de papa amarilla relleno de pollo o atún',
    price: 30.0,
    category: '2',
    imageUrl: 'assets/images/causa.jpg',
    ingredients: ['Papa amarilla', 'Limón', 'Ají amarillo', 'Pollo', 'Mayonesa'],
    toppings: [
      ToppingOption(name: 'Palta extra', extraCost: 4.0),
    ],
  ),
];

    _promotions = [
      Promotion(
        id: '1',
        name: 'Happy Hour',
        description: '2x1 en bebidas de 18:00 a 20:00',
        discountPercentage: 50.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
        applicableProductIds: ['4'],
        imageUrl: 'assets/images/happy_hour.jpg',
      ),
      Promotion(
        id: '2',
        name: 'Martes de Postres',
        description: '30% de descuento en todos los postres los martes',
        discountPercentage: 30.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 60)),
        applicableProductIds: ['3'],
        imageUrl: 'assets/images/dessert_tuesday.jpg',
      ),
    ];

    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _products.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add product error: $e');
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update product error: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  Future<bool> addCategory(Category category) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _categories.add(category);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add category error: $e');
      return false;
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update category error: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _categories.removeWhere((c) => c.id == categoryId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete category error: $e');
      return false;
    }
  }

  Future<bool> addPromotion(Promotion promotion) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _promotions.add(promotion);
      notifyListeners();
      return true;
    } catch (e) {
      print('Add promotion error: $e');
      return false;
    }
  }

  Future<bool> updatePromotion(Promotion promotion) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      final index = _promotions.indexWhere((p) => p.id == promotion.id);
      if (index != -1) {
        _promotions[index] = promotion;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update promotion error: $e');
      return false;
    }
  }

  Future<bool> deletePromotion(String promotionId) async {
    try {
      // In a real app, this would make an API call
      await Future.delayed(Duration(seconds: 1));
      
      _promotions.removeWhere((p) => p.id == promotionId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Delete promotion error: $e');
      return false;
    }
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((product) => product.category == categoryId).toList();
  }

  List<Promotion> getActivePromotions() {
    final now = DateTime.now();
    return _promotions
        .where((promo) => 
            promo.isActive && 
            now.isAfter(promo.startDate) && 
            now.isBefore(promo.endDate))
        .toList();
  }
}
