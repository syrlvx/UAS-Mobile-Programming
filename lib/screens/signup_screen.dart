import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/auth_services.dart';
import 'package:netflix_clone/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(size: size),
                SizedBox(height: 5),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(
                      value: "Boy",
                      child: Text(
                        "Boy",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Girl",
                      child: Text(
                        "Girl",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _birthdayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    hintText: 'Select your birthday',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.cake),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _birthdayController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _username.text;
    String email = _email.text;
    String password = _password.text;
    String birthday = _birthdayController.text;
    String? gender = _selectedGender;
    String phone = _phoneController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        birthday.isEmpty ||
        gender == null ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }

    try {
      // Mendaftarkan user
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        String uid = user.uid;

        // Menyimpan data ke Firestore
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'username': username,
          'email': email,
          'birthday': birthday,
          'gender': gender,
          'phone': phone,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed: $e")),
      );
    }
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
        SizedBox(width: size.width * 0.21),
        Image.asset(
          'assets/logo.png',
          width: 200,
          height: 125,
        ),
      ],
    );
  }
}
