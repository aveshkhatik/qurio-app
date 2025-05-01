import '../../../quotes/domain/repository.dart';
import '../../../quotes/domain/models/quote.dart';

class Randomizer {
  final QuoteAPI _quoteAPI = QuoteAPI();

  // Fetch a list of random quotes sequentially
  Future<List<Quote>> getRandomQuoteList({int count = 8}) async {
    List<Quote> quotes = [];
    for (int i = 0; i < count; i++) {
      try {
        // Fetch a single quote
        final singleQuote = await _quoteAPI.fetchAndPrintQuotes();

        // If we get a valid quote, add it to the list
        if (singleQuote.isNotEmpty) {
          quotes.add(singleQuote[0]); // Only add the first quote from the result
        }
      } catch (e) {
        // Simply catch the error and continue without printing
        // Optionally handle errors here or log them silently
      }
    }
    return quotes;
  }
}
