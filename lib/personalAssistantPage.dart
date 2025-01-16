import 'package:flutter/material.dart';
import 'weatherScreen.dart';
import 'notesScreen.dart';
import 'remindersScreen.dart';
import 'tasksScreen.dart';
import 'settingsScreen.dart';

class PersonalAssistantPage extends StatelessWidget {
  const PersonalAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişisel Asistan'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text('Hava Durumu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notlar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('Hatırlatıcılar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Görevler'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen()),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ayarlar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}