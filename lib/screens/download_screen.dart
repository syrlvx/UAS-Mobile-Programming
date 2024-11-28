import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final List<Map<String, dynamic>> episodes = [
    {
      'title': 'Season 1: Pilot',
      'duration': '54m',
      'description':
          'After a hurricane, John B, JJ, Pope and Kiara plunge headlong into danger and adventure when they find a mysterious sunken wreck.',
      'image': 'assets/episode1.jpg',
      'isDownloading': false,
      'progress': 0.0,
      'isDownloaded': false,
    },
    {
      'title': 'Episode 2: The Weirdo on Maple Street',
      'duration': '55m',
      'description':
          'Lucas, Mike and Dustin try to talk to the girl they found in the woods...',
      'image': 'assets/episode2.jpg',
      'isDownloading': false,
      'progress': 0.0,
      'isDownloaded': false,
    },
    {
      'title': 'Episode 3: Holly, Jolly',
      'duration': '51m',
      'description':
          'An increasingly concerned Nancy looks for Barb and finds out what Jonathan\'s been up to...',
      'image': 'assets/episode3.jpg',
      'isDownloading': false,
      'progress': 0.0,
      'isDownloaded': false,
    },
  ];

  void _startDownload(int index) {
    setState(() {
      episodes[index]['isDownloading'] = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        episodes[index]['progress'] = 1.0;
        episodes[index]['isDownloading'] = false;
        episodes[index]['isDownloaded'] = true;
      });
    });

    for (int i = 1; i <= 10; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        setState(() {
          episodes[index]['progress'] = i / 10;
        });
      });
    }
  }

  void _deleteDownload(int index) {
    setState(() {
      episodes[index]['progress'] = 0.0;
      episodes[index]['isDownloaded'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Downloads'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar episode
                    Container(
                      width: 120.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(episode['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Detail episode
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            episode['duration'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            episode['description'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                            maxLines: 3, // Maksimal 3 baris untuk deskripsi
                            overflow: TextOverflow
                                .ellipsis, // Tambahkan ellipsis jika teks terlalu panjang
                          ),
                          const SizedBox(height: 8.0),
                          if (episode['isDownloading'])
                            LinearProgressIndicator(
                              value: episode['progress'],
                              backgroundColor: Colors.grey[800],
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Tombol aksi
                    episode['isDownloaded']
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDownload(index),
                          )
                        : IconButton(
                            icon: Icon(
                              episode['isDownloading']
                                  ? Icons.downloading
                                  : Icons.download,
                              color: Colors.white,
                            ),
                            onPressed: episode['isDownloading']
                                ? null
                                : () => _startDownload(index),
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
