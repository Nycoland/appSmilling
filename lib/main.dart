import 'package:app_smilling/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app_smilling/screens/home_screen.dart';
import 'package:app_smilling/screens/login_screen.dart';

void main() {
  runApp(AppSmilling());
}

class AppSmilling extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smilling App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _apiService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? HomeScreen() : LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
