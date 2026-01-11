import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Bottom Navigation Bar dengan 4 tab navigasi
/// Menampilkan warna ungu (#661FFF) pada tab yang aktif
class NavBottom extends StatelessWidget {
  /// Index tab yang aktif (0: Home, 1: Explore, 2: Learn Path, 3: Profile)
  final int currentIndex;

  const NavBottom({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Menggunakan AppDimensions.bottomNavHeight (107px dari analisis UI/UX)
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        // Background putih keabu-abuan sesuai design
        color: AppColors.cardBackground,
        // Border radius atas menggunakan AppDimensions.screenRadius (20px)
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.screenRadius),
          topRight: Radius.circular(AppDimensions.screenRadius),
        ),
        // Shadow subtle di bagian atas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        // Padding horizontal menggunakan AppDimensions.screenPadding (16px)
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Tab Home
            _NavItem(
              icon: 'assets/navbottom/home.svg',
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => context.go('/home'),
            ),
            // Tab Explore
            _NavItem(
              icon: 'assets/navbottom/explore.svg',
              label: 'Explore',
              isActive: currentIndex == 1,
              onTap: () => context.go('/explore'),
            ),
            // Tab Learn Path
            _NavItem(
              icon: 'assets/navbottom/learn-path.svg',
              label: 'Learn Path',
              isActive: currentIndex == 2,
              onTap: () => context.go('/learn-path'),
            ),
            // Tab Profile
            _NavItem(
              icon: 'assets/navbottom/profile.svg',
              label: 'Profile',
              isActive: currentIndex == 3,
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget item navigasi individual
class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon SVG dengan ukuran AppDimensions.iconLarge (24px)
            SvgPicture.asset(
              icon,
              width: AppDimensions.iconLarge,
              height: AppDimensions.iconLarge,
              colorFilter: ColorFilter.mode(
                // Warna ungu saat active, abu-abu saat inactive
                isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            // Label menggunakan AppTextStyles.label
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                // Warna ungu saat active, abu-abu saat inactive
                color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                // Font weight lebih tebal saat active
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
