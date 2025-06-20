import 'package:flutter/material.dart';
import 'package:app_smilling/services/api_service.dart';
import 'package:app_smilling/screens/clinicas_screen.dart';
import 'package:app_smilling/screens/doencas_screen.dart';
import 'package:app_smilling/screens/como_ajudar_screen.dart'; // Crie essa tela depois

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await _apiService.getUserEmail();
    setState(() => _userEmail = email);
  }

  Future<void> _logout() async {
    await _apiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Row(
          children: [
            Icon(Icons.pets, size: 28, color: Color(0xFF8E2DE2)),
            SizedBox(width: 8),
            Text('Smilling App', style: TextStyle(color: Color(0xFF8E2DE2))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFF8E2DE2)),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF8E2DE2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.pets, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    _userEmail ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.local_hospital,
                color: Color(0xFF8E2DE2),
              ),
              title: const Text('Clínicas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClinicasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.healing, color: Color(0xFF8E2DE2)),
              title: const Text('Doenças'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  DoencasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: Color(0xFF8E2DE2)),
              title: const Text('Como Ajudar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComoAjudarScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF8E2DE2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Expanded(
                      child: Text(
                        'Bem-vindo ao Smilling App!\nInformando os cuidados com seus pets.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.pets, size: 70, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              title: 'Clínicas Veterinárias',
              icon: Icons.local_hospital,
              description:
                  'Encontre clínicas veterinárias para cuidar do seu pet com amor e responsabilidade.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClinicasScreen()),
                );
              },
            ),
            _buildInfoCard(
              title: 'Doenças Comuns',
              icon: Icons.healing,
              description:
                  'Saiba mais sobre as principais doenças que podem afetar seu pet.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoencasScreen()),
                );
              },
            ),
            _buildInfoCard(
              title: 'Como Ajudar?',
              icon: Icons.volunteer_activism,
              description:
                  'Descubra como você pode ajudar animais em situação de risco, apoiando ONGs, adotando ou sendo voluntário.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ComoAjudarScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF8E2DE2)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
