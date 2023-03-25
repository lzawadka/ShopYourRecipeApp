import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String displayText;
  final int? maxLine;

  const TextFormWidget({Key? key, required this.textEditingController, required this.displayText, this.maxLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: displayText,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLine,
    );
  }
}