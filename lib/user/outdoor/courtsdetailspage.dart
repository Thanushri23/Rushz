import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rushz/user/bookings/bookingconfirmed.dart';

class CourtDetailsPage extends StatefulWidget {
  final Map<String, dynamic> court;

  const CourtDetailsPage({super.key, required this.court});

  @override
  State<CourtDetailsPage> createState() => _CourtDetailsPageState();
}

class _CourtDetailsPageState extends State<CourtDetailsPage> {
  late Map<String, dynamic> court; // Local copy for instant updates
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    court = Map<String, dynamic>.from(widget.court);
  }

  Future<void> _bookNow() async {
    try {
      setState(() => isLoading = true);

      final user = supabase.auth.currentUser;

      // Step 1: Ensure the user is logged in
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to book.')),
        );
        setState(() => isLoading = false);
        return;
      }

      print("Court object: $court");
      print("Court ID: ${court['id']}");

      // Step 2: Update court availability to false
      final updateResponse = await supabase
          .from('courts')
          .update({'availability': false})
          .eq('id', court['id'])
          .select();

      print("Update response: $updateResponse");

      if (updateResponse.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update court availability.')),
        );
        setState(() => isLoading = false);
        return;
      }

      // Update local UI instantly
      setState(() {
        court['availability'] = false;
      });

      // Step 3: Insert booking into `bookings` table
      final bookingResponse = await supabase.from('bookings').insert({
        'user_id': user.id,
        'item_id': court['id'].toString(),
        'item_type': 'court',
        'item_name': court['court_name'],
        'category': court['game_category'],
        'location': court['address'],
                'admin_id': court['admin_id'],

        'status': 'booked',
      }).select();

      print("Booking response: $bookingResponse");

      if (bookingResponse.isNotEmpty) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingConfirmedPage(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${court['court_name']} booked successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to insert booking.')),
        );
      }
    } catch (error) {
      print("Error booking court: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(court['court_name'] ?? 'Court Details'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.yellow.shade600,
                          child: const Icon(
                            Icons.sports_tennis,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            court['court_name'] ?? 'Unnamed Court',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Category: ${court['game_category'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.yellow.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          "Location:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            court['address'] ?? 'Not specified',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Availability
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.yellow.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          "Availability:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            court['availability'] == true ? 'Available' : 'Not Available',
                            style: TextStyle(
                              fontSize: 16,
                              color: court['availability'] == true
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Skill Level
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          "Skill Level:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            court['skill_level'] ?? 'Amateur - Advanced',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Book Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: court['availability'] == true
                              ? Colors.yellow.shade700
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: (court['availability'] == false || isLoading)
                            ? null
                            : _bookNow,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
