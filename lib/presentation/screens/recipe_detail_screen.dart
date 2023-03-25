import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/recipe_session.dart';

import '../../core/entities/recipe.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/image_widget.dart';

class RecipeDetailScreenArgs {
  final Recipe recipe;
  RecipeDetailScreenArgs({required this.recipe});
}

class RecipeDetailScreen extends StatelessWidget {
  final RecipeDetailScreenArgs args;

  static const routeName = '/recipe-detail';
  RecipeDetailScreen({required this.args});

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = args.recipe;

    return Scaffold(
      bottomNavigationBar: const BottomNavbarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (recipe.steps.isNotEmpty)
              CachedNetworkImage(
                imageUrl: recipe.steps.first.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final shoppingList = prefs.getStringList('shoppingList') ?? [];

                for (final ingredient in recipe.ingredients) {
                  shoppingList.add(ingredient.name);
                }

                await prefs.setStringList('shoppingList', shoppingList);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Les ingrédients ont été ajoutés à la liste de courses.'),
                  ),
                );
              },
              child: Text('Ajouter à la liste de courses'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                recipe.description,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ingredients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            ...recipe.ingredients.map(
                  (ingredient) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('- '),
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Steps',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            ...recipe.steps.map(
                  (step) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      step.instruction,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ImageWidget(imageUrl: step.imageUrl),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}