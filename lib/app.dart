import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/theme_provider.dart';
import 'core/providers/calendar_provider.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/speed_dial_fab.dart';
import 'core/utils/constants.dart';
import 'core/utils/navigation.dart';
import 'core/services/notification_service.dart';
import 'core/providers/database_provider.dart';
import 'features/splash/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/add_class_entry_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/subjects/subjects_screen.dart';
import 'features/subjects/add_edit_subject_screen.dart';
import 'features/subjects/subject_detail_screen.dart';
import 'features/planner/planner_screen.dart';
import 'features/planner/add_edit_deadline_screen.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _calendarNavigatorKey = GlobalKey<NavigatorState>();
final _subjectsNavigatorKey = GlobalKey<NavigatorState>();
final _plannerNavigatorKey = GlobalKey<NavigatorState>();

final _branchNavigatorKeys = [
  _homeNavigatorKey,
  _calendarNavigatorKey,
  _subjectsNavigatorKey,
  _plannerNavigatorKey,
];

final _branchRouteRefresh = ValueNotifier<int>(0);
final _branchRouteDepths = [0, 0, 0, 0];

class _BranchRouteObserver extends NavigatorObserver {
  final int branchIndex;

  _BranchRouteObserver(this.branchIndex);

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _branchRouteRefresh.value++;
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _branchRouteDepths[branchIndex]++;
    _notify();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (_branchRouteDepths[branchIndex] > 0) {
      _branchRouteDepths[branchIndex]--;
    }
    _notify();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (_branchRouteDepths[branchIndex] > 0) {
      _branchRouteDepths[branchIndex]--;
    }
    _notify();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notify();
  }
}

class AtenoApp extends ConsumerStatefulWidget {
  const AtenoApp({super.key});

  @override
  ConsumerState<AtenoApp> createState() => _AtenoAppState();
}

class _AtenoAppState extends ConsumerState<AtenoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _branchRouteDepths.fillRange(0, _branchRouteDepths.length, 0);
    _branchRouteRefresh.value = 0;
    shellOverlayDepth.value = 0;

    // Deferred cleanup of expired recurring notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cleanupExpiredNotifications();
    });
  }

  Future<void> _cleanupExpiredNotifications() async {
    try {
      final notificationService = NotificationService();
      await notificationService.init();
      final db = ref.read(databaseProvider);
      final deadlines = await db.deadlineDao.getDeadlinesWithReminders();
      await notificationService.cancelExpiredRecurring(deadlines);
      // Re-schedule all active reminders with alarmClock-based one-shots
      await notificationService.rescheduleAll(deadlines);
    } catch (_) {
      // Silently handle — not critical for startup
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (shellOverlayDepth.value > 0) return false;

    final path = _router.routeInformationProvider.value.uri.path;
    if (path != '/home' && path != '/splash') {
      _router.go('/home');
      return true;
    }

    return false;
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeModeProvider);
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final colorMode = switch (themePreference) {
      AppThemePreference.light => AppColorMode.light,
      AppThemePreference.dark => AppColorMode.dark,
      AppThemePreference.amoled => AppColorMode.amoled,
      AppThemePreference.system =>
        platformBrightness == Brightness.dark
            ? AppColorMode.dark
            : AppColorMode.light,
    };

    AppColors.setMode(colorMode);

    return MaterialApp.router(
      title: 'Ateno',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: flutterThemeMode(themePreference),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashScreen()),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _RootShell(navigationShell: navigationShell),
      branches: [
        // ── Home tab ──
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          observers: [_BranchRouteObserver(0)],
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
            GoRoute(
              path: '/add-class',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AddClassEntryScreen()),
            ),
          ],
        ),
        // ── Calendar tab ──
        StatefulShellBranch(
          navigatorKey: _calendarNavigatorKey,
          observers: [_BranchRouteObserver(1)],
          routes: [
            GoRoute(
              path: '/calendar',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CalendarScreen()),
            ),
          ],
        ),
        // ── Subjects tab ──
        StatefulShellBranch(
          navigatorKey: _subjectsNavigatorKey,
          observers: [_BranchRouteObserver(2)],
          routes: [
            GoRoute(
              path: '/subjects',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SubjectsScreen()),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) =>
                      const AddEditSubjectScreen(mode: FormMode.add),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => SubjectDetailScreen(
                    subjectId: int.parse(state.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => AddEditSubjectScreen(
                        mode: FormMode.edit,
                        subjectId: int.parse(state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // ── Planner tab ──
        StatefulShellBranch(
          navigatorKey: _plannerNavigatorKey,
          observers: [_BranchRouteObserver(3)],
          routes: [
            GoRoute(
              path: '/planner',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PlannerScreen()),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) =>
                      const AddEditDeadlineScreen(mode: FormMode.add),
                ),
                GoRoute(
                  path: ':id/edit',
                  builder: (context, state) => AddEditDeadlineScreen(
                    mode: FormMode.edit,
                    deadlineId: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const _UnknownDeepLinkFallback(),
);

class _UnknownDeepLinkFallback extends StatefulWidget {
  const _UnknownDeepLinkFallback();

  @override
  State<_UnknownDeepLinkFallback> createState() =>
      _UnknownDeepLinkFallbackState();
}

class _UnknownDeepLinkFallbackState extends State<_UnknownDeepLinkFallback> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        GoRouter.of(context).go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _RootShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const _RootShell({required this.navigationShell});

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell>
    with SingleTickerProviderStateMixin {
  bool _handlingBack = false;
  late final AnimationController _tabFadeController;
  late final Animation<double> _tabFadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _tabFadeAnimation = CurvedAnimation(
      parent: _tabFadeController,
      curve: Curves.easeOutCubic,
    );
    _tabFadeController.value = 1.0;
  }

  @override
  void dispose() {
    _tabFadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _RootShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell.currentIndex;
    if (newIndex != oldWidget.navigationShell.currentIndex) {
      _tabFadeController.forward(from: 0.0);
    }
  }

  NavigatorState? get _currentBranchNavigator =>
      _branchNavigatorKeys[widget.navigationShell.currentIndex].currentState;

  void _goBranch(int index, {bool initialLocation = false}) {
    widget.navigationShell.goBranch(index, initialLocation: initialLocation);
  }

  void _handleSystemBack(BuildContext context) {
    if (_handlingBack) return;
    _handlingBack = true;
    try {
      final navigator = Navigator.of(context);
      final branchNavigator = _currentBranchNavigator;

      if (shellOverlayDepth.value > 0) {
        navigator.pop();
        return;
      }
      if (navigator.canPop()) {
        navigator.pop();
        return;
      }
      if (branchNavigator != null && branchNavigator.canPop()) {
        branchNavigator.pop();
        return;
      }
      if (widget.navigationShell.currentIndex != 0) {
        _goBranch(0, initialLocation: true);
        return;
      }
      SystemNavigator.pop();
    } finally {
      _handlingBack = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shellOverlayDepth,
      builder: (context, overlayDepth, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _branchRouteRefresh,
          builder: (context, _, _) {
            final branchCanPop = _currentBranchNavigator?.canPop() ?? false;
            final branchDepth =
                _branchRouteDepths[widget.navigationShell.currentIndex];
            final showShellFab =
                overlayDepth == 0 && !branchCanPop && branchDepth <= 1;
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleSystemBack(context);
              },
              child: Scaffold(
                body: FadeTransition(
                  opacity: _tabFadeAnimation,
                  child: widget.navigationShell,
                ),
                floatingActionButton: showShellFab
                    ? SpeedDialFAB(
                        actions: [
                          SpeedDialAction(
                            icon: Icons.add_rounded,
                            label: 'Add Class',
                            onTap: () {
                              final container = ProviderScope.containerOf(context, listen: false);
                              final selectedDate = container.read(selectedDateProvider);
                              openAddClassSheet(
                                context,
                                topRadius: 20,
                                selectedDate: selectedDate,
                              );
                            },
                          ),
                          SpeedDialAction(
                            icon: Icons.book_outlined,
                            label: 'Add Subject',
                            onTap: () => context.push('/subjects/add'),
                          ),
                          SpeedDialAction(
                            icon: Icons.event_note_outlined,
                            label: 'Add Deadline',
                            onTap: () => context.push('/planner/add'),
                          ),
                        ],
                      )
                    : null,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(4, (index) {
                          final isSelected = widget.navigationShell.currentIndex == index;
                          final icons = [
                            [Icons.home_rounded, Icons.home_outlined],
                            [Icons.calendar_month_rounded, Icons.calendar_month_outlined],
                            [Icons.auto_stories_rounded, Icons.auto_stories_outlined],
                            [Icons.assignment_rounded, Icons.assignment_outlined],
                          ];
                          final labels = ['Home', 'Calendar', 'Subjects', 'Planner'];
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _goBranch(index),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 250),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        isSelected ? icons[index][0] : icons[index][1],
                                        key: ValueKey('nav_${index}_$isSelected'),
                                        size: isSelected ? 26 : 24,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: TextStyle(
                                        fontSize: isSelected ? 11.5 : 11,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textMuted,
                                      ),
                                      child: Text(labels[index]),
                                    ),
                                    const SizedBox(height: 3),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOutCubic,
                                      width: isSelected ? 20 : 0,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
