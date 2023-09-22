// ignore_for_file: use_build_context_synchronously
// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'list.dart';
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
  bool vertical = false;

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
          estrella: item['estrella'] == 1);
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
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () => Get.to(() => const ListScreen()),
                child: const Text("Lista")),
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
                            estrella: !article.estrella);
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
                            estrella: !article.estrella);
                      },
                    ),
            ),
            ElevatedButton(
                onPressed: () => setState(() {
                      vertical = !vertical;
                    }),
                child: const Text('Cambiar')),
          ],
        ));
  }
}
