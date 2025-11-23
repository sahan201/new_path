import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Popular', 'Recommended'];
  
  final List<Map<String, dynamic>> _destinations = [
    {
      'name': 'Demak',
      'location': 'Kab. Semarang',
      'image': 'mountain_lake',
      'color': const Color(0xFF87CEEB),
    },
    {
      'name': 'Klaten',
      'location': 'Kab. Solo',
      'image': 'temple',
      'color': const Color(0xFFFFD700),
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Villages',
      'icon': Icons.home_rounded,
      'color': const Color(0xFF90EE90),
    },
    {
      'name': 'Mountains',
      'icon': Icons.terrain_rounded,
      'color': const Color(0xFF87CEEB),
    },
    {
      'name': 'Rice Fields',
      'icon': Icons.grass_rounded,
      'color': const Color(0xFFFFD700),
    },
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Where do you',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'wanna go?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Searching destination ...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tab buttons
                  Row(
                    children: _tabs.map((tab) {
                      bool isSelected = _selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = tab;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFF4A460)
                                  : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
                    // Destination cards
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _destinations.length,
                        itemBuilder: (context, index) {
                          return _buildDestinationCard(_destinations[index]);
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _categories.map((category) {
                        return _buildCategoryItem(category);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom navigation
            Container(
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
                  _buildNavItem(Icons.notifications_rounded, 'Notifications', 1),
                  _buildNavItem(Icons.shopping_bag_rounded, 'Order', 2),
                  _buildNavItem(Icons.person_rounded, 'Profile', 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: destination['color'],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: destination['color'].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background illustration
          if (destination['image'] == 'mountain_lake')
            Positioned.fill(
              child: CustomPaint(
                painter: MountainLakePainter(),
              ),
            )
          else if (destination['image'] == 'temple')
            Positioned.fill(
              child: CustomPaint(
                painter: TemplePainter(),
              ),
            ),
          
          // Content
          Positioned(
            bottom: 15,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  destination['location'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            category['icon'],
            color: category['color'],
            size: 35,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category['name'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
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
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for mountain lake scene
class MountainLakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Mountains
    final mountainPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final mountainPath = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.5, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.1)
      ..lineTo(size.width, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(mountainPath, mountainPaint);

    // Trees
    final treePaint = Paint()
      ..color = const Color(0xFF228B22).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw simple triangle trees
    for (double x = 20; x < size.width; x += 40) {
      final treePath = Path()
        ..moveTo(x, size.height * 0.6)
        ..lineTo(x - 10, size.height * 0.7)
        ..lineTo(x + 10, size.height * 0.7)
        ..close();
      canvas.drawPath(treePath, treePaint);
    }

    // House
    final housePaint = Paint()
      ..color = const Color(0xFF8B4513).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.15,
      ),
      housePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for temple scene
class TemplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Temple structure
    final templePaint = Paint()
      ..color = const Color(0xFF8B4513).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Main temple body
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.4,
        size.width * 0.4,
        size.height * 0.3,
      ),
      templePaint,
    );

    // Temple roof
    final roofPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.4)
      ..close();

    canvas.drawPath(roofPath, templePaint);

    // Decorative elements
    final decorPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(
          size.width * (0.35 + i * 0.15),
          size.height * 0.55,
        ),
        8,
        decorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}