import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
  // Unfocus keyboard
  FocusScope.of(context).unfocus();

  // Tampilkan loading spinner
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Tutup loading spinner
    Navigator.of(context).pop();

    // Tampilkan animasi Lottie sebagai konfirmasi login sukses
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog tidak dapat ditutup dengan klik luar
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animasi Lottie
            Lottie.asset(
              'assets/Animation - 1732808536233.json', // Path ke file animasi
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login Berhasil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // Tunggu animasi selesai (sekitar 2 detik, tergantung durasi animasi)
    Future.delayed(const Duration(seconds: 2), () {
      // Tutup dialog animasi
      Navigator.of(context).pop();

      // Arahkan pengguna ke HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    } catch (e) {
      // Tutup loading spinner jika terjadi error
      Navigator.of(context).pop();

      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Gagal: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF78B3CE), // Background color
            ),
          ),
          // Content
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
                      Container(
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.6,
                        child: Image.asset(
                          'assets/event_images/5_km_downtown_run.jpeg', // Your illustration path
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 24),
                      // Title
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Log in to explore local events near you",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Color(0xFF78B3CE)),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF78B3CE)),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF78B3CE),
                          minimumSize: Size(200, 48), // Width 200, height 48
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                        onPressed: _login,
                        child: Text(
                          "Log In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Forgot Password or Sign Up Text
                      TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                        },
                        child: Text(
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
}