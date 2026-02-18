import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'repositories/food_repository.dart';
import 'repositories/mock_food_repository.dart';
import 'splash_screen.dart';
import 'repositories/cached_food_repository.dart';

late List<CameraDescription> cameras;

/// Global food analysis repository.
/// Currently uses MockFoodAnalysisRepository for testing.
/// When ready for real API, swap to:
///   ApiFoodAnalysisRepository() (and import api_food_repository.dart)
late FoodAnalysisRepository foodRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // Initialize repository: Mock → Cached
  // To switch to real API: replace MockFoodAnalysisRepository() with ApiFoodAnalysisRepository()
  foodRepository = CachedFoodAnalysisRepository(
    inner: MockFoodAnalysisRepository(),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
