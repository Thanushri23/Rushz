import 'package:flutter/material.dart';
import 'package:rushz/user/outdoor/courtsdetailspage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rushz/user/fav/favouritesscreen.dart';
import 'package:rushz/user/settings/user_profile.dart';

class Outdoorhomescreen extends StatefulWidget {
  const Outdoorhomescreen({super.key});

  @override
  State<Outdoorhomescreen> createState() => _OutdoorhomescreenState();
}

class _OutdoorhomescreenState extends State<Outdoorhomescreen> {
  final supabase = Supabase.instance.client;

  final List<String> sports = ['Badminton', 'Pickleball'];
  int selectedSportsIndex = 0;

  /// List to store favorite courts
  final List<Map<String, dynamic>> favoriteCourts = [];

  List<Map<String, dynamic>> courts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourts();
  }

  Future<void> fetchCourts() async {
    setState(() => isLoading = true);

    try {
      String selectedSport = sports[selectedSportsIndex];
      final response = await supabase
          .from('courts')
          .select()
          .eq('game_category', selectedSport)
          .eq('availability', true);

      if (response is List) {
        setState(() {
          courts = response.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          courts = [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching courts: $e");
      setState(() {
        courts = [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Return an icon based on sport
  IconData getSportIcon(String sport) {
    if (sport.toLowerCase() == 'badminton') {
      return Icons.sports_tennis;
    } else if (sport.toLowerCase() == 'pickleball') {
      return Icons.sports;
    }
    return Icons.sports_esports;
  }

  /// Toggle favorite court
  void toggleFavorite(Map<String, dynamic> court) {
    setState(() {
      if (favoriteCourts.contains(court)) {
        favoriteCourts.remove(court);
      } else {
        favoriteCourts.add(court);
      }
    });
  }

  bool isFavorite(Map<String, dynamic> court) {
    return favoriteCourts.contains(court);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Outdoor Games"),
        actions: [
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

        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SPORTS FILTER TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: List.generate(
                sports.length,
                (index) => GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedSportsIndex = index;
                    });
                    await fetchCourts();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selectedSportsIndex == index
                          ? Colors.green
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sports[index],
                      style: TextStyle(
                        color: selectedSportsIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// COURTS LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : courts.isEmpty
                    ? const Center(child: Text("No available courts found"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: courts.length,
                        itemBuilder: (context, index) {
                          final court = courts[index];
                          final sportIcon =
                              getSportIcon(court['game_category'] ?? '');

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CourtDetailsPage(court: court),
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
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.yellow,
                                        child: Icon(sportIcon, color: Colors.black),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade200,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "${court['cabins_left'] ?? '1'} Court Left",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => toggleFavorite(court),
                                        child: Icon(
                                          Icons.favorite,
                                          color: isFavorite(court)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    court['court_name'] ?? "Court Name",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${court['address'] ?? ''} · ${court['distance'] ?? ''} kms"),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                            court['skill_level'] ??
                                                "Amateur - Advanced"),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: court['availability'] == true
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          "Available",
                                          style: TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
