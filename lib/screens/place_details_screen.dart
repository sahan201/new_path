import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;
  final String placeName;
  
  const PlaceDetailsScreen({
    super.key,
    required this.placeId,
    required this.placeName,
  });

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Image gallery with app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF8CB369),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved ? const Color(0xFF8CB369) : Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black87),
                  onPressed: () {
                    // Share functionality
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder for image
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF87CEEB),
                          const Color(0xFF87CEEB).withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: PlaceImagePainter(),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.placeName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Semarang, Central Java',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8CB369).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              ' (245)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to directions
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CB369),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Call functionality
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8CB369),
                            side: const BorderSide(color: Color(0xFF8CB369)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF8CB369),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Reviews'),
                        Tab(text: 'Photos'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tab content
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Overview tab
                        _buildOverviewTab(),
                        
                        // Reviews tab
                        _buildReviewsTab(),
                        
                        // Photos tab
                        _buildPhotosTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // FAB for adding review
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddReviewDialog();
        },
        backgroundColor: const Color(0xFFF4A460),
        icon: const Icon(Icons.rate_review),
        label: const Text('Add Review'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Experience the natural beauty of this stunning destination. '
            'Perfect for nature lovers and adventure seekers, this place offers '
            'breathtaking views, peaceful surroundings, and various activities '
            'for all ages. Whether you\'re looking for relaxation or adventure, '
            'this destination has something for everyone.',
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // Opening hours
          const Text(
            'Opening Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildOpeningHoursItem('Monday - Friday', '8:00 AM - 6:00 PM'),
          _buildOpeningHoursItem('Saturday', '8:00 AM - 8:00 PM'),
          _buildOpeningHoursItem('Sunday', '9:00 AM - 5:00 PM'),
          
          const SizedBox(height: 20),
          
          // Contact info
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildContactItem(Icons.phone, '+62 123 456 789'),
          _buildContactItem(Icons.email, 'info@loongao.com'),
          _buildContactItem(Icons.language, 'www.loongao.com'),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF8CB369),
                    child: Text(
                      'U${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 14,
                              color: i < 4
                                  ? const Color(0xFFFFD700)
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2 days ago',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Great place to visit! The scenery is absolutely beautiful and '
                'the staff is very friendly. Highly recommend!',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotosTab() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF87CEEB).withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              size: 50,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpeningHoursItem(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(color: Colors.grey[700]),
          ),
          Text(
            hours,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8CB369)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: const Icon(Icons.star_border),
                    color: const Color(0xFFFFD700),
                    onPressed: () {},
                  ),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review added successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8CB369),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class PlaceImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simple illustration for place
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Mountains
    paint.color = Colors.white.withOpacity(0.3);
    final mountainPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mountainPath, paint);
    
    // Trees
    paint.color = const Color(0xFF228B22).withOpacity(0.5);
    for (double x = 50; x < size.width; x += 100) {
      canvas.drawCircle(
        Offset(x, size.height * 0.7),
        30,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}