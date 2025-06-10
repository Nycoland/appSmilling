import 'package:flutter/material.dart';
import 'package:app_smilling/models/clinica.dart';

class DetalhesClinicaScreen extends StatelessWidget {
  final Clinica clinica;

  const DetalhesClinicaScreen({super.key, required this.clinica});

  Widget _buildInfoSection(BuildContext context, String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(content),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(clinica.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (clinica.imagemUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  clinica.imagemUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.error_outline)),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              clinica.nome,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Especialidade: ${clinica.especialidade}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoSection(context, 'Endereço:', clinica.endereco),
            _buildInfoSection(context, 'Telefone:', clinica.telefone as String),
          ],
        ),
      ),
    );
  }
}
