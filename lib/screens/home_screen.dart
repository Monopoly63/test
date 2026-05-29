import 'package:flutter/material.dart';
import '../models/app_data.dart';
import '../models/dhikr_model.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/stats_bar.dart';
import 'dhikr_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final double fontScale;
  final String fontFamily;
  final VoidCallback onToggleTheme;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<String> onFontFamilyChanged;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.fontScale,
    required this.fontFamily,
    required this.onToggleTheme,
    required this.onFontScaleChanged,
    required this.onFontFamilyChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _activeGroup;
  String _searchQuery = '';
  Map<String, int> _state = {};
  Map<String, bool> _favs = {};
  final TextEditingController _searchController = TextEditingController();

  List<String> get _groups {
    return appData.map((c) => c.group).toSet().toList();
  }

  @override
  void initState() {
    super.initState();
    _state = StorageService.getState();
    _favs = StorageService.getFavs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshState() {
    setState(() {
      _state = StorageService.getState();
      _favs = StorageService.getFavs();
    });
  }

  int _getRemaining(String catName, int idx, int total) {
    final key = '${catName}_$idx';
    return _state[key] ?? total;
  }

  List<DhikrCategory> get _filteredCategories {
    var cats = appData.toList();
    if (_activeGroup != null) {
      cats = cats.where((c) => c.group == _activeGroup).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      cats = cats
          .where((c) => c.category.contains(q) || c.items.any((i) => i.text.contains(q)))
          .toList();
    }
    return cats;
  }

  int get _totalDhikr => appData.fold(0, (s, c) => s + c.items.length);

  int get _doneDhikr {
    int done = 0;
    for (final cat in appData) {
      for (int i = 0; i < cat.items.length; i++) {
        if (_getRemaining(cat.category, i, cat.items[i].count) == 0) {
          done++;
        }
      }
    }
    return done;
  }

  int get _favCount => _favs.values.where((v) => v).length;

  void _resetAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة تعيين', textDirection: TextDirection.rtl),
        content: const Text('هل تريد إعادة تعيين جميع الأذكار؟', textDirection: TextDirection.rtl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _state = {};
                StorageService.saveState(_state);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت إعادة تعيين الكل', textDirection: TextDirection.rtl)),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _openCategory(DhikrCategory cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DhikrScreen(
          category: cat,
          state: _state,
          favs: _favs,
          onStateChanged: _refreshState,
        ),
      ),
    ).then((_) => _refreshState());
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDark: widget.isDark,
          fontScale: widget.fontScale,
          fontFamily: widget.fontFamily,
          onToggleTheme: widget.onToggleTheme,
          onFontScaleChanged: widget.onFontScaleChanged,
          onFontFamilyChanged: widget.onFontFamilyChanged,
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  Widget _buildHomeBody() {
    final cats = _filteredCategories;
    return Column(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            controller: _searchController,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'ابحث عن قسم أو ذكر...',
              hintTextDirection: TextDirection.rtl,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryLight),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
          ),
        ),
        StatsBar(
          total: _totalDhikr,
          done: _doneDhikr,
          cats: appData.length,
          favs: _favCount,
        ),
        FilterChips(
          groups: _groups,
          activeGroup: _activeGroup,
          onSelect: (group) {
            setState(() {
              _activeGroup = group;
            });
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 4),
          child: Text(
            'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
            style: TextStyle(
              fontSize: 22,
              color: AppTheme.gold,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 6),
          child: Divider(color: AppTheme.gold.withOpacity(0.65), thickness: 1),
        ),
        Expanded(
          child: cats.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد نتائج',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: cats.length,
                  itemBuilder: (ctx, index) {
                    final cat = cats[index];
                    final doneItems = cat.items.asMap().entries
                        .where((e) => _getRemaining(cat.category, e.key, e.value.count) == 0)
                        .length;
                    final progress = cat.items.isNotEmpty ? doneItems / cat.items.length : 0.0;
                    final allDone = doneItems == cat.items.length;

                    return CategoryCard(
                      category: cat,
                      progress: progress,
                      allDone: allDone,
                      onTap: () => _openCategory(cat),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_awesome_outlined, color: AppTheme.goldLight, size: 20),
            SizedBox(width: 8),
            Text(
              'تذكر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.goldLight,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: _openNotifications,
          ),
          IconButton(
            tooltip: widget.isDark ? 'الوضع النهاري' : 'الوضع الليلي',
            icon: Icon(widget.isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeBody()
          : FavoritesScreen(
              favs: _favs,
              onFavChanged: _refreshState,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _resetAll();
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'إعادة الكل',
          ),
        ],
      ),
    );
  }
}
