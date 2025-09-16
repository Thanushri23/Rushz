import 'package:flutter/material.dart';
import 'package:rushz/admin/bookings/bookingscreen.dart';
import 'package:rushz/admin/cabins/cabinscreen.dart';
import 'package:rushz/admin/cabins/cainslist_screen.dart';
import 'package:rushz/admin/courts/courtslistscreen.dart';
import 'package:rushz/admin/courts/courtsscreen.dart';
import 'package:rushz/admin/settings/settings.dart';
import 'package:rushz/admin/support/supportscreen.dart';
import 'package:rushz/admin/users/usersscreen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search",
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Health Section with navigation
            _buildCard(
              context: context,
              listscreen: Courtslistscreen(),
              color: Colors.blue[50]!,
              icon: Icons.sports_tennis,
              iconColor: Colors.blue,
              title: "Courts",
              subtitle: "You have pending court additions",
             
              
            ),
            const SizedBox(height: 8),
            _buildCard(
              context: context,
              listscreen: CabinListScreen(),
              color: Colors.orange[50]!,
              icon: Icons.meeting_room,
              iconColor: Colors.orange,
              title: "Cabins",
              subtitle: "You have pending cabin additions",
              
            ),
            const SizedBox(height: 8),
            _buildCard(
              context: context,
              listscreen: Bookingscreen(),
              color: Colors.green[50]!,
              icon: Icons.event,
              iconColor: Colors.green,
              title: "Bookings",
              subtitle: "You have no new bookings",
             
            ),

            const SizedBox(height: 16),

            // Quick Links
            const Text(
              "Quick Links",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _quickLink(context, Icons.sports_tennis, "Add Court", Courtsscreen()),
                _quickLink(context, Icons.meeting_room, "Add Cabin", Cabinscreen()),
                _quickLink(context, Icons.event, "Bookings", Bookingscreen()),
                _quickLink(context, Icons.settings, "Settings", AdminSetting()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card Builder with navigation
  Widget _buildCard({
    required BuildContext context,
    required Widget listscreen,
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
   
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => listscreen));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  // Quick Link Button with navigation
  Widget _quickLink(BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
