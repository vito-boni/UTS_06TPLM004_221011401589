// vito was here!!!
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Weather',
      debugShowCheckedModeBanner: false,
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = 'Loading...';
  String description = '';
  double temperature = 0;
  double minTemp = 0;
  double maxTemp = 0;
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    _getWeather();
  }

  Future<void> _getWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lon = position.longitude;

      String apiKey =
          'be16870e505d1320b8b034cc2d401e61'; // bagian kode API
      String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);

      setState(() {
        location = data['name'];
        description = data['weather'][0]['description'];
        temperature = data['main']['temp'];
        minTemp = data['main']['temp_min'];
        maxTemp = data['main']['temp_max'];
      });
    } catch (e) {
      setState(() {
        location = 'Failed to get weather';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Image.asset('assets/bg-cuaca.jpg', fit: BoxFit.cover),
          ),
          Container(
            width: width,
            height: height,
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      location,
                      style: GoogleFonts.roboto(
                        fontSize: 34,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentDate,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '${temperature.toStringAsFixed(0)}°C',
                      style: GoogleFonts.roboto(
                        fontSize: 90,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(width: 180, height: 1, color: Colors.white54),
                    const SizedBox(height: 20),
                    Text(
                      toBeginningOfSentenceCase(description) ?? '',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${minTemp.toStringAsFixed(0)}°C / ${maxTemp.toStringAsFixed(0)}°C',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}