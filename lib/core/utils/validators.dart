class Validators {
  const Validators._();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredField(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'Email');
    if (requiredError != null) return requiredError;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final requiredError = requiredField(value, fieldName: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? fourDigitCode(String? value) {
    final requiredError = requiredField(value, fieldName: 'Code');
    if (requiredError != null) return requiredError;
    if (!RegExp(r'^\d{4}$').hasMatch(value!.trim())) {
      return 'Enter the 4-digit code';
    }
    return null;
  }
}
