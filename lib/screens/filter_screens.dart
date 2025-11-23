// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);
  double minRating = 0;
  double maxDistance = 50;
  List<String> selectedAmenities = [];
  String? sortBy;

  final List<String> categories = [
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

  final List<String> amenities = [
    'WiFi',
    'Parking',
    'Restaurant',
    'Pool',
    'Gym',
    'Spa',
    'Pet Friendly',
    'Air Conditioning'
  ];

  final List<Map<String, String>> sortOptions = [
    {'value': 'rating', 'label': 'Highest Rated'},
    {'value': 'price_low', 'label': 'Price: Low to High'},
    {'value': 'price_high', 'label': 'Price: High to Low'},
    {'value': 'distance', 'label': 'Nearest First'},
    {'value': 'popular', 'label': 'Most Popular'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Color(0xFF8CB369)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildCategorySection(),
                const SizedBox(height: 25),
                _buildPriceRangeSection(),
                const SizedBox(height: 25),
                _buildRatingSection(),
                const SizedBox(height: 25),
                _buildDistanceSection(),
                const SizedBox(height: 25),
                _buildAmenitiesSection(),
                const SizedBox(height: 25),
                _buildSortSection(),
              ],
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = selected ? category : null;
                  });
                },
                selectedColor: const Color(0xFF8CB369),
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${priceRange.start.toInt()} - \$${priceRange.end.toInt()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: const Color(0xFF8CB369),
            onChanged: (values) {
              setState(() {
                priceRange = values;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minimum Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    minRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                ],
              ),
            ],
          ),
          Slider(
            value: minRating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: const Color(0xFF8CB369),
            onChanged: (value) {
              setState(() {
                minRating = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Maximum Distance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${maxDistance.toInt()} km',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Slider(
            value: maxDistance,
            min: 5,
            max: 100,
            divisions: 19,
            activeColor: const Color(0xFF8CB369),
            onChanged: (value) {
              setState(() {
                maxDistance = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: amenities.map((amenity) {
              final isSelected = selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedAmenities.add(amenity);
                    } else {
                      selectedAmenities.remove(amenity);
                    }
                  });
                },
                selectedColor: const Color(0xFF8CB369).withOpacity(0.2),
                checkmarkColor: const Color(0xFF8CB369),
                backgroundColor: Colors.grey[100],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...sortOptions.map((option) {
            final isSelected = sortBy == option['value'];
            return RadioListTile<String>(
              title: Text(option['label']!),
              value: option['value']!,
              groupValue: sortBy,
              activeColor: const Color(0xFF8CB369),
              onChanged: (value) {
                setState(() {
                  sortBy = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8CB369),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Apply Filters',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      priceRange = const RangeValues(0, 1000);
      minRating = 0;
      maxDistance = 50;
      selectedAmenities.clear();
      sortBy = null;
    });
  }

  void _applyFilters() {
    // Return filter results to previous screen
    Navigator.pop(context, {
      'category': selectedCategory,
      'minPrice': priceRange.start,
      'maxPrice': priceRange.end,
      'minRating': minRating,
      'maxDistance': maxDistance,
      'amenities': selectedAmenities,
      'sortBy': sortBy,
    });
  }
}