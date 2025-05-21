class Promotion {
  final String id;
  final String name;
  final String description;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> applicableProductIds;
  final String imageUrl;
  final bool isActive;

  Promotion({
    required this.id,
    required this.name,
    required this.description,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    this.applicableProductIds = const [],
    required this.imageUrl,
    this.isActive = true,
  });

  Promotion copyWith({
    String? id,
    String? name,
    String? description,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? applicableProductIds,
    String? imageUrl,
    bool? isActive,
  }) {
    return Promotion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      applicableProductIds: applicableProductIds ?? this.applicableProductIds,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'discountPercentage': discountPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'applicableProductIds': applicableProductIds,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  factory Promotion.fromMap(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      discountPercentage: map['discountPercentage'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      applicableProductIds: List<String>.from(map['applicableProductIds'] ?? []),
      imageUrl: map['imageUrl'],
      isActive: map['isActive'] ?? true,
    );
  }

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}
