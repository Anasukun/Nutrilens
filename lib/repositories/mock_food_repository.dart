import 'dart:math';
import 'package:image_picker/image_picker.dart';
import '../models/food_analysis_result.dart';
import 'food_repository.dart';

class MockFoodAnalysisRepository implements FoodAnalysisRepository {
  final _random = Random();

  @override
  Future<FoodAnalysisResult> analyzeImage(XFile image) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final presets = [
      _saladBowl(),
      _grilledChickenRice(),
      _smoothieBowl(),
      _burger(),
      _pastaPlate(),
    ];

    return presets[_random.nextInt(presets.length)];
  }

  FoodAnalysisResult _saladBowl() {
    return const FoodAnalysisResult(
      foodName: 'Caesar Salad Bowl',
      healthRating: 'Healthy',
      totalCalories: 320,
      confidence: 0.88,
      macros: [
        MacroNutrient(name: 'Protein', amount: 18, unit: 'g', percentage: 0.36),
        MacroNutrient(name: 'Carbs', amount: 24, unit: 'g', percentage: 0.30),
        MacroNutrient(name: 'Fats', amount: 12, unit: 'g', percentage: 0.18),
      ],
      micros: [
        MicroNutrient(name: 'Vitamin A', amount: '120%'),
        MicroNutrient(name: 'Vitamin C', amount: '80%'),
        MicroNutrient(name: 'Iron', amount: '15%'),
        MicroNutrient(name: 'Calcium', amount: '12%'),
        MicroNutrient(name: 'Fiber', amount: '8g'),
        MicroNutrient(name: 'Sugar', amount: '3g'),
      ],
      suggestions: [
        'Great choice! This salad is rich in vitamins A and C.',
        'Consider adding some nuts or seeds for healthy fats and extra protein.',
      ],
      detectedComponents: [
        DetectedComponent(
          label: 'Leafy Greens',
          category: 'Vegetable',
          calories: 40,
          relativeX: 0.3,
          relativeY: 0.4,
        ),
        DetectedComponent(
          label: 'Grilled Chicken',
          category: 'Protein',
          calories: 150,
          relativeX: 0.7,
          relativeY: 0.5,
        ),
        DetectedComponent(
          label: 'Creamy Dressing',
          category: 'Fat',
          calories: 80,
          relativeX: 0.4,
          relativeY: 0.65,
        ),
        DetectedComponent(
          label: 'Croutons',
          category: 'Carbs',
          calories: 50,
          relativeX: 0.6,
          relativeY: 0.3,
        ),
      ],
    );
  }

  FoodAnalysisResult _grilledChickenRice() {
    return const FoodAnalysisResult(
      foodName: 'Grilled Chicken with Rice',
      healthRating: 'Balanced',
      totalCalories: 520,
      confidence: 0.92,
      macros: [
        MacroNutrient(name: 'Protein', amount: 35, unit: 'g', percentage: 0.70),
        MacroNutrient(name: 'Carbs', amount: 55, unit: 'g', percentage: 0.45),
        MacroNutrient(name: 'Fats', amount: 14, unit: 'g', percentage: 0.22),
      ],
      micros: [
        MicroNutrient(name: 'Vitamin B6', amount: '45%'),
        MicroNutrient(name: 'Niacin', amount: '60%'),
        MicroNutrient(name: 'Iron', amount: '20%'),
        MicroNutrient(name: 'Zinc', amount: '25%'),
        MicroNutrient(name: 'Fiber', amount: '3g'),
        MicroNutrient(name: 'Sugar', amount: '1g'),
      ],
      suggestions: [
        'Good protein source! Consider adding vegetables for more micronutrients.',
        'Try brown rice for extra fiber and slower carb absorption.',
      ],
      detectedComponents: [
        DetectedComponent(
          label: 'Chicken Breast',
          category: 'Protein',
          calories: 220,
          relativeX: 0.4,
          relativeY: 0.4,
        ),
        DetectedComponent(
          label: 'White Rice',
          category: 'Carbs',
          calories: 300,
          relativeX: 0.65,
          relativeY: 0.5,
        ),
      ],
    );
  }

  FoodAnalysisResult _smoothieBowl() {
    return const FoodAnalysisResult(
      foodName: 'Berry Smoothie Bowl',
      healthRating: 'Healthy',
      totalCalories: 280,
      confidence: 0.85,
      macros: [
        MacroNutrient(name: 'Protein', amount: 8, unit: 'g', percentage: 0.16),
        MacroNutrient(name: 'Carbs', amount: 48, unit: 'g', percentage: 0.60),
        MacroNutrient(name: 'Fats', amount: 6, unit: 'g', percentage: 0.09),
      ],
      micros: [
        MicroNutrient(name: 'Vitamin C', amount: '150%'),
        MicroNutrient(name: 'Vitamin K', amount: '35%'),
        MicroNutrient(name: 'Manganese', amount: '40%'),
        MicroNutrient(name: 'Potassium', amount: '15%'),
        MicroNutrient(name: 'Fiber', amount: '7g'),
        MicroNutrient(name: 'Sugar', amount: '22g'),
      ],
      suggestions: [
        'High in antioxidants! Watch the sugar content from fruits.',
        'Add a scoop of protein powder for a more balanced meal.',
      ],
      detectedComponents: [
        DetectedComponent(
          label: 'Mixed Berries',
          category: 'Fruit',
          calories: 80,
          relativeX: 0.5,
          relativeY: 0.4,
        ),
        DetectedComponent(
          label: 'Granola',
          category: 'Carbs',
          calories: 120,
          relativeX: 0.3,
          relativeY: 0.6,
        ),
        DetectedComponent(
          label: 'Banana Slices',
          category: 'Fruit',
          calories: 80,
          relativeX: 0.7,
          relativeY: 0.35,
        ),
      ],
    );
  }

  FoodAnalysisResult _burger() {
    return const FoodAnalysisResult(
      foodName: 'Classic Beef Burger',
      healthRating: 'Unhealthy',
      totalCalories: 680,
      confidence: 0.91,
      macros: [
        MacroNutrient(name: 'Protein', amount: 28, unit: 'g', percentage: 0.56),
        MacroNutrient(name: 'Carbs', amount: 42, unit: 'g', percentage: 0.35),
        MacroNutrient(name: 'Fats', amount: 38, unit: 'g', percentage: 0.58),
      ],
      micros: [
        MicroNutrient(name: 'Vitamin B12', amount: '80%'),
        MicroNutrient(name: 'Iron', amount: '30%'),
        MicroNutrient(name: 'Sodium', amount: '45%'),
        MicroNutrient(name: 'Calcium', amount: '15%'),
        MicroNutrient(name: 'Fiber', amount: '2g'),
        MicroNutrient(name: 'Sugar', amount: '8g'),
      ],
      suggestions: [
        'High in saturated fats and sodium. Enjoy occasionally.',
        'Try a lettuce wrap instead of a bun to reduce carbs.',
        'Pair with a side salad instead of fries for better nutrition.',
      ],
      detectedComponents: [
        DetectedComponent(
          label: 'Beef Patty',
          category: 'Protein',
          calories: 250,
          relativeX: 0.5,
          relativeY: 0.45,
        ),
        DetectedComponent(
          label: 'Burger Bun',
          category: 'Carbs',
          calories: 200,
          relativeX: 0.5,
          relativeY: 0.3,
        ),
        DetectedComponent(
          label: 'Cheese',
          category: 'Fat',
          calories: 100,
          relativeX: 0.5,
          relativeY: 0.5,
        ),
        DetectedComponent(
          label: 'Lettuce & Toppings',
          category: 'Vegetable',
          calories: 30,
          relativeX: 0.5,
          relativeY: 0.55,
        ),
        DetectedComponent(
          label: 'Sauce',
          category: 'Condiment',
          calories: 100,
          relativeX: 0.5,
          relativeY: 0.6,
        ),
      ],
    );
  }

  FoodAnalysisResult _pastaPlate() {
    return const FoodAnalysisResult(
      foodName: 'Spaghetti Bolognese',
      healthRating: 'Balanced',
      totalCalories: 480,
      confidence: 0.87,
      macros: [
        MacroNutrient(name: 'Protein', amount: 22, unit: 'g', percentage: 0.44),
        MacroNutrient(name: 'Carbs', amount: 58, unit: 'g', percentage: 0.48),
        MacroNutrient(name: 'Fats', amount: 16, unit: 'g', percentage: 0.25),
      ],
      micros: [
        MicroNutrient(name: 'Vitamin A', amount: '25%'),
        MicroNutrient(name: 'Vitamin C', amount: '20%'),
        MicroNutrient(name: 'Iron', amount: '25%'),
        MicroNutrient(name: 'Calcium', amount: '8%'),
        MicroNutrient(name: 'Fiber', amount: '5g'),
        MicroNutrient(name: 'Sugar', amount: '6g'),
      ],
      suggestions: [
        'Decent balance of macros. Consider whole wheat pasta for extra fiber.',
        'Add more vegetables to the sauce for extra vitamins.',
      ],
      detectedComponents: [
        DetectedComponent(
          label: 'Spaghetti',
          category: 'Carbs',
          calories: 220,
          relativeX: 0.5,
          relativeY: 0.5,
        ),
        DetectedComponent(
          label: 'Meat Sauce',
          category: 'Protein',
          calories: 180,
          relativeX: 0.5,
          relativeY: 0.4,
        ),
        DetectedComponent(
          label: 'Parmesan',
          category: 'Fat',
          calories: 80,
          relativeX: 0.6,
          relativeY: 0.35,
        ),
      ],
    );
  }
}
