
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/pet_order.dart';

import '../pet_repo_provider.dart';
import '../pet_usecase.dart';


final getPetsUseCaseProvider = Provider<GetPetsUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return GetPetsUseCase(repo);
});

final getPetByIdUseCaseProvider = Provider<GetPetByIdUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return GetPetByIdUseCase(repo);
});

final createPetUseCaseProvider = Provider<CreatePetUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return CreatePetUseCase(repo);
});

final updatePetUseCaseProvider = Provider<UpdatePetUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return UpdatePetUseCase(repo);
});

final deletePetUseCaseProvider = Provider<DeletePetUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return DeletePetUseCase(repo);
});

final orderPetsUseCaseProvider = Provider<OrderPetUseCase>((ref) {
  final repo = ref.read(petRepositoryProvider);
  return OrderPetUseCase(repo);
});