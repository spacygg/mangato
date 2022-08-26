import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nelo/screens/home_page.dart';
import 'package:nelo/services/online_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => OnlineManager.build();
}
