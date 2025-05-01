import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import '../features/quotes/domain/repository.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showLogo;
  final Widget? titleWidget; // Added optional title widget
  final String? titleText; // Added optional title text

  const CustomAppBar({
    super.key,
    this.showLogo = true,
    this.titleWidget,
    this.titleText,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10); // Keep slightly taller

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final quoteAPI = QuoteAPI();
  bool _isSearchTapped = false;
  final TextEditingController _controller = TextEditingController();
  // ignore: unused_field
  String? _searchedQuoteText;
  // ignore: unused_field
  String? _searchedAuthor;

  Future<void> _searchQuote() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    // Keep search logic, but ensure UI updates correctly
    try {
      final quotes = await quoteAPI.searchQuote(query);
      if (!mounted) return;

      if (quotes.isNotEmpty) {
        // Handle successful search - maybe navigate or show results?
        // For now, just close search
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Category search might require premium access or check spelling."),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
       if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Search failed: ${e.toString()}"),
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }

    // Close search field after attempt
    if (mounted) {
       _controller.clear();
       setState(() => _isSearchTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget titleContent;
    if (_isSearchTapped) {
      titleContent = _buildSearchField(context);
    } else if (widget.titleWidget != null) {
      titleContent = widget.titleWidget!;
    } else if (widget.showLogo) {
      titleContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/logo.svg', // Path to your SVG logo
            height: 30, // Adjust height as needed
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn), // Use primary color
          ),
          const SizedBox(width: 8),
          Text(
            "Qurio", // App name or tagline
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary, // Use primary color
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else {
      titleContent = Text(
        widget.titleText ?? "Qurio", // Use provided title text or default
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return AppBar(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.9), // Use theme surface color with slight transparency
      elevation: 3, // Keep subtle shadow
      leading: IconButton(
        icon: Icon(Icons.menu, color: colorScheme.onSurface), // Use theme color
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: titleContent,
      centerTitle: true, // Center the title/logo
      actions: [
        if (!_isSearchTapped)
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurface), // Use theme color
            onPressed: () => setState(() => _isSearchTapped = true),
          ),
        // Keep search icon visibility logic
        if (_isSearchTapped)
          SizedBox(width: 48) // Placeholder to balance the leading icon when search is active
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7), // Use theme color
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _searchQuote(),
        style: TextStyle(color: colorScheme.onSurfaceVariant), // Text color
        decoration: InputDecoration(
          hintText: 'Search quotes...', // Placeholder text
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)), // Hint text color
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant), // Icon color
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant), // Icon color
            onPressed: () {
              _controller.clear();
              setState(() => _isSearchTapped = false);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15), // Adjust padding
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

