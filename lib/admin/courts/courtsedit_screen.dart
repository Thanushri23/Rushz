import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourtEditScreen extends StatefulWidget {
  final Map<String, dynamic> court;
  const CourtEditScreen({super.key, required this.court});

  @override
  State<CourtEditScreen> createState() => _CourtEditScreenState();
}

class _CourtEditScreenState extends State<CourtEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  String? _gameCategory;
  bool? _availability;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final court = widget.court;
    _nameController = TextEditingController(text: court['court_name']);
    _addressController = TextEditingController(text: court['address']);
    _gameCategory = court['game_category'];
    _availability = court['availability'];
  }

  Future<void> _updateCourt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final courtId = widget.court['id'];

      await supabase.from('courts').update({
        'court_name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'game_category': _gameCategory,
        'availability': _availability,
      }).eq('id', courtId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Court updated successfully")),
      );

      Navigator.pop(context, true); // return true to refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Court")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Court Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter court name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration("Address"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gameCategory,
                decoration: _inputDecoration("Game Category"),
                items: const [
                  DropdownMenuItem(value: "Badminton", child: Text("Badminton")),
                  DropdownMenuItem(value: "Pickleball", child: Text("Pickleball")),
                  DropdownMenuItem(value: "Both", child: Text("Both")),
                ],
                onChanged: (v) => setState(() => _gameCategory = v),
                validator: (v) =>
                    v == null ? "Select game category" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<bool>(
                value: _availability,
                decoration: _inputDecoration("Availability"),
                items: const [
                  DropdownMenuItem(value: true, child: Text("Available")),
                  DropdownMenuItem(value: false, child: Text("Not Available")),
                ],
                onChanged: (v) => setState(() => _availability = v),
                validator: (v) =>
                    v == null ? "Select availability" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateCourt,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
