import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/services/locale_controller.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Compact neon pill that opens a popup with English / العربية.
///
/// Reads/writes through [LocaleScope] — drop it anywhere under the [MaterialApp].
class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key, this.dense = false});

  /// When true, renders without the leading globe icon (saves space in AppBars).
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);
    final l10n = AppLocalizations.of(context);
    final isArabic = controller.isArabic;

    final shortLabel = isArabic ? l10n.languageShortAr : l10n.languageShortEn;

    return PopupMenuButton<Locale>(
      tooltip: l10n.language,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 6),
      color: BakasaColors.bgPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: BakasaColors.neonCyan.withValues(alpha: 0.35)),
      ),
      onSelected: controller.setLocale,
      itemBuilder: (context) => <PopupMenuEntry<Locale>>[
        _menuItem(
          context,
          value: LocaleController.englishLocale,
          label: l10n.languageEnglish,
          tag: 'EN',
          selected: !isArabic,
        ),
        _menuItem(
          context,
          value: LocaleController.arabicLocale,
          label: l10n.languageArabic,
          tag: 'ع',
          selected: isArabic,
        ),
      ],
      child: _Pill(
        label: shortLabel,
        dense: dense,
      ),
    );
  }

  PopupMenuItem<Locale> _menuItem(
    BuildContext context, {
    required Locale value,
    required String label,
    required String tag,
    required bool selected,
  }) {
    return PopupMenuItem<Locale>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: selected
                  ? BakasaColors.neonCyan.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: selected
                    ? BakasaColors.neonCyan
                    : BakasaColors.borderGlow,
              ),
            ),
            child: Text(
              tag,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? BakasaColors.neonCyan : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.exo2(
              color: Colors.white,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (selected) ...[
            const SizedBox(width: 10),
            Icon(Icons.check_rounded, size: 18, color: BakasaColors.neonCyan),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.dense});

  final String label;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final padH = dense ? 10.0 : 12.0;
    final padV = dense ? 6.0 : 8.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: BakasaColors.bgPanel.withValues(alpha: 0.65),
        border: Border.all(
          color: BakasaColors.neonCyan.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: BakasaColors.neonCyan.withValues(alpha: 0.12),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!dense) ...[
            Icon(
              Icons.language_rounded,
              size: 16,
              color: BakasaColors.neonCyan,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.expand_more_rounded,
            size: 16,
            color: BakasaColors.textMuted,
          ),
        ],
      ),
    );
  }
}
