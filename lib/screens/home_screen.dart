import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/matches_provider.dart';
import 'matches/matches_list_screen.dart';
import 'more_screen.dart';
import 'quiz/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Quiz is index 0 — primary screen
  int _currentIndex = 0;

  final List<_NavItem> _items = const [
    _NavItem(
      label: 'Live',
      icon: Icons.fiber_manual_record,
      activeIcon: Icons.fiber_manual_record,
      matchType: MatchType.live,
    ),
    _NavItem(
      label: 'Today',
      icon: Icons.today_outlined,
      activeIcon: Icons.today,
      matchType: MatchType.today,
    ),
    _NavItem(
      label: 'Yesterday',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      matchType: MatchType.yesterday,
    ),
    _NavItem(
      label: 'Tomorrow',
      icon: Icons.event_outlined,
      activeIcon: Icons.event,
      matchType: MatchType.tomorrow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Quiz=0, match tabs=1..4, More=5
    final isQuizTab = _currentIndex == 0;
    final isMoreTab = _currentIndex == 5;
    final hideAppBar = isQuizTab || isMoreTab;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: hideAppBar
          ? null
          : AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    color: isDark ? AppColors.primary : Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Takort',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const QuizScreen(),
          ..._items.map(
            (item) => MatchesListScreen(
              matchType: item.matchType,
              autoRefresh: item.matchType == MatchType.live,
            ),
          ),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          ..._items.map(
            (item) => BottomNavigationBarItem(
              icon: _navIcon(item, false),
              activeIcon: _navIcon(item, true),
              label: item.label,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _navIcon(_NavItem item, bool active) {
    if (item.matchType == MatchType.live) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(active ? item.activeIcon : item.icon),
          if (active)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.live,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    }
    return Icon(active ? item.activeIcon : item.icon);
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final MatchType matchType;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.matchType,
  });
}
