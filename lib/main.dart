
import 'package:curso_youtube/src/apis/apy_yt.dart';
import 'package:curso_youtube/src/views/screens/screen_home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => ApiYt(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        )),
  );
}
