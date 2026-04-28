import 'dart:math' as math;

import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:flutter/material.dart';

/// Product hero: your game logo from [BakasaConfig.gameLogoAsset].
class ProductBoxHero extends StatelessWidget {
  const ProductBoxHero({super.key, this.maxHeight = 420});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = math.min(maxHeight, constraints.maxHeight);
        return SizedBox(
          height: h,
          child: AspectRatio(
            aspectRatio: 1,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.96, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: BakasaColors.borderGlow),
                  boxShadow: [
                    BoxShadow(
                      color: BakasaColors.neonCyan.withValues(alpha: 0.12),
                      blurRadius: 32,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: ColoredBox(
                    color: BakasaColors.bgPanel.withValues(alpha: 0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        BakasaConfig.gameLogoAsset,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: BakasaColors.textMuted,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
