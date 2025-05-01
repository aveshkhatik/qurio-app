import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/quote_card.dart';
import '../../domain/models/quote.dart';
import '../../domain/firebase_quote_service.dart';
import '../../../../shared/theme/app_colors.dart';

class SavedQuotesScreen extends StatelessWidget {
  const SavedQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Quotes'),
        backgroundColor: Color(0xFF006B5B),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseQuoteService().getSavedQuotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No quotes saved yet!'));
          }

          final quotes = snapshot.data!.docs
              .map((doc) => Quote.fromFirestore(doc))
              .where((quote) => quote.id != null)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Dismissible(
                key: Key(quote.id!),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Quote'),
                      content: const Text('Are you sure?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  FirebaseQuoteService().deleteQuote(quote.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quote deleted')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: QuoteCard(
                    quote: quote,
                    gradientColors: _getRandomGradient(index),
                    isSaved: true,
                    onSaveToggle: () {
                      FirebaseQuoteService().toggleSaveQuote(quote, true);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Color> _getRandomGradient(int index) {
    final colors = AppColors.gradientColors;
    return colors[index % colors.length];
  }
}