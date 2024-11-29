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
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _query = value.toLowerCase();
            });
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search for movies...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('film')
            .snapshots(), // Ambil semua data film
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          // Filter berdasarkan query
          final filteredMovies = snapshot.data!.docs.where((doc) {
            final title = (doc['title'] ?? '').toString().toLowerCase();
            return title.contains(_query);
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
      backgroundColor: Colors.black,
    );
  }
}
