import 'package:flutter/material.dart';
import '../models/app_data.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  final Map<String, bool> favs;
  final VoidCallback onFavChanged;

  const FavoritesScreen({
    super.key,
    required this.favs,
    required this.onFavChanged,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Map<String, bool> _favs;

  @override
  void initState() {
    super.initState();
    _favs = Map.from(widget.favs);
  }

  @override
  void didUpdateWidget(FavoritesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _favs = Map.from(widget.favs);
  }

  void _removeFav(String key) {
    setState(() {
      _favs[key] = false;
    });
    StorageService.saveFavs(_favs);
    widget.onFavChanged();
  }

  @override
  Widget build(BuildContext context) {
    final favItems = <Map<String, dynamic>>[];
    for (final cat in appData) {
      for (int i = 0; i < cat.items.length; i++) {
        final key = '${cat.category}_$i';
        if (_favs[key] == true) {
          favItems.add({
            'key': key,
            'cat': cat,
            'item': cat.items[i],
          });
        }
      }
    }

    if (favItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⭐', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text(
              'لم تضف أي ذكر للمفضلة بعد',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 8),
            Text(
              'اضغط ☆ على أي ذكر لإضافته',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favItems.length,
      itemBuilder: (ctx, index) {
        final data = favItems[index];
        final cat = data['cat'] as dynamic;
        final item = data['item'] as dynamic;
        final key = data['key'] as String;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${cat.icon} ${cat.category}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _removeFav(key),
                      child: const Text('⭐', style: TextStyle(fontSize: 22)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    height: 1.9,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                if (item.ref.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '📚 ${item.ref}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}