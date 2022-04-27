// ignore_for_file: unused_local_variable, unnecessary_new

import 'dart:convert';

class Weather {
  final String city;
  final String weatherStatus;
  final String weatherDescription;
  final double temperature;
  final double minimumTemperature;
  final double maximumTemperature;
  final double windSpeed;
  final DateTime sunset;
  final DateTime sunrise;

  Weather(
      {required this.city,
      required this.weatherStatus,
      required this.weatherDescription,
      required this.temperature,
      required this.minimumTemperature,
      required this.maximumTemperature,
      required this.windSpeed,
      required this.sunset,
      required this.sunrise});

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    return Weather(
      city: city, 
      weatherStatus: json["weather"][0]["main"], 
      weatherDescription: json["weather"][0]["description"], 
      temperature: json["main"]['temp'].toDouble(), 
      minimumTemperature: json["main"]['temp_min'].toDouble(), 
      maximumTemperature: json["main"]['temp_max'].toDouble(), 
      windSpeed: json["wind"]["speed"].toDouble(), 
      sunset: DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunset"] * 1000), 
      sunrise: DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunrise"] * 1000)
    );
  }    
}