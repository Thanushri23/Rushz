import 'package:flutter/material.dart';
import 'package:rushz/auth/login_screen.dart';
import 'package:rushz/user/bottombar/user_bottombar.dart';
import 'package:rushz/user/home/user_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;

  /// Fetch user details from Supabase
  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null; // User not logged in

    final response = await supabase
        .from('users') // Your table name
        .select()
        .eq('id', user.id)
        .eq('role', 'user')
        .maybeSingle();

    return response;
  }

  /// Logout Function
  Future<void> logout() async {
    await supabase.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  /// Delete Account Function
  Future<void> deleteAccount() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('users').delete().eq('id', user.id);
      await supabase.auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottombar(child: UserHome(),)));
        }, icon: Icon(Icons.arrow_back)),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('No user details found.'));
          }

          // Replace keys with your actual column names
          final name = data['name'] ?? 'N/A';
          final phone = data['phone_no'] ?? 'N/A';
          final location = data['location'] ?? 'N/A';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Section
              Column(
                children: [
                  const  CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey,
      child: const Icon(
        Icons.person,
        size: 60,
         color: Colors.white, // Fallback icon if image fails
      ),
    ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Phone: $phone",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Location: $location",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Account Settings Section
              const Text(
                "Account settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Personal information"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to personal info screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("Payments and payouts"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to payments screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.translate),
                title: const Text("Translation"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to translation screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text("Notifications"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to notifications screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text("Privacy and sharing"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to privacy screen
                },
              ),

              const Divider(height: 30),

              // Logout Button
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: logout,
              ),

              // Delete Account Button
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                        "Are you sure you want to permanently delete your account? This action cannot be undone.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    deleteAccount();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
