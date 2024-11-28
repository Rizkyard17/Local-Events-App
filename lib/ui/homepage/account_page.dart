import 'package:flutter/material.dart';
import 'package:local_events_app/styleguide.dart';
import 'login.dart';

class AccountPage extends StatelessWidget {
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
                            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
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
                          style: fadedTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        // PopupMenuButton untuk dropdown menu
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            // Logika untuk setiap menu item
                            if (value == 'Settings') {
                              // Navigasi ke halaman pengaturan
                              print("Navigasi ke Pengaturan");
                            } else if (value == 'Help') {
                              // Navigasi ke halaman bantuan
                              print("Navigasi ke Bantuan");
                            } else if (value == 'Info') {
                              // Navigasi ke halaman info
                              print("Navigasi ke Info");
                            }
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Settings',
                              child: Text('Pengaturan'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Help',
                              child: Text('Bantuan'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Info',
                              child: Text('Info'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/profile_picture.png"), // Ganti dengan path gambar profil
                  ),
                  SizedBox(height: 16),
                  Text(
                    "M. Rizky Ardiansyah Putra",
                    style: whiteHeadingTextStyle.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "rizky.ardiansyah@gmail.com", // Email pengguna
                    style: fadedTextStyle,
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
                            // Tambahkan navigasi ke halaman Edit Profil
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
                        _buildAccountOption(
                          context,
                          icon: Icons.notifications,
                          label: "Notifikasi",
                          onTap: () {
                            // Tambahkan navigasi ke halaman Notifikasi
                          },
                        ),
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

  // Widget untuk opsi menu
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

  // Tombol untuk keluar
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tambahkan logika untuk keluar
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
                  // Logika keluar aplikasi
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                    ); // Tutup dialog
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
}