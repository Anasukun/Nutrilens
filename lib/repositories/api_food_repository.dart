import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/food_analysis_result.dart';
import 'food_repository.dart';

class ApiFoodAnalysisRepository implements FoodAnalysisRepository {
  late final String? _apiKey;

  ApiFoodAnalysisRepository() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? dotenv.env['API_KEY'];
  }

  @override
  Future<FoodAnalysisResult> analyzeImage(XFile image) async {
    if (_apiKey == null || _apiKey.isEmpty) {
      throw Exception(
        'API key not configured. Add GEMINI_API_KEY=your_key to .env',
      );
    }

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: _apiKey,
    );

    final bytes = await image.readAsBytes();
    final prompt = '''
Analyze the following image.
If there is no food in the image, or it is impossible to determine any food, output EXACTLY this JSON:
{"error": "No food found"}
Do NOT hallucinate or make up information if there is no food. Accept all types of food.

If there is food, analyze its nutritional content and provide the following details in a STRICT JSON format. Do not include markdown formatting like ```json or any other text.
{
  "foodName": "Name of the food",
  "healthRating": "Healthy, Balanced, or Unhealthy",
  "totalCalories": 123,
  "confidence": 0.95,
  "macros": [
    {"name": "Protein", "amount": 20.5, "unit": "g", "percentage": 0.4},
    {"name": "Carbs", "amount": 50.0, "unit": "g", "percentage": 0.15},
    {"name": "Fat", "amount": 10.0, "unit": "g", "percentage": 0.15}
  ],
  "micros": [
    {"name": "Vitamin C", "amount": "20%"},
    {"name": "Iron", "amount": "10%"}
  ],
  "suggestions": [
     "Provide an actionable tip to improve the nutritional balance of this meal.",
     "Provide another practical tip or insight about this food."
  ],
  "detectedComponents": [
     {
        "label": "Chicken",
        "category": "Protein",
        "calories": 150,
        "relativeX": 0.5,
        "relativeY": 0.5
     }
  ]
}
''';

    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', bytes)]),
    ];

    try {
      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Received empty response from Gemini.');
      }

      // Clean up markdown block if the model outputs it
      String jsonStr = text.trim();
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      } else if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      print('=== GEMINI RAW JSON ===');
      print(jsonStr);

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      print('=== PARSED JSON ===');
      print(json['suggestions']);

      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }

      return FoodAnalysisResult.fromJson(json);
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Failed to parse Gemini response as JSON. Try again.');
      }
      rethrow;
    }
  }
}
