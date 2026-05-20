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
    required String governorate,
    required String city,
    required String street,
    required String buildingNumber,
    required String floorNumber,
    required String apartmentNumber,
    String? notesOrLandmark,
    String? promoCode,
    required int listPriceEgp,
    required int itemPriceAfterDiscountEgp,
    required int deliveryCostEgp,
    required int totalPriceEgp,
    int discountPercentApplied = 0,
  }) {
    final cur = BakasaConfig.priceCurrency;
    final buffer = StringBuffer()
      ..writeln('New Bakasa box order')
      ..writeln()
      ..writeln('Name: $name')
      ..writeln('Phone: $phone')
      ..writeln('Governorate: $governorate')
      ..writeln('City: $city')
      ..writeln('Street: $street')
      ..writeln('Building no.: $buildingNumber')
      ..writeln('Floor no.: $floorNumber')
      ..writeln('Apartment no.: $apartmentNumber');
    if (notesOrLandmark != null && notesOrLandmark.trim().isNotEmpty) {
      buffer.writeln('Notes / landmark: ${notesOrLandmark.trim()}');
    }
    buffer
      ..writeln()
      ..writeln('Pricing')
      ..writeln('List price ($cur): $listPriceEgp');
    if (discountPercentApplied > 0) {
      buffer.writeln('Promo discount: $discountPercentApplied%');
    }
    buffer
      ..writeln('Item after discount ($cur): $itemPriceAfterDiscountEgp')
      ..writeln('Delivery fee ($cur): $deliveryCostEgp')
      ..writeln('Total to pay ($cur): $totalPriceEgp');
    if (promoCode != null && promoCode.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Promo code: ${promoCode.trim()}');
    }
    buffer
      ..writeln()
      ..writeln('— Sent from Bakasa web order form');
    return buffer.toString();
  }

  static String _notificationBodyText({
    required String name,
    required String phone,
    required String governorate,
    required String city,
    required String street,
    required String buildingNumber,
    required String floorNumber,
    required String apartmentNumber,
    String? notesOrLandmark,
    String? promoCode,
    required int listPriceEgp,
    required int itemPriceAfterDiscountEgp,
    required int deliveryCostEgp,
    required int totalPriceEgp,
    int discountPercentApplied = 0,
  }) {
    return buildOrderBody(
      name: name,
      phone: phone,
      governorate: governorate,
      city: city,
      street: street,
      buildingNumber: buildingNumber,
      floorNumber: floorNumber,
      apartmentNumber: apartmentNumber,
      notesOrLandmark: notesOrLandmark,
      promoCode: promoCode,
      listPriceEgp: listPriceEgp,
      itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
      deliveryCostEgp: deliveryCostEgp,
      totalPriceEgp: totalPriceEgp,
      discountPercentApplied: discountPercentApplied,
    );
  }

  static Future<OrderSmtpOutcome> _notifyMail({
    required String name,
    required String phone,
    required String governorate,
    required String city,
    required String street,
    required String buildingNumber,
    required String floorNumber,
    required String apartmentNumber,
    String? notesOrLandmark,
    String? promoCode,
    required int listPriceEgp,
    required int itemPriceAfterDiscountEgp,
    required int deliveryCostEgp,
    required int totalPriceEgp,
    int discountPercentApplied = 0,
  }) {
    return sendOrderNotificationAfterSubmit(
      subject: 'Bakasa order — $name',
      bodyText: _notificationBodyText(
        name: name,
        phone: phone,
        governorate: governorate,
        city: city,
        street: street,
        buildingNumber: buildingNumber,
        floorNumber: floorNumber,
        apartmentNumber: apartmentNumber,
        notesOrLandmark: notesOrLandmark,
        promoCode: promoCode,
        listPriceEgp: listPriceEgp,
        itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
        deliveryCostEgp: deliveryCostEgp,
        totalPriceEgp: totalPriceEgp,
        discountPercentApplied: discountPercentApplied,
      ),
    );
  }

  static Future<OrderSubmissionResult> submitViaMailto({
    required String name,
    required String phone,
    required String governorate,
    required String city,
    required String street,
    required String buildingNumber,
    required String floorNumber,
    required String apartmentNumber,
    String? notesOrLandmark,
    String? promoCode,
    required int listPriceEgp,
    required int itemPriceAfterDiscountEgp,
    required int deliveryCostEgp,
    required int totalPriceEgp,
    int discountPercentApplied = 0,
  }) async {
    final bodyText = buildOrderBody(
      name: name,
      phone: phone,
      governorate: governorate,
      city: city,
      street: street,
      buildingNumber: buildingNumber,
      floorNumber: floorNumber,
      apartmentNumber: apartmentNumber,
      notesOrLandmark: notesOrLandmark,
      promoCode: promoCode,
      listPriceEgp: listPriceEgp,
      itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
      deliveryCostEgp: deliveryCostEgp,
      totalPriceEgp: totalPriceEgp,
      discountPercentApplied: discountPercentApplied,
    );
    final uri = Uri(
      scheme: 'mailto',
      path: BakasaConfig.orderEmail,
      queryParameters: <String, String>{
        'subject': 'Bakasa order — $name',
        'body': bodyText,
      },
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
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
    required String governorate,
    required String city,
    required String street,
    required String buildingNumber,
    required String floorNumber,
    required String apartmentNumber,
    String? notesOrLandmark,
    String? promoCode,
    required int listPriceEgp,
    required int itemPriceAfterDiscountEgp,
    required int deliveryCostEgp,
    required int totalPriceEgp,
    int discountPercentApplied = 0,
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
        governorate: governorate,
        city: city,
        street: street,
        buildingNumber: buildingNumber,
        floorNumber: floorNumber,
        apartmentNumber: apartmentNumber,
        notesOrLandmark: notesOrLandmark,
        promoCode: promoCode,
        listPriceEgp: listPriceEgp,
        itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
        deliveryCostEgp: deliveryCostEgp,
        totalPriceEgp: totalPriceEgp,
        discountPercentApplied: discountPercentApplied,
      );
      switch (outcome) {
        case OrderSmtpOutcome.sent:
          return const OrderSubmissionResult(success: true);
        case OrderSmtpOutcome.skippedNoCredentials:
          return submitViaMailto(
            name: name,
            phone: phone,
            governorate: governorate,
            city: city,
            street: street,
            buildingNumber: buildingNumber,
            floorNumber: floorNumber,
            apartmentNumber: apartmentNumber,
            notesOrLandmark: notesOrLandmark,
            promoCode: promoCode,
            listPriceEgp: listPriceEgp,
            itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
            deliveryCostEgp: deliveryCostEgp,
            totalPriceEgp: totalPriceEgp,
            discountPercentApplied: discountPercentApplied,
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

    final payload = <String, dynamic>{
      'name': name,
      'phone': phone,
      'governorate': governorate,
      'city': city,
      'street': street,
      'buildingNumber': buildingNumber,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'notesOrLandmark': notesOrLandmark ?? '',
      'originalPriceEgp': listPriceEgp,
      'itemPriceAfterDiscountEgp': itemPriceAfterDiscountEgp,
      'deliveryCostEgp': deliveryCostEgp,
      'finalPriceEgp': totalPriceEgp,
      'discountPercent': discountPercentApplied,
    };
    if (promoCode != null && promoCode.trim().isNotEmpty) {
      payload['promoCode'] = promoCode.trim();
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      final decoded = _tryDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded is Map) {
          if (decoded['success'] == true) {
            await _notifyMail(
              name: name,
              phone: phone,
              governorate: governorate,
              city: city,
              street: street,
              buildingNumber: buildingNumber,
              floorNumber: floorNumber,
              apartmentNumber: apartmentNumber,
              notesOrLandmark: notesOrLandmark,
              promoCode: promoCode,
              listPriceEgp: listPriceEgp,
              itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
              deliveryCostEgp: deliveryCostEgp,
              totalPriceEgp: totalPriceEgp,
              discountPercentApplied: discountPercentApplied,
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
          governorate: governorate,
          city: city,
          street: street,
          buildingNumber: buildingNumber,
          floorNumber: floorNumber,
          apartmentNumber: apartmentNumber,
          notesOrLandmark: notesOrLandmark,
          promoCode: promoCode,
          listPriceEgp: listPriceEgp,
          itemPriceAfterDiscountEgp: itemPriceAfterDiscountEgp,
          deliveryCostEgp: deliveryCostEgp,
          totalPriceEgp: totalPriceEgp,
          discountPercentApplied: discountPercentApplied,
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
