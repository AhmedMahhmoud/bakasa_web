import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/screens/success_screen.dart';
import 'package:bakasa_web/services/order_submission_service.dart';
import 'package:bakasa_web/services/reverse_geocode_service.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:bakasa_web/widgets/neon_card.dart';
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
  final _locationController = TextEditingController();
  bool _loading = false;
  bool _locating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _fillLocationFromDevice() async {
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Turn on location services to use this.')),
        );
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
            const SnackBar(content: Text('Location permission is required to detect your address.')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not look up your address. Please type it manually.'),
          ),
        );
        return;
      }
      final existing = _locationController.text.trim();
      _locationController.text = existing.isEmpty ? address : '$existing — $address';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await OrderSubmissionService.submit(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      _goSuccess();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Something went wrong. Try again.'),
      ),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Place your order',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.w700, fontSize: 18),
        ),
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
                          'We need a few details to arrange delivery.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: BakasaColors.textMuted,
                              ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your name';
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
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                            hintText: 'e.g. +20 10 1234 5678',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            final digits = RegExp(r'\d').allMatches(v).length;
                            if (digits < 7) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _locationController,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Location / delivery address',
                            alignLabelWithHint: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter an address or use your location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _locating ? null : _fillLocationFromDevice,
                          icon: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location_rounded),
                          label: Text(
                            _locating ? 'Locating…' : 'Use my current location',
                            style: GoogleFonts.exo2(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Uses your position to look up a readable address. '
                          'You can edit the text before submitting.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: BakasaColors.textMuted,
                              ),
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
                                  'SUBMIT ORDER',
                                  style: GoogleFonts.orbitron(fontWeight: FontWeight.w800),
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          BakasaConfig.orderSubmitUrlResolved.isEmpty
                              ? 'Orders are sent by email to ${BakasaConfig.orderEmail} '
                                  '(SMTP in the app on phone/desktop; on web your mail app opens). '
                                  'Optional: set firebaseOrderSubmitUrl to POST to your own server instead.'
                              : 'Orders POST to your configured URL; a copy may also be emailed to '
                                  '${BakasaConfig.orderEmail}.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: BakasaColors.textMuted.withValues(alpha: 0.85),
                              ),
                        ),
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
