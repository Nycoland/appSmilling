import 'package:flutter/material.dart';
import 'package:app_smilling/models/doenca.dart';
import 'package:app_smilling/services/api/doenca_service.dart';

class DoencasScreen extends StatefulWidget {
  const DoencasScreen({super.key});

  @override
  _DoencasScreenState createState() => _DoencasScreenState();
}

class _DoencasScreenState extends State<DoencasScreen> {
  List<Doenca> _doencas = [];
  List<Doenca> _filteredDoencas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _severityLevels = [
    {'title': 'Leve', 'value': 'leve'},
    {'title': 'Moderado', 'value': 'moderado'},
    {'title': 'Grave', 'value': 'grave'},
    {'title': 'Muito Grave', 'value': 'muito_grave'},
  ];

  @override
  void initState() {
    super.initState();
    _loadDoencas();
  }

  Future<void> _loadDoencas() async {
    setState(() => _isLoading = true);
    try {
      final doencas = await DoencaService.getDoencas();
      setState(() {
        _doencas = doencas;
        _filteredDoencas = doencas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar doenças: ${e.toString()}')),
      );
    }
  }

  void _filterDoencas(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredDoencas = _searchQuery.isEmpty
          ? _doencas
          : _doencas.where((d) =>
              d.nome.toLowerCase().contains(_searchQuery) ||
              d.sintomas.toLowerCase().contains(_searchQuery) ||
              (d.prevencao?.toLowerCase().contains(_searchQuery) ?? false) ||
              d.nivelGravidade.toLowerCase().contains(_searchQuery)).toList();
    });
  }

  String _formatSeverity(String severity) {
    final level = _severityLevels.firstWhere(
      (l) => l['value'] == severity,
      orElse: () => {'title': severity},
    );
    return level['title']!;
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'leve': return Colors.green;
      case 'moderado': return Colors.orange;
      case 'grave': return Colors.red;
      case 'muito_grave': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Guia de Doenças', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDoencas,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conheça as principais doenças que podem afetar seu pet, seus sintomas e níveis de gravidade.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar Doenças',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterDoencas('');
                          },
                        )
                      : null,
                ),
                onChanged: _filterDoencas,
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando doenças...'),
                          ],
                        ),
                      )
                    : _filteredDoencas.isEmpty
                        ? Center(
                            child: _doencas.isEmpty
                                ? const Text('Nenhuma doença cadastrada ainda.')
                                : const Text('Nenhuma doença encontrada.'),
                          )
                        : ListView.builder(
                            itemCount: _filteredDoencas.length,
                            itemBuilder: (context, index) => _buildDoencaCard(_filteredDoencas[index]),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoencaCard(Doenca doenca) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doenca.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: _getSeverityColor(doenca.nivelGravidade),
                  label: Text(
                    _formatSeverity(doenca.nivelGravidade),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Sintomas
            _buildInfoSection(
              icon: Icons.medical_services,
              iconColor: Colors.orange,
              title: 'Sintomas',
              content: doenca.sintomas,
            ),
            const SizedBox(height: 16),
            
            // Prevenção
            _buildInfoSection(
              icon: Icons.shield,
              iconColor: Colors.green,
              title: 'Prevenção',
              content: doenca.prevencao ?? 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}