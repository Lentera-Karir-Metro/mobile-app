import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Bottom Navigation Bar dengan 5 tab navigasi termasuk tombol AI di tengah
/// Menampilkan warna ungu (#661FFF) pada tab yang aktif
/// Index: 0=Home, 1=Explore, 2=AI Assistant, 3=Learn Path, 4=Profile
class NavBottom extends StatelessWidget {
  /// Index tab yang aktif (0: Home, 1: Explore, 2: AI, 3: Learn Path, 4: Profile)
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
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Regular nav items
          Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final horizontalPadding = screenWidth < 360 ? 8.0 : (screenWidth < 400 ? 12.0 : AppDimensions.screenPadding);
              final centerSpacing = screenWidth < 360 ? 40.0 : (screenWidth < 400 ? 50.0 : 70.0);
              
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
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
                    // Spacer untuk tombol tengah - responsive
                    SizedBox(width: centerSpacing),
                    // Tab Learn Path
                    _NavItem(
                      icon: 'assets/navbottom/learn-path.svg',
                      label: 'Learn Pa...',
                      isActive: currentIndex == 3,
                      onTap: () => context.go('/learn-path'),
                    ),
                    // Tab Profile
                    _NavItem(
                      icon: 'assets/navbottom/profile.svg',
                      label: 'Profile',
                      isActive: currentIndex == 4,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Center AI Button - Floating
          Positioned(
            top: -28,
            left: 0,
            right: 0,
            child: Center(
              child: _CenterAIButton(
                isActive: currentIndex == 2,
                onTap: () => context.go('/asisten'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol AI di tengah dengan efek floating dan notch
/// Design: Lingkaran putih dengan icon ungu/abu-abu di tengah
class _CenterAIButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterAIButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main button - lingkaran putih dengan icon di tengah
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              // Background selalu putih
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
              // Border halus
              border: Border.all(
                color: AppColors.textSecondary.withAlpha(40),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive 
                      ? AppColors.primaryPurple.withAlpha(60)
                      : Colors.black.withAlpha(15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/navbottom/ai_icon_new.svg',
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  // Icon ungu saat aktif, abu-abu saat tidak aktif
                  isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
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
    // Responsive width based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth < 360 ? 55.0 : (screenWidth < 400 ? 60.0 : 70.0);
    final iconSize = screenWidth < 360 ? 20.0 : AppDimensions.iconLarge;
    final fontSize = screenWidth < 360 ? 9.0 : (screenWidth < 400 ? 10.0 : 12.0);
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon SVG dengan ukuran responsive
            SvgPicture.asset(
              icon,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                // Warna ungu saat active, abu-abu saat inactive
                isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 6),
            // Label dengan responsive font size
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontSize: fontSize,
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
