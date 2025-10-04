import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_store/pet_order.dart';
import 'package:pet_store/pet_repository.dart';
import 'package:pet_store/pet_response.dart';

class PetRepositoryImpl implements PetRepository {
  final http.Client client;

  PetRepositoryImpl({
    required this.client
  });
  bool get _isWeb => identical(0, 0.0);

  String get baseUrl {
    if (_isWeb) {
      // 🔹 Use a proxy for web since Petstore API has no CORS
      return "https://cors-anywhere.herokuapp.com/https://petstore3.swagger.io/api/v3";
    }
    return "https://petstore3.swagger.io/api/v3";
  }

  @override
  Future<List<PetResponse>> getPets() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/pet/findByStatus?status=available'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => PetResponse.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch pets (status: ${response.statusCode})');
      }
    } catch (e, stacktrace) {
      // Log error and stacktrace for debugging
      throw Exception('Error fetching pets: $e');
    }
  }


  @override
  Future<PetResponse> getPetById(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/pet/$id'));
    if (response.statusCode == 200) {
      return PetResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch pet');
    }
  }

  @override
  Future<PetResponse> createPet(PetResponse pet) async {
    final response = await client.post(
      Uri.parse('$baseUrl/pet'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    if (response.statusCode == 200) {
      return PetResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create pet');
    }
  }

  @override
  Future<PetResponse> updatePet(PetResponse pet) async {
    final response = await client.put(
      Uri.parse('$baseUrl/pet'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    if (response.statusCode == 200) {
      return PetResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update pet');
    }
  }

  @override
  Future<void> deletePet(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/pet/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pet');
    }
  }

  @override
  Future<void> orderPet(Order order) async {
    final response = await client.post(
      Uri.parse('$baseUrl/store/order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create order (status: ${response.statusCode})');
    }
  }
}
