import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsAndHotScreen extends StatefulWidget {
  const NewsAndHotScreen({super.key});

  @override
  State<NewsAndHotScreen> createState() => _NewsAndHotScreenState();
}

class _NewsAndHotScreenState extends State<NewsAndHotScreen> {
  List _movies = [];
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMovies();
      }
    });
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const String apiKey = '38044b25292884813a6d0f737734e700';
    final url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=en-US&page=$_currentPage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (_currentPage == 1) {
            _movies = (data['results'] as List).where((movie) {
              final releaseDate = movie['release_date'];
              final year = releaseDate?.split('-')[0];
              return year == '2024';
            }).toList();
          } else {
            final newMovies = (data['results'] as List).where((movie) {
              final releaseDate = movie['release_date'];
              final year = releaseDate?.split('-')[0];
              return year == '2024';
            }).toList();
            _movies.addAll(newMovies);
          }
          _currentPage++;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchMovieDetails(int movieId) async {
    const String apiKey = '38044b25292884813a6d0f737734e700';
    final url =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=en-US&append_to_response=credits';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch movie details');
        return null;
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    }
  }

  Future<String?> _fetchTrailerKey(int movieId) async {
    const String apiKey = '38044b25292884813a6d0f737734e700';
    final url =
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=en-US';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = data['results'];

        final trailer = videos.firstWhere(
          (video) => video['type'] == 'Trailer',
          orElse: () => null,
        );

        if (trailer != null) {
          return trailer['key'];
        }
      }
    } catch (e) {
      print('Error fetching trailer: $e');
    }
    return null;
  }

  List<String> _getTrivia() {
    return [
      "Did you know? This film was shot in multiple countries across the globe!",
      "Fun Fact: The lead actor performed his own stunts in many scenes!",
      "Interesting Trivia: The soundtrack was composed by a Grammy-winning artist.",
      "Behind the scenes: The director was once a stuntman before becoming a filmmaker.",
    ];
  }

  void _showMovieDetails(
      BuildContext context, Map<String, dynamic> details, String? trailerKey) {
    final cast = details['credits']['cast'] ?? [];
    final crew = details['credits']['crew'] ?? [];
    final directors =
        crew.where((person) => person['job'] == 'Director').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final title = details['title'] ?? 'No title';
        final overview = details['overview'] ?? 'No description available';
        final releaseDate = details['release_date'] ?? 'Unknown';
        final rating = details['vote_average']?.toString() ?? 'N/A';

        final trivia = _getTrivia();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (trailerKey != null)
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: trailerKey,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Release Date: $releaseDate',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Rating: $rating/10',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              Text(
                overview,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Menampilkan Trivia
              const SizedBox(height: 20),
              const Text(
                'Trivia and Fun Facts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...trivia.map((fact) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '• $fact',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )),
              const SizedBox(height: 16),

              // Tampilkan Sutradara
              if (directors.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Director(s):',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...directors.map((director) {
                  final name = director['name'] ?? 'Unknown';
                  final profilePath = director['profile_path'];
                  final imageUrl = profilePath != null
                      ? 'https://image.tmdb.org/t/p/w200$profilePath'
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        if (imageUrl != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 25,
                          )
                        else
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 25,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],

              // Tampilkan Aktor
              if (cast.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Cast:',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...cast.map((actor) {
                  final name = actor['name'] ?? 'Unknown';
                  final profilePath = actor['profile_path'];
                  final imageUrl = profilePath != null
                      ? 'https://image.tmdb.org/t/p/w200$profilePath'
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        if (imageUrl != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 25,
                          )
                        else
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 25,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        );
      },
    );
  }

  void _onMovieTap(int movieId) async {
    final movieDetails = await _fetchMovieDetails(movieId);
    if (movieDetails != null) {
      final trailerKey = await _fetchTrailerKey(movieId);
      _showMovieDetails(context, movieDetails, trailerKey);
    }
  }

  void _onVerticalSwipe(DragUpdateDetails details) {
    if (details.primaryDelta! > 0) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (details.primaryDelta! < 0) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset - 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News And Hot",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalSwipe,
        child: _movies.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          final movie = _movies[index];
                          final posterPath = movie['poster_path'];
                          final title = movie['title'] ?? 'No title';
                          final movieId = movie['id'];
                          final imageUrl = posterPath != null
                              ? 'https://image.tmdb.org/t/p/w200$posterPath'
                              : null;

                          return GestureDetector(
                            onTap: () => _onMovieTap(movieId),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            child: const Icon(
                                              Icons.movie,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}