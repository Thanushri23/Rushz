import 'package:flutter/material.dart';
import 'package:rushz/user/fav/favouritesscreen.dart';
import 'package:rushz/user/movie/user_movie_screen.dart';
import 'package:rushz/user/outdoor/outdoorhomescreen.dart';
import 'package:rushz/user/settings/user_profile.dart';
import 'package:rushz/user/video/videohomescreen.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  final List<String> imageUrls = [
    "https://pbs.twimg.com/media/GmhbJ_EaEAENb4q?format=jpg&name=large",
    "https://www.organizer.endlessevent.com/event/coverPhoto5fd622484.jpg",
  ];

  // Basic reusable category card
  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome User"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Favouritesscreen(),
                ),
              );
            },
          ),
    GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
    );
  },
  child: Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey,
      child: const Icon(
        Icons.person,
        size: 16,
         color: Colors.white, // Fallback icon if image fails
      ),
    ),
  ),
),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search events, games...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),

            // Carousel
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Categories
            _buildCategoryCard(
              icon: Icons.sports_esports,
              title: "Video Games",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Videohomescreen()),
                );
              },
            ),
            _buildCategoryCard(
              icon: Icons.sports_baseball_outlined,
              title: "Outdoor Games",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Outdoorhomescreen()),
                );
              },
            ),
            _buildCategoryCard(
              icon: Icons.movie_outlined,
              title: "Movie Screens",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserMovieScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
