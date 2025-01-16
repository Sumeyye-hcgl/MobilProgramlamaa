import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'notes_provider.dart';
import 'reminders_provider.dart';
import 'tasksScreen.dart';
import 'notesScreen.dart';
import 'remindersScreen.dart';
import 'settingsScreen.dart';
import 'weatherScreen.dart';
import 'dart:convert'; // JSON verisini işlemek için gerekli import
import 'package:http/http.dart' as http; // http istekleri için import

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kişisel Asistan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String? _weatherInfo;
  String? _iconUrl;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final apiKey = '6a1b65798bc24090a1b114140251101';
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=Turkey&aqi=no';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // JSON verisini çözme
        setState(() {
          _weatherInfo =
              'Türkiye: ${data["current"]["temp_c"]}°C, ${data["current"]["condition"]["text"]}';
          _iconUrl = "https:${data['current']['condition']['icon']}";
        });
      } else {
        setState(() {
          _weatherInfo = 'Hava durumu bilgisi alınamadı.';
          _iconUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Hata: Hava durumu alınırken bir sorun oluştu.';
        _iconUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hava Durumu Bilgisi
            if (_weatherInfo != null)
              Column(
                children: [
                  if (_iconUrl != null)
                    Image.network(
                      _iconUrl!,
                      width: 50,
                      height: 50,
                    ),
                  SizedBox(height: 10),
                  Text(
                    _weatherInfo!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                ],
              ),
            // Hatırlatıcılar
            Text(
              'Hatırlatıcılar',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<ReminderProvider>(
                builder: (context, reminderProvider, child) {
                  return ListView.builder(
                    itemCount: reminderProvider.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminderProvider.reminders[index];
                      return ListTile(
                        title: Text(reminder.title),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
            // Notlar
            Text(
              'Notlar',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return ListView.builder(
                    itemCount: notesProvider.notes.length,
                    itemBuilder: (context, index) {
                      final task = notesProvider.notes[index];
                      return ListTile(
                        title: Text(task.title),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
            // Görevler
            Text(
              'Görevler',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return ListTile(
                        title: Text(task.title),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            const Color.fromARGB(255, 58, 167, 125), // Footer background color
        selectedItemColor:
            const Color.fromARGB(255, 255, 255, 255), // Selected icon color
        unselectedItemColor:
            const Color.fromARGB(255, 255, 255, 255), // Unselected icon color
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Sayfalara yönlendirme işlemi
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemindersScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Görevler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Hatırlatıcılar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Hava Durumu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
