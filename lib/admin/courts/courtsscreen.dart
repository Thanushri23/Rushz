import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Courtsscreen extends StatefulWidget {
  const Courtsscreen({super.key});

  @override
  State<Courtsscreen> createState() => _CourtsscreenState();
}

class _CourtsscreenState extends State<Courtsscreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _gameCategory; // badminton / pickleball / both
  bool? _availability;   // true = available, false = not available
  bool _isLoading = false;

  Future<void> _saveCourt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Get current logged-in admin's ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("Not logged in");
      }

      // Insert into courts table
      final response = await Supabase.instance.client.from('courts').insert({
        'court_name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'game_category': _gameCategory,
        'availability': _availability,
        'admin_id': user.id, // This links court to the logged-in admin
      });

      if (response.error != null) {
        throw response.error!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Court added successfully")),
      );

      // Clear form
      _nameController.clear();
      _addressController.clear();
      setState(() {
        _gameCategory = null;
        _availability = null;
      });
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
      appBar: AppBar(
        title: const Text("Add Court"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Court Name", _nameController),
              const SizedBox(height: 12),
              _buildTextField("Address", _addressController),
              const SizedBox(height: 12),

              // Game Category Dropdown
              DropdownButtonFormField<String>(
                value: _gameCategory,
                decoration: _inputDecoration("Game Category"),
                items: const [
                  DropdownMenuItem(value: "Badminton", child: Text("Badminton")),
                  DropdownMenuItem(value: "Pickleball", child: Text("Pickleball")),
                ],
                onChanged: (value) => setState(() => _gameCategory = value),
                validator: (value) =>
                    value == null ? "Please select game category" : null,
              ),

              const SizedBox(height: 12),

              // Availability Dropdown
              DropdownButtonFormField<bool>(
                value: _availability,
                decoration: _inputDecoration("Availability"),
                items: const [
                  DropdownMenuItem(value: true, child: Text("Available")),
                  DropdownMenuItem(value: false, child: Text("Not Available")),
                ],
                onChanged: (value) => setState(() => _availability = value),
                validator: (value) =>
                    value == null ? "Please select availability" : null,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCourt,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      validator: (value) =>
          value == null || value.isEmpty ? "Enter $label" : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
    );
  }
}
