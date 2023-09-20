// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'dart:ffi';
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
  bool vertical = false;
  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    var response =
        await http.get(Uri.parse("http://192.168.57.145:3000/getArticles"));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);

      List<Article> articles = [];

      for (var articleJson in jsonData) {
        // Create Article object for each JSON item
        Article article = Article.fromJson(articleJson);
        articles.add(article);
      }

      setState(() {
        _articles = articles;
      });
    } else {
      throw Exception('Error al cargar artículos');
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    var response =
        await http.get(Uri.parse('http://192.168.57.145:3000/logout'));
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
            child: vertical
                ? GridView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      Article article = _articles[index];
                      return WidgetList(
                        key: ValueKey(index),
                        foto: Image.network(article.foto),
                        nombre: article.nombre,
                        vendedor: article.vendedor,
                        calificacion: article.calificacion,
                        vertical: vertical,
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.7),
                  )
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      Article article = _articles[index];
                      return WidgetList(
                        key: ValueKey(index),
                        foto: Image.network(article.foto),
                        nombre: article.nombre,
                        vendedor: article.vendedor,
                        calificacion: article.calificacion,
                        vertical: vertical,
                      );
                    },
                  ),
          ),
          ElevatedButton(
              onPressed: () => setState(() {
                    vertical = !vertical;
                  }),
              child: const Text('Cambiar')),
          ElevatedButton(
              onPressed: () => _logout(), child: const Text('Cerrar sesión')),
        ],
      ),
    );
  }
}
