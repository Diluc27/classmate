import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeInAnim;
  late final Animation<double> _fadeOutAnim;
  late final Animation<double> _textFadeAnim;
  late final Animation<Offset> _textSlideAnim;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    final reducedMotion =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .reduceMotion;

    if (reducedMotion) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
      _glowAnim =
          Tween<double>(begin: 0.0, end: 0.0).animate(_pulseController);
      _mainController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
      _fadeInAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
      );
      _fadeOutAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
      );
      _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
      );
      _textFadeAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
      );
      _textSlideAnim =
          Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
      );
      _mainController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
        }
      });
      _mainController.forward();
      return;
    }

    // Pulse controller for glow ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Main controller: 1200ms total
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Icon: scale 0.6→1.0 with easeOutBack (0-350ms)
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );

    // Icon: fade-in 0→1 (0-250ms)
    _fadeInAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // Text: fade in + slide up (200-500ms)
    _textFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeOut),
      ),
    );
    _textSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Crossfade-out (850-1200ms)
    _fadeOutAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });
      }
    });

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _pulseController]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF1D4ED8),
                  Color(0xFF7C3AED),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Opacity(
              opacity: _fadeOutAnim.value,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pulsing glow ring behind icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        Container(
                          width: 140 + (20 * _glowAnim.value),
                          height: 140 + (20 * _glowAnim.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(
                                  alpha: 0.15 + 0.1 * _glowAnim.value),
                              width: 2,
                            ),
                          ),
                        ),
                        // Inner glow
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                    alpha: 0.1 * _glowAnim.value),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        // Icon
                        Transform.scale(
                          scale: _scaleAnim.value,
                          child: Opacity(
                            opacity: _fadeInAnim.value,
                            child: Image.asset(
                              'assets/icon/icon_light.png',
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // App name with slide-up fade-in
                    SlideTransition(
                      position: _textSlideAnim,
                      child: Opacity(
                        opacity: _textFadeAnim.value,
                        child: Column(
                          children: [
                            Text(
                              'Ateno',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Your Student Planner',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
