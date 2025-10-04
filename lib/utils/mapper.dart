
import 'package:pet_store/domain/models/pet.dart';
import 'package:pet_store/repository/response/pet_response.dart';

extension PetMapper on PetResponse {
  Pet toEntity() {
    return Pet(
      id: id ?? 0,
      name: name ?? "",
      category: Category(id: category?.id ?? 0, name: category?.name ?? ""),
      status: status ?? "",
    );
  }
}
