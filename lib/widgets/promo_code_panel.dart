import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/services/order_pricing.dart';
import 'package:bakasa_web/services/promo_code_service.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Promo entry + apply flow for the order form (Firestore-backed).
class PromoCodePanel extends StatelessWidget {
  const PromoCodePanel({
    super.key,
    required this.controller,
    required this.applied,
    required this.inlineError,
    required this.applying,
    required this.onApply,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValidatedPromo? applied;

  /// Shown after a failed Apply (submit uses a SnackBar instead).
  final String? inlineError;
  final bool applying;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF1E293B)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: BakasaColors.neonCyan, width: 1.2),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BakasaColors.bgPanel.withValues(alpha: 0.55),
            BakasaColors.bgDeep.withValues(alpha: 0.25),
          ],
        ),
        border: Border.all(
          color: applied != null
              ? BakasaColors.neonCyan.withValues(alpha: 0.45)
              : BakasaColors.borderGlow,
        ),
        boxShadow: [
          if (applied != null)
            BoxShadow(
              color: BakasaColors.neonCyan.withValues(alpha: 0.12),
              blurRadius: 18,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_outlined, color: BakasaColors.neonMagenta),
              const SizedBox(width: 10),
              Text(
                l10n.promoCode,
                style: GoogleFonts.orbitron(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.promoCodeIntro,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: BakasaColors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.enterYourPromoCode,
                    hintStyle: TextStyle(
                      color: BakasaColors.textMuted.withValues(alpha: 0.7),
                    ),
                    filled: true,
                    fillColor: BakasaColors.bgDeep.withValues(alpha: 0.35),
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => onApply(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: applying ? null : onApply,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: BakasaColors.bgPanel,
                  foregroundColor: BakasaColors.neonCyan,
                ),
                child: applying
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l10n.apply,
                        style: GoogleFonts.exo2(fontWeight: FontWeight.w700),
                      ),
              ),
            ],
          ),
          if (inlineError != null) ...[
            const SizedBox(height: 8),
            Text(
              inlineError!,
              style: GoogleFonts.exo2(
                fontSize: 12.5,
                color: Colors.redAccent.shade100,
                height: 1.3,
              ),
            ),
          ],
          if (applied != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: BakasaColors.neonCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.exo2(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.appliedLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: applied!.id,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (applied!.discountPercent > 0)
                          TextSpan(
                            text:
                                '  ·  ${l10n.percentOff(applied!.discountPercent)}',
                            style: TextStyle(
                              color: BakasaColors.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        else if (applied!.label != applied!.id)
                          TextSpan(
                            text: '  ·  ${applied!.label}',
                            style: TextStyle(
                              color: BakasaColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onClear,
                  child: Text(
                    l10n.remove,
                    style: GoogleFonts.exo2(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Divider(
            height: 1,
            color: BakasaColors.textMuted.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.collectorBoxPrice,
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: BakasaColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _PriceSummary(appliedPromo: applied),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({required this.appliedPromo});

  final ValidatedPromo? appliedPromo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final base = BakasaConfig.productPriceEgp;
    final cur = l10n.currencyEgp;
    final pct = appliedPromo?.discountPercent ?? 0;
    final hasPct = pct > 0;
    final finalAmt = OrderPricing.finalPriceEgp(base, pct);
    final save = OrderPricing.savingsEgp(base, pct);

    if (!hasPct) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$cur ',
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: BakasaColors.textMuted,
            ),
          ),
          Text(
            '$base',
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: BakasaColors.gold,
              height: 1.05,
            ),
          ),
          if (appliedPromo != null) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.promoNoPercent,
                style: GoogleFonts.exo2(
                  fontSize: 11.5,
                  color: BakasaColors.textMuted,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ],
      );
    }

    final codeId = appliedPromo!.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$cur ',
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BakasaColors.textMuted,
              ),
            ),
            Text(
              '$base',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BakasaColors.textMuted,
                decoration: TextDecoration.lineThrough,
                decorationColor: BakasaColors.textMuted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: BakasaColors.neonCyan.withValues(alpha: 0.85),
              ),
            ),
            Text(
              ' $cur ',
              style: GoogleFonts.orbitron(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: BakasaColors.neonCyan,
              ),
            ),
            Text(
              '$finalAmt',
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: BakasaColors.gold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          save > 0
              ? l10n.youSave(cur, save, pct, codeId)
              : l10n.percentOffApplied(pct, codeId),
          style: GoogleFonts.exo2(
            fontSize: 12.5,
            color: BakasaColors.textMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
