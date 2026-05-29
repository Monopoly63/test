import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FilterChips extends StatelessWidget {
  final List<String> groups;
  final String? activeGroup;
  final Function(String?) onSelect;

  const FilterChips({
    super.key,
    required this.groups,
    required this.activeGroup,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          _buildChip(context, 'الكل', activeGroup == null, () => onSelect(null)),
          ...groups.map((g) => _buildChip(context, g, activeGroup == g, () => onSelect(g))),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: isActive ? AppTheme.primary : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? AppTheme.primary : Theme.of(context).dividerColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}