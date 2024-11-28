import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix_clone/screens/homescreen.dart';
import 'package:netflix_clone/screens/movie_screen.dart';
import 'package:netflix_clone/screens/push.dart';
import 'package:netflix_clone/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: SplashScreen(),
    );
  }
}
