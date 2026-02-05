import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class CampReviewsSheet extends StatefulWidget {
  final String campId;
  final String campName;

  const CampReviewsSheet({
    super.key,
    required this.campId,
    required this.campName,
  });

  @override
  State<CampReviewsSheet> createState() => _CampReviewsSheetState();
}

class _CampReviewsSheetState extends State<CampReviewsSheet> {
  final _commentCtrl = TextEditingController();
  double _rating = 5.0;
  bool _submitting = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  CollectionReference<Map<String, dynamic>> get _reviewsRef => FirebaseFirestore
      .instance
      .collection('camps')
      .doc(widget.campId)
      .collection('reviews');

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    final comment = _commentCtrl.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Write a comment first.')));
      return;
    }

    setState(() => _submitting = true);

    try {
      // ✅ (اختياري) جلب الاسم من users إذا عندك
      String userName = 'User';
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        final data = userDoc.data();
        if (data != null && data['name'] != null)
          userName = data['name'].toString();
      } catch (_) {}

      await _reviewsRef.add({
        'userId': _user!.uid,
        'userName': userName,
        'rating': _rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _commentCtrl.clear();
      setState(() => _rating = 5.0);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review added ✅')));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add review.')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _stars(double value) {
    // نعرض نجوم بسيطة
    final full = value.floor().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < full;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          color: kAccent,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kBgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        children: [
          // handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Reviews • ${widget.campName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // add review box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add your review',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text(
                      'Rating:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _rating.toStringAsFixed(0),
                        onChanged: (v) => setState(() => _rating = v),
                        activeColor: kAccent,
                        inactiveColor: Colors.white24,
                      ),
                    ),
                    Text(
                      _rating.toStringAsFixed(0),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                TextField(
                  controller: _commentCtrl,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write your experience…',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submitting ? null : _submitReview,
                    child: _submitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // reviews list
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _reviewsRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: kAccent),
                  );
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reviews yet. Be the first ⭐',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    final userName = (d['userName'] ?? 'User').toString();
                    final rating = (d['rating'] ?? 5).toDouble();
                    final comment = (d['comment'] ?? '').toString();

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              _stars(rating),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            comment,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
