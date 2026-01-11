import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/kelas/preview_mulai_kelas.dart';
import 'package:lentera_karir/widgets/kelas/sertif_status.dart';

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
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  ContentTab _selectedTab = ContentTab.overview;
  
  // Video quality options
  String _selectedQuality = '480P';
  final List<String> _qualityOptions = ['480P', '720P', '1080P'];
  
  // Playback speed
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  // TODO: Replace with actual API data
  final String thumbnailPath = "assets/hardcode/sample_image.png";
  final String videoPath = "assets/hardcode/sample_video.mp4";
  final String courseTitle = "Bootcamp: Kick-start Karier Digital";
  final String releaseDate = "March 2025";
  final String lastUpdated = "August 2025";
  final int totalVideos = 7;
  final int completedVideos = 0;
  
  // Current video index
  int _currentVideoIndex = 0;
  
  // Sertifikat status
  final SertifikatStatus _sertifikatStatus = SertifikatStatus.notReady;

  // Data ebook dummy
  final List<Map<String, dynamic>> ebookList = [
    {'title': 'Modul 1: Pengenalan Digital Marketing', 'pages': 45},
    {'title': 'Modul 2: SEO Fundamental', 'pages': 62},
    {'title': 'Modul 3: Social Media Marketing', 'pages': 38},
    {'title': 'Modul 4: Content Marketing Strategy', 'pages': 51},
    {'title': 'Modul 5: Google Analytics', 'pages': 44},
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset(videoPath);
    
    try {
      await _videoController.initialize();
      _videoController.addListener(_videoListener);
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _videoListener() {
    if (_videoController.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _videoController.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    // Pause video before disposing
    if (_videoController.value.isPlaying) {
      _videoController.pause();
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
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  void _seekForward() {
    final currentPosition = _videoController.value.position;
    final duration = _videoController.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoController.seekTo(newPosition > duration ? duration : newPosition);
  }

  void _seekBackward() {
    final currentPosition = _videoController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoController.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _nextVideo() {
    if (_currentVideoIndex < totalVideos - 1) {
      setState(() {
        _currentVideoIndex++;
      });
      // TODO: Load next video
      debugPrint('Next video: ${_currentVideoIndex + 1}');
    }
  }

  void _previousVideo() {
    if (_currentVideoIndex > 0) {
      setState(() {
        _currentVideoIndex--;
      });
      // TODO: Load previous video
      debugPrint('Previous video: ${_currentVideoIndex + 1}');
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
    if (_videoController.value.isPlaying) {
      _videoController.pause();
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
    setState(() {
      _playbackSpeed = speed;
    });
    _videoController.setPlaybackSpeed(speed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
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
                // Header Banner (seperti detail_kelas.dart)
                _buildHeader(),

                // Video Player Section
                _buildVideoPlayer(),

                // Content Card dengan Tab Filter
                _buildContentCard(),

                // Space untuk bottom sheet preview
                const SizedBox(height: 200),
              ],
            ),
          ),

          // Preview Widget - Bottom Sheet
          PreviewMulaiKelasWidget(
            totalVideos: totalVideos,
            completedVideos: completedVideos,
            onItemTap: (item) {
              debugPrint('Play video: ${item.title}');
            },
            onQuizTap: (item) {
              context.push('/quiz/${item.id}');
            },
          ),

          // Back Button - Fixed di atas (sama seperti detail_kelas.dart)
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
  }

  /// Header Banner dengan title dan info (sama seperti detail_kelas.dart)
  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          // Background banner image - full cover with rounded corners
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
          
          // Content di bagian bawah banner
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
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
                const SizedBox(height: 16),
                
                // Released date row
                Row(
                  children: [
                    const Icon(
                      Icons.public_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Released date $releaseDate',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Last updated row
                Row(
                  children: [
                    const Icon(
                      Icons.update_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated $lastUpdated',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
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
        child: _isVideoInitialized
            ? GestureDetector(
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
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),

                    // Controls Overlay
                    if (_showControls) ...[
                      // Dark overlay
                      Container(color: Colors.black38),

                      // Top Left - Fullscreen button
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton(
                          onPressed: _toggleFullScreen,
                          icon: Icon(
                            _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      // Top Right Controls (Quality, Speed)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            // Quality selector
                            _buildControlButton(
                              label: _selectedQuality,
                              onTap: _showQualityDialog,
                            ),
                            const SizedBox(width: 8),
                            // Speed selector
                            _buildControlButton(
                              label: '${_playbackSpeed}X',
                              onTap: _showSpeedDialog,
                            ),
                          ],
                        ),
                      ),

                      // Center Controls (Previous, Play/Pause, Next)
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

                      // Bottom Controls (Progress, Duration, Fullscreen)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            // Progress bar
                            VideoProgressIndicator(
                              _videoController,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: AppColors.primaryPurple,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                            // Duration and controls
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Previous button
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: _previousVideo,
                                        icon: const Icon(Icons.skip_previous_rounded, 
                                          color: Colors.white, size: 24),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Previous',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Duration display
                                  ValueListenableBuilder(
                                    valueListenable: _videoController,
                                    builder: (context, value, child) {
                                      final position = _formatDuration(value.position);
                                      final duration = _formatDuration(value.duration);
                                      return Text(
                                        '$position / $duration',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  // Next button
                                  Row(
                                    children: [
                                      Text(
                                        'Next',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        onPressed: _nextVideo,
                                        icon: const Icon(Icons.skip_next_rounded, 
                                          color: Colors.white, size: 24),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              )
            : Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      thumbnailPath,
                      width: double.infinity,
                      height: playerHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.video_library_rounded,
                            color: Colors.white54,
                            size: 48,
                          ),
                        );
                      },
                    ),
                    const CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
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
  Widget _buildContentCard() {
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
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(ContentTab tab, String label) {
    final bool isSelected = _selectedTab == tab;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case ContentTab.overview:
        return _buildOverviewContent();
      case ContentTab.ebook:
        return _buildEbookContent();
      case ContentTab.sertifikat:
        return _buildSertifikatContent();
    }
  }

  Widget _buildOverviewContent() {
    return Text(
      'Program pelatihan intensif yang dirancang khusus untuk memfasilitasi individu, baik fresh graduate maupun profesional yang berkeinginan melakukan career pivot, untuk memasuki industri digital dengan bekal pengetahuan dan keterampilan yang relevan.\n\nKurikulum program ini disusun berdasarkan kebutuhan pasar kerja saat ini, berfokus pada tiga pilar utama: penguasaan mindset digital, implementasi keterampilan teknis dasar (seperti SEO, copywriting, dan analisis data sederhana), serta strategi profesional dalam pengembangan personal branding dan portofolio.\n\nPeserta akan dibimbing untuk memahami lanskap industri digital, mengidentifikasi peran kunci yang sesuai dengan minat dan kompetensi, serta membangun aset profesional (portofolio) yang memenuhi standar industri.\n\nTujuan Utama: Menghasilkan lulusan yang siap kerja (job-ready) dan mampu memberikan kontribusi signifikan dalam lingkungan kerja digital yang dinamis dan kompetitif.',
      style: AppTextStyles.body2.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildEbookContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ebookList.map((ebook) => _buildEbookItem(
        title: ebook['title'],
        pages: ebook['pages'],
      )).toList(),
    );
  }

  Widget _buildEbookItem({required String title, required int pages}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          debugPrint('Open ebook: $title');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Colors.red,
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
                      '$pages halaman',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.download_rounded,
                color: AppColors.primaryPurple,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSertifikatContent() {
    return SertifStatus(
      status: _sertifikatStatus,
      onTap: () {
        if (_sertifikatStatus == SertifikatStatus.canClaim) {
          debugPrint('Download sertifikat');
        }
      },
    );
  }
}
