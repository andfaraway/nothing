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
}
