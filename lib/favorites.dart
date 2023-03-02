// ignore_for_file: use_build_context_synchronously
// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Future<String> convertImageToBase64(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    Uint8List bytes = response.bodyBytes;
    String base64Image = base64Encode(bytes);
    return base64Image;
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
            foto: Image.memory(article.foto as Uint8List),
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
