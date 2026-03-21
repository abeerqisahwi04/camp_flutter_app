import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'campName': 'Wadi Rum Desert Camp',
      'location': 'Wadi Rum, Jordan',
      'startDate': DateTime.now().add(const Duration(days: 5)),
      'endDate': DateTime.now().add(const Duration(days: 7)),
      'totalPrice': 70,
      'status': 'Pending',
    },
    {
      'id': '2',
      'campName': 'Ajloun Forest Camp',
      'location': 'Ajloun, Jordan',
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'endDate': DateTime.now().subtract(const Duration(days: 8)),
      'totalPrice': 56,
      'status': 'Completed',
    },
    {
      'id': '3',
      'campName': 'Dead Sea Escape Camp',
      'location': 'Dead Sea, Jordan',
      'startDate': DateTime.now().add(const Duration(days: 12)),
      'endDate': DateTime.now().add(const Duration(days: 14)),
      'totalPrice': 84,
      'status': 'Confirmed',
    },
  ];

  void _cancelBooking(BuildContext context, String bookingId) {
    final index = _bookings.indexWhere((booking) => booking['id'] == bookingId);
    if (index == -1) return;

    setState(() {
      _bookings[index]['status'] = 'Cancelled';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled.')),
    );
  }

  DateTime? _getEndDate(Map<String, dynamic> booking) {
    final end = booking['endDate'];
    if (end is DateTime) return end;
    return null;
  }

  String _getDateText(Map<String, dynamic> booking) {
    final start = booking['startDate'];
    final end = booking['endDate'];

    if (start is DateTime && end is DateTime) {
      final s = start.toString().split(' ').first;
      final e = end.toString().split(' ').first;
      return '$s → $e';
    }

    final date = booking['date'];
    if (date is String && date.isNotEmpty) return date;

    return '—';
  }

  bool _isPast(Map<String, dynamic> booking) {
    final end = _getEndDate(booking);
    if (end == null) return false;
    return end.isBefore(DateTime.now());
  }

  Color _statusColor(String status) {
    if (status == 'Cancelled') return Colors.redAccent;
    if (status == 'Pending') return Colors.orangeAccent;
    if (status == 'Confirmed') return Colors.greenAccent;
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _bookings.where((booking) => !_isPast(booking)).toList();
    final past = _bookings.where((booking) => _isPast(booking)).toList();

    Widget list(List<Map<String, dynamic>> items, {required bool pastList}) {
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
          final booking = items[index];

          final id = booking['id'].toString();
          final name = booking['campName'].toString();
          final location = booking['location'].toString();
          final status = booking['status'].toString();
          final total = booking['totalPrice'] as num;
          final dateText = _getDateText(booking);

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
                        color: _statusColor(status),
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
        body: TabBarView(
          children: [
            list(upcoming, pastList: false),
            list(past, pastList: true),
          ],
        ),
      ),
    );
  }
}
