import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية للعرض
    final orders = [
      {"title": "Wadi Rum Camp", "date": "12 Jan 2026", "status": "Confirmed"},
      {"title": "Dead Sea Camp", "date": "20 Jan 2026", "status": "Pending"},
      {"title": "Ajloun Forest", "date": "5 Feb 2026", "status": "Cancelled"},
    ];

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final o = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF15252A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                o["title"]!,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                o["date"]!,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              trailing: Text(
                o["status"]!,
                style: TextStyle(
                  color: o["status"] == "Confirmed"
                      ? kAccent
                      : (o["status"] == "Cancelled"
                            ? Colors.redAccent
                            : Colors.orangeAccent),
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
