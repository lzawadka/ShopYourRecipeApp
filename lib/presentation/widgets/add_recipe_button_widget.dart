import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/recipe_session.dart';
import '../screens/add_recipe_screen.dart';

class AddRecipeButtonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateRecipeScreen(
              addRecipeToSession: Provider.of<RecipeSession>(context, listen: false).addRecipe,
              recipeSession: Provider.of<RecipeSession>(context, listen: false),
            ),
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }
}