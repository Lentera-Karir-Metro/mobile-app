import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Model data untuk setiap halaman onboarding
class OnboardingData {
  final String illustration;
  final String title;
  final String description;

  OnboardingData({
    required this.illustration,
    required this.title,
    required this.description,
  });
}

/// Screen onboarding dengan 3 halaman
/// Menampilkan intro app sebelum masuk ke login
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Data untuk 3 halaman onboarding
  final List<OnboardingData> _onboardingPages = [
    OnboardingData(
      illustration: 'assets/welcome/onboarding1.svg',
      title: 'Temukan Arah Kariermu\nMulai dari Sini',
      description:
          'Membantu fresh graduate mempersiapkan diri menghadapi dunia kerja dengan bimbingan',
    ),
    OnboardingData(
      illustration: 'assets/welcome/onboarding2.svg',
      title: 'Hadir untuk Perjalanan\nKarier Profesionalmu',
      description:
          'Menjawab tantangan seperti kebingungan arah hingga rasa kurang percaya diri.',
    ),
    OnboardingData(
      illustration: 'assets/welcome/onboarding3.svg',
      title: 'Kami Memberikan\nStrategi yang Tepat',
      description:
          'Membangun fondasi profesional yang kuat sejak langkah pertama dengan pengalaman yang interaktif',
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Setup fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );
    
    // Start fade in animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Navigate ke halaman berikutnya atau ke login jika sudah halaman terakhir
  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Halaman terakhir, ke login
      context.go('/login');
    }
  }

  /// Skip onboarding dan langsung ke login
  void _skipToLogin() {
    context.go('/login');
  }

  /// Build page indicator (dots)
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primaryPurple
                : AppColors.textSecondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// Build single onboarding page
  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        children: [
          // Ilustrasi SVG
          Expanded(
            flex: 3,
            child: Center(
              child: SvgPicture.asset(
                data.illustration,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Page Indicator
          _buildPageIndicator(),

          const SizedBox(height: 40),

          // Title
          Text(
            data.title,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
            // Skip button (top right)
            // Align(
            //   alignment: Alignment.topRight,
            //   child: TextButton(
            //     onPressed: _skipToLogin,
            //     child: Text(
            //       'Lewati',
            //       style: AppTextStyles.body1.copyWith(
            //         color: AppColors.textSecondary,
            //       ),
            //     ),
            //   ),
            // ),

            // PageView dengan 3 halaman
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_onboardingPages[index]);
                },
              ),
            ),

            // Bottom button
            Padding(
              padding: EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: [
                  // Primary button (Get Started / Lanjut)
                  PrimaryButton(
                    text: _currentPage == _onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Lanjut',
                    onPressed: _nextPage,
                    width: double.infinity,
                  ),

                  const SizedBox(height: 16),

                  // Already have account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _skipToLogin,
                        child: Text(
                          'Login',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
