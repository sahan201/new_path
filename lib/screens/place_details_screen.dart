import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;
  final String placeName;
  final String imageUrl; // Added imageUrl

  const PlaceDetailsScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.imageUrl,
  });

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            leading: IconButton(
              icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back, color: Colors.black)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white, 
                  child: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFF8CB369))
                ),
                onPressed: () => setState(() => _isSaved = !_isSaved),
              ),
              const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0, -20, 0), // Overlap effect
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.placeName,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            SizedBox(width: 5),
                            Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                      SizedBox(width: 5),
                      Text('Central Java, Indonesia', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking feature coming soon!")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CB369),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Book Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: const Icon(Icons.share, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "About Destination",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Experience the breathtaking beauty of this location. Perfect for travelers looking to explore nature and culture. The site offers guided tours, culinary experiences, and stunning photography spots.",
                    style: TextStyle(color: Colors.grey[600], height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}