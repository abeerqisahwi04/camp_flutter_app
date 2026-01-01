import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_images.dart';

class CampDetailsPage extends StatelessWidget {
  final String? title;
  final String? location;
  final String? price;

  const CampDetailsPage({super.key, this.title, this.location, this.price});

  @override
  Widget build(BuildContext context) {
    final safeTitle = (title != null && title!.trim().isNotEmpty)
        ? title!.trim()
        : 'Camp';
    final safeLocation = (location != null && location!.trim().isNotEmpty)
        ? location!.trim()
        : 'Unknown location';
    final safePrice = (price != null && price!.trim().isNotEmpty)
        ? price!.trim()
        : '--';

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text(
          'Camp Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              kHeroImage,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            safeTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(safeLocation, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            safePrice,
            style: const TextStyle(
              color: kAccent,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'A beautiful camping spot with great views, perfect for a weekend escape.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}
