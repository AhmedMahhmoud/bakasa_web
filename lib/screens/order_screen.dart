import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/l10n/governorate_labels.dart';
import 'package:bakasa_web/l10n/promo_error_messages.dart';
import 'package:bakasa_web/screens/success_screen.dart';
import 'package:bakasa_web/services/order_pricing.dart';
import 'package:bakasa_web/services/order_submission_service.dart';
import 'package:bakasa_web/services/promo_code_service.dart';
import 'package:bakasa_web/services/reverse_geocode_service.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:bakasa_web/widgets/language_switcher_button.dart';
import 'package:bakasa_web/widgets/neon_card.dart';
import 'package:bakasa_web/widgets/promo_code_panel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _notesController = TextEditingController();
  final _promoController = TextEditingController();

  String? _selectedGovernorate;
  ValidatedPromo? _appliedPromo;
  String? _promoInlineError;
  bool _promoApplying = false;
  bool _loading = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _promoController.addListener(_onPromoTextChanged);
  }

  void _onPromoTextChanged() {
    final typed = PromoCodeService.normalize(_promoController.text);
    if (_appliedPromo != null && _appliedPromo!.id != typed) {
      setState(() {
        _appliedPromo = null;
        _promoInlineError = null;
      });
    }
  }

  @override
  void dispose() {
    _promoController.removeListener(_onPromoTextChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _notesController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _fillLocationFromDevice() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorLocationServicesOff)));
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorLocationPermissionRequired)),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final lang = Localizations.localeOf(context).toLanguageTag();
      final address = await ReverseGeocodeService.addressFromCoordinates(
        latitude: pos.latitude,
        longitude: pos.longitude,
        acceptLanguage: lang,
      );
      if (!mounted) return;
      if (address == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorLookupAddress)));
        return;
      }
      final existing = _notesController.text.trim();
      _notesController.text = existing.isEmpty
          ? address
          : '$existing — $address';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGetLocation(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _applyPromoFromButton() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    final raw = _promoController.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _promoInlineError = l10n.promoErrorEmpty;
        _appliedPromo = null;
      });
      return;
    }

    setState(() {
      _promoApplying = true;
      _promoInlineError = null;
    });

    final r = await PromoCodeService.validate(raw);
    if (!mounted) return;
    setState(() => _promoApplying = false);

    if (!r.ok) {
      setState(() {
        _appliedPromo = null;
        _promoInlineError = r.errorCode == null
            ? l10n.promoErrorCouldNotApply
            : promoErrorMessage(l10n, r.errorCode!, context: r.errorContext);
      });
      return;
    }

    setState(() {
      _appliedPromo = r.promo;
      _promoInlineError = null;
    });
  }

  void _clearPromo() {
    _promoController.clear();
    setState(() {
      _appliedPromo = null;
      _promoInlineError = null;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final rawPromo = _promoController.text.trim();
    String? promoToSend;

    if (rawPromo.isNotEmpty) {
      final normalized = PromoCodeService.normalize(rawPromo);
      if (_appliedPromo?.id == normalized) {
        promoToSend = _appliedPromo!.id;
      } else {
        setState(() => _loading = true);
        final r = await PromoCodeService.validate(rawPromo);
        if (!mounted) return;
        setState(() => _loading = false);
        if (!r.ok) {
          final msg = r.errorCode == null
              ? l10n.promoErrorNotValid
              : promoErrorMessage(l10n, r.errorCode!, context: r.errorContext);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
          return;
        }
        promoToSend = r.promo!.id;
        if (!mounted) return;
        setState(() {
          _appliedPromo = r.promo;
          _promoInlineError = null;
        });
      }
    }

    setState(() => _loading = true);

    final listEgp = BakasaConfig.productPriceEgp;
    final discPct =
        (promoToSend != null &&
            _appliedPromo != null &&
            _appliedPromo!.id == promoToSend)
        ? _appliedPromo!.discountPercent
        : 0;
    final payEgp = OrderPricing.finalPriceEgp(listEgp, discPct);
    final deliveryEgp =
        BakasaConfig.deliveryCostByGovernorateEgp[_selectedGovernorate] ?? 0;
    final totalEgp = payEgp + deliveryEgp;

    final result = await OrderSubmissionService.submit(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      governorate: _selectedGovernorate ?? '',
      city: _cityController.text.trim(),
      street: _streetController.text.trim(),
      buildingNumber: _buildingController.text.trim(),
      floorNumber: _floorController.text.trim(),
      apartmentNumber: _apartmentController.text.trim(),
      notesOrLandmark: _notesController.text.trim(),
      promoCode: promoToSend,
      listPriceEgp: listEgp,
      itemPriceAfterDiscountEgp: payEgp,
      deliveryCostEgp: deliveryEgp,
      totalPriceEgp: totalEgp,
      discountPercentApplied: discPct,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      _goSuccess();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message ?? l10n.errorSomethingWentWrong)),
    );
  }

  void _goSuccess() {
    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        pageBuilder: (context, a, s) => const SuccessScreen(),
        transitionsBuilder: (context, animation, secondary, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // iOS-style chevron is not auto-mirrored; flip manually in RTL.
          icon: Transform.flip(
            flipX: isRtl,
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.placeYourOrder,
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 12),
            child: Center(child: LanguageSwitcherButton(dense: true)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    BakasaColors.bgDeep,
                    BakasaColors.bgPanel.withValues(alpha: 0.5),
                    BakasaColors.bgDeep,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: NeonCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.deliveryDetailsIntro,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: BakasaColors.textMuted),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.fullName,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validatorEnterName;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: l10n.phoneNumber,
                            hintText: l10n.phoneHint,
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validatorEnterPhone;
                            }
                            final digits = RegExp(r'\d').allMatches(v).length;
                            if (digits < 7) {
                              return l10n.validatorPhoneInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGovernorate,
                          isExpanded: true,
                          alignment: AlignmentDirectional.centerStart,
                          decoration: InputDecoration(
                            labelText: l10n.governorate,
                            prefixIcon: const Icon(
                              Icons.location_city_outlined,
                            ),
                          ),
                          items: BakasaConfig
                              .deliveryCostByGovernorateEgp
                              .entries
                              .map(
                                (entry) => DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      governorateLabel(entry.key, l10n),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedGovernorate = value);
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.validatorSelectGovernorate;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _cityController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.city,
                            prefixIcon: const Icon(Icons.map_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validatorEnterCity;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _streetController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.streetName,
                            prefixIcon: const Icon(Icons.route_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validatorEnterStreet;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _buildingController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: l10n.buildingNumber,
                                  prefixIcon: const Icon(
                                    Icons.apartment_rounded,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.validatorRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _floorController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: l10n.floorNumber,
                                  prefixIcon: const Icon(Icons.stairs_rounded),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.validatorRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _apartmentController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.apartmentNumber,
                            prefixIcon: const Icon(
                              Icons.door_front_door_outlined,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validatorEnterApartment;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.notesLandmarkOptional,
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _locating ? null : _fillLocationFromDevice,
                          icon: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location_rounded),
                          label: Text(
                            _locating
                                ? l10n.locating
                                : l10n.useMyCurrentLocation,
                            style: GoogleFonts.exo2(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.locationHelp,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: BakasaColors.textMuted),
                        ),
                        const SizedBox(height: 22),
                        PromoCodePanel(
                          controller: _promoController,
                          applied: _appliedPromo,
                          inlineError: _promoInlineError,
                          applying: _promoApplying,
                          onApply: _applyPromoFromButton,
                          onClear: _clearPromo,
                        ),
                        const SizedBox(height: 18),
                        _DeliverySummary(
                          itemAfterDiscountEgp: OrderPricing.finalPriceEgp(
                            BakasaConfig.productPriceEgp,
                            _appliedPromo?.discountPercent ?? 0,
                          ),
                          deliveryCostEgp: _selectedGovernorate == null
                              ? null
                              : BakasaConfig
                                    .deliveryCostByGovernorateEgp[_selectedGovernorate!],
                        ),
                        const SizedBox(height: 28),
                        FilledButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: BakasaColors.bgDeep,
                                  ),
                                )
                              : Text(
                                  l10n.submitOrder,
                                  style: GoogleFonts.orbitron(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        // Text(
                        //   BakasaConfig.orderSubmitUrlResolved.isEmpty
                        //       ? l10n.orderInfoEmailOnly(BakasaConfig.orderEmail)
                        //       : l10n.orderInfoPost(BakasaConfig.orderEmail),
                        //   textAlign: TextAlign.center,
                        //   style: Theme.of(context).textTheme.bodySmall
                        //       ?.copyWith(
                        //         color: BakasaColors.textMuted.withValues(
                        //           alpha: 0.85,
                        //         ),
                        //       ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverySummary extends StatelessWidget {
  const _DeliverySummary({
    required this.itemAfterDiscountEgp,
    required this.deliveryCostEgp,
  });

  final int itemAfterDiscountEgp;
  final int? deliveryCostEgp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cur = l10n.currencyEgp;
    final delivery = deliveryCostEgp ?? 0;
    final total = itemAfterDiscountEgp + delivery;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BakasaColors.bgPanel.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BakasaColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderTotal,
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: BakasaColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          _line(l10n.item, l10n.currencyAmount(cur, itemAfterDiscountEgp)),
          const SizedBox(height: 6),
          _line(
            l10n.delivery,
            deliveryCostEgp == null
                ? l10n.selectGovernorateShort
                : l10n.currencyAmount(cur, delivery),
          ),
          const Divider(height: 18, color: Color(0x33475569)),
          _line(l10n.total, l10n.currencyAmount(cur, total), emphasize: true),
        ],
      ),
    );
  }

  Widget _line(String title, String value, {bool emphasize = false}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.exo2(
            color: emphasize ? Colors.white : BakasaColors.textMuted,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: emphasize ? BakasaColors.gold : Colors.white,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
