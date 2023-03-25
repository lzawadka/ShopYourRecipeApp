import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/bottom_navbar.dart';

class ShoppingListScreen extends StatelessWidget {
  static const routeName = '/shopping-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de courses'),
      ),
      body: FutureBuilder<List<String>>(
        future: getShoppingList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final shoppingList = snapshot.data!;
              if (shoppingList.isEmpty) {
                return Center(
                  child: Text('La liste de courses est vide.'),
                );
              } else {
                return ListView.builder(
                  itemCount: shoppingList.length,
                  itemBuilder: (context, index) {
                    final ingredient = shoppingList[index];
                    return ListTile(
                      title: Text(ingredient),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: Text('La liste de courses est vide.'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavbarWidget(),
    );
  }

  Future<List<String>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingList = prefs.getStringList('shoppingList') ?? [];
    return shoppingList;
  }
}