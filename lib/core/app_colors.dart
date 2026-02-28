import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5A55CA); 
  static const Color primaryDark = Color(0xFF4A45A0);
  
  static const Color background = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  static const Color textMain = Color(0xFF1E1E1E);
  static const Color textMainDark = Colors.white;

  static const Color textSub = Color(0xFF9E9E9E);
  static const Color textSubDark = Color(0xFFB0B0B0);

  static const Color error = Colors.redAccent;

  // Task color palette — shared across Add Task and Task Tile
  static const List<Color> taskColors = [
    Color(0xFF5A55CA), // Blue (primary)
    Color(0xFFFF7043), // Orange
    Color(0xFFE91E63), // Pink / Red
    Color(0xFF26A69A), // Teal
    Color(0xFF7E57C2), // Purple
  ];
}
