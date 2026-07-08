class ReviewContentFilter {
  static const Set<String> _placeholderExactValues = {
    'test',
    'testticket',
    'test ticket',
    'redsd',
  };

  static bool hasPlaceholderContent(Iterable<String?> values) {
    return values.any((value) {
      final normalized = _normalize(value);
      if (normalized.isEmpty) return false;

      return _placeholderExactValues.contains(normalized) ||
          normalized.contains('testscreen') ||
          normalized == 'in_door test' ||
          normalized == 'indoor test';
    });
  }

  static String _normalize(String? value) {
    return (value ?? '')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}