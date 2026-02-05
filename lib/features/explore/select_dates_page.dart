import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'confirm_booking_page.dart';

class SelectDatesPage extends StatefulWidget {
  final String campId;
  final String campName;
  final String location;
  final num pricePerNight;
  final String image;

  const SelectDatesPage({
    super.key,
    required this.campId,
    required this.campName,
    required this.location,
    required this.pricePerNight,
    required this.image,
  });

  @override
  State<SelectDatesPage> createState() => _SelectDatesPageState();
}

class _SelectDatesPageState extends State<SelectDatesPage> {
  // ✅ تاريخ ثابت مؤقت (بكرا بنبدله بتواريخ الأدمن)
  final DateTime _startDate = DateTime(2026, 3, 24);
  final DateTime _endDate = DateTime(2026, 3, 27);

  int _guests = 1;

  int get _nights => _endDate.difference(_startDate).inDays;

  num get _totalPrice => widget.pricePerNight * _nights;

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmBookingPage(
          campId: widget.campId,
          campName: widget.campName,
          location: widget.location,
          image: widget.image,
          pricePerNight: widget.pricePerNight,
          startDate: _startDate,
          endDate: _endDate,
          guests: _guests,
          nights: _nights,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rangeText =
        '${_startDate.toString().split(" ").first}  →  ${_endDate.toString().split(" ").first}';

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Select Dates',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Camp header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.white10,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.campName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.location,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.pricePerNight} JD / night',
                        style: const TextStyle(
                          color: kAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Dates (static)
            const Text(
              'Dates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rangeText,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Icon(Icons.lock_outline, color: kAccent),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Guests
            const Text(
              'Guests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _guests > 1
                        ? () => setState(() => _guests--)
                        : null,
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Text(
                    '$_guests',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _guests++),
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                  const Spacer(),
                  const Icon(Icons.people_alt_outlined, color: kAccent),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Summary
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
                    'Nights: $_nights',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total: $_totalPrice JD',
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
                onPressed: _goNext,
                child: const Text(
                  'Continue',
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
