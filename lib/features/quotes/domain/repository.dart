import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/quote.dart'; // Import Quote model

class QuoteAPI {
  final String apiKey = 'BW5NpttFBPdzodqm0Zd76w==HfW2bkmHg7VEgEMU';
  final Duration _delay = const Duration(milliseconds: 300);

  Future<List<Quote>> fetchMultipleQuotes({int count = 1}) async {
    List<Quote> quotes = [];
    for (int i = 0; i < count; i++) {
      await Future.delayed(_delay); // Prevent rate limiting
      try {
        final result = await fetchAndPrintQuotes();
        if (result.isNotEmpty) quotes.add(result[0]);
      } catch (_) {
        // Silent error handling as per your requirements
      }
    }
    return quotes;
  }

  // Method to fetch a list of random quotes
  Future<List<Quote>> fetchAndPrintQuotes() async {
    const apiUrl = 'https://api.api-ninjas.com/v1/quotes';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        List<Quote> quotes =
            data.map((quoteData) => Quote.fromJson(quoteData)).toList();
        return quotes;
      }
      return [];
    } else {
      // Removed the print statement here
      return [];
    }
  }

  // NEW: Method to search quotes by category (e.g., 'happiness', 'success', etc.)
  Future<List<Quote>> searchQuote(String query) async {
    final apiUrl = 'https://api.api-ninjas.com/v1/quotes?category=$query';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Quote.fromJson(item)).toList();
    } else {
      // Removed the print statement here
      return [];
    }
  }
}
