import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nelo/screens/home_page.dart';
import 'dart:convert';

import 'package:nelo/services/update_manager.dart';

class OnlineManager {
  static Uri _base_url = Uri.parse('https://tenz.surge.sh/zoro.json');

  static Widget build() {
    return FutureBuilder(
      future: UpdateManager.isUpdateAvailable(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return _loadingPage();
        bool updateAvailable = snapshot.data;
        return updateAvailable ? _downloadingUpdate() : _homePage();
      },
    );
  }

  static _homePage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manganelo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.raleway(),
          bodyMedium: GoogleFonts.raleway(),
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }

  static _loadingPage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      title: 'Manganelo',
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static _downloadingUpdate() {
    UpdateManager.downloadUpdate();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      title: 'Manganelo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please wait while we update the app :)',
                  style: GoogleFonts.raleway(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
