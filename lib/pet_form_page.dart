import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/controller/pet_provider_page.dart';
import 'package:pet_store/pet.dart';

class PetFormPage extends ConsumerStatefulWidget {
  final Pet? pet; // null = create, not null = update
  const PetFormPage({super.key, this.pet});

  @override
  ConsumerState<PetFormPage> createState() => _PetFormPageState();
}

class _PetFormPageState extends ConsumerState<PetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _categoryCtrl;
  late String _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.pet?.name ?? "");
    _categoryCtrl = TextEditingController(text: widget.pet?.category.name ?? "");
    _status = widget.pet?.status ?? "available";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final pet = Pet(
      id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameCtrl.text,
      category: Category(id: 0, name: _categoryCtrl.text),
      status: _status,
    );

    try {
      if (widget.pet == null) {
        final create = ref.read(createPetProvider);
        await create(pet);
      } else {
        final update = ref.read(updatePetProvider);
        await update(pet);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pet == null ? "Create Pet" : "Update Pet"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Pet Name"),
              validator: (v) => v!.isEmpty ? "Enter name" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _categoryCtrl,
              decoration: const InputDecoration(labelText: "Category"),
              validator: (v) => v!.isEmpty ? "Enter category" : null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _status,
              items: const [
                DropdownMenuItem(value: "available", child: Text("Available")),
                DropdownMenuItem(value: "pending", child: Text("Pending")),
                DropdownMenuItem(value: "sold", child: Text("Sold")),
              ],
              onChanged: (v) => setState(() => _status = v!),
              decoration: const InputDecoration(labelText: "Status"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _onSubmit,
          child: _isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(widget.pet == null ? "Create" : "Update"),
        ),
      ],
    );
  }
}
