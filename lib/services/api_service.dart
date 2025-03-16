import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://frontend-interview.touchinspiration.net/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // Fetch all users
  Future<List<dynamic>> fetchUsers() async {
    try {
      Response response = await _dio.get('/users');
      return response.data;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Fetch a single user by ID
  Future<Map<String, dynamic>?> fetchUserById(String id) async {
    try {
      Response response = await _dio.get('/user/$id');
      return response.data;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Update a user by ID
  Future<bool> updateUser(String id, Map<String, dynamic> updatedData) async {
    try {
      Response response = await _dio.patch('/user/$id', data: updatedData);
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }
}
