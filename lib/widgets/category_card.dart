import 'package:flutter/material.dart';
import '../models/dhikr_model.dart';
import '../utils/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final DhikrCategory category;
  final double progress;
  final bool allDone;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.allDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryLight, AppTheme.gold],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
              ),
            ),
            if (allDone)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'مكتمل ✓',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.category,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${category.items.length} ذكر',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Theme.of(context).dividerColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}