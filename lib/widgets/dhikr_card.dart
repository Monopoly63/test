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
            // Number badge
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
            // Dhikr text
            Text(
              item.text,
              style: const TextStyle(
                fontSize: 19,
                fontFamily: 'Amiri',
                height: 1.95,
              ),
              textDirection: TextDirection.rtl,
            ),
            // Reference
            if (item.ref.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '📚 ${item.ref}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                  fontStyle: FontStyle.italic,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
            const SizedBox(height: 12),
            // Progress bar
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
            // Footer
            Row(
              children: [
                // Count button or done text
                if (isDone)
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.primaryLight, size: 20),
                      SizedBox(width: 4),
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
                  ElevatedButton(
                    onPressed: onCount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    ),
                    child: Text(
                      item.count > 1 ? '$remaining / ${item.count}' : '$remaining',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                const Spacer(),
                // Fav button
                GestureDetector(
                  onTap: onFav,
                  child: Text(
                    isFav ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 24),
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