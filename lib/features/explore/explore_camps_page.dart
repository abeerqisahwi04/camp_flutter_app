import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/profile/contact_page.dart';
import 'package:flutter_application_1/features/profile/profile_page.dart';
import 'package:flutter_application_1/features/shop/shop_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/explore/camp_details_page.dart';

class ExploreCampsPage extends StatelessWidget {
  const ExploreCampsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text(
          'Explore Camps',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find your next escape',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Browse camps & then shop what you need.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // زر الشوب
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShopPage()),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag, color: Colors.black),
                  label: const Text(
                    'Shop Camping Gear',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // قراءة الكامبات من Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('camps')
                      .orderBy('price')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: kAccent),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error loading camps',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No camps found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final doc = docs[i];
                        final data = doc.data() as Map<String, dynamic>;

                        final campId = doc.id;
                        final title = (data['name'] ?? 'Camp') as String;
                        final location =
                            (data['location'] ?? 'Unknown') as String;
                        final priceValue = (data['price'] ?? 0) as num;
                        final priceText = "$priceValue JD / night";
                        final imageUrl =
                            (data['image'] ?? '') as String; // رابط الصورة
                        final rating =
                            (data['rating'] ?? 0).toDouble() as double;

                        return _campCard(
                          context,
                          campId: campId,
                          title: title,
                          location: location,
                          priceText: priceText,
                          priceValue: priceValue,
                          imageUrl: imageUrl,
                          rating: rating,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campCard(
    BuildContext context, {
    required String campId,
    required String title,
    required String location,
    required String priceText,
    required num priceValue,
    required String imageUrl,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF15252A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white54,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: kAccent, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      priceText,
                      style: const TextStyle(
                        color: kAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CampDetailsPage(
                              campId: campId,
                              title: title,
                              location: location,
                              price: priceValue,
                              image: imageUrl,
                              rating: rating,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
