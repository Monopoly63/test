import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/app_data.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/icon_mapper.dart';

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

  Future<void> _copyText(String text, String ref) async {
    await Clipboard.setData(ClipboardData(text: ref.isEmpty ? text : '$text\n\n$ref'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ نص الذكر في الحافظة', textDirection: TextDirection.rtl)),
    );
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 58, color: Colors.grey[500]),
            const SizedBox(height: 16),
            const Text(
              'لم تضف أي ذكر للمفضلة بعد',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على أيقونة النجمة بجانب الذكر لإضافته',
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
                    Icon(iconForCategory(cat), size: 18, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        cat.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.62),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: 'حفظ نص الذكر',
                      onPressed: () => _copyText(item.text, item.ref),
                      icon: const Icon(Icons.content_copy_outlined),
                      color: AppTheme.primary,
                    ),
                    IconButton(
                      tooltip: 'إزالة من المفضلة',
                      onPressed: () => _removeFav(key),
                      icon: const Icon(Icons.star),
                      color: AppTheme.gold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.text,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.9,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                if (item.ref.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 15,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.ref,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                            fontStyle: FontStyle.italic,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
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
