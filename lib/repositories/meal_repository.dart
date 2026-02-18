import 'package:flutter/foundation.dart';
import '../models/food_analysis_result.dart';

/// Repository for storing and retrieving meal logs.
/// Uses a ValueNotifier to propagate updates to the UI (Dashboard).
class MealRepository {
  // Singleton pattern
  static final MealRepository instance = MealRepository._internal();
  MealRepository._internal();

  /// Reactive list of logged meals.
  final ValueNotifier<List<LoggedMeal>> meals = ValueNotifier([]);

  /// Add a meal to the log.
  void addMeal(FoodAnalysisResult result, {String? imagePath}) {
    final newMeal = LoggedMeal(
      result: result,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
    // ValueNotifier only notifies if the reference changes or we manually notify.
    // List.add doesn't change reference, so we create a new list.
    meals.value = [newMeal, ...meals.value];
  }

  /// Get total calories for today.
  int get todayCalories {
    final now = DateTime.now();
    return meals.value
        .where((m) => isSameDay(m.timestamp, now))
        .fold(0, (sum, m) => sum + m.result.totalCalories);
  }

  /// Get total macros for today.
  Map<String, double> get todayMacros {
    final now = DateTime.now();
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (final meal in meals.value.where((m) => isSameDay(m.timestamp, now))) {
      for (final macro in meal.result.macros) {
        if (macro.name == 'Protein') protein += macro.amount;
        if (macro.name == 'Carbs') carbs += macro.amount;
        if (macro.name == 'Fat' || macro.name == 'Fats') fat += macro.amount;
      }
    }

    return {'Protein': protein, 'Carbs': carbs, 'Fat': fat};
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Wrapper class for a logged meal.
class LoggedMeal {
  final FoodAnalysisResult result;
  final DateTime timestamp;

  final String? imagePath;

  LoggedMeal({required this.result, required this.timestamp, this.imagePath});
}
