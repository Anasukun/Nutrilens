import 'package:flutter/material.dart';
import 'dart:io';
import '../repositories/meal_repository.dart';

import 'widgets/food_details_sheet.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Meal History',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E1E1E)),
      ),
      body: ValueListenableBuilder<List<LoggedMeal>>(
        valueListenable: MealRepository.instance.meals,
        builder: (context, meals, child) {
          if (meals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No meals logged yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          // Group meals by date
          final groupedMeals = _groupMealsByDate(meals);

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: groupedMeals.length,
            itemBuilder: (context, index) {
              final date = groupedMeals.keys.elementAt(index);
              final dayMeals = groupedMeals[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4,
                      bottom: 12,
                      top: index == 0 ? 0 : 20,
                    ),
                    child: Text(
                      _formatDate(date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...dayMeals.map(
                    (meal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _showMealDetails(context, meal),
                        child: _MealHistoryItem(meal: meal),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showMealDetails(BuildContext context, LoggedMeal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodDetailsSheet(
        result: meal.result,
        imageFile: meal.imagePath != null ? File(meal.imagePath!) : null,
      ),
    );
  }

  Map<DateTime, List<LoggedMeal>> _groupMealsByDate(List<LoggedMeal> meals) {
    // Sort meals by date descending first
    final sortedMeals = List<LoggedMeal>.from(meals)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final Map<DateTime, List<LoggedMeal>> grouped = {};
    for (var meal in sortedMeals) {
      final date = DateTime(
        meal.timestamp.year,
        meal.timestamp.month,
        meal.timestamp.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(meal);
    }
    return grouped;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MealHistoryItem extends StatelessWidget {
  final LoggedMeal meal;

  const _MealHistoryItem({required this.meal});

  @override
  Widget build(BuildContext context) {
    final hours = meal.timestamp.hour.toString().padLeft(2, '0');
    final minutes = meal.timestamp.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: meal.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(meal.imagePath!), fit: BoxFit.cover),
                  )
                : const Icon(
                    Icons.restaurant,
                    color: Color(0xFF8B9D42),
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.result.foodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$hours:$minutes',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.result.totalCalories}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Text(
                'kcal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
