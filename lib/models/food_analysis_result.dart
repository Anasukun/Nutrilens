// Data models for food analysis results.
// Used by all repository implementations and UI screens.

class FoodAnalysisResult {
  final String foodName;
  final String healthRating; // 'Healthy', 'Balanced', 'Unhealthy'
  final int totalCalories;
  final double confidence; // 0.0 to 1.0
  final List<MacroNutrient> macros;
  final List<MicroNutrient> micros;
  final List<String> suggestions;
  final List<DetectedComponent> detectedComponents;

  const FoodAnalysisResult({
    required this.foodName,
    required this.healthRating,
    required this.totalCalories,
    required this.confidence,
    required this.macros,
    required this.micros,
    required this.suggestions,
    this.detectedComponents = const [],
  });

  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResult(
      foodName: json['foodName'] as String? ?? 'Unknown',
      healthRating: json['healthRating'] as String? ?? 'Unknown',
      totalCalories: json['totalCalories'] as int? ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      macros:
          (json['macros'] as List<dynamic>?)
              ?.map((m) => MacroNutrient.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      micros:
          (json['micros'] as List<dynamic>?)
              ?.map((m) => MicroNutrient.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      suggestions:
          (json['suggestions'] as List<dynamic>?)
              ?.map((s) => s as String)
              .toList() ??
          [],
      detectedComponents:
          (json['detectedComponents'] as List<dynamic>?)
              ?.map(
                (d) => DetectedComponent.fromJson(d as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'foodName': foodName,
    'healthRating': healthRating,
    'totalCalories': totalCalories,
    'confidence': confidence,
    'macros': macros.map((m) => m.toJson()).toList(),
    'micros': micros.map((m) => m.toJson()).toList(),
    'suggestions': suggestions,
    'detectedComponents': detectedComponents.map((d) => d.toJson()).toList(),
  };
}

class MacroNutrient {
  final String name; // e.g. 'Protein', 'Carbs', 'Fats'
  final double amount;
  final String unit; // e.g. 'g'
  final double percentage; // 0.0 to 1.0 (of daily value)

  const MacroNutrient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.percentage,
  });

  factory MacroNutrient.fromJson(Map<String, dynamic> json) {
    return MacroNutrient(
      name: json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? 'g',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'unit': unit,
    'percentage': percentage,
  };

  String get formatted => '${amount.toStringAsFixed(0)}$unit';
}

class MicroNutrient {
  final String name; // e.g. 'Vitamin A', 'Iron'
  final String amount; // e.g. '120%', '8g'

  const MicroNutrient({required this.name, required this.amount});

  factory MicroNutrient.fromJson(Map<String, dynamic> json) {
    return MicroNutrient(
      name: json['name'] as String? ?? '',
      amount: json['amount'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'amount': amount};
}

class DetectedComponent {
  final String label;
  final String category; // 'Protein', 'Vegetable', 'Carbs', 'Fat'
  final int calories;
  final double relativeX; // 0.0 to 1.0
  final double relativeY; // 0.0 to 1.0

  const DetectedComponent({
    required this.label,
    required this.category,
    required this.calories,
    required this.relativeX,
    required this.relativeY,
  });

  factory DetectedComponent.fromJson(Map<String, dynamic> json) {
    return DetectedComponent(
      label: json['label'] as String? ?? '',
      category: json['category'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      relativeX: (json['relativeX'] as num?)?.toDouble() ?? 0.5,
      relativeY: (json['relativeY'] as num?)?.toDouble() ?? 0.5,
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'category': category,
    'calories': calories,
    'relativeX': relativeX,
    'relativeY': relativeY,
  };
}
