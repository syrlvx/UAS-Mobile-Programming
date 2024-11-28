import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/logout_screen.dart';
import 'package:netflix_clone/screens/globals.dart' as globals;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _gender = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      final doc =
          await _firestore.collection('user').doc(currentUser!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _usernameController.text = data['username'] ?? '';
        _emailController.text = currentUser!.email ?? '';
        _phoneController.text = data['phone'] ?? '';
        _birthdayController.text = data['birthday'] ?? '';
        _gender = data['gender'] ?? '';
      }
      setState(() {});
    }
  }

  Future<void> _updateUserData() async {
    try {
      if (currentUser != null) {
        final String newUsername = _usernameController.text;
        final String newEmail = _emailController.text;

        // Reauthenticate user
        if (_currentPasswordController.text.isNotEmpty) {
          final credential = EmailAuthProvider.credential(
            email: currentUser!.email!,
            password: _currentPasswordController.text,
          );
          await currentUser!.reauthenticateWithCredential(credential);
        }

        // Update Firestore data
        await _firestore.collection('user').doc(currentUser!.uid).update({
          'username': newUsername,
          'phone': _phoneController.text,
          'birthday': _birthdayController.text,
          'gender': _gender,
        });
        globals.nama = newUsername;

        // Update email in FirebaseAuth
        await currentUser!.updateEmail(newEmail);

        // Update password if provided
        if (_newPasswordController.text.isNotEmpty) {
          await currentUser!.updatePassword(_newPasswordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );

        // Keluar dari mode edit
        setState(() {
          isEditing = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogoutScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Menavigasi kembali ke layar sebelumnya
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Mengatur elemen di kiri
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 100,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? _buildEditForm() : _buildUserInfo(),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "User Information",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Text(
            "Username",
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _usernameController.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text(
            "Email",
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _emailController.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text(
            "Phone Number",
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _phoneController.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text(
            "Gender",
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _gender,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text(
            "Birthday",
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _birthdayController.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("Edit Profile", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: _logout,
            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 22),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.person, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.email, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: "Phone Number",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.phone, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _gender.isEmpty ? null : _gender,
          items: const [
            DropdownMenuItem(value: "Boy", child: Text("Boy")),
            DropdownMenuItem(value: "Girl", child: Text("Girl")),
          ],
          decoration: InputDecoration(
            labelText: "Gender",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _gender = value ?? '';
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _birthdayController,
          decoration: InputDecoration(
            labelText: "Birthday",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _currentPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Current Password",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "New Password",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _updateUserData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("Save Changes", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
