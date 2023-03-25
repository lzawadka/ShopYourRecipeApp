import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/entities/step_recipe.dart';

class StepDialog extends StatefulWidget {
  const StepDialog({Key? key}) : super(key: key);

  @override
  _StepDialogState createState() => _StepDialogState();
}

class _StepDialogState extends State<StepDialog> {
  final _formKey = GlobalKey<FormState>();
  final _instructionController = TextEditingController();
  final picker = ImagePicker();
  File? _imageFile;

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle étape'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _instructionController,
              decoration: InputDecoration(
                labelText: 'Instruction de l\'étape',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une étape';
                }
                return null;
              },
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 100,
                width: 100,
                child: _imageFile == null
                    ? const Icon(Icons.add_a_photo)
                    : Image.file(_imageFile!),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Ajouter'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(
                StepRecipe(
                  instruction: _instructionController.text,
                  imageUrl: _imageFile?.path ?? '',
                ),
              );
            }
          },
        ),
      ],
    );
  }
}