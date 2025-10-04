import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/provider/pet_provider_page.dart';
import 'package:pet_store/domain/models/pet.dart';
import 'package:pet_store/screen/pet_form_page.dart';

class PetsListPage extends ConsumerWidget {
  const PetsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Petstore Backoffice'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: petsAsync.hasError ? null : FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => Dialog(
                    child: SizedBox(
                      width: 400,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: PetFormPage(),
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created new pet')),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Pet"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: petsAsync.when(
          data: (pets) => _buildDataTable(context, ref, pets),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, WidgetRef ref, List<Pet> pets) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 32,
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: pets.map(
                      (pet) =>
                      DataRow(
                        cells: [
                          DataCell(Text(pet.id.toString())),
                          DataCell(Align(
                            alignment: Alignment.centerLeft,
                            child: Text(pet.name),
                          )),
                          DataCell(Text(pet.status ?? "unknown")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                                onPressed: () async {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder: (_) =>
                                        Dialog(
                                          child: SizedBox(
                                            width: 400,
                                            height: MediaQuery.of(context).size.height * 0.6,
                                            child: PetFormPage(pet: pet),
                                          ),
                                        ),
                                  );
                                  // if (result == true) ref.invalidate(petsProvider);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.delete, color: Colors.red),
                                tooltip: 'Delete',
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        bool isDeleting = false;
                                        return StatefulBuilder(
                                          builder: (context, setState) => AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: Text('Are you sure you want to delete "${pet.name}"?'),
                                            actions: [
                                              TextButton(
                                                onPressed: isDeleting ? null : () => Navigator.pop(context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                onPressed: isDeleting
                                                    ? null
                                                    : () async {
                                                  setState(() => isDeleting = true);
                                                  final deletePet = ref.read(deletePetProvider);
                                                  await deletePet(pet.id, ref);
                                                  if (context.mounted) {
                                                    Navigator.pop(context, true); // close with success
                                                  }
                                                },
                                                child: isDeleting
                                                    ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                                    : const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    if (confirmed == true && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Deleted "${pet.name}"')),
                                      );
                                    }
                                  }
                              ),

                            ],
                          )),
                        ],
                      ),
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
