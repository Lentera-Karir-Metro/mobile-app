import 'package:flutter/material.dart';

/// Widget untuk animasi lingkaran-lingkaran yang bergerak dengan smooth gradient
/// untuk splash screen modern
class AnimatedCircles extends StatefulWidget {
  const AnimatedCircles({super.key});

  @override
  State<AnimatedCircles> createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  
  // Jumlah lingkaran yang expand dari center
  final int _circleCount = 5;
  
  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controllers dengan durasi berbeda untuk stagger effect
    _controllers = List.generate(
      _circleCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 300)),
        vsync: this,
      ),
    );
    
    // Scale animation - lingkaran expand dari 0 ke full
    _scaleAnimations = List.generate(
      _circleCount,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeOutQuart,
        ),
      ),
    );
    
    // Fade animation - muncul lalu menghilang
    _fadeAnimations = List.generate(
      _circleCount,
      (index) => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 0.8),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.8, end: 0.6),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.6, end: 0.0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeOut,
        ),
      ),
    );
    
    // Mulai semua animasi dengan stagger delay
    for (int i = 0; i < _circleCount; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        if (mounted) {
          _controllers[i].repeat();
        }
      });
    }
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxSize = screenSize.width > screenSize.height 
        ? screenSize.width * 2
        : screenSize.height * 1.5;
    
    return Stack(
      alignment: Alignment.center,
      children: List.generate(
        _circleCount,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final scale = _scaleAnimations[index].value;
            final opacity = _fadeAnimations[index].value;
            final size = maxSize * scale * (0.4 + (index * 0.15));
            
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: opacity * 0.5),
                  width: 2.0 + (index * 0.5),
                ),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity * 0.15),
                    Colors.white.withValues(alpha: opacity * 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
