// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'sqlite.dart';

abstract class Widgets extends StatefulWidget {
  final Image foto;
  final String nombre;
  final String vendedor;
  final String calificacion;
  final bool vertical;
  final bool estrella;

  const Widgets(
      {super.key,
      required this.foto,
      required this.nombre,
      required this.vendedor,
      required this.calificacion,
      required this.vertical,
      required this.estrella});

  @override
  State<Widgets> createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  late bool _starred;

  @override
  void initState() {
    super.initState();
    _starred = widget.estrella;
  }

  Future<void> update(String nombre) async {
    try {
      var response = await http
          .put(Uri.parse("http://192.168.0.31:3000/estrella?nombre=$nombre"));

      if (response.statusCode == 200) {
        print('Estrella attribute toggled successfully for nombre: $nombre');
      } else if (response.statusCode == 404) {
        print('Article not found for nombre: $nombre');
      } else {
        print(
            'Error toggling estrella attribute. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling estrella attribute: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.vertical ? 190 : 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 100, 100, 100),
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: widget.vertical
              ? _buildVerticalLayout()
              : _buildHorizontalLayout(),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: IconButton(
            icon: Icon(
              _starred ? Icons.star : Icons.star_outline,
              color: _starred ? Colors.yellow : Colors.grey,
              size: 40,
            ),
            onPressed: () async {
              setState(() {
                _starred = !_starred;
              });
              final data = {
                'foto': widget.foto.toString().substring(
                    widget.foto.toString().indexOf('"') + 1,
                    widget.foto.toString().lastIndexOf('"')),
                'nombre': widget.nombre,
                'vendedor': widget.vendedor,
                'calificacion': widget.calificacion,
                'estrella': widget.estrella
              };
              if (_starred) {
                await DBHelper.insert('favoritos', data);
                await update(data['nombre']! as String);
              } else {
                await DBHelper.delete('favoritos', widget.nombre);
                await update(data['nombre']! as String);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        SizedBox(width: 120, height: 120, child: widget.foto),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTextWidgets(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        SizedBox(width: 120, height: 120, child: widget.foto),
        const SizedBox(height: 20),
        ..._buildTextWidgets(),
      ],
    );
  }

  List<Widget> _buildTextWidgets() {
    return [
      RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: "Articulo: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: widget.nombre),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: "Vendedor: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: widget.vendedor),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: "Calificación: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: widget.calificacion),
          ],
        ),
      )
    ];
  }
}

class WidgetList extends Widgets {
  const WidgetList(
      {required super.key,
      required Image foto,
      required String nombre,
      required String vendedor,
      required String calificacion,
      required bool vertical,
      required bool estrella})
      : super(
            foto: foto,
            nombre: nombre,
            vendedor: vendedor,
            calificacion: calificacion,
            vertical: vertical,
            estrella: estrella);
}
