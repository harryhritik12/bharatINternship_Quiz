import 'package:flutter/material.dart';
import '../src/screens/screen.dart';

class App extends StatelessWidget{
  Widget build(context){
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(
        primarySwatch:Colors.blue,
      ),
      home:QuizScreen(),
    );
    
  }

}