import 'package:pet_store/utils/mapper.dart';
import 'package:pet_store/domain/models/pet.dart';
import 'package:pet_store/domain/models/pet_order.dart';
import 'package:pet_store/repository/pet_repository.dart';
import 'package:pet_store/repository/response/pet_response.dart';

class GetPetsUseCase {
  final PetRepository repository;
  GetPetsUseCase(this.repository);

  Future<List<Pet>> call() async {
    final responses = await repository.getPets();
    return responses.map((e) => e.toEntity()).toList();
  }
}

class GetPetByIdUseCase {
  final PetRepository repository;
  GetPetByIdUseCase(this.repository);

  Future<Pet> call(int id) async {
    final response = await repository.getPetById(id);
    return response.toEntity();
  }
}

class CreatePetUseCase {
  final PetRepository repository;
  CreatePetUseCase(this.repository);

  Future<Pet> call(Pet pet) async {
    final petResponse = PetResponse(
      id: DateTime.now().millisecondsSinceEpoch,
      name: pet.name,
      category: CategoryResponse(id: pet.category.id, name: pet.category.name),
      photoUrls: [],
      tags: [],
      status: pet.status,
    );
    final createdResponse = await repository.createPet(petResponse);
    return createdResponse.toEntity();
  }
}

class UpdatePetUseCase {
  final PetRepository repository;
  UpdatePetUseCase(this.repository);

  Future<Pet> call(Pet pet) async {
    final petResponse = PetResponse(
      id: pet.id,
      name: pet.name,
      category: CategoryResponse(id: pet.category.id, name: pet.category.name),
      photoUrls: [],
      tags: [],
      status: pet.status,
    );

    final response = await repository.updatePet(petResponse);
    return response.toEntity();
  }
}

class DeletePetUseCase {
  final PetRepository repository;
  DeletePetUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deletePet(id);
  }
}

class OrderPetUseCase {
  final PetRepository repository;
  OrderPetUseCase(this.repository);

  Future<void> call(Order order) async {
    await repository.orderPet(order);
  }
}