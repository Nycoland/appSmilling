import 'package:flutter/material.dart';
import 'package:app_smilling/models/clinica.dart';
import 'package:app_smilling/services/api/clinica_service.dart';

class ClinicasScreen extends StatefulWidget {
  const ClinicasScreen({super.key});

  @override
  _ClinicasScreenState createState() => _ClinicasScreenState();
}

class _ClinicasScreenState extends State<ClinicasScreen> {
  List<Clinica> _clinicas = [];
  List<Clinica> _filteredClinicas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClinicas();
  }

  Future<void> _loadClinicas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clinicas = await ClinicaService.getClinicas();
      setState(() {
        _clinicas = clinicas;
        _filteredClinicas = clinicas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clínicas: ${e.toString()}')),
      );
    }
  }

  void _filterClinicas(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredClinicas = _clinicas;
      } else {
        _filteredClinicas = _clinicas.where((clinica) {
          return clinica.nome.toLowerCase().contains(_searchQuery) ||
              (clinica.endereco?.toLowerCase().contains(_searchQuery) ?? false) ||
              (clinica.telefone?.toLowerCase().contains(_searchQuery) ?? false) ||
              (clinica.email?.toLowerCase().contains(_searchQuery) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_hospital, color: Color(0xFF7681F8)),
            SizedBox(width: 8),
            Text('Clínicas Veterinárias', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encontre as melhores clínicas para cuidar da saúde do seu pet.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            
            // Barra de pesquisa
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Clínicas',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterClinicas('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterClinicas,
            ),
            const SizedBox(height: 16),
            
            // Lista de clínicas
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando clínicas...'),
                        ],
                      ),
                    )
                  : _filteredClinicas.isEmpty
                      ? Center(
                          child: _clinicas.isEmpty
                              ? const Text('Nenhuma clínica cadastrada ainda.')
                              : const Text('Nenhuma clínica encontrada.'),
                        )
                      : ListView.builder(
                          itemCount: _filteredClinicas.length,
                          itemBuilder: (context, index) {
                            final clinica = _filteredClinicas[index];
                            return _buildClinicaCard(clinica);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicaCard(Clinica clinica) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.blue, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clinica.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.location_on, 'Endereço:', clinica.endereco),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, 'Telefone:', clinica.telefone),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.email, 'Email:', clinica.email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value ?? 'Não informado',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}