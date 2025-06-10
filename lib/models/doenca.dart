class Doenca {
  final int id;
  final String nome;
  final String descricao;
  final String sintomas;
  final String tratamento;

  Doenca({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.sintomas,
    required this.tratamento,
  });

  factory Doenca.fromJson(Map<String, dynamic> json) {
    return Doenca(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      sintomas: json['sintomas'],
      tratamento: json['tratamento'],
    );
  }
}
