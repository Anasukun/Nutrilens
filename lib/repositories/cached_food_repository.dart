import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/food_analysis_result.dart';
import 'food_repository.dart';

/// Caching decorator that wraps any [FoodAnalysisRepository].
/// Caches responses in-memory by image path hash with a configurable TTL.
class CachedFoodAnalysisRepository implements FoodAnalysisRepository {
  final FoodAnalysisRepository _inner;
  final Duration cacheTtl;

  final Map<String, _CacheEntry> _cache = {};

  CachedFoodAnalysisRepository({
    required FoodAnalysisRepository inner,
    this.cacheTtl = const Duration(minutes: 5),
  }) : _inner = inner;

  @override
  Future<FoodAnalysisResult> analyzeImage(XFile image) async {
    final key = _cacheKey(image.path);

    // Check cache
    final cached = _cache[key];
    if (cached != null && !cached.isExpired(cacheTtl)) {
      return cached.result;
    }

    // Cache miss — call inner repository
    final result = await _inner.analyzeImage(image);

    // Store in cache
    _cache[key] = _CacheEntry(
      result: result,
      timestamp: DateTime.now(),
      resultJson: jsonEncode(result.toJson()),
    );

    return result;
  }

  /// Clear all cached results.
  void clearCache() {
    _cache.clear();
  }

  /// Remove expired entries from cache.
  void pruneExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired(cacheTtl));
  }

  /// Get the number of cached entries.
  int get cacheSize => _cache.length;

  /// Check if a result is cached for the given image path.
  bool isCached(String imagePath) {
    final key = _cacheKey(imagePath);
    final cached = _cache[key];
    return cached != null && !cached.isExpired(cacheTtl);
  }

  String _cacheKey(String imagePath) {
    return imagePath.hashCode.toRadixString(36);
  }
}

class _CacheEntry {
  final FoodAnalysisResult result;
  final DateTime timestamp;
  final String resultJson; // Serialized for potential persistence

  _CacheEntry({
    required this.result,
    required this.timestamp,
    required this.resultJson,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }
}
