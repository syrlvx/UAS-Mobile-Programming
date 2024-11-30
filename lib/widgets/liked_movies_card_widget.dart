import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/movie_screen.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;

class LikedMoviesCard extends StatelessWidget {
  final String headlineText;

  const LikedMoviesCard({
    super.key,
    required this.headlineText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('likedMovies')
          .doc(globals.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Container(); // Tidak ada data, tidak ada tampilan
        }

        Map<String, dynamic> movies =
            snapshot.data!.data() as Map<String, dynamic>;

        if (movies.isEmpty) {
          return Container(); // Tidak ada film, tidak ada tampilan
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headlineText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Pastikan hanya menampilkan ListView jika ada film
            if (movies.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    String movieId = movies.keys.elementAt(index);
                    Map<String, dynamic> movieData = movies[movieId];

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieScreen(
                                documentId: movieId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  movieData['image'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
