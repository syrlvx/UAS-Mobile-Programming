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
  String? _selectedGenre = "All Genre"; // Default ke "All Genre"
  List<String> _genres = ["All Genre"]; // Tambahkan "All Genre" sebagai default

  @override
  void initState() {
    super.initState();
    _fetchGenres(); // Ambil daftar genre saat widget diinisialisasi
  }

  // Fungsi untuk mengambil daftar genre dari Firestore
  Future<void> _fetchGenres() async {
    final moviesCollection =
        FirebaseFirestore.instance.collection('film'); // Koleksi film
    final snapshot = await moviesCollection.get();
    final allGenres = snapshot.docs
        .map((doc) => (doc['genre'] ?? 'Unknown').toString())
        .toSet()
        .toList();

    setState(() {
      _genres.addAll(allGenres); // Tambahkan genre dari Firestore ke daftar
    });
  }

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
          // Dropdown menu untuk filter genre
          if (_genres.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: _selectedGenre,
                hint: const Text(
                  "Filter by genre",
                  style: TextStyle(color: Colors.white),
                ),
                dropdownColor: Colors.black,
                items: _genres.map((genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(
                      genre,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value;
                  });
                },
              ),
            ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('film').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No movies found.',
                          style: TextStyle(color: Colors.white)));
                }

                // Filter berdasarkan query pencarian dan genre yang dipilih
                final filteredMovies = snapshot.data!.docs.where((doc) {
                  final title = (doc['title'] ?? '').toString().toLowerCase();
                  final genre = (doc['genre'] ?? '').toString();
                  final matchesQuery =
                      title.contains(_query); // Filter berdasarkan judul
                  final matchesGenre = _selectedGenre == "All Genre" ||
                      genre == _selectedGenre; // Filter berdasarkan genre
                  return matchesQuery && matchesGenre;
                }).toList();

                if (filteredMovies.isEmpty) {
                  return const Center(
                      child: Text('No results found.',
                          style: TextStyle(color: Colors.white)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredMovies.length,
                  
                  


                  itemBuilder: (context, index) {
                    final movie =
                        filteredMovies[index].data() as Map<String, dynamic>;

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
                          children: [
                            // Poster Film
                            Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(movie['image'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Informasi dan Ikon Play
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Informasi Film
                                  Expanded(
                                    child: Column(
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
                                        Text(
                                          "Genre: ${movie['genre'] ?? 'Unknown'}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Ikon Play
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32,
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
      backgroundColor: Colors.black,
    );
  }
}
