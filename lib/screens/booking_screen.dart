// lib/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemType; // 'accommodation', 'activity', 'transport'
  final double pricePerPerson;
  final String imageUrl;

  const BookingScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.pricePerPerson,
    required this.imageUrl,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;
  String? selectedPaymentMethod;
  bool agreedToTerms = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {'icon': Icons.credit_card, 'name': 'Credit Card', 'value': 'credit_card'},
    {'icon': Icons.account_balance, 'name': 'Debit Card', 'value': 'debit_card'},
    {'icon': Icons.payment, 'name': 'Google Pay', 'value': 'google_pay'},
    {'icon': Icons.apple, 'name': 'Apple Pay', 'value': 'apple_pay'},
    {'icon': Icons.account_balance_wallet, 'name': 'PayPal', 'value': 'paypal'},
  ];

  double get totalPrice {
    if (checkInDate == null) return 0;
    
    int nights = 1;
    if (checkOutDate != null) {
      nights = checkOutDate!.difference(checkInDate!).inDays;
    }
    
    return widget.pricePerPerson * guests * nights;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Now',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildItemSummary(),
                const SizedBox(height: 20),
                _buildDateSelection(),
                const SizedBox(height: 20),
                _buildGuestSelection(),
                const SizedBox(height: 20),
                _buildPaymentMethodSelection(),
                const SizedBox(height: 20),
                _buildPriceSummary(),
                const SizedBox(height: 20),
                _buildTermsCheckbox(),
              ],
            ),
          ),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildItemSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.itemType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${widget.pricePerPerson}/person/night',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8CB369),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
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
            'Select Dates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  'Check-in',
                  checkInDate,
                  () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        checkInDate = date;
                        if (checkOutDate != null && checkOutDate!.isBefore(date)) {
                          checkOutDate = null;
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildDateField(
                  'Check-out',
                  checkOutDate,
                  () async {
                    if (checkInDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select check-in date first')),
                      );
                      return;
                    }
                    final date = await showDatePicker(
                      context: context,
                      initialDate: checkInDate!.add(const Duration(days: 1)),
                      firstDate: checkInDate!.add(const Duration(days: 1)),
                      lastDate: checkInDate!.add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => checkOutDate = date);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              date != null ? DateFormat('MMM dd, yyyy').format(date) : 'Select',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of Guests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                onPressed: guests > 1 ? () => setState(() => guests--) : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF8CB369),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  guests.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => guests++),
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF8CB369),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
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
            'Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ...paymentMethods.map((method) {
            final isSelected = selectedPaymentMethod == method['value'];
            return InkWell(
              onTap: () => setState(() => selectedPaymentMethod = method['value']),
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? const Color(0xFF8CB369) : Colors.grey[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected ? const Color(0xFF8CB369).withOpacity(0.1) : null,
                ),
                child: Row(
                  children: [
                    Icon(method['icon'], color: Colors.black87),
                    const SizedBox(width: 15),
                    Text(
                      method['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Color(0xFF8CB369)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
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
            'Price Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildPriceRow('Price per person', '\$${widget.pricePerPerson}'),
          _buildPriceRow('Number of guests', 'x $guests'),
          if (checkInDate != null && checkOutDate != null)
            _buildPriceRow(
              'Number of nights',
              'x ${checkOutDate!.difference(checkInDate!).inDays}',
            ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8CB369),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Checkbox(
            value: agreedToTerms,
            activeColor: const Color(0xFF8CB369),
            onChanged: (value) => setState(() => agreedToTerms = value ?? false),
          ),
          Expanded(
            child: Text(
              'I agree to the terms and conditions',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    final canBook = checkInDate != null &&
        selectedPaymentMethod != null &&
        agreedToTerms;

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
        onPressed: canBook ? _confirmBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8CB369),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: const Size(double.infinity, 50),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: const Text(
          'Confirm Booking',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Booking'),
        content: const Text('Are you sure you want to proceed with this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CB369),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _processBooking() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate booking process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading
      _showBookingSuccess();
    });
  }

  void _showBookingSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF8CB369).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF8CB369),
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Booking Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Your booking has been confirmed. Check your email for details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CB369),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}