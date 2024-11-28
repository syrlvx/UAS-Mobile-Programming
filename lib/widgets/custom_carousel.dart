import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/movie_screen.dart';
import 'package:netflix_clone/widgets/landing_card.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var carouselOptions = CarouselOptions(
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      aspectRatio: 16 / 9,
      viewportFraction: 0.9,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('film') // Nama koleksi di Firebase
          .where('status', isEqualTo: 'now_playing') // Filter status
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No now playing movies found.'));
        }

        // Ambil data dan randomize
        var movies = snapshot.data!.docs.toList();
        movies.shuffle(Random());

        return SizedBox(
          width: size.width,
          height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
          child: CarouselSlider.builder(
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              var movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieScreen(
                        documentId:
                            movie.id, // Kirim ID dokumen ke layar detail
                      ),
                    ),
                  );
                },
                child: LandingCard(
                  image: CachedNetworkImageProvider(movie['image']),
                  name:
                      movie['title'], // Pastikan ada field "title" di Firestore
                ),
              );
            },
            options: carouselOptions,
          ),
        );
      },
    );
  }
}
