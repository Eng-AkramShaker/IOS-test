// core/widgets/loading_widget.dart
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modern_animated_loader/flutter_animated_loader.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingWidget({super.key, this.size = 60, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterAnimatedLoader.arcTrio(color: color ?? AppColors.primary, size: size),
    );
  }
}
