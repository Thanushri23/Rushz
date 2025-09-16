// import 'package:flutter/material.dart';
// import 'package:rushz/auth/login_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final supabase = Supabase.instance.client;
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailcontroller = TextEditingController();
//   final TextEditingController namecontroller = TextEditingController();
//   final TextEditingController passcontroller = TextEditingController();
//   final TextEditingController locationcontroller = TextEditingController();
//   final TextEditingController phonenumcontroller = TextEditingController();
//   final TextEditingController rolecontroller = TextEditingController();

//   Future<void> signUp() async {
//     try {
//       // Sign up the user with email and password
//       final res = await supabase.auth.signUp(
//         email: emailcontroller.text.trim(),
//         password: passcontroller.text.trim(),
//       );

//       if (res.user != null) {
//         // Insert additional profile info into 'users' table using auth user id
//         await supabase.from('users').insert({
//           'id': res.user!.id, // link to auth.users id
//           'name': namecontroller.text.trim(),
//           'phone_no': phonenumcontroller.text.trim(),
//           'location': locationcontroller.text.trim(),
//           'role': rolecontroller.text.trim(),
//         });

//         if (res.session == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Confirmation mail sent!")),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Registered and logged in!")),
//           );
//         }

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Auth Error: ${e.message}")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Unknown error: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: namecontroller,
//                 decoration: const InputDecoration(labelText: "Name"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Please enter name" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: emailcontroller,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator: (value) {
//                   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
//                   if (value == null || value.isEmpty) {
//                     return "Please enter email";
//                   } else if (!emailRegex.hasMatch(value)) {
//                     return "Enter valid email";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: passcontroller,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: "Password"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter password";
//                   } else if (value.length < 6) {
//                     return "Minimum 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: phonenumcontroller,
//                 decoration: const InputDecoration(labelText: "Phone No"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Please enter phone number" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: locationcontroller,
//                 decoration: const InputDecoration(labelText: "Location"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Please enter location" : null,
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: "Role"),
//                 value: null,
//                 items: ['user', 'admin']
//                     .map((role) => DropdownMenuItem(value: role, child: Text(role)))
//                     .toList(),
//                 onChanged: (value) {
//                   rolecontroller.text = value!;
//                 },
//                 validator: (value) =>
//                     value == null ? "Please select a role" : null,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     signUp();
//                   }
//                 },
//                 child: const Text("Register"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:rushz/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final locationcontroller = TextEditingController();
  final phonenumcontroller = TextEditingController();
  final rolecontroller = TextEditingController();

  Future<void> signUp() async {
    try {
      final res = await supabase.auth.signUp(
        email: emailcontroller.text.trim(),
        password: passcontroller.text.trim(),
      );

      if (res.user != null) {
        // Insert additional data into custom users table
        final insertResponse = await supabase.from('users').insert({
          'id': res.user!.id,
          'name': namecontroller.text.trim(),
          'phone_no': phonenumcontroller.text.trim(),
          'location': locationcontroller.text.trim(),
          'role': rolecontroller.text.trim(),
        }).select();

        if (insertResponse.error != null) {
          // Show any insertion error for debugging
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Insert error: ${insertResponse.error!.message}")),
          );
          return;
        }

        if (res.session == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Confirmation mail sent!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered and logged in!")),
          );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth Error: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unknown error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                  if (value == null || value.isEmpty) {
                    return "Please enter email";
                  } else if (!emailRegex.hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passcontroller,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  } else if (value.length < 6) {
                    return "Minimum 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phonenumcontroller,
                decoration: const InputDecoration(labelText: "Phone No"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter phone number" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationcontroller,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter location" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Role"),
                value: null,
                items: ['user', 'admin']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  rolecontroller.text = value!;
                },
                validator: (value) =>
                    value == null ? "Please select a role" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on PostgrestList {
  get error => null;
}
