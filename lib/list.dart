// ignore_for_file: use_build_context_synchronously
// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parcial_movil/schema_article.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'widget_list.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final url = Uri.parse('http://localhost:3000/getArticles');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _articles = (jsonData as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      });
    } else {
      throw Exception('Error al cargar artículos');
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    var response =
        await http.get(Uri.parse('http://10.153.76.132:3000/logout'));
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
      body: Column(
        children: [
          ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (BuildContext context, int index) {
              Article article = _articles[index];
              return WidgetList(
                key: ValueKey(index),
                foto: Image.asset(article.foto),
                nombre: article.nombre,
                vendedor: article.vendedor,
                calificacion: article.calificacion,
                vertical: false,
              );
            },
          ),
          ElevatedButton(
              onPressed: () => _logout(), child: const Text('Cerrar sesión'))
        ],
      ),
    );
  }
}
