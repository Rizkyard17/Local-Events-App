import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> _saveLoginData(String email) async {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
    await users.add({
      'email': email,
      'login_time': FieldValue.serverTimestamp(),
    });
    print("Data login berhasil disimpan.");
  } catch (e) {
    print("Error menyimpan data login: $e");
  }
  }

  // Future<void> _login() async {
  //   final String email = _emailController.text.trim();
  //   final String password = _passwordController.text.trim();

  //   // Validasi input kosong
  //   if (email.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Email dan Password tidak boleh kosong!")),
  //     );
  //     return;
  //   }

  //   // Fokus keluar dari keyboard
  //   FocusScope.of(context).unfocus();

  //   // Tampilkan loading spinner
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );

  //   try {
  //     // Login pengguna
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     User? user = userCredential.user;

  //     // Periksa apakah pengguna telah memverifikasi email
  //     if (user != null && !user.emailVerified) {
  //       // Tutup loading spinner
  //       DocumentSnapshot userDoc =
  //         await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //     }

  //     if (user != null) {
  //   // Ambil data pengguna dari Firestore
  //   DocumentSnapshot userDoc =
  //       await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  //   if (userDoc.exists) {
  //     String username = userDoc['username'];

  //     // Tampilkan animasi login sukses dengan username
  //     _showLoginSuccessAnimation(String username);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Data $username tidak ditemukan!")),
  //     );
  //   }
  //   }

  //     // Simpan data login ke Firestore
  //     await _saveLoginData(email);

  //     // Tampilkan animasi Lottie sebagai konfirmasi login sukses
  //     _showLoginSuccessAnimation();
  //   } catch (e) {
  //     // Tutup loading spinner jika terjadi error
  //     Navigator.of(context).pop();

  //     // Tampilkan pesan error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Login Gagal: ${e.toString()}")),
  //     );
  //   }
  // }
  Future<void> _login() async {
  final String email = _emailController.text.trim();
  final String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email dan Password tidak boleh kosong!")),
    );
    return;
  }

  FocusScope.of(context).unfocus();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // Ambil data username dari Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {

        // Tampilkan animasi login sukses dengan username
        Navigator.of(context).pop(); // Tutup spinner
        _showLoginSuccessAnimation();
      } else {
        Navigator.of(context).pop(); // Tutup spinner
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data pengguna tidak ditemukan!")),
        );
      }
    }
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Gagal: ${e.toString()}")),
    );
  }
}

  void _showVerificationDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Email Belum Diverifikasi"),
        content: Text(
          "Email Anda belum diverifikasi. Silakan cek email Anda untuk memverifikasi akun.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await user.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email verifikasi telah dikirim!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
              Navigator.pop(context);
            },
            child: Text("Kirim Ulang Email"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal"),
          ),
        ],
      ),
    );
  }

  void _showLoginSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/success.json',
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login Berhasil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,  // Menghapus semua halaman sebelumnya
      );
    });
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
                      // Illustration or Logo
                      Image.asset(
                        'assets/logo/logo.png',
                        height: 150,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Welcome!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Log in to explore local events near you",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Email Input
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      // Password Input
                      _buildTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),
                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(200, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 18, color: Color(0xFF78B3CE) ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Forgot Password or Sign Up Text
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/SignupPage');
                        },
                        child: const Text(
                          "Forgot Password? | Sign Up",
                          style: TextStyle(color: Colors.white70),
                        ),
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