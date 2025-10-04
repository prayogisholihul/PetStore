
import 'package:pet_store/domain/models/pet_order.dart';
import 'package:pet_store/repository/response/pet_response.dart';

/// Abstract contract for Pet repository
abstract class PetRepository {
  Future<List<PetResponse>> getPets();
  Future<PetResponse> getPetById(int id);
  Future<PetResponse> createPet(PetResponse pet);
  Future<PetResponse> updatePet(PetResponse pet);
  Future<void> deletePet(int id);
  Future<void> orderPet(Order order);
}
