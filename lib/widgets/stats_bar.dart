import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StatsBar extends StatelessWidget {
  final int total;
  final int done;
  final int cats;
  final int favs;

  const StatsBar({
    super.key,
    required this.total,
    required this.done,
    required this.cats,
    required this.favs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          _buildStat(context, '$total', 'إجمالي الأذكار'),
          _divider(context),
          _buildStat(context, '$done', 'مكتملة'),
          _divider(context),
          _buildStat(context, '$cats', 'الأقسام'),
          _divider(context),
          _buildStat(context, '$favs', 'المفضلة'),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String num, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(
              num,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                fontFamily: 'Amiri',
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Theme.of(context).dividerColor,
    );
  }
}