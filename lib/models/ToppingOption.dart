class ToppingOption {
  final String name;
  final double extraCost;

  ToppingOption({
    required this.name,
    this.extraCost = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'extraCost': extraCost,
    };
  }

  factory ToppingOption.fromMap(Map<String, dynamic> map) {
    return ToppingOption(
      name: map['name'],
      extraCost: (map['extraCost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
