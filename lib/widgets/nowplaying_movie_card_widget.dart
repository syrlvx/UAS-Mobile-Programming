import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NowplayingMovieCard extends StatelessWidget {
  final String headlineText;

  // Data statis untuk Now Playing
  final List<Map<String, String>> movies = [
    {
      "name": "The Witcher",
      "poster":
          "https://cdn0-production-images-kly.akamaized.net/tqhvf2D9AtALFl94TThDSNub9No=/1200x1200/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3437135/original/066028200_1619110168-The_Witcher.jpg",
      "id": "1",
    },
    {
      "name": "Money Heist",
      "poster":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0ztyvTZQzqm2K238M5SOSmZvaldNUZGlgMA&s",
      "id": "2",
    },
    {
      "name": "Stranger Things",
      "poster":
          "https://d1p1su8170li4z.cloudfront.net/book_covers/12111/focus@2x.jpg?git=af39efddba168716b100809d96406443fcfddfc1&ts=1720741347",
      "id": "3",
    },
    {
      "name": "Reply 1988",
      "poster":
          "https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/9E022FFEEE36FDF2DB44D24E373123A6DEA7DC94CE47C09B2D4730E5DFF9C03B/scale?width=506&aspectRatio=2.00&format=webp",
      "id": "4",
    },
    {
      "name": "True Beauty",
      "poster":
          "https://upload.wikimedia.org/wikipedia/id/6/6b/True_Beauty_main_poster.jpg",
      "id": "5",
    },
    {
      "name": "Queen Of Tears",
      "poster":
          "https://akcdn.detik.net.id/visual/2024/04/29/drama-korea-queen-of-tears-1_43.png?w=720&q=90",
      "id": "6",
    },
  ];

  NowplayingMovieCard({
    super.key,
    required this.headlineText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headlineText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              var movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(movie["poster"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
