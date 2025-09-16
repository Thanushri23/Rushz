import 'package:flutter/material.dart';
import 'package:rushz/admin/cabins/cabinedit_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CabinListScreen extends StatefulWidget {
  const CabinListScreen({super.key});

  @override
  State<CabinListScreen> createState() => _CabinListScreenState();
}

class _CabinListScreenState extends State<CabinListScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> cabins = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCabins();
  }

  Future<void> fetchCabins() async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        // No user logged in
        setState(() {
          cabins = [];
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No logged-in user found")),
        );
        return;
      }

      final adminId = currentUser.id; // Get logged-in user's UUID

      // Fetch cabins belonging to the logged-in admin
      final response = await supabase
          .from('cabins')
          .select()
          .eq('admin_id', adminId)
          .order('created_at', ascending: false);

      setState(() {
        cabins = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint("Error fetching cabins: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading cabins: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cabins")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cabins.isEmpty
              ? const Center(child: Text("No cabins found."))
              : ListView.builder(
                  itemCount: cabins.length,
                  itemBuilder: (context, index) {
                    final cabin = cabins[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(cabin['name']),
                        subtitle: Text(
                          "Location: ${cabin['location']}\n"
                          "Capacity: ${cabin['capacity']}\n"
                          "Category: ${cabin['category']}\n"
                          "Availability: ${cabin['availability']}",
                        ),
                        isThreeLine: true,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CabinEditScreen(cabin: cabin),
                            ),
                          );
                          fetchCabins(); // Refresh list after editing
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
