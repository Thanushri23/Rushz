import 'package:flutter/material.dart';
import 'package:rushz/admin/courts/courtsedit_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Courtslistscreen extends StatefulWidget {
  const Courtslistscreen({super.key});

  @override
  State<Courtslistscreen> createState() => _CourtslistscreenState();
}

class _CourtslistscreenState extends State<Courtslistscreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _courts = [];

  @override
  void initState() {
    super.initState();
    _fetchCourts();
  }

  Future<void> _fetchCourts() async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final response = await supabase
          .from('courts')
          .select()
          .eq('admin_id', user.id)
          .order('id', ascending: false);

      setState(() {
        _courts = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    await _fetchCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Courts")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: _courts.isEmpty
                  ? const Center(child: Text("No courts added yet"))
                  : ListView.builder(
                      itemCount: _courts.length,
                      itemBuilder: (context, index) {
                        final court = _courts[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(court['court_name']),
                            subtitle: Text(
                                "${court['address']} • ${court['game_category']} • ${court['availability'] ? 'Available' : 'Not Available'}"),
                            onTap: () async {
                              // Navigate to edit screen
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourtEditScreen(court: court),
                                ),
                              );
                              if (updated == true) {
                                _fetchCourts(); // refresh list after edit
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
