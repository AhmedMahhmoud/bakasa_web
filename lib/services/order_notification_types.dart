/// Result of attempting to send order mail via SMTP ([mailer], IO only).
enum OrderSmtpOutcome {
  /// No app password configured — use another channel (e.g. mailto).
  skippedNoCredentials,

  /// SMTP accepted the message.
  sent,

  /// SMTP failed after credentials were present.
  failed,
}
