import 'package:flutter/material.dart';
import 'package:app_smilling/widgets/clinica_card.dart';
import 'package:app_smilling/models/clinica.dart';
import 'package:app_smilling/services/api_service.dart';
import 'package:app_smilling/screens/detalhes_clinica_screen.dart';

class ClinicasScreen extends StatefulWidget {
  @override
  _ClinicasScreenState createState() => _ClinicasScreenState();
}

class _ClinicasScreenState extends State<ClinicasScreen> {
  late Future<List<Clinica>> _futureClinicas;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureClinicas = _fetchClinicas();
  }

  Future<List<Clinica>> _fetchClinicas() async {
    final data = await _apiService.get('clinicas');
    return (data as List).map((clinica) => Clinica.fromJson(clinica)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clínicas')),
      body: FutureBuilder<List<Clinica>>(
        future: _futureClinicas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar clínicas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma clínica encontrada'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final clinica = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetalhesClinicaScreen(clinica: clinica),
                    ),
                  );
                },
                child: ClinicaCard(clinica: clinica),
              );
            },
          );
        },
      ),
    );
  }
}
