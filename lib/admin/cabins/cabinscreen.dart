import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cabinscreen extends StatefulWidget {
  const Cabinscreen({super.key});

  @override
  State<Cabinscreen> createState() => _CabinscreenState();
}

class _CabinscreenState extends State<Cabinscreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _genreController = TextEditingController();
  String? _selectedCategory;
  String? _selectedGenre;
  String? _selectedGame;
  String _availabilityStatus = "Available"; // Default

  final List<String> _categories = ['Movies', 'Video Games'];

  final List<String> _availabilityOptions = ['Available', 'Not Available'];

  final List<String> _movieGenres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
  ];

  final List<String> _videoGames = [
    'BGMI',
    'Call of Duty',
    'Grand Theft V',
    
  ];

  // Save data to Supabase (Admin adds cabin)
  Future<void> _saveCabin() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin not logged in')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('cabins').insert({
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
          'category': _selectedCategory,
          'genre': _selectedCategory == "Movies"
              ? (_selectedGenre ?? _genreController.text.trim())
              : null,
          'game_type': _selectedCategory == "Video Games" ? _selectedGame : null,
          'availability': _availabilityStatus,
          'admin_id': user.id,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cabin added successfully!')),
          );
          _nameController.clear();
          _locationController.clear();
          _capacityController.clear();
          _genreController.clear();
          setState(() {
            _selectedCategory = null;
            _selectedGenre = null;
            _selectedGame = null;
            _availabilityStatus = "Available";
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Cabin (Admin)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Cabin Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter cabin name' : null,
              ),
              const SizedBox(height: 12),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 12),

              // Capacity
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedGenre = null;
                    _selectedGame = null;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 12),

              // Genre Field (only if category is Movies)
              if (_selectedCategory == "Movies") ...[
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  items: _movieGenres
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGenre = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Select a genre' : null,
                ),
                const SizedBox(height: 12),
              ],

              // Games Field (only if category is Video Games)
              if (_selectedCategory == "Video Games") ...[
                DropdownButtonFormField<String>(
                  value: _selectedGame,
                  decoration: const InputDecoration(labelText: 'Game Type'),
                  items: _videoGames
                      .map((game) => DropdownMenuItem(
                            value: game,
                            child: Text(game),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGame = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Select a game type' : null,
                ),
                const SizedBox(height: 12),
              ],

              // Availability Dropdown
              DropdownButtonFormField<String>(
                value: _availabilityStatus,
                decoration:
                    const InputDecoration(labelText: 'Availability Status'),
                items: _availabilityOptions
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _availabilityStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveCabin,
                child: const Text('Save Cabin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
