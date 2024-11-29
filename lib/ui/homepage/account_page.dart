// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_events_app/styleguide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_events_app/ui/homepage/EditProfile.dart';
// import 'package:image_picker/image_picker.dart';
import 'login.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPage createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool light1 = false;

  void _reloadUserInfo() {
    setState(() {
      // Re-fetch user info after update
      // This triggers a rebuild with the updated username
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF78B3CE),
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/HomePage'); // Navigasi kembali ke halaman sebelumnya
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Akun Saya",
                          style: TextStyle(color: Colors.white).copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60
                  ),
                  SizedBox(height: 16),
                  // Display updated username
                  Text(
                    user!.displayName ?? "No Username",
                    style: whiteHeadingTextStyle.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user?.email ?? "No Email", // Email pengguna
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildAccountOption(
                          context,
                          icon: Icons.edit,
                          label: "Edit Profil",
                          onTap: () {
                            Navigator.pushNamed(context, '/EditProfilePage').then((_) {
                              _reloadUserInfo(); // Refresh user info after edit
                            });
                          },
                        ),
                        _buildAccountOption(
                          context,
                          icon: Icons.lock,
                          label: "Ubah Kata Sandi",
                          onTap: () {
                            // Tambahkan navigasi ke halaman Ubah Kata Sandi
                          },
                        ),
                        _buildNotificationOption(),
                        _buildAccountOption(
                          context,
                          icon: Icons.info,
                          label: "Tentang Aplikasi",
                          onTap: () {
                            // Tambahkan navigasi ke halaman Tentang
                          },
                        ),
                        SizedBox(height: 20),
                        _buildLogoutButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.white),
            SizedBox(width: 16),
            Text(
              label,
              style: whiteHeadingTextStyle.copyWith(fontSize: 16),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Keluar"),
            content: Text("Apakah Anda yakin ingin keluar?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/LoginPage');
                },
                child: Text("Keluar"),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Keluar",
              style: whiteHeadingTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Notifikasi",
            style: whiteHeadingTextStyle.copyWith(fontSize: 16),
          ),
          Spacer(),
          Switch(
            value: light1,
            onChanged: (bool value) {
              setState(() {
                light1 = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
