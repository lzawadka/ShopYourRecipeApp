import 'package:shopyourrecipe/core/entities/step_recipe.dart';

import 'ingredient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<StepRecipe> steps;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = json['ingredients'].map<Ingredient>((json) => Ingredient.fromJson(json)).toList();
    final steps = json['steps'].map<StepRecipe>((json) => StepRecipe.fromJson(json)).toList();

    return Recipe(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      ingredients: ingredients,
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'description': description,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'steps': steps.map((s) => s.toJson()).toList(),
  };
}