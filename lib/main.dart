import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'repositories/food_repository.dart';
import 'repositories/api_food_repository.dart';
import 'splash_screen.dart';
import 'repositories/cached_food_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late List<CameraDescription> cameras;

/// Global food analysis repository.
late FoodAnalysisRepository foodRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  cameras = await availableCameras();

  foodRepository = CachedFoodAnalysisRepository(
    inner: ApiFoodAnalysisRepository(),
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
