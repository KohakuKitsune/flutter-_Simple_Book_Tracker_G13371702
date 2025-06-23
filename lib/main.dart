import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/home_screen.dart';
import 'screens/add_book_screen.dart';

void main() => runApp(BookTrackerApp());

//
class BookTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[900],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/add': (context) => AddBookScreen(),
      },
    );
  }
}

//書本Class
class Book {
  String title;
  String author;
  bool isRead;
  String? imageUrl;

  Book({
    required this.title,
    required this.author,
    this.isRead = false,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'isRead': isRead,
    'imageUrl': imageUrl,
  };

  static Book fromJson(Map<String, dynamic> json) => Book(
    title: json['title'],
    author: json['author'],
    isRead: json['isRead'],
    imageUrl: json['imageUrl'],
  );
}


//reading list by Yoyon Pujiyono from <a href="https://thenounproject.com/browse/icons/term/reading-list/" target="_blank" title="reading list Icons">Noun Project</a> (CC BY 3.0)