import 'package:flutter/material.dart';
import 'package:netflix_clone/widgets/bottom_nav_bar.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;

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
            Center(
              child: Text("Halo, ${globals.nama}"),
            ),
            SizedBox(height: size.height * 0.05),
            username(
              size: size,
              username1: "woi",
              username2: "Ul",
              image1:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTNlixg4qwjWdWKOxakcDVFZtsrCe4UVQqkw&s",
              image2:
                  "https://www.citypng.com/public/uploads/preview/png-mickey-mouse-disney-round-logo-701751694864249qxzevq6u7o.png?v=2024110602",
            ),
            SizedBox(height: size.height * 0.05),
            username(
              size: size,
              username1: "Na",
              username2: "Nic",
              image1:
                  "https://static.wikia.nocookie.net/pororo/images/2/26/PororoCurrentOutfit.jpg/revision/latest?cb=20220224154302",
              image2:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMTm25GDpVw281drFRvtI3HCGSNa7iGU8MAg&s",
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
        Image.asset(
          'assets/logo.png',
          width: 225,
          height: 185,
        ),
        Spacer(),
        SizedBox(width: size.width * 0.08),
      ],
    );
  }
}
