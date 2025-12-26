import 'product.dart';

const List<String> kCategories = [
  'All',
  'Tents',
  'Sleeping',
  'Cooking',
  'Lighting',
];

const List<Product> kProducts = [
  Product(
    id: 'p1',
    name: '2-Person Dome Tent',
    price: 89.99,
    category: 'Tents',
    description:
        'Lightweight dome tent with easy setup, rainfly included, perfect for weekend trips.',
    imageUrl:
        'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&w=1200&q=80',
    options: ['Green', 'Orange'],
  ),
  Product(
    id: 'p2',
    name: '4-Person Family Tent',
    price: 159.50,
    category: 'Tents',
    description:
        'Spacious tent with ventilation windows and strong poles for windy nights.',
    imageUrl:
        'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?auto=format&fit=crop&w=1200&q=80',
    options: ['4P', '6P'],
  ),
  Product(
    id: 'p3',
    name: 'Sleeping Bag -10°C',
    price: 49.50,
    category: 'Sleeping',
    description:
        'Warm sleeping bag rated for cold nights, soft inner lining, packs small.',
    imageUrl:
        'https://images.unsplash.com/photo-1526481280695-3c687fd5432c?auto=format&fit=crop&w=1200&q=80',
    options: ['Regular', 'Long'],
  ),
  Product(
    id: 'p4',
    name: 'Inflatable Sleeping Pad',
    price: 29.99,
    category: 'Sleeping',
    description:
        'Comfortable inflatable pad with quick valve, great insulation from the ground.',
    imageUrl:
        'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6?auto=format&fit=crop&w=1200&q=80',
    options: ['Single', 'Wide'],
  ),
  Product(
    id: 'p5',
    name: 'Portable Camping Stove',
    price: 34.99,
    category: 'Cooking',
    description:
        'Compact stove with stable pot supports, ideal for quick meals outdoors.',
    imageUrl:
        'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=80',
    options: ['Gas', 'Multi-fuel'],
  ),
  Product(
    id: 'p6',
    name: 'Titanium Cook Set',
    price: 42.00,
    category: 'Cooking',
    description:
        'Lightweight pot + pan set, easy to clean, perfect for hikers and campers.',
    imageUrl:
        'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?auto=format&fit=crop&w=1200&q=80',
    options: ['1L', '1.5L'],
  ),
  Product(
    id: 'p7',
    name: 'LED Lantern (Rechargeable)',
    price: 19.99,
    category: 'Lighting',
    description:
        'Bright lantern with multiple modes, rechargeable battery, hangs inside tents.',
    imageUrl:
        'https://images.unsplash.com/photo-1603570419985-6f6f2d8d64a7?auto=format&fit=crop&w=1200&q=80',
    options: ['Warm', 'Cool'],
  ),
  Product(
    id: 'p8',
    name: 'Headlamp 300lm',
    price: 14.50,
    category: 'Lighting',
    description:
        'Hands-free headlamp with strong beam and long battery life for night walks.',
    imageUrl:
        'https://images.unsplash.com/photo-1520975958225-7b0bf7c2c5a8?auto=format&fit=crop&w=1200&q=80',
    options: ['Standard', 'Pro'],
  ),
];
