import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  Timer? _opacityTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Timer untuk animasi opacity
    _opacityTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Timer untuk navigasi
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Batalkan Timer saat widget dihapus
    _opacityTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 3),
          child: Image.asset(
            "assets/logos_netflix.png",
            width: 500,
            height: 500,
          ),
        ),
      ),
    );
  }
}
