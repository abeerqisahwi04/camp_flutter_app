import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

// عدّلي المسار حسب مكان الصفحة عندك
import 'package:flutter_application_1/features/explore/camp_details_page.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({super.key});

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final user = _user;

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

      body: user == null
          ? const Center(
              child: Text(
                'Please login first.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.white70),
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
                      'No favorites yet ❤️',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final d = docs[index];
                    final data = d.data() as Map<String, dynamic>;

                    final campId = data['campId'];
                    final title = data['name'];
                    final location = data['location'];
                    final image = data['image'];
                    final price = data['price'];
                    final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),

                      // عند الضغط يفتح صفحة التفاصيل
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
                            // صورة
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                image,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // المعلومات
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
                );
              },
            ),
    );
  }
}
