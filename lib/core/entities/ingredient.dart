import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String category;

  Ingredient({this.id, required this.name, required this.category});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'category': category,
  };
}