import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    
    // Navigate langsung ke onboarding setelah frame pertama di-render
    // tanpa animasi, delay minimal untuk memastikan context tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/onboarding');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple splash screen dengan warna ungu dan logo di tengah
    // Tidak ada animasi, sama seperti native splash screen
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryPurple,
        child: Center(
          child: Image.asset(
            'assets/images/lentera-karir.png',
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
