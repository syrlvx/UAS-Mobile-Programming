import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/widgets/landing_card.dart';

class CustomCarouselSlider extends StatelessWidget {
  CustomCarouselSlider({
    super.key,
  });

  // Data statis untuk slider
  final List<Map<String, String>> data = [
    {
      "name": "Bird Box",
      "image":
          "https://www.mldspot.com/storage/posts/August2024/Bird%20Box%20(2018).webp",
    },
    {
      "name": "Leave The Behind",
      "image":
          "https://www.mldspot.com/storage/posts/August2024/Leave%20the%20World%20Behind%20(2023).webp",
    },
    {
      "name": "Move To Heaven",
      "image":
          "https://www.farah.id/assets/images/news/2024/04/20240406105325_normal.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var carouselOptions = CarouselOptions(
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      aspectRatio: 16 / 9,
      viewportFraction: 0.9,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );

    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          var item = data[index];
          return GestureDetector(
            onTap: () {},
            child: LandingCard(
              image: CachedNetworkImageProvider(item["image"]!),
              name: item["name"]!,
            ),
          );
        },
        options: carouselOptions,
      ),
    );
  }
}
