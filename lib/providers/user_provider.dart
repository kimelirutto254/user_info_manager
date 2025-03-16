import 'package:flutter/material.dart';
import 'package:frontend_interview/model/user.dart';
import 'package:frontend_interview/services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;

  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    if (_isLoading) return;
    _setLoading(true);

    try {
      List<dynamic> userData = await _apiService.fetchUsers();
      _users = userData.map((data) => User.fromJson(data)).toList();
    } catch (e) {
      _users = [];
      debugPrint("Error loading users: $e");
    }

    _setLoading(false);
  }

  Future<void> loadUser(String id) async {
    if (_isLoading) return;
    _setLoading(true);

    try {
      Map<String, dynamic>? userData = await _apiService.fetchUserById(id);
      if (userData != null) {
        _selectedUser = User.fromJson(userData);
      }
    } catch (e) {
      _selectedUser = null;
      debugPrint("Error loading user: $e");
    }

    _setLoading(false);
  }

  Future<bool> updateUser(String id, User updatedUser) async {
    _setLoading(true);
    try {
      bool success = await _apiService.updateUser(id, updatedUser.toJson());
      if (success) {
        _selectedUser = updatedUser;

        int index = _users.indexWhere((user) => user.id == id);
        if (index != -1) {
          _users[index] = updatedUser;
        }

        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error updating user: $e");
    } finally {
      _setLoading(false);
    }
    return false;
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
