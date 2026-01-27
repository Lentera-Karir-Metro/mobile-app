import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/kelas/preview_mulai_kelas.dart';
import 'package:lentera_karir/widgets/kelas/sertif_status.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';
import 'package:lentera_karir/providers/course_provider.dart';
import 'package:lentera_karir/providers/certificate_provider.dart';
import 'package:lentera_karir/data/models/module_model.dart';
import 'package:lentera_karir/data/models/course_model.dart';

/// Tab filter untuk konten kelas
enum ContentTab { overview, ebook, sertifikat }

/// Halaman Mulai Kelas - untuk kelas yang sudah dibeli
class MulaiKelasScreen extends StatefulWidget {
  final String courseId;

  const MulaiKelasScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<MulaiKelasScreen> createState() => _MulaiKelasScreenState();
}

class _MulaiKelasScreenState extends State<MulaiKelasScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _hasVideoCompleted = false; // Flag to prevent multiple completion calls
  ContentTab _selectedTab = ContentTab.overview;
  
  // Video quality options
  String _selectedQuality = '480P';
  final List<String> _qualityOptions = ['480P', '720P', '1080P'];
  
  // Playback speed
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  
  // Current video/module index
  int _currentModuleIndex = 0;
  ModuleModel? _currentModule;
  
  // Sertifikat status
  SertifikatStatus _sertifikatStatus = SertifikatStatus.notReady;
  String? _certificateUrl; // URL of generated certificate
  bool _isGeneratingCertificate = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourseContent();
    });
  }

  Future<void> _loadCourseContent() async {
    if (!mounted) return;
    final provider = context.read<CourseProvider>();
    await provider.loadCourseContent(widget.courseId);
    
    if (!mounted) return;
    
    // Initialize first video after course loads
    if (provider.currentCourse != null && provider.currentCourse!.modules.isNotEmpty) {
      // Find first video module
      final videoModules = provider.currentCourse!.videoModules;
      if (videoModules.isNotEmpty) {
        _currentModule = videoModules.first;
        _currentModuleIndex = 0;
        await _initializeVideo(_currentModule!.videoUrl);
      }
      
      if (!mounted) return;
      
      // Check certificate status from API
      await _checkCertificateStatus();
    }
  }

  Future<void> _checkCertificateStatus() async {
    if (!mounted) return;
    
    try {
      final certProvider = context.read<CertificateProvider>();
      await certProvider.getCertificateStatus(widget.courseId);
      
      if (!mounted) return;
      
      final certStatus = certProvider.certificateStatus;
      
      // Check if certificate exists using the updated model that handles backend response
      if (certStatus != null && certStatus.hasCertificate) {
        // Certificate already exists - use certificateUrl directly from status or from certificate model
        final url = certStatus.certificateUrl ?? certStatus.certificate?.certificateUrl;
        setState(() {
          _sertifikatStatus = SertifikatStatus.claimed;
          _certificateUrl = url;
        });
      } else {
        // Check if all modules completed for certificate eligibility
        final courseProvider = context.read<CourseProvider>();
        final course = courseProvider.currentCourse;
        if (course != null) {
          final allCompleted = course.completedModulesCount == course.modules.length && course.modules.isNotEmpty;
          setState(() {
            _sertifikatStatus = allCompleted 
                ? SertifikatStatus.canClaim 
                : SertifikatStatus.notReady;
          });
        }
      }
    } catch (_) {
      // Fallback to module completion check
      final courseProvider = context.read<CourseProvider>();
      final course = courseProvider.currentCourse;
      if (course != null && mounted) {
        final allCompleted = course.completedModulesCount == course.modules.length && course.modules.isNotEmpty;
        setState(() {
          _sertifikatStatus = allCompleted 
              ? SertifikatStatus.canClaim 
              : SertifikatStatus.notReady;
        });
      }
    }
  }

  Future<void> _initializeVideo(String? videoUrl) async {
    // Use fallback video if no URL provided
    final effectiveUrl = (videoUrl == null || videoUrl.isEmpty) 
        ? FallbackAssets.sampleVideo 
        : videoUrl;
    
    // Dispose previous controller if exists
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);
      await _videoController!.dispose();
      _videoController = null;
    }
    
    // Reset video initialized state and completion flag before loading new video
    if (mounted) {
      setState(() {
        _isVideoInitialized = false;
        _hasVideoCompleted = false;
      });
    }
    
    // Initialize with network video or asset with video options for better performance
    if (effectiveUrl.startsWith('http')) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(effectiveUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false, // Pause other audio
          allowBackgroundPlayback: false,
        ),
      );
    } else {
      _videoController = VideoPlayerController.asset(effectiveUrl);
    }
    
    try {
      await _videoController!.initialize();
      // Set default playback speed
      await _videoController!.setPlaybackSpeed(_playbackSpeed);
      _videoController!.addListener(_videoListener);
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (_) {
      // Try fallback if network video fails
      if (effectiveUrl.startsWith('http')) {
        _videoController = VideoPlayerController.asset(FallbackAssets.sampleVideo);
        try {
          await _videoController!.initialize();
          _videoController!.addListener(_videoListener);
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        } catch (_) {
          // Fallback video also failed
        }
      }
    }
  }

  void _videoListener() {
    if (_videoController == null) return;
    if (_videoController!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _videoController!.value.isPlaying;
      });
    }
    
    final value = _videoController!.value;
    final duration = value.duration;
    final position = value.position;
    
    // Check if video completed (only trigger once per video)
    // Use threshold of 1 second before end OR video has finished (position >= duration)
    // Also check that video is not playing to avoid false positives during seek
    if (!_hasVideoCompleted && 
        duration > Duration.zero &&
        !value.isPlaying &&
        (position >= duration || 
         (duration - position) < const Duration(seconds: 1))) {
      _hasVideoCompleted = true;
      _onVideoCompleted();
    }
  }
  
  Future<void> _onVideoCompleted() async {
    if (_currentModule == null) {
      return;
    }
    
    // Skip if module is already completed
    if (_currentModule!.isCompleted) {
      // Just auto-advance to next video
      _nextVideo();
      return;
    }
    
    // Mark module as complete
    final provider = context.read<CourseProvider>();
    final success = await provider.completeModule(_currentModule!.id);
    
    if (success && mounted) {
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Video "${_currentModule!.title}" telah diselesaikan'),
              ),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Update certificate status after module completion
      await _checkCertificateStatus();
      
      // Refresh course data to update UI
      provider.loadCourseContent(widget.courseId);
    }
    
    // Auto-advance to next video
    _nextVideo();
  }

  @override
  void dispose() {
    // Pause video before disposing
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
    }
    
    // Reset system UI settings
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Remove listener and dispose controller
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);
      _videoController!.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  void _seekForward() {
    if (_videoController == null) return;
    final currentPosition = _videoController!.value.position;
    final duration = _videoController!.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoController!.seekTo(newPosition > duration ? duration : newPosition);
  }

  void _seekBackward() {
    if (_videoController == null) return;
    final currentPosition = _videoController!.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoController!.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _nextVideo() {
    final provider = context.read<CourseProvider>();
    final course = provider.currentCourse;
    if (course == null) return;
    
    final videoModules = course.videoModules;
    if (_currentModuleIndex < videoModules.length - 1) {
      setState(() {
        _currentModuleIndex++;
        _currentModule = videoModules[_currentModuleIndex];
        _isVideoInitialized = false;
      });
      _initializeVideo(_currentModule!.videoUrl);
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  /// Handle back navigation dengan cleanup yang proper
  void _handleBackNavigation() {
    // Pause video jika sedang playing
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
    }
    
    // Reset fullscreen jika sedang fullscreen
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    
    // Check if we can pop, if not go to explore
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/explore');
    }
  }

  void _setPlaybackSpeed(double speed) {
    if (_videoController == null) return;
    setState(() {
      _playbackSpeed = speed;
    });
    _videoController!.setPlaybackSpeed(speed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final course = provider.currentCourse;
        final isLoading = provider.isLoading;
        
        if (isLoading && course == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (course == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat kelas'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCourseContent,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Calculate totals from modules
        final totalVideos = course.videoModules.length;
        final completedVideos = course.videoModules.where((m) => m.isCompleted).length;

        if (_isFullScreen) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                _handleBackNavigation();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              body: _buildVideoPlayer(isFullScreen: true),
            ),
          );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              _handleBackNavigation();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Stack(
              children: [
                // Main scrollable content
                SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner
                    _buildHeader(course.title, course.createdAt, course.updatedAt),

                    // Video Player Section
                    _buildVideoPlayer(),

                    // Content Card dengan Tab Filter
                    _buildContentCard(course),

                    // Space untuk bottom sheet preview
                    const SizedBox(height: 200),
                  ],
                ),
              ),

              // Preview Widget - Bottom Sheet
              PreviewMulaiKelasWidget(
                totalVideos: totalVideos,
                completedVideos: completedVideos,
                modules: course.modulesWithCorrectedLock, // Use corrected lock status
                onItemTap: (item) {
                  // Find module and play it
                  final moduleIndex = course.videoModules.indexWhere((m) => m.id == item.id);
                  if (moduleIndex >= 0) {
                    setState(() {
                      _currentModuleIndex = moduleIndex;
                      _currentModule = course.videoModules[moduleIndex];
                      _isVideoInitialized = false;
                    });
                    _initializeVideo(_currentModule!.videoUrl);
                  }
                },
                onQuizTap: (item) {
                  // Use quizId for quiz navigation, not module id
                  final quizId = item.quizId;
                  if (quizId != null && quizId.isNotEmpty && quizId != '0') {
                    context.push('/quiz/$quizId');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quiz tidak tersedia')),
                    );
                  }
                },
                onEbookTap: (item) async {
                  // Mark module as complete then show dialog (like web implementation)
                  if (item.ebookUrl == null || item.ebookUrl!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ebook tidak tersedia')),
                    );
                    return;
                  }
                  
                  // Capture context and provider before async gap
                  final currentContext = context;
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final courseProvider = Provider.of<CourseProvider>(context, listen: false);
                  final success = await courseProvider.completeModule(item.id);
                  
                  if (!mounted) return;
                  
                  if (success) {
                    // Show success dialog
                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: currentContext,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withAlpha(26),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.download_done_rounded,
                                color: AppColors.successGreen,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Ebook Berhasil Diunduh!',
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ebook "${item.title}" telah ditambahkan ke koleksi Ebook Saya.',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Tutup'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              currentContext.push('/ebook/view', extra: {
                                'title': item.title,
                                'url': item.ebookUrl,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                            ),
                            child: const Text('Buka Ebook'),
                          ),
                        ],
                      ),
                    );
                    
                    // Refresh course data
                    courseProvider.loadCourseContent(widget.courseId);
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengunduh ebook'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),

              // Back Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomBackButton(
                    backgroundColor: AppColors.cardBackground,
                    iconColor: AppColors.textPrimary,
                    onPressed: _handleBackNavigation,
                  ),
                ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }

  /// Header Banner dengan title dan info
  Widget _buildHeader(String courseTitle, DateTime? createdAt, DateTime? updatedAt) {
    final releasedDate = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : 'N/A';
    final lastUpdated = updatedAt != null
        ? '${updatedAt.day} ${_monthName(updatedAt.month)} ${updatedAt.year}'
        : 'N/A';
        
    return SizedBox(
      width: double.infinity,
      height: 280, // Height for new layout with top positioning
      child: Stack(
        children: [
          // Background banner image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                'assets/header-banner/header_banner.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content positioned below back button area with gap (like quiz.dart and detail_kelas.dart)
          Positioned(
            left: 20,
            right: 20,
            top: 90, // Position below back button with small gap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Title
                Text(
                  courseTitle,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Released date row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/globe.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Released Date $releasedDate',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Updated date row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/last_update.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Last Updated $lastUpdated',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Current module info
                if (_currentModule != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentModule!.title,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Video Player Section dengan controls lengkap
  Widget _buildVideoPlayer({bool isFullScreen = false}) {
    if (_videoController == null || !_isVideoInitialized) {
      return Container(
        width: double.infinity,
        height: isFullScreen ? MediaQuery.of(context).size.height : 220.0,
        margin: isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: isFullScreen ? null : BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    
    final playerHeight = isFullScreen 
        ? MediaQuery.of(context).size.height 
        : 220.0;

    return Container(
      width: double.infinity,
      height: playerHeight,
      margin: isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: isFullScreen ? null : BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(16),
        child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video Player
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),

                    // Controls Overlay
                    if (_showControls) ...[
                      // Dark overlay
                      Container(color: Colors.black38),

                      // Top Right - Quality selector only
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildControlButton(
                          label: _selectedQuality,
                          onTap: _showQualityDialog,
                        ),
                      ),

                      // Center Controls (Seek backward, Play/Pause, Seek forward)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Seek backward 10s
                          IconButton(
                            onPressed: _seekBackward,
                            icon: const Icon(Icons.replay_10_rounded, 
                              color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 24),
                          // Play/Pause
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Seek forward 10s
                          IconButton(
                            onPressed: _seekForward,
                            icon: const Icon(Icons.forward_10_rounded, 
                              color: Colors.white, size: 32),
                          ),
                        ],
                      ),

                      // Bottom Left - Speed selector
                      Positioned(
                        bottom: 40,
                        left: 12,
                        child: _buildControlButton(
                          label: '${_playbackSpeed}X',
                          onTap: _showSpeedDialog,
                        ),
                      ),

                      // Bottom Right - Fullscreen button
                      Positioned(
                        bottom: 40,
                        right: 12,
                        child: GestureDetector(
                          onTap: _toggleFullScreen,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Controls (Progress bar and Duration only)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            // Progress bar
                            VideoProgressIndicator(
                              _videoController!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: AppColors.primaryPurple,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                            // Duration display centered
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: ValueListenableBuilder(
                                valueListenable: _videoController!,
                                builder: (context, value, child) {
                                  final position = _formatDuration(_videoController!.value.position);
                                  final duration = _formatDuration(_videoController!.value.duration);
                                  return Text(
                                    '$position / $duration',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildControlButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _qualityOptions.map((quality) {
            return ListTile(
              title: Text(quality),
              trailing: _selectedQuality == quality 
                  ? const Icon(Icons.check, color: AppColors.primaryPurple)
                  : null,
              onTap: () {
                setState(() {
                  _selectedQuality = quality;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _speedOptions.map((speed) {
            return ListTile(
              title: Text('${speed}x'),
              trailing: _playbackSpeed == speed 
                  ? const Icon(Icons.check, color: AppColors.primaryPurple)
                  : null,
              onTap: () {
                _setPlaybackSpeed(speed);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Content Card dengan Tab Filter dan Shadow
  Widget _buildContentCard(CourseModel course) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTabButton(ContentTab.overview, 'Overview'),
                const SizedBox(width: 10),
                _buildTabButton(ContentTab.ebook, 'Ebook'),
                const SizedBox(width: 10),
                _buildTabButton(ContentTab.sertifikat, 'Sertifikat'),
              ],
            ),
          ),

          // Tab Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildTabContent(course),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(ContentTab tab, String label) {
    final bool isSelected = _selectedTab == tab;
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive padding - smaller on small screens
    final hPadding = screenWidth < 360 ? 14.0 : (screenWidth < 400 ? 16.0 : 20.0);
    final vPadding = screenWidth < 360 ? 8.0 : 10.0;
    final fontSize = screenWidth < 360 ? 12.0 : 14.0;
    
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tab;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: AppColors.textSecondary, width: 1),
          ),
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              fontSize: fontSize,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(CourseModel course) {
    switch (_selectedTab) {
      case ContentTab.overview:
        return _buildOverviewContent(course);
      case ContentTab.ebook:
        return _buildEbookContent(course);
      case ContentTab.sertifikat:
        return _buildSertifikatContent();
    }
  }

  Widget _buildOverviewContent(CourseModel course) {
    return Text(
      course.description ?? 'Deskripsi belum tersedia.',
      style: AppTextStyles.body2.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildEbookContent(CourseModel course) {
    final ebookModules = course.ebookModules;
    
    if (ebookModules.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Tidak ada ebook tersedia',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ebookModules.map((module) => _buildEbookItem(
        moduleId: module.id,
        title: module.title,
        ebookUrl: module.ebookUrl,
        isCompleted: module.isCompleted,
      )).toList(),
    );
  }

  Widget _buildEbookItem({
    required String moduleId,
    required String title,
    String? ebookUrl,
    bool isCompleted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          if (ebookUrl == null || ebookUrl.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ebook tidak tersedia')),
            );
            return;
          }
          
          // Mark module as complete (like web implementation)
          final courseProvider = Provider.of<CourseProvider>(context, listen: false);
          final success = await courseProvider.completeModule(moduleId);
          
          if (!mounted) return;
          
          if (success) {
            // Show success dialog like web implementation
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.download_done_rounded,
                        color: AppColors.successGreen,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ebook Berhasil Diunduh!',
                      style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ebook "$title" telah ditambahkan ke koleksi Ebook Saya.',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPurple,
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Tutup'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      // Navigate to view the ebook
                      context.push('/ebook/view', extra: {
                        'title': title,
                        'url': ebookUrl,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Buka Ebook'),
                  ),
                ],
              ),
            );
            
            // Refresh course data to update completion status
            courseProvider.loadCourseContent(widget.courseId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal mengunduh ebook'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: isCompleted ? Border.all(
              color: AppColors.successGreen.withAlpha(100),
              width: 1,
            ) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppColors.successGreen.withAlpha(26)
                      : Colors.red.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted 
                      ? Icons.download_done_rounded
                      : Icons.picture_as_pdf_rounded,
                  color: isCompleted ? AppColors.successGreen : Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted ? 'Sudah diunduh' : 'Tap untuk mengunduh',
                      style: AppTextStyles.caption.copyWith(
                        color: isCompleted 
                            ? AppColors.successGreen
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isCompleted ? Icons.check_circle : Icons.download_rounded,
                color: isCompleted ? AppColors.successGreen : AppColors.primaryPurple,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSertifikatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SertifStatus(
          status: _sertifikatStatus,
          onTap: _isGeneratingCertificate ? null : () => _handleCertificateAction(),
        ),
        if (_isGeneratingCertificate)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Membuat sertifikat...'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleCertificateAction() async {
    if (_sertifikatStatus == SertifikatStatus.claimed && _certificateUrl != null) {
      // Open existing certificate directly in browser/PDF reader
      await _openPdfUrl(_certificateUrl!);
    } else if (_sertifikatStatus == SertifikatStatus.canClaim) {
      // Generate certificate
      await _generateCertificate();
    }
    // Do nothing if notReady (disabled state)
  }

  Future<void> _openPdfUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka file')),
        );
      }
    }
  }

  Future<void> _generateCertificate() async {
    if (_isGeneratingCertificate) return;
    
    setState(() {
      _isGeneratingCertificate = true;
    });
    
    try {
      final certProvider = context.read<CertificateProvider>();
      
      // First, check if certificate already exists
      await certProvider.getCertificateStatus(widget.courseId);
      
      if (certProvider.certificateStatus?.hasCertificate == true && 
          certProvider.certificateStatus?.certificate != null) {
        // Certificate already exists, just show it
        final existingCert = certProvider.certificateStatus!.certificate!;
        if (mounted) {
          setState(() {
            _sertifikatStatus = SertifikatStatus.claimed;
            _certificateUrl = existingCert.certificateUrl;
            _isGeneratingCertificate = false;
          });
          
          // Open the existing certificate directly in browser/PDF reader
          if (_certificateUrl != null && _certificateUrl!.isNotEmpty) {
            await _openPdfUrl(_certificateUrl!);
          }
        }
        return;
      }
      
      // Load templates first
      await certProvider.loadTemplates();
      
      // Get the first template (or default template)
      String templateId = '1'; // Default template ID
      if (certProvider.templates.isNotEmpty) {
        templateId = certProvider.templates.first.id.toString();
      }
      
      // Generate certificate
      final certificate = await certProvider.generateCertificate(
        widget.courseId,
        templateId,
      );
      
      if (certificate != null && mounted) {
        setState(() {
          _sertifikatStatus = SertifikatStatus.claimed;
          _certificateUrl = certificate.certificateUrl;
          _isGeneratingCertificate = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sertifikat berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Open the certificate directly in browser/PDF reader
        if (_certificateUrl != null) {
          await _openPdfUrl(_certificateUrl!);
        }
      } else {
        // Generate failed, maybe certificate already exists - check status again
        await certProvider.getCertificateStatus(widget.courseId);
        
        if (certProvider.certificateStatus?.hasCertificate == true && 
            certProvider.certificateStatus?.certificate != null) {
          final existingCert = certProvider.certificateStatus!.certificate!;
          if (mounted) {
            setState(() {
              _sertifikatStatus = SertifikatStatus.claimed;
              _certificateUrl = existingCert.certificateUrl;
              _isGeneratingCertificate = false;
            });
            return;
          }
        }
        
        setState(() {
          _isGeneratingCertificate = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(certProvider.errorMessage ?? 'Gagal membuat sertifikat'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingCertificate = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}
