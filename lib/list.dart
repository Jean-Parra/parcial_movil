// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcial_movil/favorites.dart';
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
    var response =
        await http.get(Uri.parse("http://192.168.184.145:3000/getArticles"));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
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
        await http.get(Uri.parse('http://192.168.184.145:3000/logout'));
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Get.to(() => const LoginScreen());
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
          ElevatedButton(
              onPressed: () => Get.to(() => const FavoriteScreen()),
              child: const Text("Favoritos")),
          Expanded(
            child: ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (BuildContext context, int index) {
                Article article = _articles[index];
                return WidgetList(
                  key: ValueKey(index),
                  foto: Image.network(article.foto),
                  nombre: article.nombre,
                  vendedor: article.vendedor,
                  calificacion: article.calificacion,
                  vertical: false,
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => _logout(), child: const Text('Cerrar sesión')),
        ],
      ),
    );
  }
}
