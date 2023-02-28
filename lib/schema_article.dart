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
        foto: json['foto'],
        nombre: json['nombre'],
        vendedor: json['vendedor'],
        calificacion: json['calificacion']);
  }
}
