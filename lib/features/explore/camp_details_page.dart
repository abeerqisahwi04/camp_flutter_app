import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'select_dates_page.dart';
import 'camp_reviews_sheet.dart';

class CampDetailsPage extends StatefulWidget {
  final String campId;
  final String title;
  final String location;
  final num price; // رقم (مش سترنغ)
  final String image;
  final double rating;

  const CampDetailsPage({
    super.key,
    required this.campId,
    required this.title,
    required this.location,
    required this.price,
    required this.image,
    required this.rating,
  });

  @override
  State<CampDetailsPage> createState() => _CampDetailsPageState();
}

class _CampDetailsPageState extends State<CampDetailsPage> {
  User? get _user => FirebaseAuth.instance.currentUser;

  // مرجع الفيفوريت
  DocumentReference get _favDoc {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('favorites')
        .doc(widget.campId);
  }

  // إضافة / إزالة من المفضلة
  Future<void> _toggleFavorite(bool isFavAlready) async {
    if (_user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    try {
      if (isFavAlready) {
        await _favDoc.delete();
      } else {
        await _favDoc.set({
          'campId': widget.campId,
          'name': widget.title,
          'location': widget.location,
          'image': widget.image,
          'price': widget.price,
          'rating': widget.rating,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating favorites.')),
      );
    }
  }

  void _goToSelectDates() {
    if (_user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectDatesPage(
          campId: widget.campId,
          campName: widget.title,
          location: widget.location,
          pricePerNight: widget.price,
          image: widget.image,
        ),
      ),
    );
  }

  void _openReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: CampReviewsSheet(campId: widget.campId, campName: widget.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceText = '${widget.price} JD / night';

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          if (_user != null)
            StreamBuilder<DocumentSnapshot>(
              stream: _favDoc.snapshots(),
              builder: (context, snapshot) {
                final isFav = snapshot.data?.exists ?? false;
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () => _toggleFavorite(isFav),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الكامب
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: Image.network(
                widget.image,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.red,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم + الريتنج
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: kAccent, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // الموقع
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white60,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // السعر
                  Text(
                    priceText,
                    style: const TextStyle(
                      color: kAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "About this camp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enjoy a cozy camping experience with clear night skies, "
                    "warm campfire vibes, and a quiet natural escape away "
                    "from the city noise. Perfect for families, friends, "
                    "and adventure lovers.",
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),

                  const SizedBox(height: 16),

                  // ✅ زر Reviews
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _openReviews,
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Reviews'),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // زر Book
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
                      onPressed: _goToSelectDates,
                      child: const Text(
                        "Book this camp",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
