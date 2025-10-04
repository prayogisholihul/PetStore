import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/provider/pet_provider_domain.dart';
import 'package:pet_store/domain/models/pet_order.dart';

import '../domain/models/pet.dart';

final petsProvider = FutureProvider.autoDispose<List<Pet>>((ref) async {
  final getPets = ref.read(getPetsUseCaseProvider);
  return await getPets();
});

final deletePetProvider = Provider.autoDispose<Future<void> Function(int, WidgetRef)>((ref) {
  final deletePet = ref.read(deletePetUseCaseProvider);
  return (int id, WidgetRef widgetRef) async {
    try {
      await deletePet(id);
      // re-fetch pets after successful delete
      widgetRef.invalidate(petsProvider);
    } catch (e) {
      rethrow;
    }
  };
});

final updatePetProvider = Provider.autoDispose<Future<Pet> Function(Pet)>((ref) {
  final updatePet = ref.read(updatePetUseCaseProvider);

  return (Pet pet) async {
    final result = await updatePet(pet);
    // refresh pets list after update
    ref.invalidate(petsProvider);
    return result;
  };
});

final createPetProvider = Provider.autoDispose<Future<Pet> Function(Pet)>((ref) {
  final updatePet = ref.read(createPetUseCaseProvider);

  return (Pet pet) async {
    final result = await updatePet(pet);
    // refresh pets list after create
    ref.invalidate(petsProvider);
    return result;
  };
});

final purchaseLoadingProvider = StateProvider.family.autoDispose<bool, int>((ref, petId) => false);

final purchaseOrderProvider =
FutureProvider.family<void, Order>((ref, order) async {
  final repo = ref.read(orderPetsUseCaseProvider);
  await repo.repository.orderPet(order);
});
