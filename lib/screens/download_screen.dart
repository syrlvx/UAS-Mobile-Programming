import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;
import 'dart:math'; // Tambahkan import ini untuk menghasilkan angka acak


class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

// Fungsi untuk menghasilkan durasi acak
String _generateRandomDuration() {
  final random = Random();
  final hours = random.nextInt(3) + 1; // Antara 1 hingga 3 jam
  final minutes = random.nextInt(60); // Antara 0 hingga 59 menit
  return '${hours}h ${minutes}m';
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<Map<String, dynamic>> downloadedMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchDownloads();
  }

  Future<void> _fetchDownloads() async {
    final docRef = FirebaseFirestore.instance
        .collection('downloadedMovies')
        .doc(globals.uid);

    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          downloadedMovies = data.entries
              .map((entry) => {
                    'movieId': entry.key,
                    ...entry.value as Map<String, dynamic>
                  })
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching downloads: $e");
    }
  }

  Future<void> _deleteDownload(String movieId) async {
    final docRef = FirebaseFirestore.instance
        .collection('downloadedMovies')
        .doc(globals.uid);

    try {
      await docRef.update({movieId: FieldValue.delete()});
      setState(() {
        downloadedMovies.removeWhere((movie) => movie['movieId'] == movieId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download removed successfully.')),
      );
    } catch (e) {
      debugPrint("Error deleting download: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove download.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Downloads',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: downloadedMovies.isEmpty
          ? const Center(
              child: Text(
                'No downloads available.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: downloadedMovies.length,
              itemBuilder: (context, index) {
                final movie = downloadedMovies[index];
                              final duration = movie['duration'] ?? _generateRandomDuration();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar film
                          Container(
                            width: 120.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(movie['image'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          // Detail film
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  movie['deskripsi'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          // Tombol hapus
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDownload(movie['movieId']),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
