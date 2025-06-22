class Doenca {
  final int id;
  final String nome;
  final String sintomas;
  final String nivelGravidade;
  final int? userId; 

  Doenca({
    required this.id,
    required this.nome,
    required this.sintomas,
    required this.nivelGravidade,
    this.userId,
  });

  factory Doenca.fromJson(Map<String, dynamic> json) {
    return Doenca(
      id: json['id'] as int,
      nome: json['nome'] as String,
      sintomas: json['sintomas'] as String,
      nivelGravidade: json['nivel_gravidade'] as String,
      userId: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sintomas': sintomas,
      'nivel_gravidade': nivelGravidade,
      if (userId != null) 'user_id': userId,
    };
  }
}