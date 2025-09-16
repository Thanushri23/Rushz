import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CabinEditScreen extends StatefulWidget {
  final Map<String, dynamic> cabin;
  const CabinEditScreen({super.key, required this.cabin});

  @override
  State<CabinEditScreen> createState() => _CabinEditScreenState();
}

class _CabinEditScreenState extends State<CabinEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController capacityController;
  String? selectedCategory;
  String? selectedAvailability;

  final categories = ['Movies', 'Video Games'];
  final availabilityOptions = ['Available', 'Not Available'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.cabin['name']);
    locationController =
        TextEditingController(text: widget.cabin['location']);
    capacityController =
        TextEditingController(text: widget.cabin['capacity'].toString());
    selectedCategory = widget.cabin['category'];
    selectedAvailability = widget.cabin['availability'];
  }

  Future<void> updateCabin() async {
    if (_formKey.currentState!.validate()) {
      await supabase.from('cabins').update({
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'capacity': int.parse(capacityController.text.trim()),
        'category': selectedCategory,
        'availability': selectedAvailability,
      }).eq('id', widget.cabin['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cabin updated successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Cabin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Cabin Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter cabin name' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter location' : null,
              ),
              TextFormField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter capacity' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v == null ? 'Select category' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedAvailability,
                items: availabilityOptions
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => selectedAvailability = val),
                decoration: const InputDecoration(labelText: 'Availability'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateCabin,
                child: const Text('Update Cabin'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
