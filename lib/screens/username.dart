import 'package:flutter/material.dart';
import 'package:netflix_clone/widgets/bottom_nav_bar.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Header(size: size),
            SizedBox(height: size.height * 0.1),
            username(
              size: size,
              username1: "Muhammad",
              username2: "Hermawan",
              image1:
                  "https://wallpapers.com/images/high/netflix-profile-pictures-1000-x-1000-qo9h82134t9nv0j0.webp",
              image2:
                  "https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png",
            ),
            SizedBox(height: size.height * 0.05),
            username(
              size: size,
              username1: "Ophelia",
              username2: "Raffi",
              image1:
                  "https://i.pinimg.com/564x/1b/a2/e6/1ba2e6d1d4874546c70c91f1024e17fb.jpg",
              image2:
                  "https://wallpapers.com/images/high/netflix-profile-pictures-1000-x-1000-dyrp6bw6adbulg5b.webp",
            ),
            SizedBox(height: size.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // Image.network(
                    //   "https://www.aucklandeye.co.nz/wp-content/uploads/2023/08/Blue-eyes.jpg",
                    //   width: 20,
                    //   height: 20,
                    // ),
                    Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text("Add Profile", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class username extends StatelessWidget {
  const username({
    super.key,
    required this.size,
    required this.username1,
    required this.username2,
    required this.image1,
    required this.image2,
  });

  final Size size;
  final String username1, username2, image1, image2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomNavBar()));
          },
          child: Column(
            children: [
              Image.network(
                image1,
                width: 125,
                height: 100,
              ),
              SizedBox(height: size.height * 0.01),
              Text(username1, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.1,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomNavBar()));
          },
          child: Column(
            children: [
              Image.network(
                image2,
                width: 125,
                height: 100,
              ),
              SizedBox(height: size.height * 0.01),
              Text(username2, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: size.width * 0.23),
        Image.network(
          'https://cdn.pixabay.com/photo/2021/01/25/07/18/netflix-5947489_1280.png',
          width: 235,
          height: 150,
        ),
        Spacer(),
        // Image.network('assets/img/bx_bxs-pencil.png'),
        SizedBox(width: size.width * 0.08),
      ],
    );
  }
}
