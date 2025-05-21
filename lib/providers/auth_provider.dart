import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // In a real app, this would make an API call to authenticate
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, accept any login with valid format
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
      print('Login error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    // In a real app, this would make an API call to change password
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, always succeed
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  Future<List<User>> getUsers() async {
    // In a real app, this would make an API call to get users
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // Return dummy data
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
    } catch (e) {
      print('Get users error: $e');
      return [];
    }
  }

  Future<bool> addUser(User user) async {
    // In a real app, this would make an API call to add a user
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, always succeed
      return true;
    } catch (e) {
      print('Add user error: $e');
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    // In a real app, this would make an API call to update a user
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, always succeed
      return true;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    // In a real app, this would make an API call to delete a user
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      // For demo purposes, always succeed
      return true;
    } catch (e) {
      print('Delete user error: $e');
      return false;
    }
  }
}
