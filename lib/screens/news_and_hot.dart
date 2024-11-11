import 'package:flutter/material.dart';

class NewsAndHotScreen extends StatefulWidget {
  const NewsAndHotScreen({super.key});

  @override
  State<NewsAndHotScreen> createState() => _NewsAndHotScreenState();
}

class _NewsAndHotScreenState extends State<NewsAndHotScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("News And Hot Screen"),
      ),
    );
  }
}
