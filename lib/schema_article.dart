class Article {
  final String foto;
  final String nombre;
  final String vendedor;
  final String calificacion;

  Article({
    required this.foto,
    required this.nombre,
    required this.vendedor,
    required this.calificacion,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      foto: json['foto'] ?? '', // Provide a default value if 'foto' is null
      nombre:
          json['nombre'] ?? '', // Provide a default value if 'nombre' is null
      vendedor: json['vendedor'] ??
          '', // Provide a default value if 'vendedor' is null
      calificacion: json['calificacion'] ??
          '', // Provide a default value if 'calificacion' is null
    );
  }
}
