// ignore_for_file: library_private_types_in_public_api, avoid_print, avoid_init_to_null
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse = null;

    var response = await http
        .post(Uri.parse("http://192.168.184.145:3000/signin"), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyApp()));
      }
    } else {
      setState(() {
        _errorMessage = response.body;
        _isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const FlutterLogo(size: 70, style: FlutterLogoStyle.horizontal),
              const SizedBox(height: 80),
              TextField(
                key: const Key('email'),
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Correo electrónico',
                  labelText: 'Correo electrónico',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                key: const Key('password'),
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: emailController.text == "" ||
                        passwordController.text == ""
                    ? null
                    : () {
                        setState(() {
                          _isLoading = true;
                        });
                        signIn(emailController.text, passwordController.text);
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Iniciar sesión'),
              ),
              if (_errorMessage != "")
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
