// lib/services/search_service.dart
import 'package:flutter/material.dart';

class SearchService {
  // Filter options
  static const List<String> categories = [
    'All',
    'Nature',
    'Culture',
    'Beach',
    'Mountain',
    'City',
    'Adventure',
    'Relaxation',
    'Food'
  ];

  static const List<String> amenities = [
    'WiFi',
    'Parking',
    'Restaurant',
    'Pool',
    'Gym',
    'Spa',
    'Pet Friendly'
  ];

  // Search destinations with filters
  static List<Map<String, dynamic>> searchDestinations({
    required List<Map<String, dynamic>> destinations,
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? maxDistance,
    List<String>? selectedAmenities,
    String? sortBy,
  }) {
    var results = List<Map<String, dynamic>>.from(destinations);

    // Text search
    if (query != null && query.isNotEmpty) {
      results = results.where((dest) {
        final name = dest['name'].toString().toLowerCase();
        final location = dest['location'].toString().toLowerCase();
        final description = dest['description']?.toString().toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        
        return name.contains(searchQuery) ||
            location.contains(searchQuery) ||
            description.contains(searchQuery);
      }).toList();
    }

    // Category filter
    if (category != null && category != 'All') {
      results = results.where((dest) {
        final destCategories = dest['categories'] as List<String>? ?? [];
        return destCategories.contains(category);
      }).toList();
    }

    // Price range filter
    if (minPrice != null) {
      results = results.where((dest) {
        final price = dest['price'] as double? ?? 0;
        return price >= minPrice;
      }).toList();
    }

    if (maxPrice != null) {
      results = results.where((dest) {
        final price = dest['price'] as double? ?? double.infinity;
        return price <= maxPrice;
      }).toList();
    }

    // Rating filter
    if (minRating != null) {
      results = results.where((dest) {
        final rating = dest['rating'] as double? ?? 0;
        return rating >= minRating;
      }).toList();
    }

    // Distance filter
    if (maxDistance != null) {
      results = results.where((dest) {
        final distance = dest['distance'] as int? ?? 0;
        return distance <= maxDistance;
      }).toList();
    }

    // Amenities filter
    if (selectedAmenities != null && selectedAmenities.isNotEmpty) {
      results = results.where((dest) {
        final destAmenities = dest['amenities'] as List<String>? ?? [];
        return selectedAmenities.every((amenity) => 
          destAmenities.contains(amenity));
      }).toList();
    }

    // Sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'rating':
          results.sort((a, b) => 
            (b['rating'] as double).compareTo(a['rating'] as double));
          break;
        case 'price_low':
          results.sort((a, b) => 
            (a['price'] as double).compareTo(b['price'] as double));
          break;
        case 'price_high':
          results.sort((a, b) => 
            (b['price'] as double).compareTo(a['price'] as double));
          break;
        case 'distance':
          results.sort((a, b) => 
            (a['distance'] as int).compareTo(b['distance'] as int));
          break;
        case 'popular':
          results.sort((a, b) => 
            (b['popularity'] as int).compareTo(a['popularity'] as int));
          break;
      }
    }

    return results;
  }

  // Get recommendations based on user preferences
  static List<Map<String, dynamic>> getRecommendations({
    required List<Map<String, dynamic>> destinations,
    List<String>? userPreferences,
    List<String>? visitedPlaces,
    String? recommendationType, // 'popular', 'trending', 'personalized'
  }) {
    var results = List<Map<String, dynamic>>.from(destinations);

    switch (recommendationType) {
      case 'popular':
        results.sort((a, b) => 
          (b['popularity'] as int).compareTo(a['popularity'] as int));
        break;
      case 'trending':
        results.sort((a, b) => 
          (b['trending_score'] as int).compareTo(a['trending_score'] as int));
        break;
      case 'personalized':
        if (userPreferences != null && userPreferences.isNotEmpty) {
          // Score each destination based on matching preferences
          for (var dest in results) {
            final destCategories = dest['categories'] as List<String>? ?? [];
            int score = 0;
            for (var pref in userPreferences) {
              if (destCategories.contains(pref)) {
                score += 10;
              }
            }
            dest['preference_score'] = score;
          }
          results.sort((a, b) => 
            (b['preference_score'] as int).compareTo(a['preference_score'] as int));
        }
        break;
    }

    // Remove already visited places if needed
    if (visitedPlaces != null && visitedPlaces.isNotEmpty) {
      results = results.where((dest) => 
        !visitedPlaces.contains(dest['id'])).toList();
    }

    return results.take(10).toList(); // Return top 10 recommendations
  }
}

// Filter state management
class FilterState {
  String? category;
  double? minPrice;
  double? maxPrice;
  double? minRating;
  int? maxDistance;
  List<String> selectedAmenities;
  String? sortBy;

  FilterState({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.maxDistance,
    this.selectedAmenities = const [],
    this.sortBy,
  });

  FilterState copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? maxDistance,
    List<String>? selectedAmenities,
    String? sortBy,
  }) {
    return FilterState(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      category != null && category != 'All' ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      maxDistance != null ||
      selectedAmenities.isNotEmpty ||
      sortBy != null;

  void clear() {
    category = null;
    minPrice = null;
    maxPrice = null;
    minRating = null;
    maxDistance = null;
    selectedAmenities = [];
    sortBy = null;
  }
}