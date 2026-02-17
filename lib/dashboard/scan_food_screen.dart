import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../models/food_analysis_result.dart';
import '../repositories/meal_repository.dart';

class ScanFoodScreen extends StatefulWidget {
  const ScanFoodScreen({super.key});

  @override
  State<ScanFoodScreen> createState() => _ScanFoodScreenState();
}

class _ScanFoodScreenState extends State<ScanFoodScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Camera
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _cameraError;

  // Capture state
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  bool _showResult = false;
  String? _analysisError;
  FoodAnalysisResult? _analysisResult;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) {
      setState(() => _cameraError = 'No cameras available');
      return;
    }

    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(camera, ResolutionPreset.medium, enableAudio: false);

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      setState(() => _cameraError = 'Camera error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      // Pause camera preview to free resources while showing captured image
      await _cameraController!.pausePreview();
      if (!mounted) return;
      setState(() => _capturedImage = photo);
      _analyzeImage(photo);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture photo: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (image != null) {
      setState(() => _capturedImage = image);
      _analyzeImage(image);
    }
  }

  Future<void> _analyzeImage(XFile image) async {
    setState(() {
      _isAnalyzing = true;
      _showResult = false;
      _analysisError = null;
      _analysisResult = null;
      _animationController.repeat(reverse: true);
    });

    try {
      final result = await foodRepository.analyzeImage(image);
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _animationController.stop();
        _analysisResult = result;
        _showResult = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _animationController.stop();
        _analysisError = e.toString();
        _showResult = true;
      });
    }
  }

  void _retake() {
    // Resume camera preview
    _cameraController?.resumePreview();
    setState(() {
      _capturedImage = null;
      _isAnalyzing = false;
      _showResult = false;
      _analysisError = null;
      _analysisResult = null;
      _animationController.stop();
    });
  }

  void _storeData() {
    if (_analysisResult == null) return;
    MealRepository.instance.addMeal(_analysisResult!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal stored successfully!')),
    );
    Navigator.pop(context); // Return to dashboard
  }

  void _showFoodDetails(BuildContext context) {
    if (_analysisResult == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodDetailsSheet(result: _analysisResult!),
    );
  }

  Color _healthRatingColor(String rating) {
    switch (rating) {
      case 'Healthy':
        return const Color(0xFF2E7D32);
      case 'Balanced':
        return const Color(0xFFF57C00);
      case 'Unhealthy':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  Color _healthRatingBgColor(String rating) {
    switch (rating) {
      case 'Healthy':
        return const Color(0xFFE8F5E9);
      case 'Balanced':
        return const Color(0xFFFFF3E0);
      case 'Unhealthy':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey[200]!;
    }
  }

  Color _macroColor(String name) {
    switch (name) {
      case 'Protein':
        return const Color(0xFF4A1817);
      case 'Carbs':
        return Colors.amber;
      case 'Fats':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Captured image or live camera preview
          // IMPORTANT: Only one is built at a time to save memory
          _capturedImage != null
              ? Container(
                  color: Colors.black,
                  child: Image.file(
                    File(_capturedImage!.path),
                    fit: BoxFit.cover,
                    cacheWidth: 1080,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image,
                                color: Colors.white, size: 48),
                            SizedBox(height: 8),
                            Text('Error loading image',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : _isCameraInitialized && _cameraController != null
                  ? CameraPreview(_cameraController!)
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: _cameraError != null
                            ? Text(_cameraError!,
                                style: const TextStyle(color: Colors.white70))
                            : const CircularProgressIndicator(
                                color: Color(0xFF8B9D42)),
                      ),
                    ),

          // Scanning animation
          if (_isAnalyzing)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: 100 + (screenHeight * 0.6 * _animation.value),
                  left: 20,
                  right: 20,
                  child: child!,
                );
              },
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B9D42).withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B9D42).withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isAnalyzing ? Colors.orangeAccent : const Color(0xFF8B9D42),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isAnalyzing ? 'ANALYZING...' : 'AI ACTIVE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),

          // Corner brackets (live camera mode only)
          if (_capturedImage == null)
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    _cornerBracket(top: 0, left: 0, topLeft: true),
                    _cornerBracket(top: 0, right: 0, topRight: true),
                    _cornerBracket(bottom: 0, left: 0, bottomLeft: true),
                    _cornerBracket(bottom: 0, right: 0, bottomRight: true),
                  ],
                ),
              ),
            ),

          // Result Card — with real data
          if (_showResult && _analysisResult != null)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.45,
                ),
                child: _buildResultCard(),
              ),
            ),

          // Error Card
          if (_showResult && _analysisError != null && _analysisResult == null)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: _buildErrorCard(),
            ),

          // Analyzing overlay
          if (_isAnalyzing)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B9D42)),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Analyzing food...',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Controls
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gallery Button
                GestureDetector(
                  onTap: _capturedImage == null && !_isAnalyzing ? _pickFromGallery : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.white, size: 24),
                  ),
                ),

                // Shutter / Retake Button
                if (_capturedImage == null)
                  GestureDetector(
                    onTap: !_isAnalyzing ? _capturePhoto : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 4,
                        ),
                      ),
                      child: const Icon(Icons.camera_alt, color: Color(0xFF1E1E1E), size: 32),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: !_isAnalyzing ? _retake : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8B9D42).withValues(alpha: 0.5),
                          width: 4,
                        ),
                      ),
                      child: const Icon(Icons.refresh, color: Color(0xFF1E1E1E), size: 32),
                    ),
                  ),

                // Edit Button
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _analysisResult!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(width: 4, height: 24, color: const Color(0xFF8B9D42)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        result.foodName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B9D42).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(result.confidence * 100).toInt()}% Confidence',
                  style: const TextStyle(
                    color: Color(0xFF5D6B2C),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nutrient circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NutrientCircle(
                label: 'KCAL',
                value: '${result.totalCalories}',
                color: Colors.transparent,
                isMain: true,
              ),
              ...result.macros.map((m) => _NutrientCircle(
                    label: m.name,
                    value: m.formatted,
                    color: _macroColor(m.name),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          
          // Component Breakdown (Minimalist List)
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Breakdown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.detectedComponents.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c.label,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          Text(
                            '${c.calories} kcal',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B9D42),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Health rating badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _healthRatingBgColor(result.healthRating),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              result.healthRating,
              style: TextStyle(
                color: _healthRatingColor(result.healthRating),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _storeData,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Store Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showFoodDetails(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _retake,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Icon(Icons.refresh, color: Color(0xFF1E1E1E), size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Analysis Failed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 8),
          Text(
            _analysisError ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _retake,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBracket({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: topLeft || topRight
                ? const BorderSide(color: Color(0xFF8B9D42), width: 4)
                : BorderSide.none,
            bottom: bottomLeft || bottomRight
                ? const BorderSide(color: Color(0xFF8B9D42), width: 4)
                : BorderSide.none,
            left: topLeft || bottomLeft
                ? const BorderSide(color: Color(0xFF8B9D42), width: 4)
                : BorderSide.none,
            right: topRight || bottomRight
                ? const BorderSide(color: Color(0xFF8B9D42), width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: topLeft ? const Radius.circular(12) : Radius.zero,
            topRight: topRight ? const Radius.circular(12) : Radius.zero,
            bottomLeft: bottomLeft ? const Radius.circular(12) : Radius.zero,
            bottomRight: bottomRight ? const Radius.circular(12) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Supporting Widgets
// ──────────────────────────────────────────────

class _NutrientCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isMain;

  const _NutrientCircle({
    required this.label,
    required this.value,
    required this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isMain ? 60 : 50,
          height: isMain ? 60 : 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isMain)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  margin: const EdgeInsets.only(bottom: 2),
                ),
              Text(
                label,
                style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMain ? 18 : 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FoodDetailsSheet extends StatelessWidget {
  final FoodAnalysisResult result;

  const FoodDetailsSheet({super.key, required this.result});

  Color _macroColor(String name) {
    switch (name) {
      case 'Protein':
        return const Color(0xFF4A1817);
      case 'Carbs':
        return Colors.amber;
      case 'Fats':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _healthRatingColor(String rating) {
    switch (rating) {
      case 'Healthy':
        return const Color(0xFF2E7D32);
      case 'Balanced':
        return const Color(0xFFF57C00);
      case 'Unhealthy':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  Color _healthRatingBgColor(String rating) {
    switch (rating) {
      case 'Healthy':
        return const Color(0xFFE8F5E9);
      case 'Balanced':
        return const Color(0xFFFFF3E0);
      case 'Unhealthy':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.foodName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      Text(
                        result.healthRating,
                        style: TextStyle(
                          fontSize: 14,
                          color: _healthRatingColor(result.healthRating),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_border, color: Color(0xFF1E1E1E), size: 24),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calorie & Health Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL CALORIES',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${result.totalCalories}',
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' kcal',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _healthRatingBgColor(result.healthRating),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            result.healthRating,
                            style: TextStyle(
                              color: _healthRatingColor(result.healthRating),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Macronutrients
                  const Text(
                    'Macronutrients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 16),
                  ...result.macros.map((macro) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildMacroRow(macro.name, macro.formatted, macro.percentage, _macroColor(macro.name)),
                      )),

                  const SizedBox(height: 24),

                  // Micronutrients
                  const Text(
                    'Micronutrients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: result.micros
                        .map((micro) => _buildMicroCard(micro.name, micro.amount))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Suggestions
                  if (result.suggestions.isNotEmpty) ...[
                    const Text(
                      'Suggestions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(height: 16),
                    ...result.suggestions.map((suggestion) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFFB74D).withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline, color: Color(0xFFF57C00), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: const TextStyle(color: Color(0xFFBF360C), fontSize: 13, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, double pct, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF555555))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E))),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: pct.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMicroCard(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
