/// List price + promo percent → amounts shown on the order form and in notifications.
class OrderPricing {
  OrderPricing._();

  static int _clampPercent(int percent) => percent.clamp(0, 100);

  /// Rounds to whole EGP (your shop uses integer prices on the site).
  static int finalPriceEgp(int listPriceEgp, int discountPercent) {
    if (listPriceEgp <= 0) return 0;
    final p = _clampPercent(discountPercent);
    return ((listPriceEgp * (100 - p)) / 100).round();
  }

  static int savingsEgp(int listPriceEgp, int discountPercent) =>
      listPriceEgp - finalPriceEgp(listPriceEgp, discountPercent);
}
