import 'package:flutter/material.dart';
import 'package:rushz/user/bookings/bookingconfirmed.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieDetailsPage extends StatefulWidget {
  final Map<String, dynamic> movie; // Data passed from previous page

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Map<String, dynamic> movie; // Local copy to update UI instantly
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    movie = Map<String, dynamic>.from(widget.movie); // Create local mutable copy
  }

  Future<void> _bookNow() async {
    try {
      setState(() => isLoading = true);

      final user = supabase.auth.currentUser;

      // Step 1: Check if user is logged in
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to book.')),
        );
        setState(() => isLoading = false);
        return;
      }

      // Debugging info
      print("Movie object: $movie");
      print("Movie ID: ${movie['id']}");

      // Step 2: Update movie availability
      final updateResponse = await supabase
          .from('cabins')
          .update({'availability': 'Not Available'})
          .eq('id', movie['id'].toString()) // Use .toString() if it's UUID
          .select();

      print("Update response: $updateResponse");

      if (updateResponse.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update movie availability.'),
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      // Update local UI state
      setState(() {
        movie['availability'] = 'Not Available';
      });

      // Step 3: Insert into bookings table
      final bookingResponse = await supabase.from('bookings').insert({
        'user_id': user.id,
        'item_id': movie['id'].toString(),
        'item_type': 'cabin',
        'item_name': movie['name'],
        'category': movie['category'],
        'location': movie['location'],
        'admin_id': movie['admin_id'],
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
          SnackBar(content: Text('${movie['name']} booked successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to insert booking.')),
        );
      }
    } catch (error) {
      print("Error booking movie ticket: $error");
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
        title: Text(movie['name'] ?? 'Movie Details'),
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
                            Icons.movie,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            movie['name'] ?? 'Untitled Movie',
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
                      "Genre: ${movie['genre'] ?? 'Unknown'}",
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
                    // Theatre Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.yellow.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          "Theatre:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            movie['location'] ?? 'Not specified',
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
                            movie['availability'] ?? 'Available',
                            style: TextStyle(
                              fontSize: 16,
                              color: movie['availability'] == 'Not Available'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Icon(Icons.people_alt, color: Colors.yellow.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          "Capacity:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            movie['capacity']?.toString() ?? 'Not mentioned',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                   
                    const SizedBox(height: 20),

                    // Book Ticket Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: movie['availability'] == 'Not Available'
                              ? Colors.grey
                              : Colors.yellow.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: movie['availability'] == 'Not Available'
                            ? null
                            : _bookNow,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text(
                                'Book Ticket',
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
