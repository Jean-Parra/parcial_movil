// ignore_for_file: use_build_context_synchronously
// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    var response =
        await http.get(Uri.parse('http://192.168.184.145:3000/logout'));
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi aplicación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _logout(),
              child: const Text('Cerrar sesión'),
            )
          ],
        ),
      ),
    );
  }
}
