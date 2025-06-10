class Clinica {
  final int id;
  final String nome;
  final String endereco;
  final double telefone;
  final String especialidade;
  final String? imagemUrl;

  Clinica({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.especialidade,
    this.imagemUrl,
  });

  factory Clinica.fromJson(Map<String, dynamic> json) {
    return Clinica(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      especialidade: json['especialidade'],
      imagemUrl: json['imagemUrl'],
    );
  }
}
