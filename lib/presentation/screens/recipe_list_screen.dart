import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopyourrecipe/presentation/blocs/recipe_provider.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_detail_screen.dart';

import '../../core/entities/recipe.dart';
import '../../data/models/recipe_session.dart';
import '../../data/services/api_service.dart';
import '../widgets/add_recipe_button_widget.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/recipe_card_widget.dart';
import 'add_recipe_screen.dart';


class RecipeListScreen extends StatefulWidget {
  static const routeName = '/recipe-list';
  final RecipeSession recipeSession;

  RecipeListScreen({Key? key, required this.recipeSession}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeListScreen> {
  // Ici, vous devrez charger les recettes de l'utilisateur à partir de votre API.
  // Pour cet exemple, nous utiliserons une liste fictive de recettes.
  List<Recipe> _recipes = [];

  Future<void> loadUserRecipes() async {
    final List<Recipe> recipes = await RecipeProvider(apiService: ApiService(baseUrl: 'http://localhost:8080')).getRecipesUser();
    print(recipes[0]);
    setState(() {
      _recipes = recipes;
    });
  }
  void initState() {
    super.initState();
    print(loadUserRecipes());
    loadUserRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavbarWidget(),
      body: Consumer<RecipeSession>(
        builder: (context, session, child) => ListView.builder(
          itemCount: _recipes.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = _recipes[index];
            return RecipeCardWidget(recipe: recipe);
          },
        ),
      ),
      floatingActionButton: AddRecipeButtonWidget(),
    );
  }
}