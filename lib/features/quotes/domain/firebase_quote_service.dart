import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:qurio/features/quotes/domain/models/quote.dart';
class FirebaseQuoteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSavedQuotesStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_quotes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteQuote(String docId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_quotes')
        .doc(docId)
        .delete();
  }

  Future<void> toggleSaveQuote(Quote quote, bool isCurrentlySaved) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final savedQuotesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_quotes');

      final query = await savedQuotesRef
          .where('text', isEqualTo: quote.text)
          .where('author', isEqualTo: quote.author)
          .limit(1)
          .get();

      if (isCurrentlySaved) {
        if (query.docs.isNotEmpty) {
          await savedQuotesRef.doc(query.docs.first.id).delete();
        }
      } else {
        if (query.docs.isEmpty) {
          await savedQuotesRef.add({
            'text': quote.text,
            'author': quote.author,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      debugPrint('ToggleSaveQuote error: $e');
      rethrow;
    }
  }

  Future<bool> isQuoteSaved(Quote quote) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final query = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_quotes')
        .where('text', isEqualTo: quote.text)
        .where('author', isEqualTo: quote.author)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }
}