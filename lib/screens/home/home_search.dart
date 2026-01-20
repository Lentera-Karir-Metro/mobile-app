import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/data/models/course_model.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load all courses initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().loadCourses();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Back Button
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari Judul Kursus...',
                    hintStyle: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Search Results
            Expanded(
              child: Consumer<CatalogProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Filter courses based on search query
                  final allCourses = provider.courses;
                  final filteredCourses = _searchQuery.isEmpty
                      ? <CourseModel>[]
                      : allCourses.where((course) {
                          final title = course.title.toLowerCase();
                          final category = (course.category ?? '').toLowerCase();
                          final description = (course.description ?? '').toLowerCase();
                          return title.contains(_searchQuery) ||
                              category.contains(_searchQuery) ||
                              description.contains(_searchQuery);
                        }).toList();

                  if (_searchQuery.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ketik untuk mencari kursus',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredCourses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada hasil ditemukan',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coba kata kunci lain',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return _SearchResultItem(
                        title: course.title,
                        price: course.formattedPrice,
                        image: course.thumbnailUrl,
                        category: course.category,
                        onTap: () {
                          // Navigate to detail kelas
                          context.push('/kelas/detail/${course.id}');
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final String title;
  final String price;
  final String? image;
  final String? category;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.title,
    required this.price,
    this.image,
    this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Course Image - Rectangle shape
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image != null && image!.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: image!,
                      width: 90,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(),
                      errorWidget: (context, url, error) => _buildPlaceholder(),
                      memCacheWidth: 180,
                      memCacheHeight: 120,
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 12),
            
            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != null && category!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryPurple,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.image,
        color: AppColors.textSecondary,
      ),
    );
  }
}
