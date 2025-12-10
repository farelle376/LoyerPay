import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Nos couleurs principales (Cahier des charges)
  static const Color darkBlue = Color(
    0xFF0A2342,
  ); // Bleu Marine Profond (Confiance)
  static const Color brickOrange = Color(0xFFD85A31); // Orange Brique (Action)
  static const Color lightBackground = Color(
    0xFFF4F6F8,
  ); // Gris très clair pour le fond
  static const Color successGreen = Color(0xFF2E7D32); // Vert pour "Payé"
  static const Color errorRed = Color(0xFFC62828); // Rouge pour "Retard"

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: darkBlue,

      // Configuration globale des textes (Police Poppins)
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: darkBlue,
        displayColor: darkBlue,
      ),

      // Style global des boutons (pour éviter de le refaire à chaque fois)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brickOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Style des champs de texte (Input)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkBlue),
        titleTextStyle: TextStyle(
          color: darkBlue,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
