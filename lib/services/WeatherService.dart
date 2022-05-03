// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future getCurrentWeather() async {
    Weather? weather;
    String city = "Wedel";
    String apiKey = "18873d940eaa6bb553086427aadea343";

    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    var response = await http.post(url);
    var jsonWeatherResponse = jsonDecode(response.body);

    List<Weather> weeklyWeatherList = await weeklyForecast(city);

    for (var i = 0; i < weeklyWeatherList.length; i++) {
        var item = weeklyWeatherList[i];
        debugPrint(item.temperature.toString());
    }
    
    if (response.statusCode == 200) {

      var weatherStatus = jsonWeatherResponse["weather"][0]["main"];
      var weatherDescription = jsonWeatherResponse["weather"][0]["description"];
      var weatherIcon = jsonWeatherResponse["weather"][0]["icon"];
      var humidity = jsonWeatherResponse["main"]["humidity"];
      var temperature = jsonWeatherResponse["main"]["temp"];
      var minimumTemperature = jsonWeatherResponse["main"]["temp_min"];
      var maximumTemperature = jsonWeatherResponse["main"]["temp_max"];
      var windSpeed = jsonWeatherResponse["wind"]["speed"];
      var sunset = jsonWeatherResponse["sys"]["sunset"];
      var sunrise = jsonWeatherResponse["sys"]["sunrise"];
      var date = jsonWeatherResponse["dt"];


      weather = Weather.fromJson(city, weatherStatus, weatherDescription, weatherIcon, humidity, temperature, minimumTemperature, maximumTemperature,
                windSpeed, sunset, sunrise, date);
    } else {
      debugPrint("BRUH");
    }
    return weather;
  } 

  static Future weeklyForecast(String city) async {
    String apiKey = "18873d940eaa6bb553086427aadea343";

    var urlDailyForecast = Uri.parse("https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=hourly&appid=$apiKey&units=metric");
    var responseDailyForecast = await http.get(urlDailyForecast);
    var jsonWeatherResponse = jsonDecode(responseDailyForecast.body);

    List<dynamic> hourlyForecast = jsonWeatherResponse["daily"];
    List<Weather> weeklyWeatherForecastList = [];
    
    for (var i = 0; i < hourlyForecast.length; i++) {
      var item = hourlyForecast[i];

      var weatherStatus = item["weather"][0]["main"];
      var weatherDescription = item["weather"][0]["description"];
      var weatherIcon = item["weather"][0]["icon"];
      var humidity = item["humidity"];
      var temperature = item["temp"]["max"];
      var minimumTemperature = item["temp"]["min"];
      var maximumTemperature = item["temp"]["max"];
      var windSpeed = item["wind_speed"];
      var sunset = item["sunset"];
      var sunrise = item["sunrise"];
      var date = item["dt"];

      Weather weatherItem = Weather.fromJson(city, weatherStatus, weatherDescription, weatherIcon, humidity, temperature, minimumTemperature, 
      maximumTemperature, windSpeed, sunset, sunrise, date);

      if (!weeklyWeatherForecastList.contains(weatherItem)) {
        weeklyWeatherForecastList.add(weatherItem); 
        debugPrint("Added item!");
        debugPrint("---------------");
      }
    }
    return weeklyWeatherForecastList;
  }
}