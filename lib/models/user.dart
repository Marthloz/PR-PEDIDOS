enum UserRole { admin, cashier, waiter, chef }

class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role.toString().split('.').last,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == map['role'],
        orElse: () => UserRole.cashier,
      ),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    );
  }

  String get roleString {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.cashier:
        return 'Cajero';
      case UserRole.waiter:
        return 'Mesero';
      case UserRole.chef:
        return 'Cocinero';
      default:
        return 'Desconocido';
    }
  }
}
