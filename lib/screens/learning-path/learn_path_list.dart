import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/learn_path/path_card.dart';
import 'learn_path_detail.dart';

class LearnPathListScreen extends StatefulWidget {
  const LearnPathListScreen({super.key});

  @override
  State<LearnPathListScreen> createState() => _LearnPathListScreenState();
}

class _LearnPathListScreenState extends State<LearnPathListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample learning path data
  final List<Map<String, String>> _allLearningPaths = [
    {
      'id': '1',
      'title': 'Professional UI/UX Designer Path',
      'subtitle': 'Kumpulan kelas untuk alur belajar yang lebih teratur',
      'duration': '4 jam',
      'courses': '5 kelas',
      'description':
          'Proses UI/UX yang terus berkembang mempelajari tentang interaction design hingga pemahaman alur kerja UI/UX Designer Professional yang sudah berkembang',
      'profileSection': 'Profil UI/UX Designer Professional',
      'profileDescription':
          'UI/UX Designer Professional yang sudah berpengalaman dalam industri selama bertahun-tahun, memiliki portofolio yang solid dan pemahaman mendalam tentang user experience.',
    },
    {
      'id': '2',
      'title': 'Fullstack Web Developer',
      'subtitle': 'Kumpulan kelas untuk alur belajar yang lebih teratur',
      'duration': '6 jam',
      'courses': '8 kelas',
      'description':
          'Pelajari pengembangan web dari frontend hingga backend dengan teknologi modern seperti React, Node.js, dan database management',
      'profileSection': 'Profil Fullstack Web Developer',
      'profileDescription':
          'Fullstack Developer yang menguasai teknologi frontend dan backend, mampu membangun aplikasi web yang kompleks dan scalable dari awal hingga deployment.',
    },
    {
      'id': '3',
      'title': 'Digital Marketing Specialist Path',
      'subtitle': 'Kumpulan kelas untuk alur belajar yang lebih teratur',
      'duration': '3 jam',
      'courses': '5 kelas',
      'description':
          'Kuasai strategi digital marketing dari SEO, social media marketing, content creation hingga analytics untuk meningkatkan bisnis online',
      'profileSection': 'Profil Digital Marketing Specialist',
      'profileDescription':
          'Digital Marketing Specialist yang ahli dalam strategi pemasaran online, mampu meningkatkan brand awareness dan conversion rate melalui berbagai channel digital.',
    },
    {
      'id': '4',
      'title': 'Career Switch Kickstarter',
      'subtitle': 'Kumpulan kelas untuk alur belajar yang lebih teratur',
      'duration': '6 jam',
      'courses': '10 kelas',
      'description':
          'Program intensif untuk membantu transisi karir ke bidang teknologi dengan pembelajaran fundamental yang solid dan praktis',
      'profileSection': 'Career Switch Kickstarter',
      'profileDescription':
          'Program yang dirancang khusus untuk profesional yang ingin beralih karir ke dunia teknologi, dengan mentor berpengalaman dan kurikulum yang praktis.',
    },
  ];

  List<Map<String, String>> get _filteredLearningPaths {
    if (_searchQuery.isEmpty) {
      return _allLearningPaths;
    }
    return _allLearningPaths.where((path) {
      final titleLower = path['title']!.toLowerCase();
      final subtitleLower = path['subtitle']!.toLowerCase();
      final descriptionLower = path['description']!.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return titleLower.contains(queryLower) ||
          subtitleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan title
            _buildHeader(),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 12),
              child: CustomSearchBar(
                hintText: 'Cari judul kursus',
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Learning Paths List
            Expanded(
              child: _filteredLearningPaths.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 90),
                      itemCount: _filteredLearningPaths.length,
                      itemBuilder: (context, index) {
                        final path = _filteredLearningPaths[index];
                        return PathCard(
                          title: path['title']!,
                          duration: path['duration']!,
                          courses: path['courses']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LearnPathDetailScreen(
                                  pathId: path['id']!,
                                  title: path['title']!,
                                  description: path['description']!,
                                  profileSection: path['profileSection']!,
                                  profileDescription: path['profileDescription']!,
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
      bottomNavigationBar: const NavBottom(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(31, 8, 31, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Learning Path',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Kumpulan kelas untuk alur belajar yang lebih teratur',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'Tidak ada learning path ditemukan',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}