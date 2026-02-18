import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Shared color helpers for health ratings and macronutrient colors.
/// Used by FoodAnalysisCard, FoodDetailsSheet, and other widgets.

Color healthRatingColor(String rating) {
  switch (rating) {
    case 'Healthy':
      return AppColors.healthy;
    case 'Balanced':
      return AppColors.balanced;
    case 'Unhealthy':
      return AppColors.unhealthy;
    default:
      return Colors.grey;
  }
}

Color healthRatingBgColor(String rating) {
  switch (rating) {
    case 'Healthy':
      return AppColors.healthyBg;
    case 'Balanced':
      return AppColors.balancedBg;
    case 'Unhealthy':
      return AppColors.unhealthyBg;
    default:
      return Colors.grey[200]!;
  }
}

Color macroColor(String name) {
  switch (name) {
    case 'Protein':
      return AppColors.secondary;
    case 'Carbs':
      return Colors.amber;
    case 'Fats':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

IconData healthIcon(String rating) {
  switch (rating) {
    case 'Healthy':
      return Icons.verified_user_rounded;
    case 'Balanced':
      return Icons.balance_rounded;
    case 'Unhealthy':
      return Icons.warning_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}
