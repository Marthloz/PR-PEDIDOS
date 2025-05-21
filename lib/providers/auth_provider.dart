import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  final bool modoDemo = true;

  final String apiBaseUrl = 'http://localhost:3000/api/usuarios';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    if (modoDemo) {
      // Modo demo, sin conexión
      try {
        await Future.delayed(Duration(seconds: 1));
        if (email.isNotEmpty && password.length >= 6) {
          _currentUser = User(
            id: '1',
            name: 'Admin User',
            phone: '123456789',
            email: email,
            role: UserRole.admin,
            createdAt: DateTime.now(),
            lastLogin: DateTime.now(),
          );
          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
        return false;
      } catch (e) {
        print('Login error (demo): $e');
        return false;
      }
    } else {
      // Aquí podrías hacer una validación real con la tabla `Usuarios` si hubiera un endpoint de login.
      try {
        final response = await http.get(Uri.parse(apiBaseUrl));
        if (response.statusCode == 200) {
          final List users = jsonDecode(response.body);
          final matched = users.firstWhere(
            (u) => u['Username'] == email && u['Password'] == password,
            orElse: () => null,
          );
          if (matched != null) {
            _currentUser = User(
              id: matched['UsuarioId'].toString(),
              name: matched['Username'],
              phone: '',
              email: matched['Username'],
              role: UserRole.admin,
              createdAt: DateTime.now(),
              lastLogin: DateTime.now(),
            );
            _isAuthenticated = true;
            notifyListeners();
            return true;
          }
        }
        return false;
      } catch (e) {
        print('Login error (real): $e');
        return false;
      }
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    // No implementado aún en backend
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<List<User>> getUsers() async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      return [
        User(
          id: '1',
          name: 'Admin Principal',
          phone: '123456789',
          email: 'admin@restaurant.com',
          role: UserRole.admin,
          createdAt: DateTime.now().subtract(Duration(days: 100)),
          lastLogin: DateTime.now(),
        ),
        User(
          id: '2',
          name: 'Juan Pérez',
          phone: '987654321',
          email: 'juan@restaurant.com',
          role: UserRole.cashier,
          createdAt: DateTime.now().subtract(Duration(days: 50)),
          lastLogin: DateTime.now().subtract(Duration(days: 1)),
        ),
        User(
          id: '3',
          name: 'María López',
          phone: '456789123',
          email: 'maria@restaurant.com',
          role: UserRole.waiter,
          isActive: false,
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          lastLogin: DateTime.now().subtract(Duration(days: 10)),
        ),
      ];
    } else {
      try {
        final response = await http.get(Uri.parse(apiBaseUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return List<User>.from(data.map((u) => User(
            id: u['UsuarioId'].toString(),
            name: u['Username'],
            email: u['Username'],
            phone: '',
            role: UserRole.admin,
            createdAt: DateTime.now(),
            lastLogin: DateTime.now(),
          )));
        }
        return [];
      } catch (e) {
        print('Get users error (real): $e');
        return [];
      }
    }
  }

  Future<bool> addUser(User user) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } else {
      try {
        final response = await http.post(
          Uri.parse(apiBaseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'Username': user.email,
            'Password': '123456', // Forzado, sin login real aún
            'IsActivo': true,
          }),
        );
        return response.statusCode == 201;
      } catch (e) {
        print('Add user error: $e');
        return false;
      }
    }
  }

  Future<bool> updateUser(User user) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } else {
      try {
        final response = await http.put(
          Uri.parse('$apiBaseUrl/${user.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'Username': user.email}),
        );
        return response.statusCode == 200;
      } catch (e) {
        print('Update user error: $e');
        return false;
      }
    }
  }

  Future<bool> deleteUser(String userId) async {
    if (modoDemo) {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } else {
      try {
        final response = await http.delete(Uri.parse('$apiBaseUrl/$userId'));
        return response.statusCode == 200;
      } catch (e) {
        print('Delete user error: $e');
        return false;
      }
    }
  }
}
