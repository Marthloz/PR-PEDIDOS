import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';
import '../models/promotion.dart';
import '../models/ToppingOption.dart';

class MenuProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Promotion> _promotions = [];

  bool modoDemo = false;
  final String apiUrl = 'http://localhost:3000/api/erpproductos';

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<Promotion> get promotions => _promotions;

  MenuProvider() {
    _loadCategoriesAndPromotions();
    if (modoDemo) {
      _loadDemoProducts();
    } else {
      loadDataFromApi();
    }
  }

  Future<void> loadDataFromApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Product> loadedProducts = [];

        for (var item in data) {
          final productId = item['ProductoId'];
          final toppings = await _loadToppingsForProduct(productId);

          loadedProducts.add(
            Product(
              id: productId.toString(),
              name: item['Nombre'] ?? '',
              description: item['Descripcion'] ?? '',
              price: (item['Precio'] ?? 0).toDouble(),
              category: _mapCategoryToId(item['Categoria']),
              imageUrl: 'assets/images/default.jpg',
              ingredients: [],
              toppings: toppings,
            ),
          );
        }

        _products = loadedProducts;
        notifyListeners();
      } else {
        throw Exception('Error al obtener productos');
      }
    } catch (e) {
      print('Error en loadDataFromApi: $e');
      _products = [];
    }
  }

  Future<List<ToppingOption>> _loadToppingsForProduct(int productId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$productId/toppings'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<ToppingOption>((item) {
          return ToppingOption(
            name: item['Nombre'] ?? '',
            extraCost: (item['Precio'] ?? 0).toDouble(),
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar toppings: $e');
      return [];
    }
  }

  String _mapCategoryToId(dynamic nombreCategoria) {
    final cat = (nombreCategoria ?? '').toString().toLowerCase();
    if (cat.contains('bebida')) return '4';
    if (cat.contains('entrada') || cat.contains('dim sum') || cat.contains('causa')) return '2';
    if (cat.contains('postre') || cat.contains('torta')) return '3';
    return '1';
  }

  void _loadCategoriesAndPromotions() {
    _categories = [
      Category(id: '1', name: 'Platos Principales', description: '...', imageUrl: '', displayOrder: 1),
      Category(id: '2', name: 'Entradas', description: '...', imageUrl: '', displayOrder: 2),
      Category(id: '3', name: 'Postres', description: '...', imageUrl: '', displayOrder: 3),
      Category(id: '4', name: 'Bebidas', description: '...', imageUrl: '', displayOrder: 4),
    ];

    _promotions = [
      Promotion(
        id: '1',
        name: 'Happy Hour',
        description: '2x1 en bebidas de 18:00 a 20:00',
        discountPercentage: 50.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
        applicableProductIds: [],
        imageUrl: 'assets/images/happy_hour.jpg',
      ),
      Promotion(
        id: '2',
        name: 'Martes de Postres',
        description: '30% de descuento en todos los postres los martes',
        discountPercentage: 30.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 60)),
        applicableProductIds: [],
        imageUrl: 'assets/images/dessert_tuesday.jpg',
      ),
    ];
  }

  void _loadDemoProducts() {
    _products = [];
    notifyListeners();
  }

  // Métodos CRUD: los mantuviste igual, no requieren cambios para toppings
  // ... (sin cambios en addProduct, updateProduct, deleteProduct, etc.)

  Future<bool> addProduct(Product product) async {
    final Map<String, String> categoryIdToName = {
      '1': 'Platos Principales',
      '2': 'Entradas',
      '3': 'Postres',
      '4': 'Bebidas',
    };
    final String categoryName = categoryIdToName[product.category] ?? 'Sin categoría';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Nombre': product.name,
        'Descripcion': product.description,
        'Precio': product.price,
        'Categoria': categoryName,
      }),
    );

    if (response.statusCode == 201) {
      await loadDataFromApi();
      return true;
    } else {
      print('Error al agregar producto: ${response.body}');
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    final Map<String, String> categoryIdToName = {
      '1': 'Platos Principales',
      '2': 'Entradas',
      '3': 'Postres',
      '4': 'Bebidas',
    };
    final String categoryName = categoryIdToName[product.category] ?? 'Sin categoría';

    final response = await http.put(
      Uri.parse('$apiUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Nombre': product.name,
        'Descripcion': product.description,
        'Precio': product.price,
        'Categoria': categoryName,
      }),
    );

    if (response.statusCode == 200) {
      await loadDataFromApi();
      return true;
    } else {
      print('Error al actualizar producto: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$productId'));
    if (response.statusCode == 200) {
      await loadDataFromApi();
      return true;
    } else {
      print('Error al eliminar producto: ${response.body}');
      return false;
    }
  }

  Future<bool> addCategory(Category category) async {
    await Future.delayed(Duration(seconds: 1));
    _categories.add(category);
    notifyListeners();
    return true;
  }

  Future<bool> updateCategory(Category category) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteCategory(String categoryId) async {
    await Future.delayed(Duration(seconds: 1));
    _categories.removeWhere((c) => c.id == categoryId);
    notifyListeners();
    return true;
  }

  Future<bool> addPromotion(Promotion promotion) async {
    await Future.delayed(Duration(seconds: 1));
    _promotions.add(promotion);
    notifyListeners();
    return true;
  }

  Future<bool> updatePromotion(Promotion promotion) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _promotions.indexWhere((p) => p.id == promotion.id);
    if (index != -1) {
      _promotions[index] = promotion;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deletePromotion(String promotionId) async {
    await Future.delayed(Duration(seconds: 1));
    _promotions.removeWhere((p) => p.id == promotionId);
    notifyListeners();
    return true;
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((product) => product.category == categoryId).toList();
  }

  List<Promotion> getActivePromotions() {
    final now = DateTime.now();
    return _promotions.where((promo) =>
        promo.isActive &&
        now.isAfter(promo.startDate) &&
        now.isBefore(promo.endDate)).toList();
  }
}
