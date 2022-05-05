// ignore_for_file: prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter, avoid_print, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, prefer_const_declarations, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_simply_weather/models/Weather.dart';
import 'package:http/http.dart' as http;

import '../services/WeatherService.dart';

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
            if (snapshot.data != null) {
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
          future: WeatherService.getCurrentWeather(),
        ),
      ),
    );
  }

  Widget weatherBox(Weather weather) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 16, 27),
      body: Stack(
        children: [

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    String city = snapshot.data.toString();
                    return createText(context, city, Colors.white, FontWeight.bold, 0.04);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
                future: WeatherService.getCurrentCity(),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
              child: createText(context, currentDate(weather.date), Color.fromARGB(255, 169, 169, 169), FontWeight.normal, 0.025)
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
              child: createText(context, weather.weatherDescription, Color.fromARGB(255, 169, 169, 169), FontWeight.normal, 0.025)
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.21),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.85,  
                child: Image.network(getCurrentWeatherIcon(weather.weatherDescription)),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCurrentWeatherInformation(context, weather.windSpeed.round().toString() + "km/h", "Wind", "https://i.ibb.co/L6ZB9yS/6.png"),
                  buildCurrentWeatherInformation(context, weather.humidity.toString() + "%", "Humidity", "https://i.ibb.co/Hh0zHk0/4.png"),
                  buildCurrentWeatherInformation(context, weather.temperature.round().toString() + "°C", "Temp", getCurrentWeatherIcon(weather.weatherDescription))
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.47,
                left: MediaQuery.of(context).size.width * 0.05 
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createText(context, "Weekly", Color.fromARGB(255, 255, 255, 255), FontWeight.w200, 0.026),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05 
                    ),
                    child: createText(context, "View full forecast", Color.fromARGB(255, 4, 125, 255), FontWeight.w200, 0.020),
                  )
                ],
              ),
            )
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.77),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          List<Weather> weeklyForecastList = snapshot.data as List<Weather>;

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: weeklyForecastList.length,
                            itemBuilder: (context, index) {
                              Weather weather = weeklyForecastList[index];
                              return buildHourlyForecast(context, weather.date, weather.maximumTemperature.round().toString(), weather.minimumTemperature.round().toString(), weather.weatherDescription);
                            }
                          );

                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                      future: WeatherService.weeklyForecast(),
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  Widget createText(BuildContext context, String text, Color color, FontWeight fontWeight, double fontSize) {
    return Text(
      text, 
      style: 
      TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: MediaQuery.of(context).size.height * fontSize
      ),
    );
  }

  Widget buildCurrentWeatherInformation(BuildContext context, String title, String value, String imageLink) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Image.network(imageLink),
          ),
          createText(context, value, Color.fromARGB(255, 212, 209, 209), FontWeight.bold, 0.02) ,
          createText(context, title, Color.fromARGB(255, 200, 196, 196), FontWeight.w200, 0.02) 
        ],
      ),
    );
  }

  Widget buildHourlyForecast(BuildContext context, DateTime date, String maxTemp, String minTemp, String weatherDescription) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.05,
        left: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.height * 0.03
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.02)),
          color: Color.fromARGB(255, 3, 22, 36),
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.5,

        child: Stack(
          children: [
            Positioned(
                left: MediaQuery.of(context).size.width * 0.07,
                top: MediaQuery.of(context).size.height * 0.02,
                child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.027,
                        child: createText(context, getWeekDay(date), Color.fromARGB(255, 255, 255, 255), FontWeight.normal, 0.023),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.027,
                      child: createText(context, getMonth(date), Color.fromARGB(255, 221, 211, 211), FontWeight.normal, 0.02),
                    ),
                  ],
                ),
              )
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.65,
                top: MediaQuery.of(context).size.height * 0.015,
                child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Image.network(getCurrentWeatherIcon(weatherDescription)),
              )
            ),

            Positioned(
                left: MediaQuery.of(context).size.width * 0.4,
                top: MediaQuery.of(context).size.height * 0.02,
                child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.027,
                        child: createText(context, maxTemp + "°C", Color.fromARGB(255, 255, 255, 255), FontWeight.normal, 0.023),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.027,
                      child: createText(context, minTemp + "°C", Color.fromARGB(255, 255, 255, 255), FontWeight.normal, 0.023),
                    ),
                  ],
                ),
              )
            ),
          ]
        ),
      ),
    );
  }

  static dynamic dayData =
        '{ "1" : "Monday", "2" : "Tuesday", "3" : "Wednesday", "4" : "Thursday", "5" : "Friday", "6" : "Saturday", "7" : "Sunday" }';

  dynamic monthData =
        '{ "1" : "January", "2" : "February", "3" : "March", "4" : "April", "5" : "May", "6" : "June", "7" : "Juli", "8" : "August", "9" : "September", "10" : "October", "11" : "November", "12" : "December" }';      

  String getWeekDay(DateTime date) {
    return json.decode(dayData)['${date.weekday}'];
  }

  String getMonth(DateTime date) {
    return json.decode(monthData)['${date.month}'] + ", " + '${date.day}';
  }

  String currentDate(DateTime date) {
    return json.decode(dayData)['${date.weekday}'] +
        ", " +
        date.day.toString() +
        ". " +
        json.decode(monthData)['${date.month}'];
  }

  String getCurrentWeatherIcon(String description) {
    String icon = "";
    switch(description) { 

      //Check for cloud description
      case "few clouds": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "scattered clouds": { 
        icon = "https://i.ibb.co/4sKrY09/35.png";
      } 
      break; 
      case "broken clouds": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "overcast clouds": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "clear sky": { 
        icon = "https://i.ibb.co/527cW8x/26.png";
      } 
      break;

      //Check for rain description
      case "light rain": { 
        icon = "https://i.ibb.co/wJJ1YPf/8.png";
      } 
      break; 
      case "moderate rain": { 
        icon = "https://i.ibb.co/4sKrY09/35.png";
      } 
      break; 
      case "heavy intensity rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "very heavy rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break;
      case "extreme rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "freezing rain": { 
        icon = "https://i.ibb.co/4sKrY09/35.png";
      } 
      break; 
      case "light intensity shower rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "shower rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break;
      case "heavy intensity shower rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break; 
      case "ragged shower rain": { 
        icon = "https://i.ibb.co/NN4MVVk/27.png";
      } 
      break;
          
      default: { 
          //statements;  
      }
      break; 
    }
    return icon; 
  }
}