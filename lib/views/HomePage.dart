// ignore_for_file: prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("My Weather App!"),
        )
      ),
    );
  }
}