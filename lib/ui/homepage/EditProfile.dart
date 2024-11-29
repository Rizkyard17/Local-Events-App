// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
import 'account_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePage createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // Load current user info
    var user = _auth.currentUser;
    if (user != null) {
      usernameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.updateDisplayName(usernameController.text); // Update username
        await user.reload();
        user = _auth.currentUser;

        // Optionally: Update other fields like email or password
        // await user.updateEmail(emailController.text);
        // await user.updatePassword(passwordController.text);

        Navigator.pushNamed(context, '/AccountPage');
      }
    } catch (e) {
      // Handle errors (e.g., invalid email format, etc.)
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF78B3CE)
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "Perbarui Profil Kamu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Email Input
                      _buildTextField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 8),
                      // Username Input
                      _buildTextField(
                        controller: usernameController,
                        hintText: "Nama Pengguna",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 32),
                      // Update Profile Button
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text("Perbarui Profil"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/AccountPage');
                        },
                        child: const Text("Kembali"),
                      ),
                      const SizedBox(height: 16),
                      // Forgot Password or Sign Up Text
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF78B3CE)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF78B3CE)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}