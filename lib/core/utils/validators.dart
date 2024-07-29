class Validators {
  static final RegExp _emailRegExp =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _phoneRegExp = RegExp(
      r'^(\+?\d{1,3})?[- ]?\d{10}$'); // Adjust for specific phone number formats

  static String? requiredFieldValidator(String? value) {
    return value == null || value.isEmpty ? 'Field is required' : null;
  }

  static String? emailValidator(String? value) {
    return value!.isEmpty && !_emailRegExp.hasMatch(value)
        ? 'Invalid email'
        : null;
  }

  static String? phoneValidator(String? value) {
    return value!.isEmpty && !_phoneRegExp.hasMatch(value)
        ? 'Invalid phone number'
        : null;
  }

  static String? minLengthValidator(String? value, int minLength) {
    return value!.length < minLength
        ? 'Must be at least $minLength characters'
        : null;
  }

  static String? maxLengthValidator(String? value, int maxLength) {
    return value!.length > maxLength
        ? 'Must be at most $maxLength characters'
        : null;
  }
}
