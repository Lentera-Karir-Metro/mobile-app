import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/home/course_card.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/screens/error/error_screen.dart';

/// Halaman Explore - Katalog semua kursus dengan filter dan search
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Filter state
  String selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load courses when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().loadCourses();
      context.read<CatalogProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _showFilterModal() {
    final catalogProvider = context.read<CatalogProvider>();
    // Build dynamic category list from API
    final categories = [
      'All',
      ...catalogProvider.categories.map((c) => c.name),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.screenRadius),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Filter',
                      style: AppTextStyles.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionSpacing),

                  // Categories (dynamic from API)
                  Text(
                    'Kategori',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.itemSpacing),

                  // Dynamic category checkboxes
                  ...categories.map(
                    (category) => CheckboxListTile(
                      title: Text(
                        category,
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: selectedCategory == category,
                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory = category;
                        });
                      },
                      activeColor: AppColors.primaryPurple,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.sectionSpacing),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Update main screen
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.inputRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        'Terapkan',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = context.watch<CatalogProvider>();
    final allCourses = catalogProvider.courses;
    final isLoading = catalogProvider.isLoading;

    // Show error screen when there's a network/server error
    if (catalogProvider.status == CatalogStatus.error) {
      return ErrorScreen.server(
        message:
            catalogProvider.errorMessage ?? 'Server sedang mengalami gangguan',
        onRetry: () {
          catalogProvider.loadCourses();
          catalogProvider.loadCategories();
        },
      );
    }

    // Filter courses based on search query and category
    final courses = allCourses.where((course) {
      // Category filter
      bool matchesCategory =
          selectedCategory == 'All' ||
          (course.category ?? '').toLowerCase() ==
              selectedCategory.toLowerCase();

      // Search filter
      bool matchesSearch =
          _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery) ||
          (course.category ?? '').toLowerCase().contains(_searchQuery) ||
          (course.description ?? '').toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Builder(
                builder: (context) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final hPadding = screenWidth < 360
                      ? 16.0
                      : (screenWidth < 400 ? 20.0 : 24.0);
                  return Padding(
                    padding: EdgeInsets.fromLTRB(hPadding, 8, hPadding, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Explore Katalog Kelas',
                          style: AppTextStyles.heading3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Kumpulan kelas yang tersedia dari Lentera Karir',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Search bar with filter button
                        CustomSearchBar(
                          hintText: 'Cari kelas...',
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          showFilterButton: true,
                          onFilterTap: _showFilterModal,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // // Popular Category
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 31),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Popular Category',
              //         style: AppTextStyles.body1.copyWith(
              //           fontWeight: FontWeight.w600,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(height: 12),
              //       Row(
              //         children: [
              //           _buildCategoryChip('Marketing', 'assets/hardcode/marketing.svg'),
              //           const SizedBox(width: 8),
              //           _buildCategoryChip('Design', 'assets/hardcode/design.svg'),
              //           const SizedBox(width: 8),
              //           _buildCategoryChip('Interview & CV', 'assets/hardcode/interview.svg'),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),

              // Course grid
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : courses.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada kelas ditemukan',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              MediaQuery.of(context).size.width < 360
                              ? 0.72
                              : 0.78,
                        ),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          // Calculate prices:
                          // - price = original price (harga asli)
                          // - discountPrice = discount amount (besar diskon)
                          // - finalPrice = price - discountPrice (harga setelah diskon)
                          String priceText;
                          String? originalPrice;

                          if (course.discountPrice != null &&
                              course.discountPrice! > 0) {
                            // Has discount: show discounted price, with original price strikethrough
                            final finalPrice =
                                course.price - course.discountPrice!;
                            priceText =
                                'Rp${finalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
                            originalPrice =
                                'Rp${course.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
                          } else {
                            // No discount
                            priceText = course.price > 0
                                ? 'Rp${course.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'
                                : 'Gratis';
                          }
                          return CourseCard(
                            thumbnailPath:
                                course.thumbnail ??
                                'assets/hardcode/sample_image.png',
                            title: course.title,
                            price: priceText,
                            originalPrice: originalPrice,
                            mentorName:
                                course.mentor?.name ?? course.instructor,
                            mentorPhoto: course.mentor?.avatarUrl,
                            onTap: () {
                              context.push('/kelas/detail/${course.id}');
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const NavBottom(currentIndex: 1),
      ),
    );
  }
}
