import 'recipe.dart';
import 'shopping_list.dart';

class UserGroup {
  final String id;
  final List<String> members;
  final List<Recipe> sharedRecipes;
  final List<ShoppingList> sharedShoppingLists;

  UserGroup({
    required this.id,
    required this.members,
    required this.sharedRecipes,
    required this.sharedShoppingLists,
  });
}