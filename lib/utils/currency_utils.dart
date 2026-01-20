class CurrencyUtils {
  static String formatRupiah(double amount, {bool showSymbol = true}) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return showSymbol ? 'Rp $formatted' : formatted;
  }

  static String formatRupiahFromInt(int amount, {bool showSymbol = true}) {
    return formatRupiah(amount.toDouble(), showSymbol: showSymbol);
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}Rb';
    }
    return amount.toStringAsFixed(0);
  }

  static double parseRupiah(String value) {
    final cleaned = value
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  static String formatDiscount(double originalPrice, double discountPrice) {
    if (originalPrice <= 0) return '0%';
    final discount = ((originalPrice - discountPrice) / originalPrice * 100);
    return '${discount.toStringAsFixed(0)}%';
  }

  static String formatPriceRange(double minPrice, double maxPrice) {
    if (minPrice == maxPrice) {
      return formatRupiah(minPrice);
    }
    return '${formatRupiah(minPrice)} - ${formatRupiah(maxPrice)}';
  }

  static String formatFreeOrPrice(double price) {
    if (price == 0) return 'Gratis';
    return formatRupiah(price);
  }
}
