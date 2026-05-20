import 'dart:math' as math;

import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// Product hero slider shown at the top of the page.
class ProductBoxHero extends StatefulWidget {
  const ProductBoxHero({super.key, this.maxHeight = 420});

  final double maxHeight;

  @override
  State<ProductBoxHero> createState() => _ProductBoxHeroState();
}

class _ProductBoxHeroState extends State<ProductBoxHero>
    with SingleTickerProviderStateMixin {
  final CarouselSliderController _controller = CarouselSliderController();
  int _activeIndex = 0;
  late final AnimationController _glowCtrl;

  List<String> get _slides {
    if (BakasaConfig.heroSliderAssets.isEmpty) {
      return <String>[BakasaConfig.gameLogoAsset];
    }
    return BakasaConfig.heroSliderAssets;
  }

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final imageAsset in _slides) {
      precacheImage(AssetImage(imageAsset), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = math.min(widget.maxHeight, constraints.maxHeight);
        return SizedBox(
          height: h,
          width: double.infinity,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 18),
                  child: Transform.scale(
                    scale: 0.96 + (0.04 * value),
                    child: child,
                  ),
                ),
              );
            },
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (context, child) {
                final pulse =
                    (math.sin(_glowCtrl.value * math.pi * 2 * 6) + 1) / 2;
                final outerPulse =
                    (math.sin(_glowCtrl.value * math.pi * 2 * 4) + 1) / 2;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Color.lerp(
                        BakasaColors.borderGlow,
                        BakasaColors.neonCyan.withValues(alpha: 0.55),
                        0.12 + pulse * 0.18,
                      )!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: BakasaColors.neonCyan.withValues(
                          alpha: 0.10 + outerPulse * 0.16,
                        ),
                        blurRadius: 36 + outerPulse * 22,
                        spreadRadius: outerPulse * 2,
                      ),
                      BoxShadow(
                        color: BakasaColors.neonMagenta.withValues(
                          alpha: 0.06 + pulse * 0.10,
                        ),
                        blurRadius: 52 + pulse * 16,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _HeroAmbientGlowPainter(animation: _glowCtrl),
                    ),
                    ColoredBox(
                      color: BakasaColors.bgDeep.withValues(alpha: 0.14),
                    ),
                    CarouselSlider.builder(
                      carouselController: _controller,
                      itemCount: _slides.length,
                      itemBuilder: (context, index, realIndex) {
                        return _HeroSlide(
                          imageAsset: _slides[index],
                          slideHeight: h,
                        );
                      },
                      options: CarouselOptions(
                        height: h,
                        viewportFraction: 1,
                        autoPlay: _slides.length > 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 700,
                        ),
                        autoPlayCurve: Curves.easeInOutCubic,
                        pauseAutoPlayOnTouch: true,
                        pauseAutoPlayOnManualNavigate: true,
                        enableInfiniteScroll: true,
                        scrollPhysics: const BouncingScrollPhysics(),
                        onPageChanged: (index, reason) {
                          setState(() => _activeIndex = index);
                        },
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _NavButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => _controller.previousPage(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _NavButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => _controller.nextPage(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (index) {
                          final selected = index == _activeIndex;
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: selected ? 22 : 8,
                              decoration: BoxDecoration(
                                color: selected
                                    ? BakasaColors.neonCyan
                                    : Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Slow-drifting neon wash + subtle scan-line shimmer (game menu style).
class _HeroAmbientGlowPainter extends CustomPainter {
  _HeroAmbientGlowPainter({required Animation<double> animation})
    : _animation = animation,
      super(repaint: animation);

  final Animation<double> _animation;

  double get _t => _animation.value;

  @override
  void paint(Canvas canvas, Size size) {
    final t = _t;
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    final base = RadialGradient(
      center: const Alignment(0.04, 0.38),
      radius: 1.25,
      colors: [
        const Color(0xFF15102A).withValues(alpha: 0.92),
        BakasaColors.bgDeep,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = base.createShader(rect));

    void blob(
      Color c,
      double phaseX,
      double phaseY,
      double ampX,
      double ampY,
      double radiusFactor,
      double alpha,
    ) {
      final ox = math.sin(t * math.pi * 2 + phaseX) * ampX * w * 0.42;
      final oy = math.cos(t * math.pi * 2 * 0.93 + phaseY) * ampY * h * 0.38;
      final center = Offset(w * 0.5 + ox, h * 0.46 + oy);
      final radius = math.max(w, h) * radiusFactor;
      final g = RadialGradient(
        colors: [
          c.withValues(alpha: alpha),
          c.withValues(alpha: 0),
        ],
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = g.createShader(
            Rect.fromCircle(center: center, radius: radius),
          ),
      );
    }

    blob(BakasaColors.neonCyan, 0, 1.7, 0.95, 0.55, 0.72, 0.38);
    blob(BakasaColors.neonMagenta, 2.4, -0.35, 0.88, 0.62, 0.58, 0.32);
    blob(const Color(0xFF6366F1), 5.1, 0.85, 0.65, 0.40, 0.48, 0.18);

    final scanAlpha = 0.03 + 0.03 * math.sin(t * math.pi * 2 * 8);
    final scanY = h * (0.15 + (t % 1) * 0.72);
    final scanGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.white.withValues(alpha: scanAlpha),
        Colors.transparent,
      ],
      stops: const [0.35, 0.5, 0.65],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, scanY - h * 0.09, w, h * 0.18),
      Paint()
        ..shader = scanGrad.createShader(Rect.fromLTWH(0, scanY, w, h * 0.2)),
    );

    final vignette = RadialGradient(
      center: Alignment.center,
      radius: 0.92,
      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.38)],
      stops: const [0.45, 1],
    );
    canvas.drawRect(rect, Paint()..shader = vignette.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant _HeroAmbientGlowPainter oldDelegate) => false;
}

/// Shared frame so every slide uses the same visible width/aspect treatment.
const double _kHeroSlideImageMaxWidth = 720;

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.imageAsset, required this.slideHeight});

  final String imageAsset;
  final double slideHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final imageW = math.min(maxW, _kHeroSlideImageMaxWidth);
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            ColoredBox(color: BakasaColors.bgDeep.withValues(alpha: 0.5)),
            Center(
              child: SizedBox(
                width: imageW,
                height: slideHeight,
                child: Image.asset(
                  imageAsset,
                  width: imageW,
                  height: slideHeight,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.34),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
