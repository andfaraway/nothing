class Tools {
  static Map<String, dynamic> safeJson(dynamic value) {
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  static List safeList(dynamic value) {
    return value is List ? value : [];
  }

  static String safeString(dynamic value) {
    return value is String ? value : '';
  }

  static String formatBytes(int? bytes, {int decimalPlaces = 1}) {
    if (bytes == null) return '';
    if (bytes < 1024) {
      return '${_formatDecimal(bytes.toDouble(), decimalPlaces)}B';
    } else if (bytes < 1024 * 1024) {
      double kilobytes = bytes / 1024;
      return '${_formatDecimal(kilobytes, decimalPlaces)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      double megabytes = bytes / (1024 * 1024);
      return '${_formatDecimal(megabytes, decimalPlaces)}MB';
    } else if (bytes < 1024 * 1024 * 1024 * 1024) {
      double gigabytes = bytes / (1024 * 1024 * 1024);
      return '${_formatDecimal(gigabytes, decimalPlaces)}GB';
    } else {
      double terabytes = bytes / (1024 * 1024 * 1024 * 1024);
      return '${_formatDecimal(terabytes, decimalPlaces)}TB';
    }
  }

  static String _formatDecimal(double value, int decimalPlaces) {
    String formatted = value.toStringAsFixed(decimalPlaces);
    if (formatted.endsWith('.00')) {
      return formatted.substring(0, formatted.length - 3);
    } else if (formatted.endsWith('.0')) {
      return formatted.substring(0, formatted.length - 2);
    }
    return formatted;
  }
}
