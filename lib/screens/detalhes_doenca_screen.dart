import 'package:flutter/material.dart';
import 'package:app_smilling/models/doenca.dart';

class DetalhesDoencaScreen extends StatelessWidget {
  final Doenca doenca;

  const DetalhesDoencaScreen({super.key, required this.doenca});

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doenca.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doenca.nome, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            _buildSection(context, 'Descrição:', doenca.descricao),
            _buildSection(context, 'Sintomas:', doenca.sintomas),
            _buildSection(context, 'Tratamento:', doenca.tratamento),
          ],
        ),
      ),
    );
  }
}
