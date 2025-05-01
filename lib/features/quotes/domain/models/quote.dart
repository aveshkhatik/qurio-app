import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String? id; // For Firestore
  final String text;
  final String author;

  Quote({this.id, required this.text, required this.author});

  // 1. For API JSON parsing
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: null, // API quotes don't have IDs initially
      text: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  // 2. For Firestore documents
  factory Quote.fromFirestore(DocumentSnapshot doc) {
    return Quote(
      id: doc.id,
      text: doc['text'] as String,
      author: doc['author'] as String,
    );
  }
}
