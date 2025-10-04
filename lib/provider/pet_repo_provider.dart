import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pet_store/repository/pet_repo_impl.dart';
import 'package:pet_store/repository/pet_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepositoryImpl(client: http.Client());
});
