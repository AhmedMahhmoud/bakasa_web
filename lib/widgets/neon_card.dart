import 'dart:ui';

import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:flutter/material.dart';

class NeonCard extends StatelessWidget {
  const NeonCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: BakasaColors.bgPanel.withValues(alpha: 0.72),
            border: Border.all(color: BakasaColors.borderGlow),
            boxShadow: [
              BoxShadow(
                color: BakasaColors.neonCyan.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
