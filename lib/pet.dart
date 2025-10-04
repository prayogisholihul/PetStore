class Pet {
  final int id;
  String name;
  Category category;
  String status;

  Pet({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
  });
}

class Category {
  final int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });
}