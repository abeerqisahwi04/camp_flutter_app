import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/shop/checkout_page.dart';
import 'package:flutter_application_1/features/shop/product.dart';

class CartItem {
  final Product product;
  final String option;
  int qty;

  CartItem({required this.product, required this.option, this.qty = 1});
}

class CartStore {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => _items;

  static void add(Product p, String option) {
    final existing = _items
        .where((x) => x.product.id == p.id && x.option == option)
        .toList();
    if (existing.isNotEmpty) {
      existing.first.qty += 1;
    } else {
      _items.add(CartItem(product: p, option: option, qty: 1));
    }
  }

  static void removeAt(int index) => _items.removeAt(index);

  static double total() {
    double t = 0;
    for (final i in _items) {
      t += i.product.price * i.qty;
    }
    return t;
  }

  static void clear() => _items.clear();
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = CartStore.items;

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15252A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.network(
                              item.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF0B1A1D),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white54,
                                ),
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
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Option: ${item.option}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${item.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: kAccent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(() {
                                    if (item.qty > 1) item.qty--;
                                  }),
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  '${item.qty}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => item.qty++),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () =>
                                  setState(() => CartStore.removeAt(index)),
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15252A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '\$${CartStore.total().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: kAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
    );
  }
}
