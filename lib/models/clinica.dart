class Clinica {
  final int id;
  final String nome;
  final String endereco;
  final double telefone;

  Clinica({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
  });

  factory Clinica.fromJson(Map<String, dynamic> json) {
    return Clinica(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      telefone: json['telefone'],
    );
  }
}
