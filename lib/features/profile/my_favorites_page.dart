import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/explore/camp_details_page.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  static final List<Map<String, dynamic>> _mockFavorites = [
    {
      'campId': '1',
      'name': 'Wadi Rum Desert Camp',
      'location': 'Wadi Rum, Jordan',
      'image':
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
      'price': 35,
      'rating': 4.8,
    },
    {
      'campId': '2',
      'name': 'Ajloun Forest Camp',
      'location': 'Ajloun, Jordan',
      'image':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      'price': 28,
      'rating': 4.5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Favorites',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _mockFavorites.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet ❤️',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _mockFavorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final data = _mockFavorites[index];

                final campId = data['campId'];
                final title = data['name'];
                final location = data['location'];
                final image = data['image'];
                final price = data['price'];
                final rating = (data['rating'] as num).toDouble();

                return InkWell(
                  borderRadius: BorderRadius.circular(16),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CampDetailsPage(
                          campId: campId,
                          title: title,
                          location: location,
                          price: price,
                          image: image,
                          rating: rating,
                        ),
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15252A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 64,
                              height: 64,
                              color: Colors.white10,
                              child: const Icon(
                                Icons.broken_image,
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
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '$price JD / night',
                                    style: const TextStyle(
                                      color: kAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.star,
                                    color: kAccent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
