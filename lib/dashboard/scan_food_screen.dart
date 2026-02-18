import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import '../models/food_analysis_result.dart';
import '../repositories/meal_repository.dart';
import 'widgets/food_analysis_card.dart';
import 'widgets/food_details_sheet.dart';

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
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
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

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      setState(() => _cameraError = 'Camera error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      // Pause camera preview to free resources while showing captured image
      await _cameraController!.pausePreview();
      if (!mounted) return;
      setState(() => _capturedImage = photo);
      _analyzeImage(photo);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to capture photo: $e')));
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

  Future<void> _storeData() async {
    if (_analysisResult == null) return;

    String? savedPath;
    if (_capturedImage != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String path = '${directory.path}/$fileName';
        await File(_capturedImage!.path).copy(path);
        savedPath = path;
      } catch (e) {
        debugPrint('Error saving image: $e');
      }
    }

    MealRepository.instance.addMeal(_analysisResult!, imagePath: savedPath);
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Meal stored successfully!')));
    Navigator.pop(context); // Return to dashboard
  }

  void _showFoodDetails(BuildContext context) {
    if (_analysisResult == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodDetailsSheet(
        result: _analysisResult!,
        imageFile: _capturedImage != null ? File(_capturedImage!.path) : null,
      ),
    );
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
                            Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Error loading image',
                              style: TextStyle(color: Colors.white),
                            ),
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
                        ? Text(
                            _cameraError!,
                            style: const TextStyle(color: Colors.white70),
                          )
                        : const CircularProgressIndicator(
                            color: Color(0xFF8B9D42),
                          ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // AI Active header removed
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
                constraints: BoxConstraints(maxHeight: screenHeight * 0.45),
                child: FoodAnalysisCard(
                  result: _analysisResult!,
                  onSave: _storeData,
                  onRetake: _retake,
                  onDetails: () => _showFoodDetails(context),
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF8B9D42),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Analyzing food...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gallery Button
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _capturedImage == null && !_isAnalyzing
                          ? _pickFromGallery
                          : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white54),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
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
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF1E1E1E),
                        size: 32,
                      ),
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
                      child: const Icon(
                        Icons.refresh,
                        color: Color(0xFF1E1E1E),
                        size: 32,
                      ),
                    ),
                  ),

                // Balance
                const Expanded(child: SizedBox()),
              ],
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: (topLeft || topRight)
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
            bottom: (bottomLeft || bottomRight)
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
            left: (topLeft || bottomLeft)
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
            right: (topRight || bottomRight)
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC62828), size: 40),
          const SizedBox(height: 12),
          const Text(
            'Analysis Failed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _analysisError ?? 'Unknown error',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _retake,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
