import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:bakasa_web/widgets/language_switcher_button.dart';
import 'package:bakasa_web/widgets/neon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [
                    BakasaColors.neonCyan.withValues(alpha: 0.12),
                    BakasaColors.bgDeep,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: NeonCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                              Icons.verified_rounded,
                              size: 88,
                              color: BakasaColors.neonCyan,
                            )
                            .animate()
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              duration: 500.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),
                        Text(
                          l10n.orderReceived,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.orbitron(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.orderReceivedDescription,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: BakasaColors.textMuted,
                                height: 1.5,
                              ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            l10n.backToProduct,
                            style: GoogleFonts.orbitron(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
}
