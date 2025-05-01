import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class QuoteCardSkeleton extends StatelessWidget {
  final bool isCompact;

  const QuoteCardSkeleton({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on theme
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
    final containerColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final cardBackgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0, // Remove shadow for loading state
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardBackgroundColor, // Use theme-dependent background color
      child: Container(
        // decoration: BoxDecoration(
        //   // color: Colors.grey[200], // Removed hardcoded color
        //   borderRadius: BorderRadius.circular(16),
        // ),
        padding: const EdgeInsets.all(12),
        child: Shimmer.fromColors(
          baseColor: baseColor, // Use theme-dependent base color
          highlightColor: highlightColor, // Use theme-dependent highlight color
          period: const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Quote Icon
              Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: containerColor, // Use theme-dependent container color
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Variable Length Quote Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  isCompact ? 2 : 3, // 2-3 lines
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: containerColor, // Use theme-dependent container color
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: index == 0
                          ? double.infinity
                          : (index % 2 == 0 ? 200 : 150), // Varied widths
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Author
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: containerColor, // Use theme-dependent container color
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (_) =>
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: containerColor, // Use theme-dependent container color
                        shape: BoxShape.circle,
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  final int columnCount;
  final int itemCount;

  const SkeletonGrid({
    super.key,
    this.columnCount = 2,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final estimatedCards = (screenHeight / 220 * columnCount).ceil();

    return MasonryGridView.count(
      crossAxisCount: columnCount,
      itemCount: itemCount > 0 ? itemCount : estimatedCards,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (_, index) => const QuoteCardSkeleton(),
    );
  }
}
