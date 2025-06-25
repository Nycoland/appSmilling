class Clinica {
  final int id;
  final String nome;
  final String? endereco;
  final String? telefone;
  final String? email;
  final String? image;
  final int? userId;

  Clinica({
    required this.id,
    required this.nome,
    this.endereco,
    this.telefone,
    this.email,
    this.image,
    this.userId,
  });

  factory Clinica.fromJson(Map<String, dynamic> json) {
    return Clinica(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      email: json['email'],
      image: json['image'],
      userId: json['user_id'],
    );
  }
}