import 'ingredient.dart';

class ShoppingList {
  final String id;
  final String userId;
  final List<Ingredient> ingredients;

  ShoppingList({
    required this.id,
    required this.userId,
    required this.ingredients,
  });
}