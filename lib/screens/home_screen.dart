import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'place_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the screens for each tab
  final List<Widget> _screens = [
    const HomeTab(),
    const MapScreen(), // Ensure MapScreen no longer has its own Scaffold/BottomNav
    const Center(child: Text('Saved Places (Coming Soon)')), // Placeholder for Saved
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home', 0),
            _buildNavItem(Icons.map_rounded, 'Map', 1),
            _buildNavItem(Icons.bookmark_rounded, 'Saved', 2),
            _buildNavItem(Icons.person_rounded, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8CB369).withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
              size: 26,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // Increased size for readability
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

// --- extracted Home Content to separate widget ---

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Popular', 'Recommended'];

  final List<Map<String, dynamic>> _destinations = [
    {
      'id': '1',
      'name': 'Demak Great Mosque',
      'location': 'Central Java',
      'image': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'rating': 4.8,
    },
    {
      'id': '2',
      'name': 'Prambanan Temple',
      'location': 'Yogyakarta',
      'image': 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'rating': 4.9,
    },
    {
      'id': '3',
      'name': 'Mount Bromo',
      'location': 'East Java',
      'image': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'rating': 4.7,
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Nature', 'icon': Icons.landscape_rounded, 'color': const Color(0xFF87CEEB)},
    {'name': 'Culture', 'icon': Icons.temple_buddhist_rounded, 'color': const Color(0xFFFFD700)},
    {'name': 'Relax', 'icon': Icons.spa_rounded, 'color': const Color(0xFF90EE90)},
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'color': const Color(0xFFFF7F50)},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Where do you', style: TextStyle(fontSize: 26, color: Colors.grey)),
                const Text('wanna go?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search destination...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.map((tab) {
                      bool isSelected = _selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(tab),
                          selected: isSelected,
                          onSelected: (val) => setState(() => _selectedTab = tab),
                          selectedColor: const Color(0xFFF4A460),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[600]),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _destinations.length,
                      itemBuilder: (context, index) => _buildDestinationCard(_destinations[index]),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _categories.map((c) => _buildCategoryItem(c)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> dest) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(
              placeId: dest['id'],
              placeName: dest['name'],
              imageUrl: dest['image'], // Pass image URL
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 15, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: dest['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[300]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Text Content
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFF4A460), size: 14),
                        const SizedBox(width: 4),
                        Expanded(child: Text(dest['location'], style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        Text(dest['rating'].toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(category['icon'], color: category['color'], size: 30),
        ),
        const SizedBox(height: 8),
        Text(category['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}