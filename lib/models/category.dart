class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;
  final int displayOrder;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isActive = true,
    this.displayOrder = 0,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isActive,
    int? displayOrder,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'displayOrder': displayOrder,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isActive: map['isActive'] ?? true,
      displayOrder: map['displayOrder'] ?? 0,
    );
  }
}
