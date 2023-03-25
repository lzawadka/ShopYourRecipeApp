import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/recipe.dart';
import '../models/api_response.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<ApiResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> register(String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      body: jsonEncode({'firstName': firstName,'lastName': lastName,'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> getRecipeForUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipe'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> createRecipe(String token, Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/recipe'),
      body: jsonEncode({'title': recipe.title, 'description': recipe.description, 'ingredients': recipe.ingredients, 'steps': recipe.steps}),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

}