import 'package:image_picker/image_picker.dart';
import '../models/food_analysis_result.dart';

/// Abstract interface for food analysis.
/// All implementations (mock, API, cached) implement this contract.
abstract class FoodAnalysisRepository {
  /// Analyze a food image and return nutritional data.
  Future<FoodAnalysisResult> analyzeImage(XFile image);
}
