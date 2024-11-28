import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/auth_services.dart';
import 'package:netflix_clone/screens/username.dart';
import 'package:netflix_clone/screens/signup_screen.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Header(size: size),
              SizedBox(height: size.height * 0.1),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40.0),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    tunggu();
                    print("pencet");
                    print(globals.nama);
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Not have a account?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _email.text;
    String password = _password.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("succed");
    } else {
      print("Akun Salah");
    }
  }

  Future<void> getUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await for (var authState in auth.authStateChanges()) {
      if (authState != null) {
        globals.uid = authState.uid;
        print("User ID: ${globals.uid}");
        break;
      }
    }
  }

  final CollectionReference _produk =
      FirebaseFirestore.instance.collection('user');
  Future<void> getNamaUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await for (var authState in auth.authStateChanges()) {
      if (authState != null) {
        try {
          DocumentSnapshot userSnapshot =
              await _produk.doc(authState.uid).get();

          if (userSnapshot.exists) {
            Map<String, dynamic> userData =
                userSnapshot.data() as Map<String, dynamic>;
            if (userData.containsKey('username')) {
              setState(() {
                globals.nama = userData['username'];
              });
            } else {
              print(
                  'Kunci \'nama\' tidak ditemukan dalam data user dengan ID ${authState.uid}');
            }
          } else {
            print(
                'Dokumen tidak ditemukan untuk user dengan ID ${authState.uid}');
          }
        } catch (e) {
          print('Error: $e');
        }
        break;
      }
    }
  }

  Future<void> tunggu() async {
    _signIn();
    await getUserID();
    await getNamaUser();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Username()));
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
        SizedBox(width: size.width * 0.19),
        Image.asset(
          'assets/logo.png',
          width: 225,
          height: 185,
        ),
      ],
    );
  }
}
