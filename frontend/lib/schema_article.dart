class Article {
  final String foto;
  final String nombre;
  final String vendedor;
  final String calificacion;
  final bool estrella;

  Article(
      {required this.foto,
      required this.nombre,
      required this.vendedor,
      required this.calificacion,
      required this.estrella});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        foto: json['foto'],
        nombre: json['nombre'],
        vendedor: json['vendedor'],
        calificacion: json['calificacion'],
        estrella: json['estrella']);
  }
}
