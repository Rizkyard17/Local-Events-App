import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_events_app/styleguide.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();

    var user = _auth.currentUser;
    // Load current user info
    if (user != null) {
      emailController.text = user.email ?? "Email tidak ditemukan";

      // Load username dari Firestore jika tidak ditemukan di FirebaseAuth
      _getUsername().then((username) {
        setState(() {
          usernameController.text = username;
        });
      });
    }
  }

  Future<String> _getUsername() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid) // Ambil UID dari user yang sedang login
          .get();

      if (userDoc.exists) {
        return userDoc['username'] ?? "Username tidak ditemukan";
      } else {
        return "Username tidak ditemukan";
      }
    } catch (e) {
      print("Error fetching username: $e");
      return "Error memuat username";
    }
  }

  Future<void> _updateProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Update display name di FirebaseAuth
        await user.updateDisplayName(usernameController.text);

        // Update username di Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'username': usernameController.text});

        await user.reload();
        Navigator.pop(context, "/AccountPage");
      }
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui profil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(color: Color(0xFF78B3CE)),
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
                      // Menampilkan Username Awal
                      FutureBuilder<String>(
                        future: _getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                              "Gagal memuat data",
                              style: TextStyle(color: Colors.white),
                            );
                          } else {
                            return Text(
                              "Silahkan Isi Form untuk perbarui profil kamu!",
                              style: whiteHeadingTextStyle.copyWith(
                              fontSize: 20,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
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
                          Navigator.pop(context);
                        },
                        child: const Text("Kembali"),
                      ),
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
