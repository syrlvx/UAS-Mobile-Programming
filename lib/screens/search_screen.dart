import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  List _movies = [];
  List _popularMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  Future<void> _fetchPopularMovies() async {
    const String apiKey = '38044b25292884813a6d0f737734e700';
    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _popularMovies = data['results'] ?? [];
        });
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movies = [];
        _searchText = query;
      });
      return;
    }

    const String apiKey = '38044b25292884813a6d0f737734e700';
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _movies = data['results'] ?? [];
          _searchText = query;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToDetails(BuildContext context, Map movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) => _searchMovies(value),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search for movies...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: _searchText.isEmpty
            ? _buildMovieList(_popularMovies)
            : _buildMovieList(_movies),
      ),
    );
  }

  Widget _buildMovieList(List movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final posterPath = movie['poster_path'];
        final title = movie['title'] ?? 'No title';
        final releaseDate = movie['release_date'] ?? 'Unknown';
        final posterUrl = posterPath != null
            ? 'https://image.tmdb.org/t/p/w200$posterPath'
            : null;

        return GestureDetector(
          onTap: () => _navigateToDetails(context, movie),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    posterUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              posterUrl,
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 120,
                            width: 80,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Release Date: $releaseDate',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MovieDetailsScreen extends StatelessWidget {
  final Map movie;

  const MovieDetailsScreen({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['poster_path'];
    final posterUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;
    final title = movie['title'] ?? 'No title';
    final overview = movie['overview'] ?? 'No description available';
    final releaseDate = movie['release_date'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              posterUrl != null
                  ? Center(
                      child: Image.network(posterUrl),
                    )
                  : Container(
                      height: 300,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Release Date: $releaseDate',
                style: const TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                overview,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
