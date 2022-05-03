// ignore_for_file: unused_local_variable, unnecessary_new

import 'dart:convert';

class Weather {
  final String city;
  final String weatherStatus;
  final String weatherDescription;
  final String weatherIcon;
  final double humidity;
  final double temperature;
  final double minimumTemperature;
  final double maximumTemperature;
  final double windSpeed;
  final DateTime sunset;
  final DateTime sunrise;
  final DateTime date;

  Weather(
      {required this.city,
      required this.weatherStatus,
      required this.weatherDescription,
      required this.weatherIcon,
      required this.humidity,
      required this.temperature,
      required this.minimumTemperature,
      required this.maximumTemperature,
      required this.windSpeed,
      required this.sunset,
      required this.sunrise,
      required this.date});

  factory Weather.fromJson(String city, String weatherStatus, String weatherDescription, 
          String weatherIcon, int humidity, double temperature, double minimumTemperature, double maximumTemperature, 
          double windSpeed, int sunset, int sunrise, int date) {    

    return Weather(
      city: city, 
      weatherStatus: weatherStatus.toString(), 
      weatherDescription: weatherDescription.toString(), 
      weatherIcon: weatherIcon.toString(),
      humidity: humidity.toDouble(),
      temperature: temperature.toDouble(), 
      minimumTemperature: minimumTemperature.toDouble(), 
      maximumTemperature: maximumTemperature.toDouble(), 
      windSpeed: windSpeed.toDouble(), 
      sunset: DateTime.fromMillisecondsSinceEpoch(sunset * 1000), 
      sunrise: DateTime.fromMillisecondsSinceEpoch(sunrise * 1000),
      date: DateTime.fromMillisecondsSinceEpoch(date * 1000)
    );
  }      
}