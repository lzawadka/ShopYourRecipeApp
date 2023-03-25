import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopyourrecipe/data/models/api_response.dart';
import '../../data/services/api_service.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;

  AuthProvider({required this.apiService});

  Future<bool> signIn(String email, String password) async {
    try {
      final ApiResponse response = await apiService.login(email, password);
      print(response.data);
      if (response.code == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        return true;
      } else  {
        throw Exception('Email ou mot de passe incorrect');
      }
    } catch (e) {
      throw Exception('Failed to log in');
    }
    return false;
  }

  FutureOr<bool> signUp(String firstName, String lastName, String email, String password) async {
    try {
      final ApiResponse response = await apiService.register(
          firstName, lastName, email, password);

      if (response.code == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        return true;
      } else if (response.code == 409) {
        return false;
      }
    } catch (e) {
      throw Exception("Une erreur est survenue");
    }

    return false;
  }
}