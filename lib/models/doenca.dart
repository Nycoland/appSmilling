class Doenca {
  final int id;
  final String nome;
  final String sintomas;
  final String? prevencao;
  final String nivelGravidade;
  final int? userId;

  Doenca({
    required this.id,
    required this.nome,
    required this.sintomas,
    this.prevencao,
    required this.nivelGravidade,
    this.userId,
  });

  factory Doenca.fromJson(Map<String, dynamic> json) {
    return Doenca(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      sintomas: json['sintomas'] as String? ?? '',
      prevencao: json['prevencao'] as String?,
      nivelGravidade: json['nivel_gravidade'] as String? ?? 'leve',
      userId: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sintomas': sintomas,
      'prevencao': prevencao,
      'nivel_gravidade': nivelGravidade,
      if (userId != null) 'user_id': userId,
    };
  }
}