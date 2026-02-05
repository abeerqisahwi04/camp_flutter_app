import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  User? get _user => FirebaseAuth.instance.currentUser;

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('cancel')) return Colors.redAccent;
    if (s.contains('pending')) return Colors.orangeAccent;
    if (s.contains('confirm') || s.contains('approved')) return kAccent;
    return Colors.white70;
  }

  String _formatDateRange(DocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>?;

    final startTs = data?['startDate'];
    final endTs = data?['endDate'];

    if (startTs is Timestamp && endTs is Timestamp) {
      final start = startTs.toDate().toString().split(' ').first;
      final end = endTs.toDate().toString().split(' ').first;
      return '$start → $end';
    }

    final date = data?['date'];
    if (date is String && date.isNotEmpty) return date;

    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text('My Bookings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  .collection('bookings')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // ✅ يخليك تعرفي السبب بسرعة
                  return Center(
                    child: Text(
                      'Something went wrong:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kAccent),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No bookings yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index];
                    final data = d.data() as Map<String, dynamic>?;

                    final title =
                        (data?['campName'] ?? data?['campId'] ?? 'Camp')
                            .toString();
                    final location = (data?['location'] ?? '').toString();
                    final status = (data?['status'] ?? 'Pending').toString();
                    final dateText = _formatDateRange(d);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15252A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (location.isNotEmpty)
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              dateText,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          status,
                          style: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
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
