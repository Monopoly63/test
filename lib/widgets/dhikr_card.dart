import 'package:flutter/material.dart';
import '../models/dhikr_model.dart';
import '../utils/app_theme.dart';

class DhikrCard extends StatelessWidget {
  final int index;
  final DhikrItem item;
  final int remaining;
  final bool isDone;
  final double progress;
  final bool isFav;
  final VoidCallback onCount;
  final VoidCallback onFav;
  final VoidCallback onCopy;

  const DhikrCard({
    super.key,
    required this.index,
    required this.item,
    required this.remaining,
    required this.isDone,
    required this.progress,
    required this.isFav,
    required this.onCount,
    required this.onFav,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDone ? AppTheme.primaryLight : Theme.of(context).dividerColor,
          width: 1.5,
        ),
      ),
      color: isDone
          ? (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1a3323)
              : const Color(0xFFe8f5e9))
          : Theme.of(context).cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.text,
              style: const TextStyle(
                fontSize: 19,
                height: 1.95,
              ),
              textDirection: TextDirection.rtl,
            ),
            if (item.ref.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 16,
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
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).dividerColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (isDone)
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.primaryLight, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'تم',
                        style: TextStyle(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onCount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: Text(
                        item.count > 1 ? '$remaining / ${item.count}' : '$remaining',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                Tooltip(
                  message: 'حفظ نص الذكر',
                  child: IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.content_copy_outlined),
                    color: AppTheme.primary,
                  ),
                ),
                Tooltip(
                  message: isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                  child: IconButton(
                    onPressed: onFav,
                    icon: Icon(isFav ? Icons.star : Icons.star_border),
                    color: isFav ? AppTheme.gold : AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}