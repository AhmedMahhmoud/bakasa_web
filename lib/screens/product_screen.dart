import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/screens/order_screen.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:bakasa_web/widgets/neon_card.dart';
import 'package:bakasa_web/widgets/product_box_hero.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundGrid(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 900;
                    final pad = constraints.maxWidth < 600 ? 20.0 : 32.0;
                    final content = wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: EdgeInsets.only(right: pad),
                                  child: const ProductBoxHero(maxHeight: 440),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: _ProductCopy(
                                  onOrder: () => _openOrder(context),
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: pad,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                const ProductBoxHero(maxHeight: 360),
                                const SizedBox(height: 28),
                                _ProductCopy(
                                  onOrder: () => _openOrder(context),
                                ),
                              ],
                            ),
                          );
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: pad,
                        vertical: 8,
                      ),
                      child: content,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openOrder(BuildContext context) {
    Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondary) => const OrderScreen(),
        transitionsBuilder: (context, animation, secondary, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BakasaColors.bgDeep,
            const Color(0xFF0C1222),
            BakasaColors.bgDeep,
          ],
        ),
      ),
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BakasaColors.neonCyan.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProductCopy extends StatelessWidget {
  const _ProductCopy({required this.onOrder});

  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    final headline = GoogleFonts.orbitron(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      height: 1.15,
      color: Colors.white,
    );
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COLLECTOR EDITION',
            style: GoogleFonts.exo2(
              fontSize: 12,
              letterSpacing: 4,
              color: BakasaColors.neonMagenta,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(BakasaConfig.productName, style: headline),
          const SizedBox(height: 16),
          Text(
            BakasaConfig.shortDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: BakasaColors.textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Inside the box',
            style: GoogleFonts.exo2(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            BakasaConfig.boxContents,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: BakasaColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final row = c.maxWidth >= 420;
              final priceCol = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    BakasaConfig.priceLabel,
                    style: GoogleFonts.orbitron(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: BakasaColors.gold,
                    ),
                  ),
                  Text(
                    BakasaConfig.priceNote,
                    style: TextStyle(
                      color: BakasaColors.textMuted.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              );
              final btn = FilledButton(
                onPressed: onOrder,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                ),
                child: Text(
                  'ORDER NOW',
                  style: GoogleFonts.orbitron(fontWeight: FontWeight.w800),
                ),
              );
              if (row) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [priceCol, const Spacer(), btn],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [priceCol, const SizedBox(height: 20), btn],
              );
            },
          ),
        ],
      ),
    );
  }
}
