import 'package:flutter/material.dart';
import '../../models/food_analysis_result.dart';
import '../../utils/color_helpers.dart';

class FoodAnalysisCard extends StatelessWidget {
  final FoodAnalysisResult result;
  final VoidCallback? onSave;
  final VoidCallback? onRetake;
  final VoidCallback? onDetails;

  const FoodAnalysisCard({
    super.key,
    required this.result,
    this.onSave,
    this.onRetake,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        color: const Color(0xFF8B9D42),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          result.foodName,
                          style: const TextStyle(
                            fontSize: 20, // Slightly larger
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B9D42).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(result.confidence * 100).toInt()}% Confidence',
                    style: const TextStyle(
                      color: Color(0xFF5D6B2C),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nutrient circles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NutrientCircle(
                  label: 'KCAL',
                  value: '${result.totalCalories}',
                  color: Colors.transparent,
                  isMain: true,
                ),
                ...result.macros.map(
                  (m) => _NutrientCircle(
                    label: m.name,
                    value: m.formatted,
                    color: macroColor(m.name),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Component Breakdown (Minimalist List)
            if (result.detectedComponents.isNotEmpty) ...[
              const Text(
                'Breakdown',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ...result.detectedComponents.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        c.label,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      Text(
                        '${c.calories} kcal',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B9D42),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Suggestions Section (Beautified)
            if (result.suggestions.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      size: 18,
                      color: const Color(0xFFFFA000),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'QUICK INSIGHTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              ...result.suggestions
                  .take(3)
                  .map(
                    (s) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF8B9D42,
                            ).withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: const Color(0xFF8B9D42),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF424242),
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
            ],

            // Health rating badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: healthRatingBgColor(result.healthRating),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.healthRating,
                    style: TextStyle(
                      color: healthRatingColor(result.healthRating),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                if (onSave != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Store Data',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (onSave != null) const SizedBox(width: 10),
                if (onDetails != null) ...[
                  GestureDetector(
                    onTap: onDetails,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isMain;

  const _NutrientCircle({
    required this.label,
    required this.value,
    required this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isMain ? 64 : 54,
          height: isMain ? 64 : 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isMain
                  ? const Color(0xFF8B9D42)
                  : color.withValues(alpha: 0.5),
              width: 3,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              value.replaceAll(RegExp(r'[a-zA-Z]'), ''), // Just the number
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMain ? 18 : 14,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
