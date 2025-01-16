import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: Center(
        child: Text(
          'Ayarlar Sayfası',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
