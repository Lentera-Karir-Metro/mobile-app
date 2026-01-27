import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/learn_path/path_card.dart';
import 'package:lentera_karir/providers/learning_path_provider.dart';
import 'package:lentera_karir/data/models/learning_path_model.dart';

class LearnPathListScreen extends StatefulWidget {
  const LearnPathListScreen({super.key});

  @override
  State<LearnPathListScreen> createState() => _LearnPathListScreenState();
}

class _LearnPathListScreenState extends State<LearnPathListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Defer data loading until after the first frame to avoid Provider errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    await context.read<LearningPathProvider>().loadLearningPaths();
  }

  List<LearningPathModel> get _filteredLearningPaths {
    final provider = context.watch<LearningPathProvider>();
    final paths = provider.learningPaths;
    
    if (_searchQuery.isEmpty) {
      return paths;
    }
    return paths.where((path) {
      final titleLower = path.title.toLowerCase();
      final descriptionLower = (path.description ?? '').toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return titleLower.contains(queryLower) ||
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
    return Consumer<LearningPathProvider>(
      builder: (context, provider, child) {
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
              children: [
                // Header dengan title
                _buildHeader(),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 12),
                  child: CustomSearchBar(
                    hintText: 'Cari learning path',
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
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.errorMessage != null
                          ? _buildErrorState(provider.errorMessage!)
                          : _filteredLearningPaths.isEmpty
                              ? _buildEmptyState()
                              : RefreshIndicator(
                                  onRefresh: _loadData,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 8, bottom: 90),
                                    itemCount: _filteredLearningPaths.length,
                                    itemBuilder: (context, index) {
                                      final path = _filteredLearningPaths[index];
                                      return PathCard(
                                        title: path.title,
                                        courses: '${path.totalCourses} kelas',
                                        imagePath: path.thumbnail,
                                        onTap: () {
                                          context.push('/learn-path/${path.id}');
                                        },
                                      );
                                    },
                                  ),
                                ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const NavBottom(currentIndex: 3),
          ),
        );
      },
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

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}