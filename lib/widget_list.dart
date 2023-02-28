// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

abstract class Widgets extends StatelessWidget {
  final Image foto;
  final String nombre;
  final String vendedor;
  final String calificacion;
  final bool vertical;

  const Widgets(
      {super.key,
      required this.foto,
      required this.nombre,
      required this.vendedor,
      required this.calificacion,
      required this.vertical});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: vertical ? _buildVerticalLayout() : _buildHorizontalLayout(),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        SizedBox(width: 120, height: 120, child: foto),
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
        SizedBox(width: 120, height: 120, child: foto),
        const SizedBox(height: 20),
        ..._buildTextWidgets(),
      ],
    );
  }

  List<Widget> _buildTextWidgets() {
    return [
      Text(
        "Articulo: $nombre",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      Text(
        "Vendedor: $vendedor",
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      Text(
        "Calificación: $calificacion",
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
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
      required bool vertical})
      : super(
            foto: foto,
            nombre: nombre,
            vendedor: vendedor,
            calificacion: calificacion,
            vertical: vertical);
}
