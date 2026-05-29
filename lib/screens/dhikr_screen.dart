import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dhikr_model.dart';
import '../services/storage_service.dart';
import '../utils/icon_mapper.dart';
import '../widgets/dhikr_card.dart';

class DhikrScreen extends StatefulWidget {
  final DhikrCategory category;
  final Map<String, int> state;
  final Map<String, bool> favs;
  final VoidCallback onStateChanged;

  const DhikrScreen({
    super.key,
    required this.category,
    required this.state,
    required this.favs,
    required this.onStateChanged,
  });

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> {
  late Map<String, int> _state;
  late Map<String, bool> _favs;

  @override
  void initState() {
    super.initState();
    _state = Map.from(widget.state);
    _favs = Map.from(widget.favs);
  }

  String _getKey(int idx) => '${widget.category.category}_$idx';

  int _getRemaining(int idx) {
    final key = _getKey(idx);
    return _state[key] ?? widget.category.items[idx].count;
  }

  void _decrement(int idx) {
    final key = _getKey(idx);
    int rem = _getRemaining(idx);
    if (rem <= 0) return;
    rem--;
    setState(() {
      _state[key] = rem;
    });
    StorageService.saveState(_state);
    widget.onStateChanged();

    if (rem == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أحسنت! تم الانتهاء', textDirection: TextDirection.rtl),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleFav(int idx) {
    final key = _getKey(idx);
    setState(() {
      _favs[key] = !(_favs[key] ?? false);
    });
    StorageService.saveFavs(_favs);
    widget.onStateChanged();
  }

  Future<void> _copyDhikr(int idx) async {
    final item = widget.category.items[idx];
    final text = item.ref.isEmpty ? item.text : '${item.text}\n\n${item.ref}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ نص الذكر في الحافظة', textDirection: TextDirection.rtl),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetCategory() {
    setState(() {
      for (int i = 0; i < widget.category.items.length; i++) {
        _state.remove(_getKey(i));
      }
    });
    StorageService.saveState(_state);
    widget.onStateChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إعادة تعيين القسم', textDirection: TextDirection.rtl),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconForCategory(widget.category), size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.category.category,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _resetCategory,
            icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
            label: const Text('إعادة', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.category.items.length,
        itemBuilder: (ctx, idx) {
          final item = widget.category.items[idx];
          final remaining = _getRemaining(idx);
          final isDone = remaining == 0;
          final progress = item.count > 0 ? (item.count - remaining) / item.count : 1.0;
          final isFav = _favs[_getKey(idx)] ?? false;

          return DhikrCard(
            index: idx,
            item: item,
            remaining: remaining,
            isDone: isDone,
            progress: progress,
            isFav: isFav,
            onCount: () => _decrement(idx),
            onFav: () => _toggleFav(idx),
            onCopy: () => _copyDhikr(idx),
          );
        },
      ),
    );
  }
}
