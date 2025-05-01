import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/models/quote.dart';
import '../../../../shared/theme/theme.dart'; // Import theme file for text styles

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final List<Color> gradientColors;
  final bool isSaved;
  final VoidCallback onSaveToggle;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.gradientColors,
    required this.isSaved,
    required this.onSaveToggle,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _isLiked = false; // like button state

  //like button handler
  void _handleLike(){
    HapticFeedback.lightImpact(); // Add haptic feedback
    setState(()
      => _isLiked = !_isLiked);
  }

  //copy button handler
  Future<void> _handleCopy() async {
    HapticFeedback.lightImpact(); // Add haptic feedback
    final formattedText =
        '${widget.quote.text}\n\n- ${widget.quote.author}';

    await FlutterClipboard.copy(formattedText);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote copied to clipboard')), );
  }

  //Share button handler
  Future<void> _handleShare() async{
    HapticFeedback.lightImpact(); // Add haptic feedback
    final formattedText = '${widget.quote.text}\n\n- ${widget.quote.author}';

    // ignore: deprecated_member_use
    await Share.share(
      formattedText,
      subject: "Inspirational Quote"
    );
  }

  // Save button handler wrapper
  void _handleSaveToggle() {
     HapticFeedback.lightImpact(); // Add haptic feedback
     widget.onSaveToggle(); // Call original callback
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and theme
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Responsive sizing calculations (for padding, margins, icons etc., NOT for quote font size)
    final paddingValue = screenWidth * 0.03; // 3% padding
    final marginValue = screenWidth * 0.005; // 0.5% margin
    final borderRadius = screenWidth * 0.04; // 4% border radius
    final iconSize = screenWidth * 0.06; // 6% icon size
    final sizeboxValue = screenWidth * 0.02; // 2% sized box height

    return Card(
      margin: EdgeInsets.all(marginValue),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: iconSize,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            SizedBox(height: sizeboxValue),
            Text(
              widget.quote.text,
              // Use quote text style directly from theme.dart (which uses SettingsService)
              style: quoteTextStyle(context),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: sizeboxValue),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "- ${widget.quote.author}",
                // Use author text style directly from theme.dart (which uses SettingsService)
                style: authorTextStyle(context),
              ),
            ),
             SizedBox(height: sizeboxValue * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(context, Icons.share, _handleShare),
                _buildIconButton(context, widget.isSaved ? Icons.bookmark : Icons.bookmark_border, _handleSaveToggle),
                _buildIconButton(context, _isLiked ? Icons.favorite : Icons.favorite_border, _handleLike),
                _buildIconButton(context, Icons.copy, _handleCopy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    final iconSize = MediaQuery.of(context).size.width * 0.04;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(iconSize * 2),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(iconSize * 0.5),
          child: Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.87), size: iconSize),
        ),
      ),
    );
  }
}

