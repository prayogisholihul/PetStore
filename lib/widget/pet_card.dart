import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/provider/pet_provider_page.dart';
import 'package:pet_store/domain/models/pet.dart';
import 'package:pet_store/domain/models/pet_order.dart';

class PetCard extends ConsumerStatefulWidget {
  final Pet pet;
  const PetCard({required this.pet, super.key});

  @override
  ConsumerState<PetCard> createState() => _PetCardState();
}

class _PetCardState extends ConsumerState<PetCard> {
  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    // ✅ Watch loading state for this pet
    final isLoading = ref.watch(purchaseLoadingProvider(pet.id));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.pets, size: 48, color: Colors.blue.shade400),
            Text(
              pet.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Status: ${pet.status}",
              style: TextStyle(
                color: pet.status == "available" ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () async {
                  ref.read(purchaseLoadingProvider(pet.id).notifier).state = true;

                  final order = Order(
                    petId: pet.id,
                    quantity: 1,
                    shipDate: DateTime.now(),
                    status: "approved",
                    complete: true,
                  );

                  try {
                    await ref.read(purchaseOrderProvider(order).future);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Purchased ${pet.name}!")),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Purchase failed: $e")),
                      );
                    }
                  } finally {
                    ref.read(purchaseLoadingProvider(pet.id).notifier).state = false;
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text("Purchase"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
