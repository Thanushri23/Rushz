import 'package:flutter/material.dart';
import 'package:rushz/user/fav/favouritesscreen.dart';
import 'package:rushz/user/movie/moviedetails.dart';
import 'package:rushz/user/settings/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMovieScreen extends StatefulWidget {
  const UserMovieScreen({super.key});

  @override
  State<UserMovieScreen> createState() => _UserMovieScreenState();
}

class _UserMovieScreenState extends State<UserMovieScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await supabase
          .from('cabins')
          .select()
          .eq('category', 'Movies')
          .eq('availability', 'Available'); // Only available movies

      setState(() {
        movies = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favouritesscreen(),
                ),
              );
            },
            child: const Icon(Icons.favorite_border),
          ),
          const SizedBox(width: 10),
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
          : movies.isEmpty
              ? const Center(child: Text('No available movies found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)));
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
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.yellow,
                                  child: const Icon(Icons.movie, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // Show capacity (tickets left)
                                  child: Text("Max: ${movie['capacity']}"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Movie name and location
                            Text(
                              "${movie['name']}", // movie name
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${movie['location']}", // movie location
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // Show genre from DB
                                  child: Text(movie['genre'] ?? 'No Genre'),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text("BOOK NOW", style: TextStyle(color: Colors.white)),
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
