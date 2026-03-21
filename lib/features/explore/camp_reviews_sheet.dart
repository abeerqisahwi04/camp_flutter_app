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
  final TextEditingController _commentCtrl = TextEditingController();

  double _rating = 5.0;

  final List<Map<String, dynamic>> _reviews = [
    {
      'userName': 'Ahmad',
      'rating': 5.0,
      'comment': 'Amazing place and very peaceful atmosphere.',
    },
    {
      'userName': 'Lina',
      'rating': 4.0,
      'comment': 'Nice camp, clean area, and friendly staff.',
    },
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submitReview() {
    final comment = _commentCtrl.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a comment first.')),
      );
      return;
    }

    setState(() {
      _reviews.insert(0, {
        'userName': 'You',
        'rating': _rating,
        'comment': comment,
      });
      _commentCtrl.clear();
      _rating = 5.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review added ✅')),
    );
  }

  Widget _stars(double value) {
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
                    onPressed: _submitReview,
                    child: const Text(
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

          Expanded(
            child: _reviews.isEmpty
                ? const Center(
                    child: Text(
                      'No reviews yet. Be the first ⭐',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.separated(
                    itemCount: _reviews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final review = _reviews[i];
                      final userName = review['userName'].toString();
                      final rating = (review['rating'] as num).toDouble();
                      final comment = review['comment'].toString();

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
                  ),
          ),
        ],
      ),
    );
  }
}
