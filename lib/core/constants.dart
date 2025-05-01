import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Colors
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryColor = Colors.deepPurple;
const Color kTextColor = Colors.black87;
const Color kCardColor = Colors.white;

//Padding
const double kDefaultPadding = 16.0;

// TextStyles using Google Fonts
TextStyle kQuoteTextStyle() {
  return GoogleFonts.playfairDisplay(
    textStyle: const TextStyle(
      // fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: kTextColor,
      height: 1.2,
    ),
  );
}

TextStyle kAuthorTextStyle() {
  return GoogleFonts.robotoMono(
    textStyle: const TextStyle(
      // fontSize: 9,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: Colors.white70,
    ),
  );
}