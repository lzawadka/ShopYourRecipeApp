import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/entities/recipe.dart';
import '../screens/recipe_detail_screen.dart';


class RecipeCardWidget extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardWidget({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: recipe.steps.isNotEmpty ? NetworkImage(
              recipe.steps.first.imageUrl) : null,
        ),
        title: Text(recipe.title),
        subtitle: Text(recipe.description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(
            context,
            RecipeDetailScreen.routeName,
            arguments: RecipeDetailScreenArgs(recipe: recipe),
          );
        },
      ),
    );
  }
}