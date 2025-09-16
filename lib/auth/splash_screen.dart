import 'package:flutter/material.dart';
import 'package:rushz/admin/screen/admin_home.dart';
import 'package:rushz/auth/login_screen.dart';
import 'package:rushz/user/bottombar/user_bottombar.dart';
import 'package:rushz/user/home/user_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Check if user is logged in and redirect accordingly
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Small splash delay

    final session = supabase.auth.currentSession;

    if (session == null) {
      // No session -> Navigate to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    try {
      final user = session.user;
      final userId = user.id;

      // Fetch user details from "users" table
      final response = await supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final role = response['role']?.toString().toLowerCase();

      // Navigate based on role
      if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Bottombar(child: UserHome(),)),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHome()),
        );
      } else {
        // Fallback to login if role is invalid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      debugPrint("Splash error: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("asset/bgimg.png"), // Replace with your splash image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
