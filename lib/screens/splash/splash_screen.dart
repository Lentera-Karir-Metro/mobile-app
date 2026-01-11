import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/styles.dart';
import '../../widgets/splash/animated_circles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation untuk logo yang muncul setelah circles
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Delay untuk logo muncul setelah circular animation dimulai
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _logoController.forward();
      }
    });

    // Navigate setelah animasi selesai (3 detik total)
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryPurple,
              AppColors.primaryPurple.withValues(alpha: 0.85),
              AppColors.primaryDark,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Circles Background
            Positioned.fill(
              child: AnimatedCircles(),
            ),
            
            // Logo di tengah dengan animasi
            Center(
              child: ScaleTransition(
                scale: _logoScaleAnimation,
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: Image.asset(
                    'assets/images/lentera-karir.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
