import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopyourrecipe/data/models/api_response.dart';
import '../../core/entities/recipe.dart';
import '../../data/services/api_service.dart';
import 'package:dio/dio.dart';

class RecipeProvider extends ChangeNotifier {
  final ApiService apiService;

  RecipeProvider({required this.apiService});


  Future<List<Recipe>> getRecipesUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString('token');
      final ApiResponse response;
      if(token != null) {
        response = await apiService.getRecipeForUser(token);

        if (response.code == 200) {
          final List<dynamic> recipeJsonList = response.data['recipes'];
          final List<Recipe> recipeList = recipeJsonList.map((json) => Recipe.fromJson(json)).toList();
          print(recipeList[0]);
          return recipeList;
        } else {
          throw Exception("Une erreur est survenue");
        }
      }
      } catch (e) {
      throw Exception("Une erreur est survenue");
    }
    return [];
  }

  Future<bool> createRecipes(Recipe recipe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString('token');
      final ApiResponse response;
      if(token != null) {
        response = await apiService.createRecipe(token, recipe);

        if (response.code == 200) {
          return true;
        } else {
          throw Exception("Une erreur est survenue");
        }
      }
    } catch (e) {
      throw Exception("Une erreur est survenue");
    }
    return false;
  }
}