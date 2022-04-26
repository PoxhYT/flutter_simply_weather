// ignore_for_file: prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter, avoid_print, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, prefer_const_declarations

import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_simply_weather/models/Weather.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot != null) {
              Weather _weather = snapshot.data as Weather; 
              if (_weather == null) {
                return Text("Error getting weather");
              } else {
                return weatherBox(_weather);
              }
            } else {
              return CircularProgressIndicator();
            }
          },
          future: getCurrentWeather(),
        ),
      ),
    );
  }

  Widget weatherBox(Weather weather) {
    return Column(
      children: [
        Text("${weather.temperature}°C"),
        Text("${weather.minimumTemperature}°C"),
        Text("${weather.maximumTemperature}°C"),
      ],
    );
  }

  Future getCurrentWeather() async {
    Weather? weather;
    String city = "Berlin";
    String apiKey = "YOUR OPENWEATHERMAP API_KEY";

    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    var response = await http.post(url);

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body), city);
    } else {
      print("ERROR");
    }
    print(weather);
    return weather;
  }
}