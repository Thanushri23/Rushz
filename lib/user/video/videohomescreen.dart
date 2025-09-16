import 'package:flutter/material.dart';
import 'package:rushz/user/fav/favouritesscreen.dart';
import 'package:rushz/user/settings/user_profile.dart';
import 'package:rushz/user/video/gamepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Videohomescreen extends StatefulWidget {
  const Videohomescreen({super.key});

  @override
  State<Videohomescreen> createState() => _VideohomescreenState();
}

class _VideohomescreenState extends State<Videohomescreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> videoGames = [];
  List<Map<String, dynamic>> favoriteGames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideoGames();
  }

  /// Fetch available video games from Supabase
  Future<void> fetchVideoGames() async {
    try {
      final response = await supabase
          .from('cabins')
          .select()
          .eq('category', 'Video Games')
          .eq('availability', 'Available'); // Only available games

      setState(() {
        videoGames = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching video games: $e');
    }
  }

  /// Toggle favorite state of a game
  void toggleFavorite(Map<String, dynamic> game) {
    setState(() {
      if (favoriteGames.contains(game)) {
        favoriteGames.remove(game);
      } else {
        favoriteGames.add(game);
      }
    });
  }

  /// Check if a game is marked as favorite
  bool isFavorite(Map<String, dynamic> game) {
    return favoriteGames.contains(game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Games"),
        actions: [
          /// Navigate to favorites screen
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favouritesscreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),

          /// Navigate to profile
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
          const SizedBox(width: 16),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : videoGames.isEmpty
              ? const Center(child: Text("No available video games"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: videoGames.length,
                  itemBuilder: (context, index) {
                    final game = videoGames[index];

                    return GestureDetector(
                      onTap: () {
                        /// Navigate to details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamesDetails(game: game),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Top row with icon, game type, and heart button
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.yellow,
                                  child: const Icon(Icons.sports_esports,
                                      color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(game['game_type'] ?? 'Unknown'),
                                ),
                                const Spacer(),

                                /// Heart icon for favorites
                                GestureDetector(
                                  onTap: () => toggleFavorite(game),
                                  child: Icon(
                                    Icons.favorite,
                                    color: isFavorite(game)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// Game name
                            Text(
                              game['name'] ?? 'Unnamed Game',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            /// Location
                            Text(game['location'] ?? ''),

                            const SizedBox(height: 8),

                            /// Skill level and availability
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text("Amateur - Advanced"),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    game['availability'] ?? 'Available',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
