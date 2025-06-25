import 'package:flutter/material.dart';

class ComoAjudarScreen extends StatelessWidget {
  const ComoAjudarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, size: 28, color: Colors.red),
            SizedBox(width: 8),
            Text('Como Ajudar?', style: TextStyle(color: Colors.black)),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8E2DE2)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajudar faz a diferença!',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF8E2DE2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: '🐶 Adoção Responsável',
                content:
                    'Adote um animal e ofereça um lar cheio de amor. Visite ONGs ou abrigos da sua região e conheça pets que precisam de uma familia.',
              ),
              _buildSection(
                title: '❤️ Apadrinhamento',
                content:
                    'Se não pode adotar, você pode apadrinhar um pet. Ajude com alimentação, vacinas e cuidados médicos.',
              ),
              _buildSection(
                title: '💰 Doações',
                content:
                    'Doe ração, medicamentos, produtos de limpeza ou apoio financeiro para ONGs e abrigos. Sua contribuição é muito importante.',
              ),
              _buildSection(
                title: '🤝 Voluntariado',
                content:
                    'Doe seu tempo! Ajude em feiras de adoção, cuidados nos anbrigos, campanhas de arrecadação e divulgações.',
              ),
              _buildSection(
                title: '📢 Divulgue',
                content:
                    'Use suas redes sociais para divulgar animais para adoção, eventos, campanhas e a causa animal.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
