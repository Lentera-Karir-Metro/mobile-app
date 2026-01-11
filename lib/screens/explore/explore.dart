import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/home/course_card.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/screens/kelas/detail_kelas.dart';

/// Halaman Explore - Katalog semua kursus dengan filter dan search
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Filter state
  String selectedCategory = 'All';
  String selectedSort = 'Terpopuler';
  
  // Sample course data
  final List<Map<String, dynamic>> courses = [
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'UI/UX Design Fundamental untuk Pemula',
      'price': 'Rp 150.000',
      'category': 'Design',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'Flutter Mobile Development Bootcamp',
      'price': 'Rp 250.000',
      'category': 'Programming',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'Digital Marketing Strategy 2024',
      'price': 'Rp 200.000',
      'category': 'Marketing',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'Resume Writing & Interview Tips',
      'price': 'Rp 100.000',
      'category': 'Interview & CV',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'React Native for Beginners',
      'price': 'Rp 300.000',
      'category': 'Programming',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'Graphic Design Mastery',
      'price': 'Rp 180.000',
      'category': 'Design',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'SEO & Content Marketing',
      'price': 'Rp 220.000',
      'category': 'Marketing',
    },
    {
      'thumbnail': 'assets/hardcode/sample_image.png',
      'title': 'Career Development Essentials',
      'price': 'Rp 120.000',
      'category': 'Interview & CV',
    },
  ];

  // Filter courses based on selected category
  List<Map<String, dynamic>> get filteredCourses {
    if (selectedCategory == 'All') {
      return courses;
    }
    return courses.where((course) => course['category'] == selectedCategory).toList();
  }

  Widget _buildCategoryChip(String label, String iconPath) {
    final isActive = selectedCategory == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryPurple : Colors.black.withValues(alpha: 0.1),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                AppColors.primaryPurple,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
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
                
                // Categories
                Text(
                  'Kategori',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: AppDimensions.itemSpacing),
                
                // Category checkboxes (no icons)
                ...['All', 'Design', 'Programming', 'Marketing', 'Interview & CV']
                    .map((category) => CheckboxListTile(
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
                        )),
                
                const SizedBox(height: AppDimensions.sectionSpacing),
                
                // Sort
                Text(
                  'Urutkan',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: AppDimensions.itemSpacing),
                
                // Sort radio buttons
                ...['Baru Rilis', 'Terpopuler'].map((sort) => Radio<String>(
                      value: sort,
                      groupValue: selectedSort,
                      onChanged: (String? value) {
                        setModalState(() {
                          selectedSort = value!;
                        });
                      },
                      activeColor: AppColors.primaryPurple,
                    )).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final radio = entry.value;
                      final sort = ['Baru Rilis', 'Terpopuler'][index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: radio,
                        title: Text(
                          sort,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onTap: () {
                          setModalState(() {
                            selectedSort = sort;
                          });
                        },
                      );
                    }),
                
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
                        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.fromLTRB(31, 8, 31, 0),
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
                    showFilterButton: true,
                    onFilterTap: _showFilterModal,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Popular Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Category',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildCategoryChip('Marketing', 'assets/hardcode/marketing.svg'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Design', 'assets/hardcode/design.svg'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Interview & CV', 'assets/hardcode/interview.svg'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Course grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.95, // Diperbesar agar card lebih pendek
                ),
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  return CourseCard(
                    thumbnailPath: course['thumbnail'],
                    title: course['title'],
                    price: course['price'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailKelasScreen(
                            courseId: (index + 1).toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBottom(currentIndex: 1),
    );
  }
}
