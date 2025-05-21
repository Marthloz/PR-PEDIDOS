import 'ToppingOption.dart'; // asegúrate que el archivo se llama así y está en el mismo folder

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final List<String> ingredients;
  final List<String> allergens;
  final List<ToppingOption> toppings;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.ingredients = const [],
    this.allergens = const [],
    this.toppings = const [],
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    List<String>? ingredients,
    List<String>? allergens,
    List<ToppingOption>? toppings,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      toppings: toppings ?? this.toppings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'ingredients': ingredients,
      'allergens': allergens,
      'toppings': toppings.map((t) => t.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      isAvailable: map['isAvailable'] ?? true,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      allergens: List<String>.from(map['allergens'] ?? []),
      toppings: map['toppings'] != null
          ? List<ToppingOption>.from(
              map['toppings'].map((t) => ToppingOption.fromMap(t)))
          : [],
    );
  }
}
