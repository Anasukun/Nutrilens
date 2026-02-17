import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/food_analysis_result.dart';
import 'food_repository.dart';

/// Real API implementation.
/// Reads the API key from .env and sends the image to the food recognition endpoint.
///
/// To activate:
/// 1. Add your API key to .env:  API_KEY=your_key_here
/// 2. Set API_BASE_URL in .env:  API_BASE_URL=https://your-api-endpoint.com
/// 3. Swap MockFoodAnalysisRepository → ApiFoodAnalysisRepository in main.dart
class ApiFoodAnalysisRepository implements FoodAnalysisRepository {
  late final String? _apiKey;
  late final String? _baseUrl;

  ApiFoodAnalysisRepository() {
    _apiKey = dotenv.env['API_KEY'];
    _baseUrl = dotenv.env['API_BASE_URL'];
  }

  @override
  Future<FoodAnalysisResult> analyzeImage(XFile image) async {
    if (_apiKey == null || _apiKey.isEmpty) {
      throw Exception('API key not configured. Add API_KEY=your_key to .env');
    }

    if (_baseUrl == null || _baseUrl.isEmpty) {
      throw Exception(
        'API base URL not configured. Add API_BASE_URL=https://... to .env',
      );
    }

    // TODO: Implement actual API call when you have your API key.
    // Example implementation:
    //
    // import 'dart:convert';
    // import 'package:http/http.dart' as http;
    //
    // final bytes = await image.readAsBytes();
    // final request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse('$_baseUrl/analyze'),
    // );
    // request.headers['Authorization'] = 'Bearer $_apiKey';
    // request.files.add(http.MultipartFile.fromBytes(
    //   'image',
    //   bytes,
    //   filename: image.name,
    // ));
    //
    // final streamedResponse = await request.send();
    // final response = await http.Response.fromStream(streamedResponse);
    //
    // if (response.statusCode == 200) {
    //   final json = jsonDecode(response.body) as Map<String, dynamic>;
    //   return FoodAnalysisResult.fromJson(json);
    // } else {
    //   throw Exception('API error: ${response.statusCode} ${response.body}');
    // }

    throw Exception(
      'API call not yet implemented. Complete the TODO in api_food_repository.dart',
    );
  }
}
