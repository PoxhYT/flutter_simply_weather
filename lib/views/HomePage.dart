// ignore_for_file: prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter, avoid_print, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, prefer_const_declarations, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
import 'dart:html';

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
              child: createText(context, weather.city, Colors.white, FontWeight.bold, 0.04),
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.21),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.85,  
                child: Image.network("https://i.ibb.co/89x8YH1/27.png"),
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
                  buildCurrentWeatherInformation(context, weather.temperature.round().toString() + "°C", "Temp", "https://i.ibb.co/D1rXr3W/8.png")
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
                  createText(context, "Today", Color.fromARGB(255, 255, 255, 255), FontWeight.w200, 0.026),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05 
                    ),
                    child: createText(context, "View weekly forecast", Color.fromARGB(255, 4, 125, 255), FontWeight.w200, 0.020),
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
                        if (snapshot != null) {
                          List<Weather> weeklyForecastList = snapshot.data as List<Weather>;

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: weeklyForecastList.length,
                            itemBuilder: (context, index) {
                              Weather weather = weeklyForecastList[index];
                              return buildHourlyForecast(context, weather.date, weather.maximumTemperature.round().toString(), weather.minimumTemperature.round().toString());
                            }
                          );

                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                      future: WeatherService.weeklyForecast("wedel"),
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

  Widget buildHourlyForecast(BuildContext context, DateTime date, String maxTemp, String minTemp) {
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
                child: Image.network("https://i.ibb.co/D1rXr3W/8.png"),
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
}