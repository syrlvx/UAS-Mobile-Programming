import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/login_screen.dart';
import 'package:netflix_clone/screens/logout_screen.dart';
import 'package:netflix_clone/screens/movie_screen.dart';
import 'package:netflix_clone/screens/settings_screen.dart';
import 'package:netflix_clone/screens/username.dart';
import 'package:netflix_clone/widgets/foryou_movies_card_widget.dart';
import 'package:netflix_clone/widgets/liked_movies_card_widget.dart';
import 'package:netflix_clone/widgets/nowplaying_movie_card_widget.dart';
import 'package:netflix_clone/widgets/custom_carousel.dart';
import 'package:netflix_clone/widgets/top_movies_card_widget.dart';
import 'package:netflix_clone/widgets/watch_later_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/logo.png',
          height: 50,
          width: 120,
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Username(),
                  ),
                );
              },
              child: Container(
                color: Colors.blue,
                height: 27,
                width: 27,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCarouselSlider(),
            // const SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   height: 220,
            //   child: Favorite(
            //     headlineText: 'Favorite',
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: NowplayingMovieCard(
                headlineText: 'Now Playing',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: TopMoviesCard(
                headlineText: 'Top 10 Movies',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: ForyouMoviesCard(
                headlineText: 'For You',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: WatchLaterCard(
                headlineText: 'My List',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: LikedMoviesCard(
                headlineText: 'Liked Movies',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
