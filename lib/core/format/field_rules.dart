class FieldRules {
  const FieldRules._();

  static final _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final _digits = RegExp(r'^\d+$');

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  static String? email(String? value) {
    final missing = required(value, 'Email');
    if (missing != null) return missing;
    if (!_email.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? phone(String? value) {
    final missing = required(value, 'Phone');
    if (missing != null) return missing;
    final trimmed = value!.trim();
    if (!_digits.hasMatch(trimmed) || trimmed.length != 10) {
      return 'Enter a 10 digit phone number.';
    }
    return null;
  }

  static String? wholeNumber(
    String? value,
    String label, {
    required int min,
    required int max,
  }) {
    final missing = required(value, label);
    if (missing != null) return missing;
    final trimmed = value!.trim();
    if (!_digits.hasMatch(trimmed)) {
      return '$label must be a whole number.';
    }
    final parsed = int.parse(trimmed);
    if (parsed < min || parsed > max) {
      return '$label must be between $min and $max.';
    }
    return null;
  }

  static String? length(
    String? value,
    String label, {
    required int min,
    required int max,
  }) {
    final missing = required(value, label);
    if (missing != null) return missing;
    final trimmed = value!.trim();
    if (trimmed.length < min) {
      return '$label needs at least $min characters.';
    }
    if (trimmed.length > max) {
      return '$label must be $max characters or fewer.';
    }
    return null;
  }
}
