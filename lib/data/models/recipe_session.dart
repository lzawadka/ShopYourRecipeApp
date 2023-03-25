import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopyourrecipe/core/entities/step_recipe.dart';

import '../../core/entities/ingredient.dart';
import '../../core/entities/recipe.dart';

class RecipeSession with ChangeNotifier {
  static final RecipeSession _singleton = RecipeSession._internal();
  static RecipeSession get instance => _singleton;
  RecipeSession._internal();

  RecipeSession();

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  set recipes(List<Recipe> recipes) {
    _recipes = recipes;
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(int index) {
    _recipes.removeAt(index);
    notifyListeners();
  }
}