import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopyourrecipe/presentation/blocs/auth_provider.dart';
import 'package:shopyourrecipe/presentation/screens/add_recipe_screen.dart';
import 'package:shopyourrecipe/presentation/screens/home_screen.dart';
import 'package:shopyourrecipe/presentation/screens/login_screen.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_detail_screen.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_list_screen.dart';
import 'data/models/recipe_session.dart';
import 'data/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recipeSession = RecipeSession.instance;

  runApp(MyApp(
    recipeSession: recipeSession,
  ));
}
class MyApp extends StatelessWidget {
  final RecipeSession recipeSession;

  const MyApp({Key? key, required this.recipeSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(apiService: ApiService(baseUrl: 'http://localhost:8080')),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeSession(),
        ),
      ],
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.pink,
              ),
              initialRoute: LoginScreen.routeName,
              routes: {
                LoginScreen.routeName: (context) => LoginScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                CreateRecipeScreen.routeName: (context) =>
                    CreateRecipeScreen(
                      addRecipeToSession: recipeSession.addRecipe,
                      recipeSession: recipeSession,
                    ),
                RecipeDetailScreen.routeName: (context) {
                  final args = ModalRoute
                      .of(context)!
                      .settings
                      .arguments as RecipeDetailScreenArgs;
                  return RecipeDetailScreen(args: args);
                },
                RecipeListScreen.routeName: (context) => RecipeListScreen(recipeSession: recipeSession),
              },
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      ),
    );
  }
}