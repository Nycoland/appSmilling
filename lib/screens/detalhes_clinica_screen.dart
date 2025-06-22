// import 'package:flutter/material.dart';
// import 'package:app_smilling/models/clinica.dart';
// import 'package:app_smilling/services/api/clinica_service.dart';

// class DetalhesClinicaScreen extends StatefulWidget {
//   final Clinica clinica;
//   final bool isOwner;
//   final VoidCallback? onClinicaUpdated;

//   const DetalhesClinicaScreen({
//     super.key,
//     required this.clinica,
//     required this.isOwner,
//     this.onClinicaUpdated,
//   });

//   @override
//   State<DetalhesClinicaScreen> createState() => _DetalhesClinicaScreenState();
// }

// class _DetalhesClinicaScreenState extends State<DetalhesClinicaScreen> {
//   late Clinica _clinica;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _clinica = widget.clinica;
//   }

//   Future<void> _deleteClinica() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirmar exclusão'),
//         content: const Text('Tem certeza que deseja excluir esta clínica?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancelar'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Excluir', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
      
//       try {
//         await ClinicaService.deleteClinica(_clinica.id);
//         if (widget.onClinicaUpdated != null) {
//           widget.onClinicaUpdated!();
//         }
//         if (mounted) {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Clínica excluída com sucesso')),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erro ao excluir clínica: ${e.toString()}')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_clinica.nome),
//         actions: [
//           if (widget.isOwner)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: _isLoading ? null : () => _showEditDialog(),
//             ),
//           if (widget.isOwner)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: _isLoading ? null : _deleteClinica,
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (_clinica.image != null)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         _clinica.image!,
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   else
//                     Container(
//                       height: 200,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: const Center(
//                         child: Icon(Icons.medical_services, size: 64, color: Colors.grey),
//                       ),
//                     ),
//                   const SizedBox(height: 24),
//                   _buildInfoRow('Nome', _clinica.nome),
//                   _buildInfoRow('Endereço', _clinica.endereco),
//                   _buildInfoRow('Telefone', _clinica.telefone),
//                   if (_clinica.email != null) _buildInfoRow('Email', _clinica.email!),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   Future<void> _showEditDialog() async {
//     // Implementar diálogo de edição
//   }
// }