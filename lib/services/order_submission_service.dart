import 'dart:convert';

import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/services/order_notification_mail.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrderSubmissionResult {
  const OrderSubmissionResult({required this.success, this.message});

  final bool success;
  final String? message;
}

/// Submits orders: optional `POST` to [BakasaConfig.orderSubmitUrlResolved], or email-only
/// when that URL is empty (SMTP via [mailer] on mobile/desktop, mailto on web).
class OrderSubmissionService {
  OrderSubmissionService._();

  static String buildOrderBody({
    required String name,
    required String phone,
    required String location,
  }) {
    final buffer = StringBuffer()
      ..writeln('New Bakasa box order')
      ..writeln()
      ..writeln('Name: $name')
      ..writeln('Phone: $phone')
      ..writeln('Location / delivery: $location')
      ..writeln()
      ..writeln('— Sent from Bakasa web order form');
    return buffer.toString();
  }

  static String _notificationBodyText({
    required String name,
    required String phone,
    required String location,
  }) {
    final requestJson = jsonEncode(<String, String>{
      'name': name,
      'phone': phone,
      'location': location,
    });
    return '${buildOrderBody(name: name, phone: phone, location: location)}\n\n'
        '---\n'
        'Request JSON:\n'
        '$requestJson';
  }

  static Future<OrderSmtpOutcome> _notifyMail({
    required String name,
    required String phone,
    required String location,
  }) {
    return sendOrderNotificationAfterSubmit(
      subject: 'Bakasa order — $name',
      bodyText: _notificationBodyText(
        name: name,
        phone: phone,
        location: location,
      ),
    );
  }

  static Future<OrderSubmissionResult> submitViaMailto({
    required String name,
    required String phone,
    required String location,
  }) async {
    final bodyText = buildOrderBody(name: name, phone: phone, location: location);
    final uri = Uri(
      scheme: 'mailto',
      path: BakasaConfig.orderEmail,
      queryParameters: <String, String>{
        'subject': 'Bakasa order — $name',
        'body': bodyText,
      },
    );
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      return const OrderSubmissionResult(
        success: false,
        message: 'Could not open email app. Please email us your details.',
      );
    }
    return const OrderSubmissionResult(success: true);
  }

  static Future<OrderSubmissionResult> submit({
    required String name,
    required String phone,
    required String location,
  }) async {
    final url = BakasaConfig.orderSubmitUrlResolved;
    if (url.isEmpty) {
      // Web cannot send SMTP from the browser; mailto only opens a draft (never auto-sends).
      if (kIsWeb) {
        return const OrderSubmissionResult(
          success: false,
          message:
              'Web orders need firebaseOrderSubmitUrl (Cloud Function) in lib/config.dart — '
              'then rebuild and redeploy hosting. Mail cannot be sent automatically from the browser.',
        );
      }
      final outcome = await _notifyMail(
        name: name,
        phone: phone,
        location: location,
      );
      switch (outcome) {
        case OrderSmtpOutcome.sent:
          return const OrderSubmissionResult(success: true);
        case OrderSmtpOutcome.skippedNoCredentials:
          return submitViaMailto(
            name: name,
            phone: phone,
            location: location,
          );
        case OrderSmtpOutcome.failed:
          return const OrderSubmissionResult(
            success: false,
            message:
                'Could not send the order email. Check your Gmail app password in lib/config.dart and try again.',
          );
      }
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final secret = BakasaConfig.orderFormSecretResolved;
    if (secret.isNotEmpty) {
      headers['X-Order-Secret'] = secret;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'phone': phone,
          'location': location,
        }),
      );

      final decoded = _tryDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded is Map) {
          if (decoded['success'] == true) {
            await _notifyMail(
              name: name,
              phone: phone,
              location: location,
            );
            return const OrderSubmissionResult(success: true);
          }
          if (decoded['success'] == false) {
            return OrderSubmissionResult(
              success: false,
              message: decoded['message']?.toString() ?? 'Submission rejected',
            );
          }
        }
        await _notifyMail(
          name: name,
          phone: phone,
          location: location,
        );
        return const OrderSubmissionResult(success: true);
      }

      final errMsg = decoded is Map ? decoded['message']?.toString() : null;
      return OrderSubmissionResult(
        success: false,
        message: errMsg ?? 'Server error (${response.statusCode})',
      );
    } catch (e) {
      return OrderSubmissionResult(success: false, message: e.toString());
    }
  }

  static Object? _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }
}
