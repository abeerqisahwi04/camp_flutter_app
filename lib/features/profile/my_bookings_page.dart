import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  static final List<Map<String, dynamic>> _mockBookings = [
    {
      'campName': 'Wadi Rum Desert Camp',
      'location': 'Wadi Rum, Jordan',
      'startDate': DateTime.now().add(const Duration(days: 3)),
      'endDate': DateTime.now().add(const Duration(days: 5)),
      'status': 'Pending',
    },
    {
      'campName': 'Ajloun Forest Camp',
      'location': 'Ajloun, Jordan',
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'endDate': DateTime.now().subtract(const Duration(days: 8)),
      'status': 'Completed',
    },
    {
      'campName': 'Dead Sea Escape Camp',
      'location': 'Dead Sea, Jordan',
      'startDate': DateTime.now().add(const Duration(days: 7)),
      'endDate': DateTime.now().add(const Duration(days: 9)),
      'status': 'Confirmed',
    },
  ];

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('cancel')) return Colors.redAccent;
    if (s.contains('pending')) return Colors.orangeAccent;
    if (s.contains('confirm') || s.contains('approved')) return kAccent;
    return Colors.white70;
  }

  String _formatDateRange(Map<String, dynamic> b) {
    final start = b['startDate'];
    final end = b['endDate'];

    if (start is DateTime && end is DateTime) {
      final s = start.toString().split(' ').first;
      final e = end.toString().split(' ').first;
      return '$s → $e';
    }

    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _mockBookings.isEmpty
          ? const Center(
              child: Text(
                'No bookings yet.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockBookings.length,
              itemBuilder: (context, index) {
                final b = _mockBookings[index];

                final title = b['campName'].toString();
                final location = b['location'].toString();
                final status = b['status'].toString();
                final dateText = _formatDateRange(b);

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
            ),
    );
  }
}
