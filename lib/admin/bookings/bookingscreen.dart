import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bookingscreen extends StatefulWidget {
  const Bookingscreen({super.key});

  @override
  State<Bookingscreen> createState() => _BookingscreenState();
}

class _BookingscreenState extends State<Bookingscreen> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchAdminBookings();
  }

  Future<void> fetchAdminBookings() async {
    try {
      final adminId = supabase.auth.currentUser?.id;

      if (adminId == null) {
        throw Exception("No logged-in admin found");
      }

      final response = await supabase
          .from('bookings')
          .select()
          .eq('admin_id', adminId) // ✅ Directly filter by admin_id
          .order('created_at', ascending: false);

      setState(() {
        bookings = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching admin bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text("No bookings found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final isCourt = booking['item_type'] == 'court';
                    final isCabin = booking['item_type'] == 'cabin';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          isCourt
                              ? Icons.sports_tennis
                              : isCabin
                                  ? Icons.home
                                  : Icons.movie,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Name: ${booking['item_name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                           
                          "Type: ${booking['item_type']}\n"
                          "Category: ${booking['category']}\n"
                          "Date: ${booking['created_at'].split('T')[0]}\n"
                          "Booked by User: ${booking['user_id']}\n"
                         
                          

                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
