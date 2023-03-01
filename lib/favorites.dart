// ignore_for_file: use_build_context_synchronously
// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'schema_article.dart';
import 'sqlite.dart';
import 'widget_list.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _getArticles();
  }

  Future<void> _getArticles() async {
    print("favoritos");
    List<Map<String, dynamic>> data = await DBHelper.getData('favoritos');
    List<Article> articles = [];
    for (var item in data) {
      Article article = Article(
        foto: item['foto'],
        nombre: item['nombre'],
        vendedor: item['vendedor'],
        calificacion: item['calificacion'],
      );
      articles.add(article);
    }
    setState(() {
      _articles = articles;
    });
  }

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
      body: GridView.builder(
        itemCount: _articles.length,
        itemBuilder: (BuildContext context, int index) {
          Article article = _articles[index];
          return WidgetList(
            key: ValueKey(index),
            foto: Image.asset(article.foto),
            nombre: article.nombre,
            vendedor: article.vendedor,
            calificacion: article.calificacion,
            vertical: true,
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7),
      ),
    );
  }
}
