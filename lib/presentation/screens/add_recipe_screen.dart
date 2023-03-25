import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopyourrecipe/core/entities/step_recipe.dart';
import 'package:shopyourrecipe/presentation/screens/recipe_detail_screen.dart';
import 'package:shopyourrecipe/presentation/screens/step_dialog_screen.dart';
import 'package:shopyourrecipe/presentation/widgets/bottom_navbar.dart';
import '../../data/services/api_service.dart';
import '../blocs/recipe_provider.dart';
import '../screens/recipe_detail_screen.dart';

import '../../core/entities/ingredient.dart';
import '../../core/entities/recipe.dart';
import '../../data/models/recipe_session.dart';
import '../widgets/text_form_widget.dart';

class CreateRecipeScreen extends StatefulWidget {
  static const routeName = '/create-recipe';

  final RecipeSession recipeSession;
  final Function(Recipe) addRecipeToSession;
  CreateRecipeScreen({required this.addRecipeToSession, required this.recipeSession});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _stepInstructionController = TextEditingController();
  final _stepImageUrlController = TextEditingController();
  final picker = ImagePicker();

  final List<TextEditingController> _ingredientControllers = List.generate(
    10,
    (index) => TextEditingController(),
  );

  List<Ingredient> _ingredients = [];
  List<StepRecipe> _steps = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _ingredientNameController.dispose();
    _stepInstructionController.dispose();
    _stepImageUrlController.dispose();
    super.dispose();
  }

  void _addNewIngredientField() async {
    String? newIngredient = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String ingredientName = '';
        return AlertDialog(
          title: Text('Nouvel ingrédient'),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nom de l\'ingrédient',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un ingrédient';
              }
              return null;
            },
            onChanged: (value) {
              ingredientName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (ingredientName.isNotEmpty) {
                  Navigator.of(context).pop(ingredientName);
                }
              },
            ),
          ],
        );
      },
    );
    if (newIngredient != null && newIngredient.isNotEmpty) {
      setState(() {
        _ingredients.add(Ingredient(
            name: newIngredient, id: UniqueKey().toString(), category: 'Cat'));
      });
    }
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredients.removeAt(index);
      _ingredientControllers.removeAt(index);
    });
  }

  void _addNewStep() async {
    final newStep = await showDialog<StepRecipe>(
      context: context,
      builder: (BuildContext context) {
        return StepDialog();
      },
    );
    if (newStep != null) {
      setState(() {
        _steps.add(newStep);
      });
    }
  }

  void _createRecipe() async {
    if (_formKey.currentState!.validate()) {
      Recipe newRecipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        ingredients: _ingredients,
        steps: _steps,
        id: UniqueKey().toString(),
      );

      final bool isCreated = await RecipeProvider(apiService: ApiService(baseUrl: 'http://localhost:8080')).createRecipes(newRecipe);
      widget.addRecipeToSession(newRecipe);
      setState((){});

      Navigator.pushReplacementNamed(
        context,
        RecipeDetailScreen.routeName,
        arguments: RecipeDetailScreenArgs(recipe: newRecipe),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormWidget(textEditingController: _titleController, displayText: 'Titre'),
                SizedBox(height: 16.0),
                TextFormWidget(textEditingController: _descriptionController, displayText: 'Description', maxLine: 3),
                SizedBox(height: 16.0),
                Text(
                  'Ingrédients',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _ingredients.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            _ingredients[index].name,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeIngredientField(index),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Container(),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: _addNewIngredientField,
                      child: Text('Ajouter'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  'Étapes',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _addNewStep,
                  child: Text('Ajouter une étape'),
                ),
                SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _steps.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Text("${index + 1}."),
                          title: Text(_steps[index].instruction),
                          trailing: InkWell(
                            onTap: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  _steps[index].imageUrl = pickedFile.path;
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: _steps[index].imageUrl.isEmpty
                                  ? Icon(Icons.add_a_photo)
                                  : Image.file(File(_steps[index].imageUrl)),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _createRecipe,
                  child: Text('Créer la recette'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
