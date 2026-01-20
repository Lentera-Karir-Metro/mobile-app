import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Fallback assets yang digunakan ketika data dari backend tidak tersedia
class FallbackAssets {
  static const String sampleImage = 'assets/hardcode/sample_image.png';
  static const String sampleVideo = 'assets/hardcode/sample_video.mp4';
  static const String profileImage = 'assets/hardcode/image_profile.png';
  static const String certificateImage = 'assets/hardcode/sertifikat.png';
}

/// Widget yang dapat menampilkan gambar dari network URL atau asset lokal
/// dengan fallback otomatis ke asset default jika gagal load
class AdaptiveImage extends StatelessWidget {
  final String? imagePath;
  final String fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  
  const AdaptiveImage({
    super.key,
    this.imagePath,
    this.fallbackAsset = FallbackAssets.sampleImage,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    final String effectivePath = imagePath ?? fallbackAsset;
    final bool isNetworkImage = effectivePath.startsWith('http');
    
    Widget imageWidget;
    
    if (isNetworkImage) {
      // Safely convert width/height to int, avoiding Infinity/NaN errors
      int? cacheWidth;
      int? cacheHeight;
      if (width != null && width!.isFinite && !width!.isNaN) {
        cacheWidth = width!.toInt();
      }
      if (height != null && height!.isFinite && !height!.isNaN) {
        cacheHeight = height!.toInt();
      }
      
      // Use CachedNetworkImage for better performance and caching
      imageWidget = CachedNetworkImage(
        imageUrl: effectivePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) {
          // Fallback ke asset lokal jika network error
          return Image.asset(
            fallbackAsset,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          );
        },
        // Cache configuration for better performance
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
      );
    } else {
      imageWidget = Image.asset(
        effectivePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // Fallback ke default asset jika asset tidak ditemukan
          if (effectivePath != fallbackAsset) {
            return Image.asset(
              fallbackAsset,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            );
          }
          return _buildErrorWidget();
        },
      );
    }
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }
  
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.textSecondary.withValues(alpha: 0.1),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryPurple.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
  
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.textSecondary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.image,
          size: (width != null && height != null) 
              ? (width! < height! ? width! * 0.4 : height! * 0.4)
              : 40,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
