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
  String _selectedGenre = "All Genres";

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
                contentPadding:
                    EdgeInsets.only(top: -2), // Menaikkan teks ke atas
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Dropdown untuk Sort By Genre
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedGenre,
              dropdownColor: Colors.black,
              iconEnabledColor: Colors.white,
              items: <String>[
                'All Genres',
                'Action',
                'Drama',
                'Comedy',
                'Horror',
                'Sci-Fi'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
          ),

          // Stream Builder untuk menampilkan hasil pencarian
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('film').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                }

                // Filter berdasarkan query dan genre
                final filteredMovies = snapshot.data!.docs.where((doc) {
                  final title = (doc['title'] ?? '').toString().toLowerCase();
                  final genre = (doc['genre'] ?? '').toString();
                  return title.contains(_query) &&
                      (_selectedGenre == 'All Genres' ||
                          genre == _selectedGenre);
                }).toList();

                if (filteredMovies.isEmpty) {
                  return const Center(child: Text('No results found.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.7,
                  ),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(movie['image'] ?? ''),
                            fit: BoxFit.cover,
                          ),
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
