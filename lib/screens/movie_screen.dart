import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;

class MovieScreen extends StatefulWidget {
  final String documentId;

  const MovieScreen({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  YoutubePlayerController? _youtubeController;

  /// Fetch movie details from Firestore
  Future<Map<String, dynamic>> _fetchMovieData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('film')
          .doc(widget.documentId)
          .get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error fetching movie data: $e");
      throw Exception("Failed to load movie data");
    }
  }

  void _initializeYoutubePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Movie Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchMovieData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Movie not found.'));
          }

          var movie = snapshot.data!;
          final youtubeUrl = movie['video'];

          if (youtubeUrl != null && _youtubeController == null) {
            _initializeYoutubePlayer(youtubeUrl);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _youtubeController != null
                    ? YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                      )
                    : const Center(child: CircularProgressIndicator()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'] ?? 'Unknown Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            movie['year'] ?? 'Unknown Year',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            movie['genre'] ?? 'Unknown Genre',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie['deskripsi'] ?? 'No description available.',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WatchLaterButton(
                            userId: "user",
                            movieId: widget.documentId,
                            movieData: movie,
                          ),
                          LikeButton(
                            userId: "user",
                            movieId: widget.documentId,
                            movieData: movie,
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Download starting')),
                              );
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.download_rounded,
                                    color: Colors.white),
                                SizedBox(height: 5),
                                Text("Download",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "More Like This",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMoreLikeThis(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildMoreLikeThis() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('film').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        var movies = snapshot.data!.docs
            .where((doc) => doc.id != widget.documentId)
            .toList();
        movies.shuffle();
        var limitedMovies = movies.take(15).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.7,
          ),
          itemCount: limitedMovies.length,
          itemBuilder: (context, index) {
            var movie = limitedMovies[index];
            var movieData = movie.data() as Map<String, dynamic>;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieScreen(documentId: movie.id),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(movieData['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WatchLaterButton extends StatefulWidget {
  final String userId;
  final String movieId;
  final Map<String, dynamic> movieData;

  const WatchLaterButton({
    Key? key,
    required this.userId,
    required this.movieId,
    required this.movieData,
  }) : super(key: key);

  @override
  _WatchLaterButtonState createState() => _WatchLaterButtonState();
}

class _WatchLaterButtonState extends State<WatchLaterButton> {
  bool isWatchLater = false;

  @override
  void initState() {
    super.initState();
    _checkWatchLaterStatus();
  }

  Future<void> _checkWatchLaterStatus() async {
    final docRef =
        FirebaseFirestore.instance.collection('watchLater').doc(globals.uid);
    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          isWatchLater = data.containsKey(widget.movieId);
        });
      }
    } catch (e) {
      debugPrint("Error checking Watch Later status: $e");
    }
  }

  Future<void> _toggleWatchLater() async {
    final docRef =
        FirebaseFirestore.instance.collection('watchLater').doc(globals.uid);
    print(widget.movieId);
    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        if (isWatchLater) {
          await docRef.update({widget.movieId: FieldValue.delete()});
        } else {
          await docRef
              .set({widget.movieId: widget.movieData}, SetOptions(merge: true));
        }
      } else {
        await docRef.set({widget.movieId: widget.movieData});
      }

      setState(() {
        isWatchLater = !isWatchLater;
      });
    } catch (e) {
      debugPrint("Error toggling Watch Later: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWatchLater,
      child: Column(
        children: [
          Icon(
            isWatchLater ? Icons.check_outlined : Icons.watch_later_outlined,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          const Text(
            "Watch Later",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final String userId;
  final String movieId;
  final Map<String, dynamic> movieData;

  const LikeButton({
    Key? key,
    required this.userId,
    required this.movieId,
    required this.movieData,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final docRef =
        FirebaseFirestore.instance.collection('likedMovies').doc(globals.uid);
    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          isLiked = data.containsKey(widget.movieId);
        });
      }
    } catch (e) {
      debugPrint("Error checking Like status: $e");
    }
  }

  Future<void> _toggleLike() async {
    final docRef =
        FirebaseFirestore.instance.collection('likedMovies').doc(globals.uid);
    print(widget.movieId);
    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        if (isLiked) {
          await docRef.update({widget.movieId: FieldValue.delete()});
        } else {
          await docRef
              .set({widget.movieId: widget.movieData}, SetOptions(merge: true));
        }
      } else {
        await docRef.set({widget.movieId: widget.movieData});
      }

      setState(() {
        isLiked = !isLiked;
      });
    } catch (e) {
      debugPrint("Error toggling Like: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Column(
        children: [
          Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          const Text(
            "Like",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
