/// Sends order notification via SMTP ([mailer]) on **IO** only.
///
/// On Web, returns [OrderSmtpOutcome.skippedNoCredentials] — use mailto or another HTTP backend.
///
/// Credentials: [BakasaConfig.orderSmtpAppPassword] or [BakasaConfig.orderSmtpAppPasswordBase64].
library;

export 'order_notification_types.dart';
export 'order_notification_mail_stub.dart'
    if (dart.library.io) 'order_notification_mail_io.dart';
