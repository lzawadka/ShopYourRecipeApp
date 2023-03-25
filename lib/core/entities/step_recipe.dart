import 'package:json_annotation/json_annotation.dart';

part 'step_recipe.g.dart';

@JsonSerializable()
class StepRecipe {
  @JsonKey(name: '_id')
  final String? id;
  final String instruction;
  late final String imageUrl;

  StepRecipe({this.id, required this.instruction, required this.imageUrl});

  factory StepRecipe.fromJson(Map<String, dynamic> json) {
    return StepRecipe(
      id: json['_id'],
      instruction: json['instruction'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'instruction': instruction,
    'image': imageUrl,
  };
}