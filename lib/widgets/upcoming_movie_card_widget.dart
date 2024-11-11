import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UpcomingMovieCard extends StatelessWidget {
  final String headlineText;

  // Data statis untuk Now Playing
  final List<Map<String, String>> movies = [
    {
      "name": "Agak Laen",
      "poster":
          "https://imgx.sonora.id/crop/0x0:0x0/x/photo/2024/01/31/ae8f6c08167a8957265addf264f2b1ca-20240131122121.jpg",
      "id": "1",
    },
    {
      "name": "Venom",
      "poster":
          "https://play-lh.googleusercontent.com/FJoSZUpiCSJ5nDE2ZSQXv4IU9wSqLZJmFv6bSZbZfMi6_BVg5tjy1iZ1vaRQtlJJes26Jw=w240-h480-rw",
      "id": "2",
    },
    {
      "name": "Sweet Home",
      "poster":
          "https://fr.web.img4.acsta.net/c_310_420/pictures/20/12/18/11/36/0595390.jpg",
      "id": "3",
    },
    {
      "name": "DAMSEL",
      "poster":
          "https://assets-a1.kompasiana.com/items/album/2024/03/23/img-0896-65fe890ede948f10f9302273.jpeg",
      "id": "4",
    },
    {
      "name": "All Of Us are Dead",
      "poster":
          "https://www.amartha.com/_next/image/?url=https%3A%2F%2Faccess.amartha.com%2Fuploads%2Fwajib_tahu_ini_5_fakta_menarik_drama_all_of_us_are_dead_634be7a11e.jpeg&w=1920&q=75",
      "id": "5",
    },
    {
      "name": "The Glory",
      "poster":
          "https://cdns.klimg.com/kapanlagi.com/p/vxjlpq4fwwiueyirrttrwtrt.jpg",
      "id": "6",
    },
  ];

  UpcomingMovieCard({
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
