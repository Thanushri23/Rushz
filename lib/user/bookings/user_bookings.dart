import 'package:flutter/material.dart';
import 'package:rushz/user/bottombar/user_bottombar.dart';
import 'package:rushz/user/home/user_home.dart';
import 'package:rushz/user/settings/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final supabase = Supabase.instance.client;
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  /// Fetch the logged-in user's bookings from Supabase
  Future<void> _fetchUserBookings() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in.";
          _isLoading = false;
        });
        return;
      }

      final response = await supabase.from('bookings').select().eq('user_id', user.id);

      setState(() {
        _bookings = response;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Error fetching bookings: $error";
        _isLoading = false;
      });
    }
  }

  /// Helper function to get icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'movie':
        return Icons.movie;
      case 'video games':
        return Icons.sports_esports;
      case 'badminton':
        return Icons.sports_tennis;
      case 'pickleball':
        return Icons.sports_tennis;
      default:
        return Icons.movie;
    }
  }

  /// Booking Card UI
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] ?? 'Unknown';
    final category = booking['category'] ?? 'Unknown';
    final location = booking['location'] ?? 'N/A';
    final itemName = booking['item_name'] ?? 'No Name';

    Color statusColor;
    if (status == 'Confirmed') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to booking details screen
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Category: $category",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Location: $location",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background to white
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Bottombar(child: UserHome())),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "My Bookings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : _bookings.isEmpty
                  ? const Center(
                      child: Text(
                        "No bookings found.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchUserBookings,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 12, bottom: 24),
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          return _buildBookingCard(_bookings[index]);
                        },
                      ),
                    ),
    );
  }
}