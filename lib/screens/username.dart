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
              username3: "Na",
              username4: "Nic",
              image1:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBCQD25y5J4SL_PMjwDgqfE8pfVl4UWHSvDg&s",
              image2:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmmYV0c_UcVeDCL7JgQH8wJaj4E2UTbnwcF2z75oecSOrXPgshnOgWyrBSYF8IeHR-fpc&usqp=CAU",
              image3:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtCSit7LT_vCHKn3fQu3qQ5e-Gy3cXe0EAHOV2mEH44ZhLb158LmDaFlRrsEKGYmNDf4o&usqp=CAU",
              image4:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2QpitRcp9-ctWHUTvzljjJueXPzMEtwCczOMMhJayqhulY-Rh5ubnP9bLb7coN13cK3I&usqp=CAU",
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: size.height * 0.01),
                    const Text("Add Profile", style: TextStyle(color: Colors.white)),
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
    required this.username3,
    required this.username4,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });

  final Size size;
  final String username1, username2, username3, username4;
  final String image1, image2, image3, image4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                globals.warna =
                    Colors.blue; // Menyimpan gambar1 ke globals.gambar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
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
            SizedBox(width: size.width * 0.05),
            GestureDetector(
              onTap: () {
                globals.warna =
                    Colors.red; // Menyimpan gambar2 ke globals.gambar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
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
        ),
        SizedBox(height: size.height * 0.03),
        // Second row with two images
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                globals.warna =
                    Colors.yellow; // Menyimpan gambar3 ke globals.gambar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    image3,
                    width: 125,
                    height: 100,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(username3, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.05),
            GestureDetector(
              onTap: () {
                globals.warna =
                    Colors.green; // Menyimpan gambar4 ke globals.gambar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    image4,
                    width: 125,
                    height: 100,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(username4, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
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
        const Spacer(),
        SizedBox(width: size.width * 0.08),
      ],
    );
  }
}
