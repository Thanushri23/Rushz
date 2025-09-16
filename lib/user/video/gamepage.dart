// import 'package:flutter/material.dart';
// import 'package:rushz/user/bookings/bookingconfirmed.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class GamesDetails extends StatefulWidget {
//   final Map<String, dynamic> game; // Data passed from previous page

//   const GamesDetails({super.key, required this.game});

//   @override
//   State<GamesDetails> createState() => _GamesDetailsState();
// }

// class _GamesDetailsState extends State<GamesDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final supabase = Supabase.instance.client;
//       bool isLoading = false;


//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(widget.game['name'] ?? 'Cabin Details'),
//         backgroundColor: Colors.yellow,
//         foregroundColor: Colors.black,
//         elevation: 2,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Card
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 28,
//                           backgroundColor: Colors.yellow.shade600,
//                           child: const Icon(
//                             Icons.sports_esports,
//                             size: 28,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             widget.game['name'] ?? 'Unnamed Cabin',
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "Category: ${widget.game['category'] ?? 'Unknown'}",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Details Card
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     // Location
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, color: Colors.yellow.shade800),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Location:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             widget.game['location'] ?? 'Not specified',
//                             style: const TextStyle(fontSize: 16),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),

//                     // Availability
//                     Row(
//                       children: [
//                         Icon(Icons.check_circle, color: Colors.yellow.shade800),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Availability:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             widget.game['availability'] ?? 'Available',
//                             style: const TextStyle(fontSize: 16),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),

//                     // Capacity
//                     Row(
//                       children: [
//                         Icon(Icons.people_alt, color: Colors.yellow.shade800),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Capacity:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             widget.game['capacity']?.toString() ?? 'Not mentioned',
//                             style: const TextStyle(fontSize: 16),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // Book Now Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.yellow.shade700,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () async {
//                           try {
//                             final user = supabase.auth.currentUser;
//                             // final updateResponse = await supabase
//                             //     .from('cabins')
//                             //     .update({'availability': 'Not Available'})
//                             //     .eq(
//                             //       'id',
//                             //       game['id'].toString(),
//                             //     ) // Ensure UUID is passed as a string
//                             //     .select();
//                             // print("Update response: $updateResponse");

//                             // if (updateResponse.isEmpty) {
//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //     const SnackBar(
//                             //       content: Text(
//                             //         'Failed to update availability',
//                             //       ),
//                             //     ),
//                             //   );
//                             //   return;
//                             // }
//                             // Step 1: Check if user is logged in
//                             if (user == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     'You must be logged in to book.',
//                                   ),
//                                 ),
//                               );
//                               return;
//                             }

//                             // Step 2: Update the cabin's availability (UUID ID)
//                              final updateResponse = await supabase
//           .from('cabins')
//           .update({'availability': 'Not Available'})
//           .eq('id', widget.game['id'])
//           .select();

//       if (updateResponse.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to update cabin availability.'),
//           ),
//         );
//         setState(() => isLoading = false);
//         return;
//       }

//       // Update local UI
//       setState(() {
//         widget.game['availability'] = 'Not Available';
//       });
//                             // Step 3: Insert into bookings table
//                             final bookingResponse = await supabase
//                                 .from('bookings')
//                                 .insert({
//                                   'user_id': user.id,
//                                   'item_id': widget.game['id']
//                                       .toString(), // convert int to string
//                                   'item_type': 'cabin',
//                                   'item_name': widget.game['name'],
//                                   'category': widget.game['category'],
//                                   'location': widget.game['location'],
//                                   'status': 'booked',
//                                 })
//                                 .select();

//                             if (bookingResponse.isNotEmpty) {
//                               if (context.mounted) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const BookingConfirmedPage(),
//                                   ),
//                                 );

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       '${widget.game['name']} booked successfully!',
//                                     ),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Failed to insert booking'),
//                                 ),
//                               );
//                             }
//                           } catch (error) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Error: $error')),
//                             );
//                           }
//                         },
//                         child: const Text(
//                           'Book Now',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:rushz/user/bookings/bookingconfirmed.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GamesDetails extends StatefulWidget {
  final Map<String, dynamic> game; // Data passed from previous page

  const GamesDetails({super.key, required this.game});

  @override
  State<GamesDetails> createState() => _GamesDetailsState();
}

class _GamesDetailsState extends State<GamesDetails> {
  late Map<String, dynamic> game; // Local copy to update UI instantly
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    game = Map<String, dynamic>.from(widget.game); // Create local mutable copy
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
    print("Game object: $game");
    print("Game ID: ${game['id']}");

    // Step 2: Update cabin availability
    final updateResponse = await supabase
        .from('cabins')
        .update({'availability': 'Not Available'})
        .eq('id', game['id'].toString()) // Use .toString() if it's UUID
        .select();

    print("Update response: $updateResponse");

    if (updateResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update cabin availability.'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    // Update local UI state
    setState(() {
      game['availability'] = 'Not Available';
    });

    // Step 3: Insert into bookings table
    final bookingResponse = await supabase.from('bookings').insert({
      'user_id': user.id,
      'item_id': game['id'].toString(),
      'item_type': 'cabin',
      'item_name': game['name'],
      'category': game['category'],
      'location': game['location'],
              'admin_id': game['admin_id'],

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
        SnackBar(content: Text('${game['name']} booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to insert booking.')),
      );
    }
  } catch (error) {
    print("Error updating cabin: $error");
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
        title: Text(game['name'] ?? 'Cabin Details'),
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
                            Icons.sports_esports,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            game['name'] ?? 'Unnamed Cabin',
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
                      "Category: ${game['category'] ?? 'Unknown'}",
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
                            game['location'] ?? 'Not specified',
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
                            game['availability'] ?? 'Available',
                            style: TextStyle(
                              fontSize: 16,
                              color: game['availability'] == 'Not Available'
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

                    // Capacity
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
                            game['capacity']?.toString() ?? 'Not mentioned',
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
                          backgroundColor: game['availability'] == 'Not Available'
                              ? Colors.grey
                              : Colors.yellow.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: game['availability'] == 'Not Available'
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

