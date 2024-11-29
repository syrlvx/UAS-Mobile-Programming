import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/homescreen.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/screens/news_and_hot.dart';
import 'package:netflix_clone/screens/download_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.search),
                text: "Search",
              ),
              Tab(
                icon: Icon(Icons.photo_library_outlined),
                text: "Up Coming",
              ),
              Tab(
                icon: Icon(Icons.download),
                text: "Download",
              )
            ],
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            SearchScreen(),
            NewsAndHotScreen(),
            DownloadScreen(),
          ],
        ),
      ),
    );
  }
}
