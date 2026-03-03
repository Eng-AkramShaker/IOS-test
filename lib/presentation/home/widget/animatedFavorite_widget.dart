import 'package:flutter/material.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedFavoriteButton({super.key, required this.isFavorite, required this.onTap});

  @override
  State<AnimatedFavoriteButton> createState() => AnimatedFavoriteButtonState();
}

class AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.red.withOpacity(0.2),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
