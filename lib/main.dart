import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix_clone/screens/homescreen.dart';
import 'package:netflix_clone/screens/login_screen.dart';
import 'package:netflix_clone/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:netflix_clone/screens/globals.dart' as globals;
import 'package:netflix_clone/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan ini dijalankan terlebih dahulu
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        fontFamily: GoogleFonts.ptSans().fontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 193, 64, 127))
            .copyWith(surface: Colors.black),
      ),
      // Home screen tergantung status login
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          globals.uid = snapshot.data!.uid; // Simpan UID ke globals

          // Ambil data pengguna dari Firestore berdasarkan UID
          _fetchUserData(snapshot.data!.uid);

          return BottomNavBar();
        } else {
          return SplashScreen(); // Arahkan ke halaman splash jika belum login
        }
      },
    );
  }

  // Ambil data pengguna dari Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(
              'user') // Pastikan Anda memiliki koleksi 'users' di Firestore
          .doc(uid)
          .get();

      if (userDoc.exists) {
        globals.nama =
            userDoc['username']; // Ambil nama pengguna dari field 'username'
      } else {
        print("Dokumen pengguna tidak ditemukan");
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil data pengguna: $e");
    }
  }
}
