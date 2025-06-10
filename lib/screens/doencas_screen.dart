import 'package:flutter/material.dart';
import 'package:app_smilling/models/doenca.dart';
import 'package:app_smilling/services/api_service.dart';
import 'package:app_smilling/widgets/doenca_card.dart';
import 'package:app_smilling/screens/detalhes_doenca_screen.dart';

class DoencasScreen extends StatefulWidget {
  @override
  _DoencasScreenState createState() => _DoencasScreenState();
}

class _DoencasScreenState extends State<DoencasScreen> {
  late Future<List<Doenca>> _futureDoencas;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureDoencas = _fetchDoencas();
  }

  Future<List<Doenca>> _fetchDoencas() async {
    final data = await _apiService.get('doencas');
    return (data as List).map((json) => Doenca.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doenças')),
      body: FutureBuilder<List<Doenca>>(
        future: _futureDoencas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar doenças'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma doença encontrada'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final doenca = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetalhesDoencaScreen(doenca: doenca),
                    ),
                  );
                },
                child: DoencaCard(doenca: doenca),
              );
            },
          );
        },
      ),
    );
  }
}
