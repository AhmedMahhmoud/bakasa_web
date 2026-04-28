import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/services/order_notification_types.dart';
import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Gmail SMTP using [BakasaConfig.orderEmail] and [BakasaConfig.orderSmtpPasswordResolved].
Future<OrderSmtpOutcome> sendOrderNotificationAfterSubmit({
  required String subject,
  required String bodyText,
}) async {
  final smtpPassword = BakasaConfig.orderSmtpPasswordResolved;
  if (smtpPassword == null || smtpPassword.isEmpty) {
    return OrderSmtpOutcome.skippedNoCredentials;
  }

  final smtpUser = BakasaConfig.orderEmail;
  final smtpServer = gmail(smtpUser, smtpPassword);
  final message = Message()
    ..from = Address(smtpUser, 'Bakasa orders')
    ..recipients.add(BakasaConfig.orderEmail)
    ..subject = subject
    ..text = bodyText;

  try {
    await send(message, smtpServer, timeout: const Duration(seconds: 20));
    return OrderSmtpOutcome.sent;
  } on MailerException catch (e, st) {
    debugPrint('Order notification email failed: $e');
    debugPrint('$st');
    return OrderSmtpOutcome.failed;
  } catch (e, st) {
    debugPrint('Order notification email error: $e');
    debugPrint('$st');
    return OrderSmtpOutcome.failed;
  }
}
