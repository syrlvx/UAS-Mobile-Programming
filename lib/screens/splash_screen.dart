import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/login_screen.dart';
import 'package:netflix_clone/screens/movie_screen.dart';
import 'package:netflix_clone/screens/settings_screen.dart';
import 'package:netflix_clone/screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
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
