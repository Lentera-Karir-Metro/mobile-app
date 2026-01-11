import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Search bar dengan icon search dan optional filter button
/// Digunakan di Home, Explore, Learning Path screens
/// 
/// Fitur:
/// - Border ungu saat di-focus (efek ungu saat diklik)
/// - Search icon 20px di kiri
/// - Filter button opsional di kanan (40x40px)
/// - Hint text customizable per screen
class CustomSearchBar extends StatefulWidget {
  /// Hint text yang muncul di search bar
  /// - Home: "Cari jurusan, kursus..."
  /// - Explore: "Cari kelas..."
  /// - Learning Path: "Cari learning path"
  final String hintText;
  
  /// Callback saat text berubah
  final Function(String)? onChanged;
  
  /// Controller untuk mengakses value dari luar widget
  final TextEditingController? controller;
  
  /// Menampilkan filter button di kanan (hanya di Explore)
  /// Default: false
  final bool showFilterButton;
  
  /// Callback saat filter button ditekan
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.showFilterButton = false,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  // FocusNode untuk detect focus state (efek ungu)
  late FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Rebuild saat focus berubah
    });
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Height dari analisis
      decoration: BoxDecoration(
        // Background: textSecondary 5% opacity (#747474 @ 5%)
        color: AppColors.textSecondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius), // 8px
        // Border ungu saat focus (EFEK UNGU)
        border: Border.all(
          color: _focusNode.hasFocus 
              ? AppColors.primaryPurple  // Ungu saat focus
              : Colors.transparent,      // Transparent saat tidak focus
          width: _focusNode.hasFocus ? 2 : 0,
        ),
      ),
      child: Row(
        children: [
          // Search icon di kiri (20px)
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
            ),
            child: Icon(
              Icons.search,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
          
          // Text field
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              // Input text style: body1 dengan color textPrimary
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                // Hint text: body1 dengan color textSecondary
                hintText: widget.hintText,
                hintStyle: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                // Hilangkan border default (sudah ada di Container)
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // Hilangkan padding default
                contentPadding: EdgeInsets.zero,
                isDense: true,
                // Hilangkan background putih
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          
          // Filter button (opsional - hanya di Explore)
          if (widget.showFilterButton) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground, // White background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/search-bar/filter_icon.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryPurple, // Icon color ungu
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
