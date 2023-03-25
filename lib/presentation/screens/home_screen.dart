import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopyourrecipe/presentation/blocs/recipe_provider.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_detail_screen.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_list_screen.dart';

import '../../data/models/recipe_session.dart';
import '../widgets/add_recipe_button_widget.dart';
import '../widgets/bottom_navbar.dart';
import 'add_recipe_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Center(
        child: Text('Bienvenue !'),
      ),
      floatingActionButton: AddRecipeButtonWidget(),
      bottomNavigationBar: const BottomNavbarWidget(),
    );
  }
}