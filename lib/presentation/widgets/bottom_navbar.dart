import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../screens/home_screen.dart';
import '../screens/recipe_list_screen.dart';

class BottomNavbarWidget extends StatelessWidget {

  const BottomNavbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () {
              Navigator.of(context).pushNamed(RecipeListScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(RecipeListScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}