import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/movie_screen.dart'; // Sesuaikan dengan path layar detail movie Anda

class TopMoviesCard extends StatelessWidget {
  final String headlineText;

  const TopMoviesCard({super.key, required this.headlineText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Top 10 Movies',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('film') // Nama koleksi di Firebase
            .orderBy('rank',
                descending: false) // Mengurutkan berdasarkan peringkat
            .limit(10) // Ambil 10 film teratas
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Terjadi kesalahan saat memuat data.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data untuk ditampilkan.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final movies = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal, // Scroll horizontal
            padding: const EdgeInsets.all(8.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Angka Peringkat
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          movie['rank'].toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Gambar Film
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          width: 150, // Tetapkan ukuran tetap
                          height: 200,
                          child: CachedNetworkImage(
                            imageUrl:
                                movie['image'], // URL gambar dari Firebase
                            fit: BoxFit
                                .fill, // Menyesuaikan gambar dengan kontainer
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
