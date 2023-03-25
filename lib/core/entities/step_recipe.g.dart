// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepRecipe _$StepRecipeFromJson(Map<String, dynamic> json) => StepRecipe(
      id: json['_id'] as String?,
      instruction: json['instruction'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$StepRecipeToJson(StepRecipe instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'instruction': instance.instruction,
      'imageUrl': instance.imageUrl,
    };
