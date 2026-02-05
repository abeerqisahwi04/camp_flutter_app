import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _cancelBooking(BuildContext context, String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'Cancelled'});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking cancelled.')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel booking.')),
      );
    }
  }

  // ✅ يجيب endDate إذا موجودة، وإذا لا يرجع null
  DateTime? _getEndDate(DocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>?;
    final end = data?['endDate'];
    if (end is Timestamp) return end.toDate();
    return null;
  }

  // ✅ يعرض date range إذا موجود، وإلا يعرض date string إذا موجود
  String _getDateText(DocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>?;

    final start = data?['startDate'];
    final end = data?['endDate'];

    if (start is Timestamp && end is Timestamp) {
      final s = start.toDate().toString().split(' ').first;
      final e = end.toDate().toString().split(' ').first;
      return '$s → $e';
    }

    final date = data?['date'];
    if (date is String && date.isNotEmpty) return date;

    return '—';
  }

  // ✅ يعتبر Past فقط إذا endDate موجودة وانتهت
  bool _isPast(DocumentSnapshot d) {
    final end = _getEndDate(d);
    if (end == null) return false; // اللي ما عنده endDate نحسبه Upcoming مؤقتًا
    return end.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        backgroundColor: kBgDark,
        appBar: AppBar(
          backgroundColor: kBgDark,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'My Bookings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            'Please login first.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    // ✅ بدون orderBy عشان ما يطلع error بسبب createdAt أو index
    final query = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: _user!.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBgDark,
        appBar: AppBar(
          backgroundColor: kBgDark,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'My Bookings',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: kAccent,
            unselectedLabelColor: Colors.white70,
            indicatorColor: kAccent,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: kAccent),
              );
            }

            final docs = snapshot.data!.docs;

            final upcoming = docs.where((d) => !_isPast(d)).toList();
            final past = docs.where((d) => _isPast(d)).toList();

            Widget list(
              List<DocumentSnapshot> items, {
              required bool pastList,
            }) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    pastList ? 'No past bookings.' : 'No upcoming bookings.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final d = items[index];
                  final data = d.data() as Map<String, dynamic>?;

                  final id = d.id;
                  final name = (data?['campName'] ?? data?['campId'] ?? 'Camp')
                      .toString();
                  final location = (data?['location'] ?? '').toString();
                  final status = (data?['status'] ?? 'Pending').toString();

                  final total =
                      (data?['totalPrice'] ?? data?['price'] ?? 0) as num;
                  final dateText = _getDateText(d);

                  final canCancel = !pastList && status != 'Cancelled';

                  return Container(
                    padding: const EdgeInsets.all(14),
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
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: status == 'Cancelled'
                                    ? Colors.redAccent
                                    : (status == 'Pending'
                                          ? Colors.orangeAccent
                                          : Colors.greenAccent),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (location.isNotEmpty)
                          Text(
                            location,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          dateText,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Total: $total JD',
                              style: const TextStyle(
                                color: kAccent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            if (canCancel)
                              TextButton(
                                onPressed: () => _cancelBooking(context, id),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return TabBarView(
              children: [
                list(upcoming, pastList: false),
                list(past, pastList: true),
              ],
            );
          },
        ),
      ),
    );
  }
}
