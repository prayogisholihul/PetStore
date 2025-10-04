import 'dart:convert';

class PetResponse {
  int? id;
  CategoryResponse? category;
  String? name;
  List<String>? photoUrls;
  List<CategoryResponse>? tags;
  String? status;

  PetResponse({
    this.id,
    this.category,
    this.name,
    this.photoUrls,
    this.tags,
    this.status,
  });

  factory PetResponse.fromRawJson(String str) => PetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PetResponse.fromJson(Map<String, dynamic> json) => PetResponse(
    id: json["id"],
    category: json["category"] == null ? null : CategoryResponse.fromJson(json["category"]),
    name: json["name"],
    photoUrls: json["photoUrls"] == null ? [] : List<String>.from(json["photoUrls"]!.map((x) => x)),
    tags: json["tags"] == null ? [] : List<CategoryResponse>.from(json["tags"]!.map((x) => CategoryResponse.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category?.toJson(),
    "name": name,
    "photoUrls": photoUrls == null ? [] : List<dynamic>.from(photoUrls!.map((x) => x)),
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "status": status,
  };
}

class CategoryResponse {
  int? id;
  String? name;

  CategoryResponse({
    this.id,
    this.name,
  });

  factory CategoryResponse.fromRawJson(String str) => CategoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
