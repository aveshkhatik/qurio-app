import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:qurio/features/quotes/presentation/widgets/quote_card_skeleton.dart';
import 'package:qurio/shared/services/settings_service.dart'; // Import SettingsService
import '../../domain/repository.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/drawer.dart';
import '../widgets/quote_card.dart';
import '../../domain/models/quote.dart';
import '../../domain/firebase_quote_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qurio/shared/widgets/animated_background.dart';
// Removed direct theme import, rely on Theme.of(context)
// import 'package:qurio/shared/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteAPI quoteAPI = QuoteAPI();
  final FirebaseQuoteService firebaseService = FirebaseQuoteService();
  final random = Random();
  List<Quote> currentQuotes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final Set<String> _savedQuoteKeys = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialQuotes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshQuotes() async {
    setState(() {
      _isLoading = true;
      _hasMore = true;
      currentQuotes.clear();
      _savedQuoteKeys.clear();
    });
    try {
      final quotes = await quoteAPI.fetchMultipleQuotes(count: 8);
      if (!mounted) return;
      setState(() => currentQuotes = quotes);
      await _checkSavedStatus(quotes);
    } catch (e) {
      if (!mounted) return;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchInitialQuotes() async {
    await _refreshQuotes();
  }

  Future<void> _fetchMoreQuotes() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    try {
      final newQuotes = await quoteAPI.fetchMultipleQuotes(count: 4);
      if (!mounted) return;
      setState(() {
        if (newQuotes.isEmpty) {
          _hasMore = false;
        } else {
          currentQuotes.addAll(newQuotes);
        }
      });
      await _checkSavedStatus(newQuotes);
    } catch (e) {
      if (!mounted) return;
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onScroll() {
    // Use context safely if needed, though not required here
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _fetchMoreQuotes();
    }
  }

  Future<void> _checkSavedStatus(List<Quote> quotes) async {
    final savedStatus = await Future.wait(
      quotes.map((quote) => firebaseService.isQuoteSaved(quote)),
    );

    if (!mounted) return;

    setState(() {
      for (int i = 0; i < quotes.length; i++) {
        final key = _getQuoteKey(quotes[i]);
        if (savedStatus[i]) {
          _savedQuoteKeys.add(key);
        } else {
          _savedQuoteKeys.remove(key);
        }
      }
    });
  }

  String _getQuoteKey(Quote quote) => '${quote.text}-${quote.author}';

  Future<void> _handleSaveTap(Quote quote) async {
    final key = _getQuoteKey(quote);
    final isCurrentlySaved = _savedQuoteKeys.contains(key);

    setState(() {
      if (isCurrentlySaved) {
        _savedQuoteKeys.remove(key);
      } else {
        _savedQuoteKeys.add(key);
      }
    });

    try {
      await firebaseService.toggleSaveQuote(quote, isCurrentlySaved);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (isCurrentlySaved) {
          _savedQuoteKeys.add(key);
        } else {
          _savedQuoteKeys.remove(key);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update save status: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // Updated function to use theme colors from context
  List<Color> getRandomGradient(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use colors available in ColorScheme
    final List<List<Color>> gradients = [
      [colorScheme.primary.withValues(alpha: 0.7), colorScheme.secondary.withValues(alpha: 0.7)],
      [colorScheme.secondary.withValues(alpha: 0.7), colorScheme.primary.withValues(alpha: 0.5)], // Replaced accent with secondary
      [colorScheme.secondary.withValues(alpha: 0.6), colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)], // Replaced accent with surfaceVariant
      [colorScheme.primary.withValues(alpha: 0.6), colorScheme.tertiaryContainer.withValues(alpha: 0.6)], // Example using other scheme colors if defined
    ];
    // Ensure the list isn't empty before getting random index
    if (gradients.isEmpty) {
        return [colorScheme.primary, colorScheme.secondary]; // Fallback gradient
    }
    return gradients[random.nextInt(gradients.length)];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.03;
    // Access SettingsService here
    final settingsService = Provider.of<SettingsService>(context);
    final int crossAxisCount = settingsService.layoutColumns; // Get column count

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          const AnimatedBackground(
            duration: Duration(seconds: 40),
          ),
          RefreshIndicator(
            onRefresh: _refreshQuotes,
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading && currentQuotes.isEmpty
                  ? SkeletonGrid(itemCount: 8, crossAxisCount: crossAxisCount,) // Pass crossAxisCount
                  : MasonryGridView.count(
                      controller: _scrollController,
                      crossAxisCount: crossAxisCount, // Use column count from settings
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: currentQuotes.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= currentQuotes.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(paddingValue),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final quote = currentQuotes[index];
                        return QuoteCard(
                          quote: quote,
                          // Pass context to getRandomGradient
                          gradientColors: getRandomGradient(context),
                          isSaved: _savedQuoteKeys.contains(_getQuoteKey(quote)),
                          onSaveToggle: () => _handleSaveTap(quote),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated SkeletonGrid to accept crossAxisCount
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const SkeletonGrid({super.key, required this.itemCount, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount, // Use passed value
      itemCount: itemCount,
      itemBuilder: (context, index) => QuoteCardSkeleton(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
    );
  }
}

