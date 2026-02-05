import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

// ✅ عدّلي المسار حسب مكان الملف عندك
import 'explore_camps_page.dart';

class ConfirmBookingPage extends StatefulWidget {
  final String campId;
  final String campName;
  final String location;
  final String image;

  final num pricePerNight;
  final DateTime startDate;
  final DateTime endDate;

  final int guests;
  final int nights;
  final num totalPrice;

  const ConfirmBookingPage({
    super.key,
    required this.campId,
    required this.campName,
    required this.location,
    required this.image,
    required this.pricePerNight,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.nights,
    required this.totalPrice,
  });

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  bool _loading = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _confirm() async {
    if (_user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': _user!.uid,
        'campId': widget.campId,
        'campName': widget.campName,
        'location': widget.location,
        'image': widget.image,
        'pricePerNight': widget.pricePerNight,
        'startDate': Timestamp.fromDate(widget.startDate),
        'endDate': Timestamp.fromDate(widget.endDate),
        'guests': widget.guests,
        'nights': widget.nights,
        'totalPrice': widget.totalPrice,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking confirmed!')));

      // ✅ بعد التأكيد: روح على ExploreCampsPage وامسح صفحات الحجز
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ExploreCampsPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm booking.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.startDate.toString().split(' ').first;
    final end = widget.endDate.toString().split(' ').first;

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Confirm Booking',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.campName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.location,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dates: $start → $end',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guests: ${widget.guests}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nights: ${widget.nights}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: ${widget.totalPrice} JD',
                    style: const TextStyle(
                      color: kAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _loading ? null : _confirm,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
