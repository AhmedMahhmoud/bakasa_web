import 'dart:math' as math;

import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/screens/order_screen.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:bakasa_web/widgets/how_to_play_embed.dart';
import 'package:bakasa_web/widgets/language_switcher_button.dart';
import 'package:bakasa_web/widgets/neon_card.dart';
import 'package:bakasa_web/widgets/product_box_hero.dart';
import 'package:flutter/material.dart';
import 'package:bakasa_web/theme/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const String _kHowToPlayUrl = 'https://youtube.com/shorts/-OwqJANtaUU';
const String _kHowToPlayVideoId = '-OwqJANtaUU';
const String _kGooglePlayUrl =
    'https://play.google.com/store/apps/details?id=com.game.bakasa';
const String _kAppleStoreUrl =
    'https://apps.apple.com/gb/app/bakasa/id6468965096';
const String _kInstagramUrl = 'https://www.instagram.com/bakasa_game';
const String _kFacebookUrl = 'https://www.facebook.com/bakasagame';
const String _kTikTokUrl = 'https://www.tiktok.com/@bakasa_game';
const String _kContactEmail = 'bakasagame@gmail.com';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundGrid(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pad = constraints.maxWidth < 600 ? 20.0 : 32.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: pad),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(pad, 12, pad, 0),
                        child: Center(
                          child: ConstrainedBox(
                            // Narrower hero = less upscaling of fixed-size PNGs → sharper on retina.
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth < 600
                                  ? constraints.maxWidth
                                  : 880,
                            ),
                            child: const ProductBoxHero(maxHeight: 500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: _ProductCopy(
                              onOrder: () => _openOrder(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: _HowToPlaySection(
                              onOpenVideo: () => _openExternal(_kHowToPlayUrl),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      _ModernFooter(
                        minHeight: 200,
                        onGooglePlay: () => _openExternal(_kGooglePlayUrl),
                        onAppleStore: () => _openExternal(_kAppleStoreUrl),
                        onInstagram: () => _openExternal(_kInstagramUrl),
                        onFacebook: () => _openExternal(_kFacebookUrl),
                        onTikTok: () => _openExternal(_kTikTokUrl),
                        onEmail: () => _openEmail(l10n.emailSubjectContactUs),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Floating language switcher — always reachable, doesn't interrupt the scroll.
          PositionedDirectional(
            top: 0,
            end: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: const LanguageSwitcherButton(),
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

  Future<void> _openExternal(String rawUrl) async {
    final uri = Uri.parse(rawUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail(String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _kContactEmail,
      queryParameters: {'subject': subject},
    );
    await launchUrl(uri);
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
    final l10n = AppLocalizations.of(context);
    final headline = appDisplayFont(
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
            l10n.collectorEdition,
            style: appBodyFont(
              fontSize: 12,
              letterSpacing: 4,
              color: BakasaColors.neonMagenta,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.productName, style: headline),
          const SizedBox(height: 16),
          Text(
            l10n.shortDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: BakasaColors.textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.insideTheBox,
            style: appBodyFont(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.boxContents,
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
                    l10n.priceLabel(BakasaConfig.productPriceEgp),
                    style: appDisplayFont(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: BakasaColors.gold,
                    ),
                  ),
                  Text(
                    l10n.priceNote,
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
                  l10n.orderNow,
                  style: appDisplayFont(fontWeight: FontWeight.w800),
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

class _HowToPlaySection extends StatelessWidget {
  const _HowToPlaySection({required this.onOpenVideo});

  final VoidCallback onOpenVideo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.howToPlay,
            style: appBodyFont(
              fontSize: 12,
              letterSpacing: 3.5,
              color: BakasaColors.neonCyan,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.quickVideoGuide,
            style: appDisplayFont(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.howToPlayDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: BakasaColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _VideoPreviewCard(
            videoId: _kHowToPlayVideoId,
            onOpenVideo: onOpenVideo,
          ),
        ],
      ),
    );
  }
}

class _VideoPreviewCard extends StatefulWidget {
  const _VideoPreviewCard({required this.videoId, required this.onOpenVideo});

  final String videoId;
  final VoidCallback onOpenVideo;

  @override
  State<_VideoPreviewCard> createState() => _VideoPreviewCardState();
}

class _VideoPreviewCardState extends State<_VideoPreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final glow = 0.12 + (_controller.value * 0.14);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: BakasaColors.neonMagenta.withValues(alpha: glow),
                blurRadius: 28,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: BakasaColors.neonCyan.withValues(alpha: glow * 0.9),
                blurRadius: 36,
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: BakasaColors.borderGlow),
                color: const Color(0xFF111A2E),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: HowToPlayEmbed(videoId: widget.videoId),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.smart_display_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.howToPlayBakasa,
                            style: appBodyFont(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: widget.onOpenVideo,
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: Text(l10n.youtube),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModernFooter extends StatefulWidget {
  const _ModernFooter({
    required this.minHeight,
    required this.onGooglePlay,
    required this.onAppleStore,
    required this.onInstagram,
    required this.onFacebook,
    required this.onTikTok,
    required this.onEmail,
  });

  final double minHeight;
  final VoidCallback onGooglePlay;
  final VoidCallback onAppleStore;
  final VoidCallback onInstagram;
  final VoidCallback onFacebook;
  final VoidCallback onTikTok;
  final VoidCallback onEmail;

  @override
  State<_ModernFooter> createState() => _ModernFooterState();
}

class _ModernFooterState extends State<_ModernFooter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final screenW = MediaQuery.sizeOf(context).width;
        final sidePad = screenW < 600 ? 20.0 : 32.0;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2, -0.9),
              end: Alignment(1 - t * 2, 1),
              colors: [
                const Color(0xFF11192E),
                BakasaColors.bgPanel,
                const Color(0xFF161331),
              ],
            ),
            border: Border.all(
              color: Color.lerp(
                BakasaColors.borderGlow,
                BakasaColors.neonMagenta.withValues(alpha: 0.4),
                0.4 + (0.35 * math.sin(t * math.pi * 2)),
              )!,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.minHeight),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -20,
                    child: _GlowOrb(
                      color: BakasaColors.neonCyan.withValues(alpha: 0.22),
                      size: 120,
                    ),
                  ),
                  Positioned(
                    left: -26,
                    bottom: -36,
                    child: _GlowOrb(
                      color: BakasaColors.neonMagenta.withValues(alpha: 0.20),
                      size: 140,
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(sidePad, 22, sidePad, 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.connectWithUs,
                              style: appBodyFont(
                                fontSize: 12,
                                letterSpacing: 3.2,
                                color: BakasaColors.neonCyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.joinCommunityTitle,
                              style: appDisplayFont(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.joinCommunityDescription,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: BakasaColors.textMuted),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _SocialButton(
                                  label: l10n.socialGooglePlay,
                                  icon: Icons.shop_2_outlined,
                                  onTap: widget.onGooglePlay,
                                ),
                                _SocialButton(
                                  label: l10n.socialAppStore,
                                  icon: Icons.apple,
                                  onTap: widget.onAppleStore,
                                ),
                                _SocialButton(
                                  label: l10n.socialInstagram,
                                  icon: Icons.camera_alt_outlined,
                                  onTap: widget.onInstagram,
                                ),
                                _SocialButton(
                                  label: l10n.socialFacebook,
                                  icon: Icons.facebook_rounded,
                                  onTap: widget.onFacebook,
                                ),
                                _SocialButton(
                                  label: l10n.socialTikTok,
                                  icon: Icons.music_note_rounded,
                                  onTap: widget.onTikTok,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            OutlinedButton.icon(
                              onPressed: widget.onEmail,
                              icon: const Icon(Icons.alternate_email_rounded),
                              label: const Text(_kContactEmail),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: BakasaColors.neonCyan.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 48, spreadRadius: 12),
          ],
        ),
        child: SizedBox(width: size, height: size),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: BakasaColors.neonCyan),
              const SizedBox(width: 8),
              Text(
                label,
                style: appBodyFont(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
