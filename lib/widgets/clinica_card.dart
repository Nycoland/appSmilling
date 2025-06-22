// import 'package:flutter/material.dart';
// import 'package:app_smilling/models/clinica.dart';
// import 'package:app_smilling/services/api/clinica_service.dart';

// class ClinicasScreen extends StatefulWidget {
//   const ClinicasScreen({super.key});

//   @override
//   State<ClinicasScreen> createState() => _ClinicasScreenState();
// }

// class _ClinicasScreenState extends State<ClinicasScreen> {
//   List<Clinica> _clinicas = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadClinicas();
//   }

//   Future<void> _loadClinicas() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final clinicas = await ClinicaService.getClinicas();
//       setState(() {
//         _clinicas = clinicas;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Clínicas'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//               ? Center(child: Text(_errorMessage!))
//               : ListView.builder(
//                   itemCount: _clinicas.length,
//                   itemBuilder: (context, index) {
//                     final clinica = _clinicas[index];
//                     return ListTile(
//                       leading: clinica.image != null
//                           ? CircleAvatar(backgroundImage: NetworkImage(clinica.image!))
//                           : const CircleAvatar(child: Icon(Icons.medical_services)),
//                       title: Text(clinica.nome),
//                       subtitle: Text(clinica.endereco),
//                       trailing: Text(clinica.telefone),
//                       onTap: () {
//                         // Navegar para detalhes da clínica
//                       },
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Abrir formulário para adicionar nova clínica
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }