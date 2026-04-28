import 'package:bakasa_web/services/order_notification_types.dart';

/// Web: SMTP is unavailable; [OrderSmtpOutcome.skippedNoCredentials] triggers mailto fallback.
Future<OrderSmtpOutcome> sendOrderNotificationAfterSubmit({
  required String subject,
  required String bodyText,
}) async {
  return OrderSmtpOutcome.skippedNoCredentials;
}
