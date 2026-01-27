import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/widgets/universal/layout/header_banner.dart';
import 'package:lentera_karir/screens/profile/help_center.dart';
import 'package:lentera_karir/screens/profile/contact_us.dart';
import 'package:lentera_karir/screens/profile/setting.dart';
import 'package:lentera_karir/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return Column(
            children: [
              // Header Banner with pattern - menggunakan widget HeaderBanner
              HeaderBanner(
                height: 306,
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar - using same style as home.dart, 2x size (radius 66)
                        CircleAvatar(
                          radius: 66,
                          backgroundColor: AppColors.divider,
                          backgroundImage: user?.avatar != null 
                            ? NetworkImage(user!.avatar!)
                            : null,
                          child: user?.avatar == null ? const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 80,
                          ) : null,
                        ),
                        const SizedBox(height: 12),
                        // User name
                        Text(
                          user?.name ?? 'User',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // White area with menu items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 31,
                    right: 31,
                    top: 34,
                    bottom: 100,
                  ),
                  child: Column(
                    children: [
                      // Menu items
                      _buildMenuItem(
                        icon: 'assets/profile/help_center.svg',
                        title: 'Help Center',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildMenuItem(
                        icon: 'assets/profile/contact_us.svg',
                        title: 'Contact Us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactUsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                  _buildMenuItem(
                    icon: 'assets/profile/setting.svg',
                    title: 'Setting',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ),
                      );
                    },
                  ),
                      const SizedBox(height: 15),
                      _buildMenuItem(
                        icon: 'assets/profile/logout.svg',
                        title: 'Logout',
                        onTap: () => _showLogoutDialog(context, authProvider),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavBottom(currentIndex: 4),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                SvgPicture.asset(
                  'assets/profile/popup_logout.svg',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Logout?',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  'Apa kamu yakin ingin keluar\ndari aplikasi ini?',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    // Keluar button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await authProvider.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Keluar',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Batal button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Batal',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        splashColor: AppColors.primaryPurple.withValues(alpha: 0.1),
        highlightColor: AppColors.primaryPurple.withValues(alpha: 0.05),
        child: Container(
          height: 49,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFF9F9F9),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Icon
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  titleColor ?? AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: titleColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFB2B2B2),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}