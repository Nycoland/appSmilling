import 'package:app_smilling/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app_smilling/screens/homeScreen.dart';
import 'package:app_smilling/screens/loginScreen.dart';

void main() {
  runApp(const AppSmilling());
}

class AppSmilling extends StatelessWidget {
  const AppSmilling({super.key});

  Future<Widget> _checkAuth() async {
    final isLoggedIn = await ApiService.isAuthenticated();
    return isLoggedIn ? HomeScreen() : LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data as Widget;
          }
        },
      ),
    );
  }
}
