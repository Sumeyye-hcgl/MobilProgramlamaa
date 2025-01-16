import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _weatherInfo;
  String? _iconUrl;
  bool _isLoading = false;

  Future<void> _fetchWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir şehir adı girin.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final apiKey = '6a1b65798bc24090a1b114140251101';
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo =
              '${data["location"]["name"]}, ${data["location"]["country"]}: '
              '${data["current"]["temp_c"]}°C, ${data["current"]["condition"]["text"]}';
          _iconUrl = "https:${data['current']['condition']['icon']}";
        });
      } else {
        setState(() {
          _weatherInfo = 'Şehir bulunamadı veya geçersiz bir veri alındı.';
          _iconUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Hata: Hava durumu alınırken bir sorun oluştu.';
        _iconUrl = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Şehir Adı',
                hintText: 'Örneğin: İstanbul',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: Text('Hava Durumunu Getir'),
              onPressed: _fetchWeather,
            ),
            SizedBox(height: 20),
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_weatherInfo != null)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_iconUrl != null)
                      Image.network(
                        _iconUrl!,
                        width: 100,
                        height: 100,
                      ),
                    SizedBox(height: 10),
                    Text(
                      _weatherInfo!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (_weatherInfo == null && !_isLoading)
              Text(
                'Hava durumu bilgisi henüz alınmadı.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
