// ignore_for_file: prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter, avoid_print, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, prefer_const_declarations, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

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
              child: createText(context, weather.sunrise.toString(), Color.fromARGB(255, 169, 169, 169), FontWeight.normal, 0.025)
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.21),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.85,  
                child: Image.network("https://i.ibb.co/L6ZB9yS/6.png"),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCurrentWeatherInformation(context, "Temp", weather.temperature.round().toString() + "°"),
                  buildCurrentWeatherInformation(context, "Wind", weather.windSpeed.round().toString() + "km/h"),
                  buildCurrentWeatherInformation(context, "Humadity", "75%")
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return buildHourlyForecast(context);
                      }
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

  Widget buildCurrentWeatherInformation(BuildContext context, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.008)),
        color: Color.fromARGB(255, 3, 22, 36),
      ),
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.016
            ),
            child: createText(context, title, Color.fromARGB(255, 200, 196, 196), FontWeight.w200, 0.023),
          ),
          createText(context, value, Color.fromARGB(255, 255, 255, 255), FontWeight.w200, 0.026)  
        ],
      ),
    );
  }

  Widget buildHourlyForecast(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.05,
        left: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.height * 0.12
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.008)),
          color: Color.fromARGB(255, 3, 22, 36),
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.5,

        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.002,
                  left: MediaQuery.of(context).size.width * 0.008
                ),
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Image.network("https://i.ibb.co/L6ZB9yS/6.png"),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.026),
              child: Column(
                children: [
                  createText(context, "14:00", Color.fromARGB(255, 169, 169, 169), FontWeight.normal, 0.025),
                  createText(context, "21°C", Color.fromARGB(255, 169, 169, 169), FontWeight.normal, 0.025)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getCurrentWeather() async {
    Weather? weather;
    String city = "Wedel";
    String apiKey = "18873d940eaa6bb553086427aadea343";

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