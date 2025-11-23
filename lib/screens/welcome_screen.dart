import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
      backgroundColor: const Color(0xFF8CB369),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF8CB369),
                          Color(0xFFA8D08D),
                        ],
                      ),
                    ),
                  ),
                  
                  // Main content card
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFB5D99C).withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Cloud decorations
                          Stack(
                            children: [
                              Container(
                                height: 350,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    // Clouds
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      child: _buildCloud(60),
                                    ),
                                    Positioned(
                                      top: 50,
                                      right: 30,
                                      child: _buildCloud(80),
                                    ),
                                    Positioned(
                                      top: 100,
                                      left: 60,
                                      child: _buildCloud(50),
                                    ),
                                    
                                    // Title
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 60),
                                          const Text(
                                            'WELCOME TO',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'LOONGAO',
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Find place and explore your favorite\ndestination with us.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black.withOpacity(0.7),
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Landscape illustration
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: _buildLandscape(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Search button
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4A460),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF4A460).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Search Destination',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double width) {
    return Container(
      width: width,
      height: width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _buildLandscape() {
    return Container(
      height: 150,
      child: Stack(
        children: [
          // Mountains
          CustomPaint(
            size: const Size(double.infinity, 150),
            painter: MountainPainter(),
          ),
          
          // Farm elements
          Positioned(
            bottom: 20,
            left: 30,
            child: _buildFarmHouse(),
          ),
          
          // Trees
          Positioned(
            bottom: 15,
            right: 50,
            child: _buildTree(40),
          ),
          Positioned(
            bottom: 10,
            right: 80,
            child: _buildTree(35),
          ),
          
          // Fence
          Positioned(
            bottom: 25,
            left: 120,
            child: _buildFence(),
          ),
          
          // Cows
          Positioned(
            bottom: 30,
            left: 180,
            child: _buildCow(),
          ),
          Positioned(
            bottom: 35,
            right: 120,
            child: _buildCow(),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmHouse() {
    return Container(
      width: 60,
      height: 45,
      child: Stack(
        children: [
          // House body
          Positioned(
            bottom: 0,
            child: Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFD2691E),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          // Roof
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 60,
                height: 20,
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTree(double height) {
    return Container(
      width: height * 0.7,
      height: height,
      child: Stack(
        children: [
          // Tree trunk
          Positioned(
            bottom: 0,
            left: height * 0.25,
            child: Container(
              width: height * 0.2,
              height: height * 0.4,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Tree top
          Positioned(
            top: 0,
            child: Container(
              width: height * 0.7,
              height: height * 0.7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF228B22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFence() {
    return Row(
      children: List.generate(
        3,
        (index) => Container(
          width: 3,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: const Color(0xFF8B4513),
        ),
      ),
    );
  }

  Widget _buildCow() {
    return Container(
      width: 25,
      height: 15,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3),
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF90EE90);

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.25, 0,
        size.width * 0.5, size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.2,
        size.width, size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}