import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'movie_screen.dart'; // Sesuaikan path dengan struktur proyek Anda

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.toLowerCase();
                });
              },
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search for movies...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.only(top: -2),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Recommended TV Shows & Movies",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('film')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No movies found.'));
                      }

                      // Filter berdasarkan query
                      final filteredMovies = snapshot.data!.docs.where((doc) {
                        final title =
                            (doc['title'] ?? '').toString().toLowerCase();
                        return title.contains(_query);
                      }).toList();

                      if (filteredMovies.isEmpty) {
                        return const Center(child: Text('No results found.'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies[index].data()
                              as Map<String, dynamic>;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieScreen(
                                    documentId: filteredMovies[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Gambar Film
                                  Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          movie['image'] ?? '',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Informasi Film di Tengah
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['title'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 8),
                                        // Ikon Play
                                        Row(
                                          children: const [
                                            Icon(Icons.play_circle_fill,
                                                color: Colors.red, size: 24),
                                            SizedBox(width: 8),
                                            Text(
                                              "Play",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
